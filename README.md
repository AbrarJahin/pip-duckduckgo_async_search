# duckduckgo-async-search

Async DuckDuckGo search helper:
- Tries `duckduckgo-search` (DDGS SERP wrapper) first
- Falls back to DuckDuckGo Instant Answer API JSON if SERP is rate-limited or unavailable

## Install

```bash
pip install duckduckgo-async-search
```

## Usage (No Config Needed)

### Simple Import

```python
import asyncio
from DuckDuckGoAsyncSearch import top_n_result

async def main():
    query = "Capital of Bangladesh"
    items = await top_n_result(query, n=5)
    for it in items:
        print(it.title, it.url)

asyncio.run(main())
```

### Standard Import

```python
import asyncio
from duckduckgo_async_search import DuckDuckGoSearch

async def main():
    client = DuckDuckGoSearch()
    items = await client.top_n_result("Capital of Bangladesh", n=5)
    for it in items:
        print(it.title, it.url)

asyncio.run(main())
```

## Notes

- SERP wrappers can be rate-limited depending on your IP/network.
- Instant Answer API is more reliable but does not always reflect “top web results”.
