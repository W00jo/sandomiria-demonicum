# Nowa jakość kodu

*Standardy kodowania oparte o zasady "Clean code" Roberta C. Martina [https://gist.github.com/wojteklu/73c6914cc446146b8b533c0988cf8d29]. Projekt będzie stopniowo dostosowywany do tych zasad.*

## Zasady Clean Code

### Fundamenty

1. **Czytelność ponad wszystko** - kod jest czytany częściej niż pisany
2. **Jedna odpowiedzialność** - klasa/funkcja robi jedną rzecz i robi ją dobrze
3. **DRY (Don't Repeat Yourself)** - eliminuj duplikację kodu
4. **KISS (Keep It Simple, Stupid)** - prostsze rozwiązania są lepsze
5. **Fail Fast** - wykrywaj błędy jak najwcześniej

## Konwencje nazewnictwa

### GDScript

- **Klasy:** `PascalCase` - `TicketValidator`, `PassengerGenerator`
- **Zmienne:** `snake_case` - `is_valid`, `passenger_count`
- **Funkcje:** `snake_case` - `validate_ticket()`, `generate_passenger()`
- **Stałe:** `SCREAMING_SNAKE_CASE` - `MAX_PASSENGERS`, `DEFAULT_FINE_AMOUNT`
- **Pliki prywatne:** prefix `_` - `_internal_helper.gd`
- **Interfejsy:** suffix `Interface` - `ValidatorInterface`

### C# (przyszłościowe)

- **Klasy:** `PascalCase` - `TicketValidator`, `PassengerGenerator`
- **Metody:** `PascalCase` - `ValidateTicket()`, `GeneratePassenger()`
- **Zmienne:** `camelCase` - `isValid`, `passengerCount`
- **Właściwości:** `PascalCase` - `IsTicketExpired { get; set; }`
- **Stałe:** `PascalCase` - `MaxPassengers`, `DefaultFineAmount`
- **Interfejsy:** prefix `I` - `ITicketValidator`, `IPassengerRepository`
- **Pliki prywatne:** prefix `_` - `_InternalHelper.cs`

### Nazwy opisowe

**GDScript:**

```gdscript
# ✅ DOBRE - jasne i konkretne
func calculate_fine_amount(violation_type: String) -> int
var is_ticket_expired: bool
const STUDENT_DISCOUNT_PERCENTAGE = 50

# ❌ ZŁE - niejasne i skrócone  
func calc(type: String) -> int
var flag: bool
const DISC = 50
```

**C# (przyszłościowe):**

```csharp
**C# (przyszłościowe):**

```csharp
// ✅ DOBRE - jasne i konkretne
public int CalculateFineAmount(string violationType)
public bool IsTicketExpired { get; set; }
public const int StudentDiscountPercentage = 50;

// ❌ ZŁE - niejasne i skrócone  
public int Calc(string type)
public bool Flag { get; set; }
public const int Disc = 50;
```

## Struktura projektu

### Organizacja folderów

```text
src/
├── core/              # Logika biznesowa (clean architecture)
│   ├── entities/      # Pasażer, Bilet, Dokument
│   ├── use_cases/     # ValidateTicket, GeneratePassenger  
│   └── interfaces/    # Kontrakty dla zewnętrznych zależności
├── infrastructure/    # Implementacje zewnętrznych systemów
│   ├── data/         # JSON loadery, persistence
│   └── ui/           # Godot specific UI controllers
├── presentation/      # Warstawa prezentacji
│   ├── scenes/       # .tscn files
│   └── controllers/  # Scene controllers
└── tests/            # Wszystkie testy
    ├── unit/         # Testy jednostkowe
    └── integration/  # Testy integracyjne
```

### Nazewnictwo plików

- **Klasy biznesowe GDScript:** `PascalCase.gd` - `TicketValidator.gd`
- **Klasy biznesowe C#:** `PascalCase.cs` - `TicketValidator.cs`
- **Controllers:** `PascalCaseController.gd/.cs` - `PassengerController.gd`
- **Sceny:** `kebab-case.tscn` - `ticket-validation.tscn`
- **Testy GDScript:** `test_ClassName.gd` - `test_TicketValidator.gd`
- **Testy C#:** `ClassNameTests.cs` - `TicketValidatorTests.cs`

## Funkcje i metody

### Zasada Single Responsibility

**GDScript:**

```gdscript
# ✅ DOBRE - jedna odpowiedzialność
class TicketValidator:
    func is_valid(ticket: Ticket) -> bool:
        return not _is_expired(ticket) and _has_valid_format(ticket)
    
    func _is_expired(ticket: Ticket) -> bool:
        return ticket.expiry_date < Date.today()
    
    func _has_valid_format(ticket: Ticket) -> bool:
        return ticket.number.length() == 10

# ❌ ZŁE - robi za dużo rzeczy
class TicketManager:
    func handle_ticket(ticket):
        # waliduje
        # zapisuje do bazy  
        # wysyła email
        # updatuje UI
        # 50 linii kodu...
```

**C# (przyszłościowe):**

```csharp
**C# (przyszłościowe):**

```csharp
// ✅ DOBRE - jedna odpowiedzialność
public class TicketValidator : ITicketValidator
{
    public bool IsValid(Ticket ticket)
    {
        return !IsExpired(ticket) && HasValidFormat(ticket);
    }
    
    private bool IsExpired(Ticket ticket)
    {
        return ticket.ExpiryDate < DateTime.Today;
    }
    
    private bool HasValidFormat(Ticket ticket)
    {
        return ticket.Number.Length == 10;
    }
}

// ❌ ZŁE - robi za dużo rzeczy
public class TicketManager
{
    public void HandleTicket(Ticket ticket)
    {
        // waliduje
        // zapisuje do bazy  
        // wysyła email
        // updatuje UI
        // 50 linii kodu...
    }
}
```

### Małe funkcje

- **Maksymalnie 20 linii** na funkcję
- **Jeden poziom abstrakcji** w funkcji
- **Brak zagnieżdżonych if-ów** głębszych niż 2 poziomy

**GDScript:**

```gdscript
# ✅ DOBRE - mała i czytelna
```gdscript
# ✅ DOBRE - mała i czytelna
func calculate_student_discount(base_price: int) -> int:
    if not _is_student_eligible():
        return base_price
    return base_price * STUDENT_DISCOUNT_PERCENTAGE / 100

# ❌ ZŁE - za długa i skomplikowana
func process_ticket_with_all_validations_and_discounts(...):
    # 50+ linii z zagnieżdżonymi if-ami
```

**C# (przyszłościowe):**

```csharp
**C# (przyszłościowe):**

```csharp
// ✅ DOBRE - mała i czytelna
public int CalculateStudentDiscount(int basePrice)
{
    if (!IsStudentEligible())
        return basePrice;
    
    return basePrice * StudentDiscountPercentage / 100;
}

// ❌ ZŁE - za długa i skomplikowana
public void ProcessTicketWithAllValidationsAndDiscounts(...)
{
    // 50+ linii z zagnieżdżonymi if-ami
}
```

## Klasy i obiekty

### SOLID Principles

#### Single Responsibility Principle (SRP)

```gdscript
# ✅ DOBRE - jedna odpowiedzialność
class PassengerGenerator:
    func generate() -> Passenger:
        return _create_passenger_with_random_data()

class TicketValidator:
    func validate(ticket: Ticket) -> ValidationResult:
        return _check_all_validation_rules(ticket)

# ❌ ZŁE - robi wszystko
class PassengerManager:
    func generate_and_validate_and_save_passenger():
        # generuje pasażera
        # waliduje bilet  
        # zapisuje do bazy
        # renderuje UI
```

#### Open/Closed Principle (OCP)

```gdscript
# ✅ DOBRE - rozszerzalne bez modyfikacji
class TicketValidator:
    var _rules: Array[ValidationRule] = []
    
    func add_rule(rule: ValidationRule):
        _rules.append(rule)
    
    func validate(ticket: Ticket) -> bool:
        return _rules.all(func(rule): return rule.is_valid(ticket))

# Nowe reguły bez zmiany kodu
class ExpiryDateRule extends ValidationRule:
    func is_valid(ticket: Ticket) -> bool:
        return not ticket.is_expired()
```

#### Dependency Inversion Principle (DIP)

```gdscript
# ✅ DOBRE - zależy od abstrakcji
class TicketService:
    var _repository: TicketRepositoryInterface
    
    func _init(repository: TicketRepositoryInterface):
        _repository = repository
    
    func save_ticket(ticket: Ticket):
        _repository.save(ticket)

# ❌ ZŁE - zależy od konkretnej implementacji
class TicketService:
    var _file_system = FileSystem.new()  # hard dependency
```

### Kompozycja nad dziedziczeniem

```gdscript
# ✅ DOBRE - kompozycja
class Passenger:
    var _ticket_validator: TicketValidator
    var _document_generator: DocumentGenerator
    
    func validate_documents() -> bool:
        return _ticket_validator.is_valid(_ticket)

# ❌ ZŁE - dziedziczenie dla wszystkiego
class StudentPassenger extends Passenger:
class SeniorPassenger extends Passenger:
class VIPPassenger extends Passenger:
```

## Obsługa błędów

### Result Pattern zamiast wyjątków

```gdscript
# ✅ DOBRE - explicite handling
class ValidationResult:
    var is_success: bool
    var error_message: String
    var error_code: ErrorCode
    
    static func success() -> ValidationResult:
        return ValidationResult.new(true, "", ErrorCode.NONE)
    
    static func failure(message: String, code: ErrorCode) -> ValidationResult:
        return ValidationResult.new(false, message, code)

func validate_ticket(ticket: Ticket) -> ValidationResult:
    if ticket == null:
        return ValidationResult.failure("Ticket is null", ErrorCode.NULL_TICKET)
    
    if ticket.is_expired():
        return ValidationResult.failure("Ticket expired", ErrorCode.EXPIRED_TICKET)
    
    return ValidationResult.success()

# Użycie
var result = validate_ticket(passenger.ticket)
if not result.is_success:
    show_error_message(result.error_message)
    return

proceed_with_validation()
```

### Logging z poziomami

```gdscript
# ✅ DOBRE - strukturowany logging
enum LogLevel { DEBUG, INFO, WARNING, ERROR, CRITICAL }

class Logger:
    static func debug(message: String, context: Dictionary = {}):
        _log(LogLevel.DEBUG, message, context)
    
    static func info(message: String, context: Dictionary = {}):
        _log(LogLevel.INFO, message, context)
    
    static func error(message: String, context: Dictionary = {}):
        _log(LogLevel.ERROR, message, context)

# Użycie
Logger.info("Starting ticket validation", {"passenger_id": passenger.id})
Logger.error("Validation failed", {"reason": "expired_ticket", "ticket_id": ticket.id})
```

## Testowanie

### Test-Driven Development (TDD)

```gdscript
# 1. Napisz test (który failuje)
extends GutTest

func test_ticket_validation_rejects_expired_ticket():
    # Arrange
    var expired_ticket = Ticket.new()
    expired_ticket.expiry_date = Date.yesterday()
    var validator = TicketValidator.new()
    
    # Act
    var result = validator.validate(expired_ticket)
    
    # Assert
    assert_false(result.is_success)
    assert_eq(result.error_code, ErrorCode.EXPIRED_TICKET)

# 2. Napisz najmniejszy kod żeby test przeszedł
# 3. Refaktoryzuj
```

### Struktura testów AAA

- **Arrange** - przygotuj dane testowe
- **Act** - wykonaj akcję
- **Assert** - sprawdź rezultat

### Testy jednostkowe vs integracyjne

```gdscript
# ✅ Test jednostkowy - testuje jedną klasę
func test_passenger_generator_creates_valid_passenger():
    var generator = PassengerGenerator.new()
    var passenger = generator.generate()
    
    assert_not_null(passenger)
    assert_true(passenger.age >= 12)
    assert_true(passenger.age <= 95)

# ✅ Test integracyjny - testuje przepływ
func test_full_ticket_validation_flow():
    var passenger = PassengerGenerator.new().generate()
    var validator = TicketValidator.new()
    var result = validator.validate(passenger.ticket)
    
    assert_true(result.is_success)
```

## Formatowanie i style

### Czytelność kodu

```gdscript
# ✅ DOBRE - czytelne i jednoznaczne
class TicketValidator:
    const MAX_TICKET_AGE_DAYS = 30
    const STUDENT_ID_LENGTH = 6
    
    func is_student_ticket_valid(ticket: StudentTicket) -> ValidationResult:
        if not _has_valid_student_id(ticket.student_id):
            return ValidationResult.failure("Invalid student ID format")
        
        if _is_ticket_expired(ticket.issue_date):
            return ValidationResult.failure("Student ticket has expired")
        
        return ValidationResult.success()
    
    func _has_valid_student_id(student_id: String) -> bool:
        return student_id.length() == STUDENT_ID_LENGTH and student_id.is_valid_int()
    
    func _is_ticket_expired(issue_date: Date) -> bool:
        var days_since_issue = Date.today().days_since(issue_date)
        return days_since_issue > MAX_TICKET_AGE_DAYS

# ❌ ZŁE - nieczytelne i zagnieżdżone
func check(t):
    if t != null:
        if t.type == "student":
            if t.id != null and t.id.length() == 6:
                if t.date != null:
                    # 10 poziomów zagnieżdżenia...
```

## Przykłady zastosowania Clean Code

### Przed: Legacy kod

```gdscript
```gdscript
# ❌ ZŁY PRZYKŁAD
extends Node2D

var p
var t
var d
var validation_result

func _ready():
    p = get_passenger()
    t = p.get_ticket()
    d = p.get_document()

func check():
    if p != null and t != null:
        if t.type == "student":
            if d != null and d.id != null:
                if d.id.length() == 6:
                    if t.date != null:
                        var now = Time.get_unix_time_from_system()
                        var ticket_time = Time.get_unix_time_from_datetime_string(t.date)
                        if now - ticket_time < 2592000:  # magic number
                            validation_result = true
                            return
    validation_result = false
```

### Po: Clean Code

```gdscriptgdscript
# ✅ DOBRY PRZYKŁAD
class_name StudentTicketValidator
extends TicketValidator

const TICKET_VALIDITY_DAYS = 30
const STUDENT_ID_LENGTH = 6

func validate(passenger: Passenger) -> ValidationResult:
    var ticket = passenger.get_student_ticket()
    var student_id = passenger.get_student_id()
    
    var validation_steps = [
        _validate_ticket_exists(ticket),
        _validate_student_id_format(student_id),
        _validate_ticket_not_expired(ticket)
    ]
    
    for step in validation_steps:
        if not step.is_success:
            return step
    
    return ValidationResult.success()

func _validate_ticket_exists(ticket: StudentTicket) -> ValidationResult:
    if ticket == null:
        return ValidationResult.failure("Student ticket not found", ErrorCode.MISSING_TICKET)
    return ValidationResult.success()

func _validate_student_id_format(student_id: String) -> ValidationResult:
    if student_id.length() != STUDENT_ID_LENGTH:
        return ValidationResult.failure("Invalid student ID length", ErrorCode.INVALID_STUDENT_ID)
    
    if not student_id.is_valid_int():
        return ValidationResult.failure("Student ID must be numeric", ErrorCode.INVALID_STUDENT_ID)
    
    return ValidationResult.success()

func _validate_ticket_not_expired(ticket: StudentTicket) -> ValidationResult:
    var days_since_issue = Date.today().days_since(ticket.issue_date)
    
    if days_since_issue > TICKET_VALIDITY_DAYS:
        return ValidationResult.failure("Student ticket has expired", ErrorCode.EXPIRED_TICKET)
    
    return ValidationResult.success()
```

### Wzorzec Factory dla tworzenia pasażerów

```gdscript
# ✅ Clean Factory Pattern
class PassengerFactory:
    static func create_student_passenger(age: int, student_id: String) -> StudentPassenger:
        var passenger = StudentPassenger.new()
        passenger.age = age
        passenger.student_id = student_id
        passenger.ticket = StudentTicketFactory.create_valid_ticket()
        return passenger
    
    static func create_senior_passenger(age: int) -> SeniorPassenger:
        var passenger = SeniorPassenger.new()
        passenger.age = age
        passenger.ticket = SeniorTicketFactory.create_discounted_ticket()
        return passenger
```

## Migracja z legacy kodu

### Krok po kroku

1. **Identyfikuj najgorsze części** - długie funkcje, zagnieżdżone if-y
2. **Napisz testy** dla istniejącej funkcjonalności
3. **Refaktoryzuj małymi krokami** - Extract Method, Extract Class
4. **Wprowadź interfaces** - oddziel logikę od implementacji
5. **Zastąp if-y polimorfizmem** - Strategy Pattern

### Boy Scout Rule

"Zawsze zostaw kod w lepszym stanie niż go zastałeś"

## Status języków programowania

### GDScript - język główny

- **Status:** ✅ **Aktywnie używany**
- **Zastosowanie:** Cała logika gry, UI, systemy gameplay
- **Zalety:** Natywna integracja z Godot, szybki rozwój prototypów
- **Wady:** Brak silnego typowania, mniejsza wydajność

### C# - język przyszłościowy

- **Status:** 📋 **Planowany do wprowadzenia**
- **Zastosowanie:** Krytyczne systemy wymagające wydajności
- **Kandydaci do przepisania:**
  - `PersonalDataManager` - algorytmy generowania danych
  - `TicketValidator` - logika walidacji biletów
  - `StatisticsManager` - obliczenia statystyk
- **Zalety:** Silne typowanie, lepsza wydajność, zaawansowane narzędzia
- **Wady:** Większa złożoność, dłuższy czas kompilacji

### Strategia migracji *(potencjalna)*

1. **Faza 1:** Wszystko w GDScript (obecna)
2. **Faza 2:** Krytyczne systemy w C# + interfejsy
3. **Faza 3:** Stopniowa migracja pozostałych komponentów
4. **Cel:** Hybrydowa architektura - GDScript dla UI, C# dla logiki

---

*Wizja Clean Code dla projektu. Refaktoryzacja będzie stopniowa!*
