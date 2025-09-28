# Assignment #2 integration (SilkStep Commerce)

This adds:
- 6 charts (pie, bar, horizontal bar, line, histogram, scatter) → `/charts/`
- Each chart uses SQL with ≥2 JOINs (see `queries.sql`)
- Plotly time slider (`show_time_slider()`)
- Excel export with formatting → `/exports/`

## How to run
1) Set DB URL in `config.py`
2) `pip install -r requirements.txt`
3) `python analytics.py`

During defense: re-run one chart, insert a new row into DB, re-run, show the change.