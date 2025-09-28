
            lines = [ln for ln in block.splitlines() if not ln.strip().startswith("--")]
            cleaned = "\n".join(lines).strip()
            return cleaned if cleaned.endswith(";") else cleaned + ";"
    raise ValueError(f"Query named '{name}' not found in {path}")

def fetch_df(query_name: str) -> pd.DataFrame: