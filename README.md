# Kate's Kitchen

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

## The food

52 recipes across Chicken, Beef, Pork, Fish, Vegetarian, Salads and Comfort. Every one is built to the same bar: **at least 30g of protein and no more than 18g of fat per serving**, with carbohydrate left at normal levels. The collection averages 34% of its energy from protein, comfortably above the 20% that Waitrose uses as its own high-protein threshold, and averages 13g of fat.

What keeps the fat down: lean mince, pork loin and tenderloin, turkey, and Greek yogurt or cottage cheese wherever a recipe would traditionally reach for cream, butter or a fried crumb.

No lamb anywhere. The only fish are salmon and tuna.

## Generating a menu

**Generate menu** shows 15 options, deliberately mixed: about five you could cook from what's in the kitchen right now, and the rest that need a shop. Without that mix a depleted kitchen would only ever offer the same well-stocked handful, which is what the first version did.

It also remembers the last four weeks of menus and pushes those recipes to the back, so a fresh batch really is fresh. **Show me another 15** reshuffles.

## Marking dishes as cooked

Each day card has a **Cooked?** button, and so does each recipe. Ticking it does two things: the dish is struck through for the week, and **every ingredient in it comes out of My kitchen**, since you have just used them.

Anything you have *not* ticked when you next generate a menu is **carried over automatically** — it appears at the top of the options, already chosen and badged *Carried over*, so a dish you planned but never got round to is not quietly lost. Committing a new week clears the ticks.

Un-ticking a dish cannot put its ingredients back, because there is no way to know what was left, which is why the tick asks for confirmation first.

## Servings and the shopping list

Each recipe carries its own head count, set on the recipe card and starting at 2. The shopping list totals every dish at its own count and shows it on each chip, so a week of mostly-two dinners with one Sunday meal for five adds up correctly.

**Copy for Ocado** outputs just the things you need to buy, as plain product names, one per line, with quantities and preparation notes stripped ("head cabbage, shredded" becomes "cabbage"). Paste that into Ocado's Shopping Lists box — *My Ocado → Shopping Lists* on the site, or *Meals & Lists* in the app — and it matches the products so you can add the lot to your trolley in one go.

There is no way to fill an Ocado basket directly: Ocado publishes no API for it, and the only alternative would be automating a logged-in session with your password.

## Adding your own items

Open **My kitchen**, scroll to *Something not listed*, and type the item. The section is guessed from the name as you type — "Halloumi" goes to *Dairy & chilled*, "Frozen prawns" to *Freezer* — and the dropdown next to the box lets you correct it. The guess is only a starting point; whatever the dropdown shows is where the item is filed.

Items you add are kept for good. They show up in their proper section in the panel and on the shopping list, and each one has a small **×** to remove it. Nothing else deletes them: *Reset ticks to the original list* puts the ticks back to the defaults but leaves your own items alone.

Added items are recorded for the shopping list but won't unlock new recipes on their own, since the recipes reference a fixed set of ingredients.

## Sharing between the two phones

Both phones can share one list, so either of you can add an item or untick something and the other sees it. This needs a small free database, because a page hosted on GitHub Pages has nowhere of its own to store shared data.

**This is already set up** — the Supabase project exists, `supabase-setup.sql` has been run against it, and the project URL and `anon` key are in the `SYNC` block near the top of the `<script>` in `index.html`. Nothing further is needed unless you ever move to a different Supabase project, in which case re-run that SQL there and swap those two values.

Only the **anon / public** key belongs in `index.html`. The **service_role** key and the **database password** must never go near this file, or any file in this repo — it is public. Neither is needed: the anon key alone cannot read the table (see below).

**On the first phone:** open **My kitchen**, scroll to *Shared between phones*, and tap **Start sharing**. It shows a code like `ZYTL-Y7SX-BQJL`.

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

## Changing the look

Colours are CSS custom properties at the very top of the `<style>` block — `--ink`, `--chalk`, `--paper`, `--turmeric`, `--herb`, `--paprika`, `--line` — plus `--radius` for how rounded everything is. Category colours live in the `COL` object in the script. Icons are inline SVG in the `ICON` object; the page deliberately loads no icon font or image files, so that it stays one portable file.

## Privacy

There is no account and no analytics.

Without sharing switched on, ticks and kitchen edits are stored by the browser on the phone itself and go nowhere.

With sharing on, the list is held in your own Supabase project, reachable only by the twelve-character code. That code lives on your two phones and is deliberately never written into this repo. The database table has row-level security on with no policies, so the public key in `index.html` cannot read or write the table directly — the only way in is the two functions in `supabase-setup.sql`, and both require the code. Anyone who guessed a code could read that list, which is why the codes are random enough (roughly 10^18 combinations) that guessing is not realistic.

A public repo means anyone can read the page's source. There is nothing personal in it beyond a list of food, and no keys beyond the publishable `anon` one.
