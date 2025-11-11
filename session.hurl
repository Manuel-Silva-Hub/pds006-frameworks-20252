# Sesión de pruebas de la API de dispositivos con Hurl

POST {{host}}/api/computers/frequent
[MultipartFormData]
brand: Sony
model: VAIO
ownerName: Harry Potter
ownerId: 123456
photo: @tests/fixtures/test.png; type=image/png; filename=test.png

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
jsonpath "$.checkinURL" matches ".*/api/computers/frequent/checkin/.*"
jsonpath "$.checkoutURL" matches ".*/api/devices/checkout/.*"

GET {{host}}/api/computers/frequent

HTTP/1.1 200
[Asserts]
jsonpath "$[*].device.id" contains "{{frequent_id}}"
jsonpath "$[*]" count == 1
jsonpath "$[*].device.brand" contains "Sony"
jsonpath "$[*].device.owner.name" contains "Harry Potter"

POST {{host}}/api/computers/checkin
[MultipartFormData]
brand: Dell
model: Latitude
ownerName: Alice Smith
ownerId: A12345
photo: @tests/fixtures/test.png; type=image/png; filename=test.png

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

GET {{host}}/api/computers

HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{computer_id}}"
jsonpath "$[*].brand" contains "Dell"
jsonpath "$[*].owner.name" contains "Alice Smith"
jsonpath "$[*]" count == 1

GET {{host}}/api/devices/entered

HTTP/1.1 200
[Asserts]
jsonpath "$[*]" count == 1
jsonpath "$[*].id" contains "{{computer_id}}"
jsonpath "$[*].type" contains "computer"

POST {{host}}/api/medicaldevices/checkin
[MultipartFormData]
brand: GE
model: ECG1000
ownerName: Dr. House
ownerId: 123512464
serial: F48238R7Y2R
photo: @tests/fixtures/test.png; type=image/png; filename=test.png

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

GET {{host}}/api/medicaldevices

HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{medical_id}}"
jsonpath "$[*].brand" contains "GE"
jsonpath "$[*].owner.name" contains "Dr. House"
jsonpath "$[*].serial" contains "F48238R7Y2R"
jsonpath "$[*]" count == 1

GET {{host}}/api/devices/entered

HTTP/1.1 200
[Asserts]
jsonpath "$[*]" count == 2
jsonpath "$[*].id" contains "{{computer_id}}"
jsonpath "$[*].id" contains "{{medical_id}}"
jsonpath "$[*].type" contains "computer"
jsonpath "$[*].type" contains "medical-device"

PATCH {{frequent_checkin_url}}

HTTP/1.1 200
[Asserts]
jsonpath "$.device.id" == "{{frequent_id}}"
jsonpath "$.device.brand" == "Sony"
jsonpath "$.device.owner.name" == "Harry Potter"
jsonpath "$.device.checkinAt" exists

GET {{host}}/api/devices/entered

HTTP/1.1 200
[Asserts]
jsonpath "$[*]" count == 3
jsonpath "$[*].id" contains "{{frequent_id}}"
jsonpath "$[*].id" contains "{{computer_id}}"
jsonpath "$[*].id" contains "{{medical_id}}"
jsonpath "$[*].type" contains "frequent-computer"

PATCH {{frequent_checkout_url}}

HTTP/1.1 200

GET {{host}}/api/devices/entered

HTTP/1.1 200
[Asserts]
jsonpath "$[*]" count == 2
jsonpath "$[*].id" contains "{{computer_id}}"
jsonpath "$[*].id" contains "{{medical_id}}"
jsonpath "$[*].type" contains "computer"
jsonpath "$[*].type" contains "medical-device"

PATCH {{host}}/api/devices/checkout/{{computer_id}}

HTTP/1.1 200

GET {{host}}/api/devices/entered

HTTP/1.1 200
[Asserts]
jsonpath "$[*]" count == 1
jsonpath "$[*].id" contains "{{medical_id}}"
jsonpath "$[*].type" contains "medical-device"

PATCH {{host}}/api/devices/checkout/{{medical_id}}

HTTP/1.1 200

GET {{host}}/api/devices/entered

HTTP/1.1 200
[Asserts]
jsonpath "$[*]" count == 0

