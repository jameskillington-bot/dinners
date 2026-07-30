# This Week's Dinners

Seven dinners a week, built from what's already in the kitchen. One self-contained page — no build step, no dependencies, no server code.

**Live at:** https://jameskillington-bot.github.io/dinners/

## Files

| File | What it does |
|---|---|
| `index.html` | The whole app. Everything is in here. |
| `manifest.json` | Lets iPhone and Android treat it as an app rather than a web page. |
| `icon-180.png` | Home screen icon on iPhone. |
| `icon-512.png` | Home screen icon on Android, and the splash screen. |
| `supabase-setup.sql` | One-off database setup, only needed for sharing between phones. |

The first four must sit in the same folder, at the top level of the repo.

## Adding it to an iPhone home screen

Send the address above by message. On each phone:

1. Open the link **in Safari**. Chrome on iOS cannot add to the home screen properly, so it has to be Safari.
2. Tap the **Share** button (the square with the arrow).
3. Scroll down and tap **Add to Home Screen**, then **Add**.

It gets its own icon and opens full-screen with no browser bar. This is why hosting matters: opening an HTML file from the Files app runs it from a `file://` address, where Safari blocks saving and treats the page as untrusted. A real `https://` address behaves like any other website.

## Adding your own items

Open **My kitchen**, scroll to *Something not listed*, and type the item. The section is guessed from the name as you type — "Halloumi" goes to *Dairy & chilled*, "Frozen prawns" to *Freezer* — and the dropdown next to the box lets you correct it. The guess is only a starting point; whatever the dropdown shows is where the item is filed.

Items you add are kept for good. They show up in their proper section in the panel and on the shopping list, and each one has a small **×** to remove it. Nothing else deletes them: *Reset ticks to the original list* puts the ticks back to the defaults but leaves your own items alone.

Added items are recorded for the shopping list but won't unlock new recipes on their own, since the recipes reference a fixed set of ingredients.

## Sharing between the two phones

Both phones can share one list, so either of you can add an item or untick something and the other sees it. This needs a small free database, because a page hosted on GitHub Pages has nowhere of its own to store shared data.

**One-off setup:**

1. Sign up at **supabase.com** and create a project. Any name; the free tier is enough.
2. Open the **SQL Editor** in the left sidebar, paste in the whole of `supabase-setup.sql`, and press **Run**.
3. Go to **Settings → API**. Copy the **Project URL** and the **anon / public** key.
4. Put those two values into `index.html`, replacing `__SUPABASE_URL__` and `__SUPABASE_ANON_KEY__` near the top of the `SYNC` block, then upload the file over the old one.

Never put the **service_role** key in this file. It bypasses all the protections below, and this repo is public. Only the `anon` key belongs here.

**Then, on the first phone:** open **My kitchen**, scroll to *Shared between phones*, and tap **Start sharing**. It shows a code like `ZYTL-Y7SX-BQJL`.

**On the second phone:** same panel, type that code into the box, and tap **Join**. Joining replaces that phone's list with the shared one, so start from whichever phone has the list you want to keep.

After that both phones stay in step. Changes are saved to the shared copy about a second after you make them, and each phone checks for the other's changes every twenty seconds and whenever you switch back to the app. The panel shows what's happening — *In step with the other phone*, *Saving…*, or *Offline*.

If you both change something in the same few seconds, the later save wins and the earlier phone quietly adopts it rather than overwriting; you'll see *The other phone had newer changes*. Editing at the same moment is the only case where a change can be lost, and it is a narrow window.

Working offline is fine. Changes are saved on the phone immediately and go up the next time it has a connection.

## Editing the default kitchen list

To change what the page assumes before anyone has touched it, edit the `PANTRY` block near the top of the `<script>` in `index.html`:

```js
["spinach","Baby spinach",0],
```

The last number is `1` for *in the kitchen* and `0` for *not*. Change the numbers, save the file, upload it over the old one on GitHub, done.

## Privacy

There is no account and no analytics.

Without sharing switched on, ticks and kitchen edits are stored by the browser on the phone itself and go nowhere.

With sharing on, the list is held in your own Supabase project, reachable only by the twelve-character code. That code lives on your two phones and is deliberately never written into this repo. The database table has row-level security on with no policies, so the public key in `index.html` cannot read or write the table directly — the only way in is the two functions in `supabase-setup.sql`, and both require the code. Anyone who guessed a code could read that list, which is why the codes are random enough (roughly 10^18 combinations) that guessing is not realistic.

A public repo means anyone can read the page's source. There is nothing personal in it beyond a list of food, and no keys beyond the publishable `anon` one.
