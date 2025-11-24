# ===========================================================
# 🧪 Sesión de pruebas de la API de Dispositivos
# ===========================================================

# -----------------------------------------------------------
# 1️⃣ Registrar un computador frecuente
# -----------------------------------------------------------
POST {{host}}/api/computers/frequent
[MultipartFormData]
brand: Sony
model: VAIO
ownerName: Harry Potter
ownerId: 123456
photo: file, tests/fixtures/test.png;type=image/png

HTTP/1.1 200
[Captures]
frequent_id: jsonpath "$.device.id"
frequent_checkin_url_raw: jsonpath "$.checkinURL"
frequent_checkout_url_raw: jsonpath "$.checkoutURL"

[Set]
frequent_checkin_url = "https://pds006in.azurewebsites.net:443" + frequent_checkin_url_raw.replace("^.*?(?=/api)", "")
frequent_checkout_url = "https://pds006in.azurewebsites.net:443" + frequent_checkout_url_raw.replace("^.*?(?=/api)", "")

[Asserts]
jsonpath "$.device.id" exists
jsonpath "$.device.brand" == "Sony"
jsonpath "$.device.model" == "VAIO"
jsonpath "$.device.owner.name" == "Harry Potter"
jsonpath "$.device.owner.id" == "123456"
jsonpath "$.checkinURL" exists
jsonpath "$.checkoutURL" exists
jsonpath "$.checkinURL" matches ".*/api/computers/frequent/checkin/.*"
jsonpath "$.checkoutURL" matches ".*/api/devices/checkout/.*"


# -----------------------------------------------------------
# 2️⃣ Obtener lista de computadores frecuentes
# -----------------------------------------------------------
GET {{host}}/api/computers/frequent
HTTP/1.1 200
[Asserts]
jsonpath "$[*].device.id" contains "{{frequent_id}}"
jsonpath "$[*].device.brand" contains "Sony"
jsonpath "$[*].device.owner.name" contains "Harry Potter"


# -----------------------------------------------------------
# 3️⃣ Registrar computador normal (checkin)
# -----------------------------------------------------------
POST {{host}}/api/computers/checkin
[MultipartFormData]
brand: Dell
model: Latitude
ownerName: Alice Smith
ownerId: A12345
photo: file, tests/fixtures/test.png;type=image/png

HTTP/1.1 200
[Captures]
computer_id: jsonpath "$.id"

[Asserts]
jsonpath "$.id" exists
jsonpath "$.brand" == "Dell"
jsonpath "$.model" == "Latitude"
jsonpath "$.owner.name" == "Alice Smith"
jsonpath "$.owner.id" == "A12345"
jsonpath "$.photoURL" exists
jsonpath "$.checkinAt" exists


# -----------------------------------------------------------
# 4️⃣ Ver lista de computadores
# -----------------------------------------------------------
GET {{host}}/api/computers
HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{computer_id}}"
jsonpath "$[*].brand" contains "Dell"
jsonpath "$[*].owner.name" contains "Alice Smith"


# -----------------------------------------------------------
# 5️⃣ Dispositivos ingresados
# -----------------------------------------------------------
GET {{host}}/api/devices/entered
HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{computer_id}}"
jsonpath "$[*].type" contains "computer"


# -----------------------------------------------------------
# 6️⃣ Registrar dispositivo médico
# -----------------------------------------------------------
POST {{host}}/api/medicaldevices/checkin
[MultipartFormData]
brand: GE
model: ECG1000
ownerName: Dr. House
ownerId: 123512464
serial: F48238R7Y2R
photo: file, tests/fixtures/test.png;type=image/png

HTTP/1.1 200
[Captures]
medical_id: jsonpath "$.id"

[Asserts]
jsonpath "$.id" exists
jsonpath "$.brand" == "GE"
jsonpath "$.model" == "ECG1000"
jsonpath "$.owner.name" == "Dr. House"
jsonpath "$.owner.id" == "123512464"
jsonpath "$.serial" == "F48238R7Y2R"
jsonpath "$.photoURL" exists
jsonpath "$.checkinAt" exists


# -----------------------------------------------------------
# 7️⃣ Ver dispositivos médicos
# -----------------------------------------------------------
GET {{host}}/api/medicaldevices
HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{medical_id}}"
jsonpath "$[*].brand" contains "GE"
jsonpath "$[*].owner.name" contains "Dr. House"
jsonpath "$[*].serial" contains "F48238R7Y2R"


# -----------------------------------------------------------
# 8️⃣ Ver todos los dispositivos ingresados
# -----------------------------------------------------------
GET {{host}}/api/devices/entered
HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{computer_id}}"
jsonpath "$[*].id" contains "{{medical_id}}"
jsonpath "$[*].type" contains "computer"
jsonpath "$[*].type" contains "medical-device"


# -----------------------------------------------------------
# 9️⃣ Check-in del computador frecuente
# -----------------------------------------------------------
PATCH {{frequent_checkin_url}}
HTTP/1.1 200
[Asserts]
jsonpath "$.device.id" == "{{frequent_id}}"
jsonpath "$.device.brand" == "Sony"
jsonpath "$.device.owner.name" == "Harry Potter"
jsonpath "$.device.checkinAt" exists


# -----------------------------------------------------------
# 🔟 Ver dispositivos ingresados (3 totales)
# -----------------------------------------------------------
GET {{host}}/api/devices/entered
HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{frequent_id}}"
jsonpath "$[*].id" contains "{{computer_id}}"
jsonpath "$[*].id" contains "{{medical_id}}"
jsonpath "$[*].type" contains "frequent-computer"


# -----------------------------------------------------------
# 1️⃣1️⃣ Checkout del computador frecuente
# -----------------------------------------------------------
PATCH {{frequent_checkout_url}}
HTTP/1.1 200


# -----------------------------------------------------------
# 1️⃣2️⃣ Ver dispositivos ingresados (deben quedar 2)
# -----------------------------------------------------------
GET {{host}}/api/devices/entered
HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{computer_id}}"
jsonpath "$[*].id" contains "{{medical_id}}"
jsonpath "$[*].type" contains "computer"
jsonpath "$[*].type" contains "medical-device"


# -----------------------------------------------------------
# 1️⃣3️⃣ Checkout del computador normal
# -----------------------------------------------------------
PATCH {{host}}/api/devices/checkout/{{computer_id}}
HTTP/1.1 200


# -----------------------------------------------------------
# 1️⃣4️⃣ Ver dispositivos ingresados (solo debe quedar médico)
# -----------------------------------------------------------
GET {{host}}/api/devices/entered
HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{medical_id}}"
jsonpath "$[*].type" contains "medical-device"


# -----------------------------------------------------------
# 1️⃣5️⃣ Checkout del dispositivo médico
# -----------------------------------------------------------
PATCH {{host}}/api/devices/checkout/{{medical_id}}
HTTP/1.1 200


# -----------------------------------------------------------
# 1️⃣6️⃣ Ver dispositivos ingresados (vacío)
# -----------------------------------------------------------
GET {{host}}/api/devices/entered
HTTP/1.1 200
[Asserts]

