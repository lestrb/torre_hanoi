# Torre de Hanoi
def hanoi (n, origem, destino, auxiliar):
    if n == 1:
        print(f"Mover disco 1 de {origem} para {destino}")
        return
    else:
        hanoi(n - 1, origem, auxiliar, destino)
        print(f"Mover disco {n} de {origem} para {destino}")
        hanoi(n - 1, auxiliar, destino, origem)

# Pede o número de discos ao usuário
n = int(input("Número de discos: "))

# Roda o algoritmo
hanoi(n, 'A', 'C', 'B')  # A, B e C: nomes dos pinos