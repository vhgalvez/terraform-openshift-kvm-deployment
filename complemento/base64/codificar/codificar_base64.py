import base64

# Leer texto desde un archivo para codificarlo
with open('base64/codificar/input_generar_codificacion_base64.txt', 'r') as file:
    texto_a_codificar = file.read().strip()

# Codificar el texto a base64
texto_codificado_bytes = base64.b64encode(texto_a_codificar.encode('utf-8'))

# Convertir bytes a string
texto_codificado = texto_codificado_bytes.decode('utf-8')

# Guardar el texto codificado en un archivo, añadiendo al contenido existente
with open('base64/codificar/ouput_archivo_codificado.txt', 'a') as file:
    file.write(texto_codificado)
    file.write('\n')  # Añade un salto de línea para separar los contenidos
