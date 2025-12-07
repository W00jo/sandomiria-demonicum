# Changelog / Devlog

Template:

<https://keepachangelog.com/en/1.0.0/>

## Opis

Dziennik rozwoju projektu (może pod bloga potem), notatki i wewnętrzne patch notes'y.

## 2025-10-26

### Nowe

- Scena i skrypt poruszania się gracza: `scenes/characters/player`.
- Scena świata: `scenes/levels/world.tscn`.
- Scena broni: `scenes/weapons/knife/knife.tscn`.

### Zmiany

- Uporządkowano strukturę repozytorium.
- Zaktualizowano pliki projektu Godot (`project.godot`), po prostu tworząc go od nowa.
- Dostosowano ustawienia repo: `.gitignore`, `.gitattributes`.
- [USUNIĘTE Z PROJEKTU] ~~Stare sceny i skrypty + cały plik `.project`.~~

## 2025-10-29

### Jakub

- Rozpoczęcie pracy nad lepszym skryptem poruszania się gracza i dodanie ruchu kamery w ogóle

### Dominik

- Poprawiono poruszanie się gracza i teraz działa: `scenes/characters/player`

## 2025-10-30

- Stworzenie podstawowej animacji [placeholder] ataku oraz jej dźwięku.
- Dodałem komentarze, żebym lepiej rozumiał kod poruszania się (w przyszłości).
- Stworzenie nowego folderu `models/` w `assets/`, na modele 3D.
  - Stworzenie nowej sceny z kukłą treningową `training_dummy.tscn`.

## 2025-11

- Uzupełnić z listopada rzeczy

## 2025-12-07

### Jakub

- Dodanie "systemu ataku" dla tatara (`tatar.gd`).
  - Pamiętać o podmienieniu w skrypcie zakomentowanych linijek, gdy dodamy animacje i modele 3D.
  - Poza terminalem, przy "otrzymaniu obrażeń" gracz widzi wizualny indykator (czerwone ekran xd).
