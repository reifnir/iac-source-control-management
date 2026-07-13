#!/usr/bin/env python3
"""Generate the GitLab child-pipeline file from repos.yaml.

Parses repos.yaml into a list of projects, then hands that collection to
the Jinja template, which emits one trigger job per project running the
shared terraform pipeline with the TF_VAR_* and backend-state variables
set for that project.
"""

import argparse
import sys
from pathlib import Path

import yaml
from jinja2 import Environment, FileSystemLoader, StrictUndefined

SCRIPT_DIR = Path(__file__).parent
DEFAULT_CONFIG = SCRIPT_DIR.parent / "repos.yaml"
DEFAULT_TEMPLATE = SCRIPT_DIR / "repo-template.yml.j2"


def load_projects(config_path: Path) -> list[dict]:
    """Flatten repos.yaml into one dict per (group_path, project)."""
    config = yaml.safe_load(config_path.read_text())
    projects = []
    for group_path, group_projects in (config.get("group_paths") or {}).items():
        # Groups may be listed with no projects (yet)
        for project_name, properties in (group_projects or {}).items():
            properties = properties or {}
            full_project_path = f"{group_path}/{project_name}"
            projects.append(
                {
                    "group_path": group_path,
                    "project_name": project_name,
                    "full_project_path": full_project_path,
                    "description": properties.get("description", ""),
                    "state_key": f"$CI_PROJECT_PATH/{full_project_path}.tfstate",
                }
            )
    return projects


def render_pipeline(projects: list[dict], template_path: Path) -> str:
    env = Environment(
        loader=FileSystemLoader(template_path.parent),
        undefined=StrictUndefined,
        trim_blocks=True,
        lstrip_blocks=True,
        keep_trailing_newline=True,
    )
    template = env.get_template(template_path.name)
    return template.render(projects=projects)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", type=Path, default=DEFAULT_CONFIG)
    parser.add_argument("--template", type=Path, default=DEFAULT_TEMPLATE)
    parser.add_argument(
        "--output",
        type=Path,
        help="Where to write the pipeline YAML (default: stdout)",
    )
    args = parser.parse_args()

    projects = load_projects(args.config)
    if not projects:
        print(f"No projects found in {args.config}", file=sys.stderr)
        return 1

    pipeline = render_pipeline(projects, args.template)

    # Fail here rather than with an obscure error in the triggered pipeline
    yaml.safe_load(pipeline)

    if args.output:
        args.output.write_text(pipeline)
        print(f"Wrote {len(projects)} jobs to {args.output}", file=sys.stderr)
    else:
        print(pipeline)
    return 0


if __name__ == "__main__":
    sys.exit(main())
