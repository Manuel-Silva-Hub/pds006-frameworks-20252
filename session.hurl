# Sesión de pruebas de la API de dispositivos con JSON

# Registrar un computador frecuente (sin foto)
POST {{host}}/api/computers/frequent
Content-Type: application/json

{
  "brand": "Sony",
  "model": "VAIO",
  "ownerName": "Harry Potter",
  "ownerId": "123456"
}

HTTP/1.1 200
[Captures]
frequent_id: jsonpath "$.device.id"
frequent_checkin_url: jsonpath "$.checkinURL"
frequent_checkout_url: jsonpath "$.checkoutURL"
[Asserts]
jsonpath "$.device.id" exists
jsonpath "$.device.brand" == "Sony"
jsonpath "$.device.model" == "VAIO"
jsonpath "$.device.owner.name" == "Harry Potter"
jsonpath "$.device.owner.id" == "123456"
jsonpath "$.checkinURL" exists
jsonpath "$.checkoutURL" exists

# Listar los computadores frecuentes
GET {{host}}/api/computers/frequent

HTTP/1.1 200
[Asserts]
jsonpath "$[*].device.id" contains "{{frequent_id}}"
jsonpath "$[*]" count >= 1

# Registrar un computador normal
POST {{host}}/api/computers/checkin
Content-Type: application/json

{
  "brand": "Dell",
  "model": "Latitude",
  "ownerName": "Alice Smith",
  "ownerId": "A12345"
}

HTTP/1.1 200
[Captures]
computer_id: jsonpath "$.id"
[Asserts]
jsonpath "$.id" exists
jsonpath "$.brand" == "Dell"
jsonpath "$.model" == "Latitude"
jsonpath "$.owner.name" == "Alice Smith"
jsonpath "$.owner.id" == "A12345"

# Listar computadores
GET {{host}}/api/computers

HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{computer_id}}"
jsonpath "$[*]" count >= 1

# Registrar dispositivo médico
POST {{host}}/api/medicaldevices/checkin
Content-Type: application/json

{
  "brand": "GE",
  "model": "ECG1000",
  "ownerName": "Dr. House",
  "ownerId": "123512464",
  "serial": "F48238R7Y2R"
}

HTTP/1.1 200
[Captures]
medical_id: jsonpath "$.id"
[Asserts]
jsonpath "$.id" exists
jsonpath "$.brand" == "GE"
jsonpath "$.model" == "ECG1000"
jsonpath "$.owner.name" == "Dr. House"
jsonpath "$.serial" == "F48238R7Y2R"

# Listar dispositivos médicos
GET {{host}}/api/medicaldevices

HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{medical_id}}"
jsonpath "$[*]" count >= 1

# Consultar dispositivos ingresados
GET {{host}}/api/devices/entered

HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{computer_id}}"
jsonpath "$[*].id" contains "{{medical_id}}"

# Hacer check-in y check-out de computador frecuente
PATCH {{frequent_checkin_url}}

HTTP/1.1 200

PATCH {{frequent_checkout_url}}

HTTP/1.1 200

# Checkout del resto
PATCH {{host}}/api/devices/checkout/{{computer_id}}

HTTP/1.1 200

PATCH {{host}}/api/devices/checkout/{{medical_id}}

HTTP/1.1 200

# Comprobar que ya no hay dispositivos activos
GET {{host}}/api/devices/entered

HTTP/1.1 200
[Asserts]
jsonpath "$[*]" count == 0
