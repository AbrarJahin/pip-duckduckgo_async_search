from __future__ import annotations

from typing import List, Optional

from duckduckgo_async_search.client import DuckDuckGoResult, DuckDuckGoSearch

_default_client: Optional[DuckDuckGoSearch] = None


async def top_n_result(query: str, n: int = 5) -> List[DuckDuckGoResult]:
    """
    Convenience function:
      from DuckDuckGoAsyncSearch import top_n_result
    """
    global _default_client
    if _default_client is None:
        _default_client = DuckDuckGoSearch()
    return await _default_client.top_n_result(query, n=n)
