# Sesión de pruebas de la API de dispositivos con Hurl

POST http://localhost:3000/api/computers/frequent
[FormData]
brand: Sony
model: VAIO
ownerName: Harry Potter
ownerId: 123456
photo: file,filename=test.png;type=image/png;path=tests/fixtures/test.png

HTTP/1.1 200
[Captures]
frequent_id: jsonpath "$.device.id"
frequent_checkin_url: jsonpath "$.checkinURL"
frequent_checkout_url: jsonpath "$.checkoutURL"
[Asserts]
jsonpath "$.device.id" exists
jsonpath "$.checkinURL" exists
jsonpath "$.checkoutURL" exists

GET http://localhost:3000/api/computers/frequent

HTTP/1.1 200
[Asserts]
jsonpath "$[*].device.id" contains "{{frequent_id}}"

POST http://localhost:3000/api/computers/checkin
[FormData]
brand: Dell
model: Latitude
ownerName: Alice Smith
ownerId: A12345
photo: file,filename=test.png;type=image/png;path=tests/fixtures/test.png

HTTP/1.1 200
[Captures]
computer_id: jsonpath "$.id"
[Asserts]
jsonpath "$.id" exists
jsonpath "$.photoURL" exists

GET http://localhost:3000/api/computers

HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{computer_id}}"

POST http://localhost:3000/api/medicaldevices/checkin
[FormData]
brand: GE
model: ECG1000
ownerName: Dr. House
ownerId: 123512464
serial: F48238R7Y2R
photo: file,filename=test.png;type=image/png;path=tests/fixtures/test.png

HTTP/1.1 200
[Captures]
medical_id: jsonpath "$.id"
[Asserts]
jsonpath "$.id" exists
jsonpath "$.photoURL" exists

GET http://localhost:3000/api/medicaldevices

HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{medical_id}}"

GET http://localhost:3000/api/devices/entered

HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{computer_id}}"
jsonpath "$[*].id" contains "{{medical_id}}"

PATCH {{frequent_checkin_url}}

HTTP/1.1 200
[Asserts]
jsonpath "$.device.id" equals "{{frequent_id}}"

GET http://localhost:3000/api/devices/entered

HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{frequent_id}}"

PATCH {{frequent_checkout_url}}

HTTP/1.1 200

GET http://localhost:3000/api/devices/entered

HTTP/1.1 200
[Asserts]
jsonpath "$[*].id" contains "{{computer_id}}"
jsonpath "$[*].id" contains "{{medical_id}}"

