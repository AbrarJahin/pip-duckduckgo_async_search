# Makefile Commands Reference

This project uses a **local Conda environment stored inside the repository**
(`.conda/env`) and a **Makefile** to standardize setup, development, build,
and publishing workflows.

> ⚠️ Note  
> Make **cannot activate a Conda environment in the current shell session**.
> Instead:
> - `make install` creates and prepares the environment
> - `make activate` prints the correct activation command
> - Other targets run commands *inside* the environment using `conda run`

---

## Environment Location

| Item | Value |
|----|----|
| Conda environment path | `.conda/env` |
| Environment definition | `environment.yml` |
| Python version | 3.11 |
| Package install mode | Editable (`pip install -e .`) |

---

## Command Summary Table

| Command | Purpose | When to Use |
|------|--------|------------|
| `make help` | Show all available Makefile targets | First time / quick reference |
| `make install` | Create or update the local Conda env and install the package | **First command to run** |
| `make update` | Same as install (forces env update + reinstall) | After dependency changes |
| `make activate` | Print Conda activation command for your shell | To manually activate the env |
| `make status` | Show Python, pip, and key installed packages | Debug / verification |
| `make run` | Run a small async demo using the library | Sanity check |
| `make python` | Open Python REPL inside the local env | Interactive testing |
| `make build` | Build wheel + sdist into `dist/` | Before publishing |
| `make publish` | Upload package to PyPI | Release to production |
| `make testpypi` | Upload package to TestPyPI | Dry-run publishing |
| `make clean` | Remove build artifacts (`dist/`, cache) | Cleanup |
| `make delete` | Completely remove the local Conda env | Full reset |

---

## Detailed Command Descriptions

### `make install`
Creates (or updates) the Conda environment and installs the project.

**What it does**
- Creates `.conda/env` if missing
- Updates env if it already exists
- Installs:
  - Python
  - pip
  - build / twine
- Installs your package in **editable mode**

```bash
make install
