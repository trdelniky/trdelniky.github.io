#!/usr/bin/env python3
import argparse
import pathlib
import sys

from pedalboard import (
    Pedalboard,
    HighpassFilter,
    PeakFilter,
    HighShelfFilter,
    Compressor,
    Gain,
    NoiseGate,
)
from pedalboard.io import AudioFile


def process_file(input_path, output_path, args):
    with AudioFile(str(input_path)) as f:
        audio = f.read(f.frames)
        sr = f.samplerate

    board = Pedalboard([
        # Low cut
        HighpassFilter(cutoff_frequency_hz=args.highpass),

        # Presence
        PeakFilter(
            cutoff_frequency_hz=args.presence_freq,
            gain_db=args.presence_gain,
            q=args.presence_q,
        ),

        # Air / clarity
        HighShelfFilter(
            cutoff_frequency_hz=args.air_freq,
            gain_db=args.air_gain,
        ),

        # Optional noise gate
        NoiseGate(threshold_db=args.noise_floor),

        # Compression
        Compressor(
            threshold_db=args.threshold,
            ratio=args.ratio,
            attack_ms=args.attack,
            release_ms=args.release,
        ),

        # Make-up gain
        Gain(gain_db=args.makeup_gain),
    ])

    processed = board(audio, sr)

    with AudioFile(
        str(output_path),
        "w",
        sr,
        processed.shape[0]
    ) as f:
        f.write(processed)


def iter_audio_files(path):
    if path.is_file():
        yield path
    else:
        for ext in ("*.wav", "*.mp3", "*.flac", "*.ogg", "*.m4a"):
            yield from path.glob(ext)


def main():
    p = argparse.ArgumentParser(
        description="Audacity-like voice processing (normalize → EQ → compression)"
    )

    p.add_argument("input", help="Input file or directory")
    p.add_argument("-o", "--output", help="Output directory", default="out")

    # EQ
    p.add_argument("--highpass", type=float, default=90)
    p.add_argument("--presence-freq", type=float, default=2000)
    p.add_argument("--presence-gain", type=float, default=2.5)
    p.add_argument("--presence-q", type=float, default=1.0)
    p.add_argument("--air-freq", type=float, default=7000)
    p.add_argument("--air-gain", type=float, default=3.0)

    # Compression
    p.add_argument("--threshold", type=float, default=-20)
    p.add_argument("--ratio", type=float, default=3.0)
    p.add_argument("--attack", type=float, default=100)
    p.add_argument("--release", type=float, default=1000)
    p.add_argument("--noise-floor", type=float, default=-60)
    p.add_argument("--makeup-gain", type=float, default=2.5)

    args = p.parse_args()

    in_path = pathlib.Path(args.input)
    out_dir = pathlib.Path(args.output)
    out_dir.mkdir(parents=True, exist_ok=True)

    files = list(iter_audio_files(in_path))
    if not files:
        sys.exit("No audio files found.")

    for f in files:
        out_file = out_dir / f.with_suffix(".wav").name
        print(f"→ {f} → {out_file}")
        process_file(f, out_file, args)


if __name__ == "__main__":
    main()
