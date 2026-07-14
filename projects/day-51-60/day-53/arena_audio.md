**Day 53/100**

Built an offline audio revision system for **MCQ Arena**.

Revision notes are now converted into narrated audio using a local text-to-speech pipeline. Each revision module can include synchronized text and audio, while gracefully falling back to text-only mode if an audio file isn't available.

The workflow:

* Revision JSON → Narration generation
* Offline TTS → WAV
* WAV → MP3 conversion
* Automatic attachment to revision index
* Audio playback integrated into the revision interface

Everything runs locally with no external APIs, making it fast, repeatable, and easy to generate new revision content.

**Tech Stack:** React • Vite • Node.js • Piper TTS • FFmpeg • JavaScript

#100DaysOfCode #React #JavaScript #EdTech #OpenSource #BuildInPublic
