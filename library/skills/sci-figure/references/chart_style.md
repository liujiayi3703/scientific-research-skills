# Chart style reference

Publication-grade matplotlib style for the sci-figure skill. Read this before drawing the first chart.

## Resolving fonts at runtime

Never hard-code a font that may not exist. Walk the fallback chains from the config block and pick the first one available.

```python
from matplotlib import font_manager
import matplotlib as mpl

def resolve_font(candidates):
    available = {f.name for f in font_manager.fontManager.ttflist}
    for name in candidates:
        if name in available or name == "serif":
            return name
    return "serif"

CN_FONT = resolve_font(CN_SERIF_FALLBACK)
EN_FONT = resolve_font(EN_SERIF_FALLBACK)
```

For mixed CN/EN text in the same figure, list both fonts in the family — matplotlib uses the first that has the character:

```python
mpl.rcParams["font.serif"] = [EN_FONT, CN_FONT, "serif"]
mpl.rcParams["axes.unicode_minus"] = False  # avoid the minus-sign rendering bug
```

## rcParams block

Apply once at the top of the analysis, after font resolution:

```python
mpl.rcParams.update({
    # Typography
    "font.family": "serif",
    "font.serif": [EN_FONT, CN_FONT, "serif"],
    "font.size": 10,
    "axes.titlesize": 11,        # rarely used — titles live in captions
    "axes.labelsize": 10,
    "xtick.labelsize": 9,
    "ytick.labelsize": 9,
    "legend.fontsize": 9,
    "axes.unicode_minus": False,

    # Color — grayscale by default
    "axes.prop_cycle": mpl.cycler(color=["#000000", "#555555",
                                          "#888888", "#bbbbbb"]),
    "axes.edgecolor": "#000000",
    "axes.labelcolor": "#000000",
    "xtick.color": "#000000",
    "ytick.color": "#000000",
    "text.color": "#000000",

    # Chrome — stripped
    "axes.spines.top": False,
    "axes.spines.right": False,
    "axes.spines.left": True,
    "axes.spines.bottom": True,
    "axes.grid": True,
    "axes.axisbelow": True,
    "grid.color": "#e5e5e5",
    "grid.linewidth": 0.5,
    "grid.linestyle": "-",

    # No chartjunk
    "axes.facecolor": "white",
    "figure.facecolor": "white",
    "savefig.facecolor": "white",
    "legend.frameon": False,

    # Output
    "figure.dpi": 100,
    "savefig.dpi": DPI,
    "savefig.bbox": "tight",
})
```

## Color palettes

### Default: grayscale

Use the 4-color grayscale cycle in the rcParams above. Distinguish series with **line style** and **marker shape**, not color:

```python
LINE_STYLES = ["-", "--", "-.", ":"]
MARKERS = ["o", "s", "^", "D"]
```

If more than 4 series, the chart should be split (small multiples), not extended.

### When color is unavoidable: Okabe–Ito

For categorical data where grayscale truly cannot disambiguate (e.g. geographic maps, qualitative groupings on a complex chart), use the Okabe–Ito color-blind-safe palette. **Never** use matplotlib's default `tab10` or `viridis` for categorical data.

```python
OKABE_ITO = [
    "#000000",  # black
    "#E69F00",  # orange
    "#56B4E9",  # sky blue
    "#009E73",  # bluish green
    "#F0E442",  # yellow
    "#0072B2",  # blue
    "#D55E00",  # vermillion
    "#CC79A7",  # reddish purple
]
```

For sequential numeric data (heatmap, choropleth), `viridis` and `cividis` are OK — they're perceptually uniform and color-blind safe.

## Axis labels and units

**Every numeric axis label that has a unit shows it in parentheses.** No exceptions.

| ✓ Correct | ✗ Wrong |
|---|---|
| `Revenue (USD)` | `Revenue USD` |
| `Temperature (°C)` | `Temperature in Celsius` |
| `Time (s)` | `Time seconds` |
| `Concentration (μmol/L)` | `Concentration μmol/L` |
| `Mass (kg)` | `kg` |

Dimensionless quantities omit the parenthetical: `Count`, `Ratio`, `Proportion`.

```python
ax.set_xlabel("Time (s)")
ax.set_ylabel("Voltage (mV)")
```

## Numeric precision

Don't trust matplotlib's default tick formatting. Apply explicit rules:

