# Scripts/Initialize-Project.ps1

param(
    [string]$ProjectPath = "C:\Projects\TransportOrdersSystem"
)

$DataPath = Join-Path $ProjectPath "Data"

# Убедимся, что папка Data существует
New-Item -ItemType Directory -Path $DataPath -Force

# --- Генерация данных ---

# 1. Направления (Ports)
$Ports = @(
    @{ id = 1; name = "Порт СПб"; country = "Россия"; coordinates = @{ lat = 59.9343; lng = 30.3351 } },
    @{ id = 2; name = "Порт Новороссийск"; country = "Россия"; coordinates = @{ lat = 44.7178; lng = 37.7653 } },
    @{ id = 3; name = "Порт Одесса"; country = "Украина"; coordinates = @{ lat = 46.4775; lng = 30.7326 } }
)

# 2. Клиенты
$Clients = @(
    @{ id = 1; name = "ООО Рога и Копыта"; contact_info = @{ email = "info@rogaikopyta.com"; phone = "+79001234567" } },
    @{ id = 2; name = "ИП Петров"; contact_info = @{ email = "petrov@example.com"; phone = "+79007654321" } }
)

# 3. Транспорт
$Transport = @(
    @{ id = 1; type = "Судно"; name = "Корабль 1"; capacity = 10000; current_port_id = 1 },
    @{ id = 2; type = "Грузовик"; name = "Газель 1"; capacity = 5000; current_port_id = 2 }
)

# 4. Маршруты
$Routes = @(
    @{ id = 1; from_port_id = 1; to_port_id = 2; via_ports_ids = @(); transport_id = 1 },
    @{ id = 2; from_port_id = 2; to_port_id = 3; via_ports_ids = @(); transport_id = 2 }
)

# 5. Грузы
$Cargo = @(
    @{ id = 1; weight = 1000; type = "Стандартный"; description = "Электроника"; owner_client_id = 1 },
    @{ id = 2; weight = 500; type = "Хрупкий"; description = "Стекло"; owner_client_id = 2 }
)

# 6. Заказы
$Orders = @(
    @{ id = 1; client_id = 1; date = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ"); status = "pending"; route_id = 1; cargo_id = 1 },
    @{ id = 2; client_id = 2; date = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ"); status = "in_transit"; route_id = 2; cargo_id = 2 }
)

# 7. Отгрузки (Shipments)
$Shipments = @(
    @{ id = 1; order_id = 1; cargo_id = 1 },
    @{ id = 2; order_id = 2; cargo_id = 2 }
)

# 8. События в порту (MongoDB-style)
$PortLogs = @(
    @{ _id = [System.Guid]::NewGuid().ToString(); cargo_id = 1; event_type = "entry"; timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ"); location = "Порт СПб"; status = "pending" },
    @{ _id = [System.Guid]::NewGuid().ToString(); cargo_id = 1; event_type = "unload"; timestamp = (Get-Date).AddHours(2).ToString("yyyy-MM-ddTHH:mm:ssZ"); location = "Порт СПб"; status = "completed" },
    @{ _id = [System.Guid]::NewGuid().ToString(); cargo_id = 2; event_type = "entry"; timestamp = (Get-Date).AddHours(1).ToString("yyyy-MM-ddTHH:mm:ssZ"); location = "Порт Новороссийск"; status = "pending" }
)

# 9. Отслеживание (MongoDB-style)
$TrackingEvents = @(
    @{ _id = [System.Guid]::NewGuid().ToString(); cargo_id = 1; event = "Departure"; details = "Left Port A"; location = "Порт СПб" },
    @{ _id = [System.Guid]::NewGuid().ToString(); cargo_id = 1; event = "Arrival"; details = "Arrived at Port B"; location = "Порт Новороссийск" },
    @{ _id = [System.Guid]::NewGuid().ToString(); cargo_id = 2; event = "Entry"; details = "Entered Port C"; location = "Порт Новороссийск" }
)

# --- Сохранение данных в JSON ---

$DataFiles = @{
    "ports.json" = $Ports
    "clients.json" = $Clients
    "transport.json" = $Transport
    "routes.json" = $Routes
    "cargo.json" = $Cargo
    "orders.json" = $Orders
    "shipments.json" = $Shipments
    "port_logs.json" = $PortLogs
    "tracking_events.json" = $TrackingEvents
}

foreach ($File in $DataFiles.GetEnumerator()) {
    $FilePath = Join-Path $DataPath $File.Key
    $File.Value | ConvertTo-Json -Depth 10 | Out-File -FilePath $FilePath -Encoding UTF8
    Write-Host "Файл создан: $FilePath" -ForegroundColor Green
}

Write-Host "`nПроект инициализирован. Данные сгенерированы в $DataPath" -ForegroundColor Green