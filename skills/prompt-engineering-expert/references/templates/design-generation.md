# Template — Design generation (image, video, UI build tools)

Version-Timestamp: 2026-10-20

Use this template when the prompt drives a generator rather than a reasoning model:
- **Image:** Midjourney, Firefly, Imagen, GPT image, Flux.
- **Video:** Sora, Veo, Runway, Kling.
- **UI build:** v0, Lovable, Bolt, Figma Make.

Build the prompt from an approved design direction, never from adjectives alone. If the
`visual-design-studio` plugin is installed, the direction recipe and tokens come
from its `design-director` skill. Check the output with its `design-critique` skill.

```
# Role / Persona
(Omit for most image and video tools; they ignore personas. Keep it for UI
build tools: "You are a senior product designer and front-end engineer.")

# Objective / OKR
One deliverable: <asset type> for <brand/product>, used in <channel>, so that
<audience> <does what>. Success: matches the direction recipe and passes the
checks below.

# Context (the direction recipe, verbatim values)
- Subject and scene: <who/what, action, setting, time of day>
- Composition: <framing, angle, lens or focal length, depth of field, negative space for copy>
- Palette: <3-5 hex values with proportions, e.g. 60% #F6F2EA, 30% #14213D, 10% #B08D57>
- Type (UI or layouts with text only): <display face, text face, scale>
- Light and texture: <light quality, direction, grain, materials>
- Style references: <atlas style or named movement; never a living artist's name or another brand's assets>
- Motion (video): <camera move, pace, duration, loop or not>
- Channel spec: <aspect ratio, pixel size, safe area, duration, file limits>

# Requirements
- Avoid: <the direction's cliches and generic-AI tells, e.g. purple gradients, glossy 3D blobs, fake UI text>
- Text in image: <none / exact string in quotes; plan to add type in layout instead>
- Consistency: <seed, style reference or character reference to reuse across the set>
- UI build tools only: <stack (e.g. Next.js + Tailwind + shadcn/Radix), use these tokens, states required (empty, loading, error), WCAG 2.2 AA, no lorem ipsum>
- Rights: no real people without release, no trademarks, no copyrighted characters.

# Desired Output
<number> variations at <size/ratio>. UI tools: one screen or component, responsive at 390 and 1440 px.

# Evaluation
Pass if: palette and composition match the recipe; nothing on the avoid list appears;
channel spec is met; text is legible or absent as required; UI meets contrast,
target-size and state requirements. Fix the prompt, not the output by hand, when
the same failure repeats. Record tool, model, version, prompt and approver.
```

**Platform notes** (check each tool's current docs; syntax changes often):
- Image tools reward concrete nouns and visual specifics over adjectives. Put the
  subject first and the style after it. Use the tool's own parameters for aspect
  ratio and exclusions instead of writing them into the sentence.
- Video tools need a single shot description per clip: subject, action, camera, duration.
- UI build tools follow tokens and component names literally. Paste the token
  values or CSS variables in place of describing the colors.
