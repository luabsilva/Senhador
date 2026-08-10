# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: ui-components.spec.ts >> UI Components — Home Page >> all character switches are enabled by default
- Location: e2e\tests\ui-components.spec.ts:58:9

# Error details

```
TimeoutError: page.waitForSelector: Timeout 90000ms exceeded.
Call log:
  - waiting for locator('flt-glass-pane') to be visible
    166 × locator resolved to hidden <flt-glass-pane></flt-glass-pane>

```

# Page snapshot

```yaml
- button "Enable accessibility" [ref=e2]
```