```python
from matplotlib.ticker import FuncFormatter, ScalarFormatter

def smart_format(x, _pos=None):
    """Apply config-driven precision and notation rules."""
    if x == 0:
        return "0"
    ax_val = abs(x)
    if ax_val < SCIENTIFIC_LOW or ax_val >= SCIENTIFIC_HIGH:
        return f"{x:.{DEFAULT_DECIMALS}e}"
    if ax_val >= 1000:
        # Thousands separator, no decimals if integer-like
        if x == int(x):
            return f"{int(x):{THOUSANDS_SEP}}"
        return f"{x:{THOUSANDS_SEP}.{DEFAULT_DECIMALS}f}"
    return f"{x:.{DEFAULT_DECIMALS}g}"

ax.yaxis.set_major_formatter(FuncFormatter(smart_format))
ax.xaxis.set_major_formatter(FuncFormatter(smart_format))
```

For annotated values (data labels, p-values), use the same logic. p-values get one extra rule: display `p < 0.001` rather than `p = 0.0000` or `p = 8.4e-07`:

```python
def format_p(p: float) -> str:
    if p < 0.001:
        return "p < 0.001"
    if p < 0.01:
        return f"p = {p:.3f}"
    return f"p = {p:.2f}"
```

## Error bars

When bars (or points) represent a summary statistic, error bars are **required** and their meaning must be named in the caption.

Compute the interval based on `ERROR_BAR` from the config:

```python
def error_interval(values, kind="SEM"):
    """Returns the half-width of the error bar (one side)."""
    n = len(values)
    if kind == "SD":
        return values.std(ddof=1)
    if kind == "SEM":
        return values.std(ddof=1) / np.sqrt(n)
    if kind == "CI95":
        from scipy import stats as sps
        return sps.t.ppf(0.975, df=n - 1) * values.std(ddof=1) / np.sqrt(n)
    raise ValueError(f"Unknown error bar type: {kind}")

means = df.groupby("group")["value"].mean()
errs = df.groupby("group")["value"].apply(lambda s: error_interval(s, ERROR_BAR))

ax.bar(means.index, means.values,
       yerr=errs.values,
       color="#555555", edgecolor="black", linewidth=0.5,
       capsize=4, error_kw={"linewidth": 0.8, "ecolor": "black"})
```

Caption must then say "Bars represent mean ± SEM" (or SD, or 95% CI). Never just "error bars."

## Worked example: grouped bar chart with significance brackets

```python
fig, ax = plt.subplots(figsize=FIG_SINGLE_COL)

groups = ["A", "B", "C"]
means = df.groupby("group")["value"].mean().reindex(groups)
errs = df.groupby("group")["value"].apply(
    lambda s: error_interval(s, ERROR_BAR)).reindex(groups)

x = np.arange(len(groups))
ax.bar(x, means.values, yerr=errs.values,
       color="#555555", edgecolor="black", linewidth=0.5,
       capsize=4, error_kw={"linewidth": 0.8, "ecolor": "black"})

ax.set_xticks(x)
ax.set_xticklabels(groups)
ax.set_xlabel("Treatment group")
ax.set_ylabel("Response (mg/L)")
ax.yaxis.set_major_formatter(FuncFormatter(smart_format))
ax.yaxis.grid(True)
ax.xaxis.grid(False)

# Significance brackets (from Step 5 results)
y_max = (means + errs).max()
add_significance_bracket(ax, 0, 1, y_max * 1.08, "**")
add_significance_bracket(ax, 0, 2, y_max * 1.18, "*")
ax.set_ylim(top=y_max * 1.30)

# Save in all three formats
save_figure(fig, "fig_02_response_by_group")
plt.close(fig)
```

## The `save_figure` helper

Used at the end of every figure:

```python
def save_figure(fig, slug: str):
    """Save in pdf, png, jpg into the right subfolders."""
    for fmt in OUTPUT_FORMATS:
        path = OUTPUT_DIR / "figures" / fmt / f"{slug}.{fmt}"
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, dpi=DPI if fmt != "pdf" else None,
                    bbox_inches="tight")
```

## Common mistakes

- **`ax.set_title()`** — never. Titles live in the caption.
- **Seaborn defaults** — they override the rcParams block. Use pandas/matplotlib directly.
- **Auto-rotating x labels into illegibility** — switch to horizontal bar or use `fig.autofmt_xdate()`.
- **Color encoding when grayscale would work** — defeats the style.
- **Forgetting `axes.unicode_minus = False`** — Chinese fonts may not have the Unicode minus glyph, producing a broken minus sign.
- **Legend when there's only one series** — pure noise, remove it.
- **Drawing every `ns` bracket** — only draw the comparisons that matter. Mention the rest in the caption.
