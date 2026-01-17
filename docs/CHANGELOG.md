# Changelog

Dziennik rozwoju projektu (może pod bloga potem), notatki i wewnętrzne patch notes'y :>

## 2026-01-17

### Added

- Stworzenie głównego menu inspirowanego otwartą książką (np. *Tails of Iron*, Odd Bug Studio, 2021).
  - Layout z dwoma pseudo-symetrycznymi kolumnami (lewą stronę dla menu, prawą dla artworku).
  - [Placeholder] grzbietu książki w środku (`BookSpine`).
- Tytuł i podtytuł w czerwonym kolorze w foncie `Pirata One`; Przyciski są w fontcie `EB Garamond`.
- Menu z czterema przyciskami: PLAY, SETTINGS, CREDITS, QUIT.
  - Przyciski używają fancy borderów (wszystkie z numerem 028.png).
- Placeholder dla artworku na prawej stronie.
- Responsive layout z anchorami - skaluje się wraz z rozmiarem okna (gotowe do eksportu). W teorii.

## 2025-12-17/18

### Added

- Stworzenie bazy pod przyszłe dodanie animacji z poprawnymi hit boxami, w skrypcie `dagger.gd`. Skrypt póki co działa tak:
	- Zaczyna na ataku (↓), czyli `stab` (pl. *pchnięcie*) w kodzie.
	- Ruch myszką, ale nie byle jaki, tam jest dead zone, lewo/prawo/góra sprawia, że indykator Ci pokaże, jaki atak wykonasz wtedy.
	- Prawy przycisk myszki blokuje owy indykator, że możesz spamić jeden typ ataku.
	- Kiedy indykator jest zablokowany, powinien być pomarańczowy
	- Jakieś czary magicznych liczb z internetu wykrywają czy przeciwnik jest przed graczem i wyprintują odpowiednio przypisane statystyki. Tj. jeśli machasz danym trybem ataku, to czy trafisz, bo masz określony zasięg, a jeśli tak, to ile zadasz obrażeń.
- Dodanie modelu placeholder modelu `dagger.glb` z internetu. LEKKO przerobionego przeze mnie.
- ==Zostawiłem komentarze w newralgicznych miejscach oraz podpisałem **TODO:** to co trzeba będzie podmienić/przerobić/jest placeholderem.==

### Removed

- Niepotrzebny już `knife` folder, sprite, scenę oraz skrypt. Relikt z ery 2D sprite'ów i bycia klonem Doom'a.

## 2025-12-15

### Changed

- Zaktualizowanie dokumentację w folderze `docs/`
	- Dodałem treść z **gdd** w pigułce, całość ma z 2-3 strony max. To ma być szybka referencja, a nie lektura nocna.

## 2025-12-07

### Added

- Dodanie "systemu ataku" dla tatara (`tatar.gd`).
	- ==Pamiętać o podmienieniu w skrypcie zakomentowanych linijek, gdy dodamy animacje i modele 3D.==
	- Poza printem w terminalu, przy "otrzymaniu obrażeń" gracz widzi wizualny indykator (mryga czerwone na ekranie xd).

### Fixed - by Kacper

- Naprawienie chodzenia "okrakiem".
  - Gracz przyśpieszał zarówno na osi X jak i Z, zamiast tylko na Z, przez co jego ruch zanim osiągał maksymalną prędkość, skręcał na boki pierw.

## 2025-11-30

### Removed

- Niepotrzebne, stare sprite'y 2D -> teraz postacie nawet przeciwników robimy w low-poly 3D.

## 2025-11-18

### Added

- Osadzenie w directory assetów do UI.
- Przygotowanie `basic_hud` jako podstawy dla graczy, niezależnie od postaci jakie wybiorą (mam nadzieję).
- Stworzenie nowej sceny z poziomem, gdzie zaczynam pracę nad blockout'em poziomu startowego (tutorialu).

## 2025-10-30

### Added

