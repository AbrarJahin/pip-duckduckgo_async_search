.PHONY: help clear install update activate status clean delete run python build publish testpypi verify

ENV_FILE := environment.yml
ENV_PATH := .conda/env

CONDA := conda
RUN := $(CONDA) run -p $(ENV_PATH)

help:
	@echo ------------------------------------------------------------
	@echo Targets:
	@echo   make install    - Create/update local conda env in .conda/env, pip install -e .
	@echo   make update     - Update env (prune) + reinstall editable package
	@echo   make status     - Show python/pip versions and key packages inside env
	@echo   make activate   - Print activation command for your shell
	@echo   make run        - Run a small async demo using the package
	@echo   make verify     - Verify imports + async function type
	@echo   make build      - Build dist/ (wheel + sdist)
	@echo   make publish    - Upload dist/ to PyPI (requires auth)
	@echo   make testpypi   - Upload dist/ to TestPyPI
	@echo   make clean      - Remove dist/ and build artifacts
	@echo   make delete     - Remove the local conda env folder (.conda/env)
	@echo ------------------------------------------------------------

clear:
	@python -c "print('\033c', end='')"

install:
	@echo ------------------------------------------------------------
	@echo Creating/updating conda env at: $(ENV_PATH)
	@echo Using env file: $(ENV_FILE)
	@echo ------------------------------------------------------------
	@python -c "import os,subprocess; \
env_path=r'$(ENV_PATH)'; yml=r'$(ENV_FILE)'; \
py_win=os.path.join(env_path,'python.exe'); py_nix=os.path.join(env_path,'bin','python'); \
exists=os.path.isdir(env_path) and (os.path.isfile(py_win) or os.path.isfile(py_nix)); \
cmd=(['conda','env','create','-p',env_path,'-f',yml] if not exists else ['conda','env','update','-p',env_path,'-f',yml,'--prune']); \
print('Running:', ' '.join(cmd)); \
subprocess.check_call(cmd)"
	@echo ------------------------------------------------------------
	@echo Upgrading pip + installing package editable (-e .)
	@echo ------------------------------------------------------------
	@$(RUN) python -m pip install --no-user -U pip
	@$(RUN) python -m pip install --no-user -e .
	@echo ------------------------------------------------------------
	@echo Done.
	@echo Next: run 'make activate' to see how to activate in your shell.
	@echo ------------------------------------------------------------

update: install

activate:
	@echo ------------------------------------------------------------
	@echo To activate the local env:
	@echo   PowerShell:
	@echo     conda activate "$$(Resolve-Path $(ENV_PATH))"
	@echo   CMD:
	@echo     conda activate "$(ENV_PATH)"
	@echo   macOS/Linux:
	@echo     conda activate "$$(pwd)/$(ENV_PATH)"
	@echo ------------------------------------------------------------

status:
	@echo ------------------------------------------------------------
	@echo Python + Pip versions inside env:
	@$(RUN) python --version
	@$(RUN) python -m pip --version
	@echo ------------------------------------------------------------
	@echo Installed key packages:
	@$(RUN) python -m pip show duckduckgo-async-search || echo "Package not installed yet."
	@$(RUN) python -m pip show httpx || echo "httpx not installed yet."
	@$(RUN) python -m pip show duckduckgo-search || echo "duckduckgo-search not installed yet."
	@echo ------------------------------------------------------------

python:
	@$(RUN) python

verify:
	@$(RUN) python -c "import inspect; \
from duckduckgo_async_search import top_n_result, DuckDuckGoSearch, DuckDuckGoResult; \
print('imports: OK'); \
print('top_n_result is async:', inspect.iscoroutinefunction(top_n_result)); \
print('DuckDuckGoSearch:', DuckDuckGoSearch); \
print('DuckDuckGoResult:', DuckDuckGoResult)"

run:
	@$(RUN) python -c "import asyncio; \
from duckduckgo_async_search import top_n_result; \
async def main(): \
    items = await top_n_result('Capital of Bangladesh', n=5); \
    print('Results:', len(items)); \
    [print('-', i.title, i.url, '|', i.source) for i in items]; \
asyncio.run(main())"

build:
	@echo ------------------------------------------------------------
	@echo Building wheel + sdist into dist/
	@echo ------------------------------------------------------------
	@$(RUN) python -m build

publish: build
	@echo ------------------------------------------------------------
	@echo Uploading dist/* to PyPI
	@echo (If using token: username __token__ and password = token)
	@echo ------------------------------------------------------------
	@$(RUN) python -m twine upload dist/*

testpypi: build
	@echo ------------------------------------------------------------
	@echo Uploading dist/* to TestPyPI
	@echo ------------------------------------------------------------
	@$(RUN) python -m twine upload --repository testpypi dist/*

clean:
	@python -c "import shutil; \
[shutil.rmtree(p, ignore_errors=True) for p in ['dist','build','.pytest_cache']]; \
shutil.rmtree('duckduckgo_async_search.egg-info', ignore_errors=True); \
print('Cleaned build artifacts (dist/, build/, cache, *.egg-info).')"

delete:
	@python -c "import shutil; shutil.rmtree('$(ENV_PATH)', ignore_errors=True); print('Deleted $(ENV_PATH)')"
