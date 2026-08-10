# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: generate-password.spec.ts >> Generate Password — Core Flow >> adds parameter to recent parameters history after generation
- Location: e2e\tests\generate-password.spec.ts:77:9

# Error details

```
TimeoutError: page.waitForSelector: Timeout 90000ms exceeded.
Call log:
  - waiting for locator('flt-glass-pane') to be visible
    167 × locator resolved to hidden <flt-glass-pane></flt-glass-pane>

```

# Page snapshot

```yaml
- button "Enable accessibility" [ref=e2]
```