- Stworzenie podstawowej animacji [placeholder] ataku oraz jej dźwięku.
- Dodałem komentarze, żebym lepiej rozumiał kod poruszania się (w przyszłości).
- Stworzenie nowego folderu `models/` w `assets/`, na modele 3D.
  - Stworzenie nowej sceny z kukłą treningową `training_dummy.tscn`.`

## 2025-10-29

### Added

- Rozpoczęcie pracy nad lepszym skryptem poruszania się gracza i dodanie ruchu kamery w ogóle.

### Changed

- Poprawiono poruszanie się gracza i teraz działa: `scenes/characters/player`.
  - Zakomentowanie, z mojej strony, całego kodu, aby go łatwo przyswoić.

## 2025-10-26

### Added

- Scena i skrypt poruszania się gracza: `scenes/characters/player`.
- Scena świata: `scenes/levels/world.tscn`.
- Scena broni: `scenes/weapons/knife/knife.tscn`.

### Changed

- Uporządkowano strukturę repozytorium.
- Zaktualizowano pliki projektu Godot (`project.godot`), po prostu tworząc go od nowa.
- Dostosowano ustawienia repo: `.gitignore`, `.gitattributes`.

### Removed

~~Stare sceny i skrypty + cały plik `.project`.~~

### Added

- Stworzenie bazy pod przyszłe dodanie animacji z poprawnymi hit boxami, w skrypcie `dagger.gd`. Skrypt póki co działa tak:
	- Zaczyna na ataku (↓), czyli `stab` (pl. *pchnięcie*) w kodzie.
	- Ruch myszką, ale nie byle jaki, tam jest dead zone, lewo/prawo/góra sprawia, że indykator Ci pokaże, jaki atak wykonasz wtedy.
	- Prawy przycisk myszki blokuje owy indykator, że możesz spamić jeden typ ataku.
	- Kiedy indykator jest zablokowany, powinien być pomarańczowy
	- Jakieś czary magicznych liczb z internetu wykrywają czy przeciwnik jest przed graczem i wyprintują odpowiednio przypisane statystyki. Tj. jeśli machasz danym trybem ataku, to czy trafisz, bo masz określony zasięg, a jeśli tak, to ile zadasz obrażeń.
- Dodanie modelu placeholder modelu `dagger.glb` z internetu. LEKKO przerobionego przeze mnie.
- ==Zostawiłem komentarze w newralgicznych miejscach oraz podpisałem **TODO:** to co trzeba będzie podmienić/przerobić/jest placeholderem.==

### Removed

- Niepotrzebny już `knife` folder, sprite, scenę oraz skrypt. Relikt z ery 2D sprite'ów i bycia klonem Doom'a.

## 2025-12-15

### Changed

- Zaktualizowanie dokumentację w folderze `docs/`
	- Dodałem treść z **gdd** w pigułce, całość ma z 2-3 strony max. To ma być szybka referencja, a nie lektura nocna.

## 2025-12-07

### Added

- Dodanie "systemu ataku" dla tatara (`tatar.gd`).
	- ==Pamiętać o podmienieniu w skrypcie zakomentowanych linijek, gdy dodamy animacje i modele 3D.==
	- Poza printem w terminalu, przy "otrzymaniu obrażeń" gracz widzi wizualny indykator (mryga czerwone na ekranie xd).

### Fixed - by Kacper

- Naprawienie chodzenia "okrakiem".
  - Gracz przyśpieszał zarówno na osi X jak i Z, zamiast tylko na Z, przez co jego ruch zanim osiągał maksymalną prędkość, skręcał na boki pierw.

## 2025-11-30

### Removed

- Niepotrzebne, stare sprite'y 2D -> teraz postacie nawet przeciwników robimy w low-poly 3D.

## 2025-11-18

### Added

- Osadzenie w directory assetów do UI.
- Przygotowanie `basic_hud` jako podstawy dla graczy, niezależnie od postaci jakie wybiorą (mam nadzieję).
- Stworzenie nowej sceny z poziomem, gdzie zaczynam pracę nad blockout'em poziomu startowego (tutorialu).

## 2025-10-30

### Added

- Stworzenie podstawowej animacji [placeholder] ataku oraz jej dźwięku.
- Dodałem komentarze, żebym lepiej rozumiał kod poruszania się (w przyszłości).
- Stworzenie nowego folderu `models/` w `assets/`, na modele 3D.
  - Stworzenie nowej sceny z kukłą treningową `training_dummy.tscn`.`

## 2025-10-29

### Added

- Rozpoczęcie pracy nad lepszym skryptem poruszania się gracza i dodanie ruchu kamery w ogóle.

### Changed

- Poprawiono poruszanie się gracza i teraz działa: `scenes/characters/player`.
  - Zakomentowanie, z mojej strony, całego kodu, aby go łatwo przyswoić.

## 2025-10-26

### Added

- Scena i skrypt poruszania się gracza: `scenes/characters/player`.
- Scena świata: `scenes/levels/world.tscn`.
- Scena broni: `scenes/weapons/knife/knife.tscn`.

### Changed

- Uporządkowano strukturę repozytorium.
- Zaktualizowano pliki projektu Godot (`project.godot`), po prostu tworząc go od nowa.
- Dostosowano ustawienia repo: `.gitignore`, `.gitattributes`.

### Removed

~~Stare sceny i skrypty + cały plik `.project`.~~
