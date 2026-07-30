# This Week's Dinners

Seven dinners a week, built from what's already in the kitchen. One self-contained page — no build step, no dependencies, no server code.

## Files

| File | What it does |
|---|---|
| `index.html` | The whole app. Everything is in here. |
| `manifest.json` | Lets iPhone and Android treat it as an app rather than a web page. |
| `icon-180.png` | Home screen icon on iPhone. |
| `icon-512.png` | Home screen icon on Android, and the splash screen. |

All four must sit in the same folder, at the top level of the repo.

## Putting it on GitHub Pages

1. Sign in at **github.com** and click **New repository**.
2. Name it `dinners`. Set it to **Public** — Pages needs public on a free account. Tick **Add a README file**, then **Create repository**.
3. On the repo page, click **Add file → Upload files**. Drag in all four files above, then **Commit changes**. If you uploaded the README from this folder too, overwrite the one GitHub made.
4. Go to **Settings → Pages** (left sidebar).
5. Under *Build and deployment*, set **Source** to `Deploy from a branch`, **Branch** to `main`, folder `/ (root)`. Click **Save**.
6. Wait a minute or two, then reload that Settings → Pages screen. It will show the live address:

   `https://YOUR-USERNAME.github.io/dinners/`

That address is now permanent. Any future edit — uploading a new `index.html` — goes live within a minute at the same URL.

## Adding it to an iPhone home screen

Send the address to your wife by message. On each phone:

1. Open the link **in Safari**. Chrome on iOS cannot add to the home screen properly, so it has to be Safari.
2. Tap the **Share** button (the square with the arrow).
3. Scroll down and tap **Add to Home Screen**, then **Add**.

It gets its own icon and opens full-screen with no browser bar. This is why hosting fixes the problem: opening an HTML file from the Files app runs it from a `file://` address, where Safari blocks saving and treats the page as untrusted. A real `https://` address behaves like any other website.

## Editing the kitchen list permanently

The **My kitchen** panel changes save on each phone separately. To change what the page assumes by default for everyone, edit the `PANTRY` block near the top of the `<script>` in `index.html`:

```js
["spinach","Baby spinach",0],
```

The last number is `1` for *in the kitchen* and `0` for *not*. Change the numbers, save the file, upload it over the old one on GitHub, done.

## Privacy

There is no server, no account, no analytics. Ticks and kitchen edits are stored by the browser on the phone itself and go nowhere. A public repo means anyone who guesses the URL can see the recipes — there is nothing personal in the page beyond a list of food.
