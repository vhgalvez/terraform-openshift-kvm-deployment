import base64

# Leer la cadena codificada de un archivo
with open('descdificar/input_archivo_codificado.txt', 'r') as file:
    cadena_codificada = file.read().strip()

# Añadir padding faltante a la cadena, si es necesario
missing_padding = len(cadena_codificada) % 4
if missing_padding:
    cadena_codificada += '=' * (4 - missing_padding)

# Decodificar la cadena base64
try:
    cadena_decodificada_bytes = base64.b64decode(cadena_codificada)
except binascii.Error as e:
    print(f"Decoding error: {e}")
    exit(1)

# Convertir bytes a string
cadena_decodificada = cadena_decodificada_bytes.decode('utf-8')

# Añadir la cadena decodificada en un archivo sin borrar el contenido existente
with open('base64/archivo_descodificado.txt', 'a') as file:
    file.write(cadena_decodificada)
    file.write('\n')  # Añade un salto de línea para separar los contenidos
