# Compilador LVN
O compilador foi criado para transformar o código criado em LVN em um código intermediário na linguaguem ``c++`` . É utilizado um padrão de três endereços para a criação dos códigos intermediários.

## Instalação

É necessário as ferramentas ``flex``, ``bison`` e ``gpp``.

## Execução

Foi criado um ``Makefile`` com os comandos para a execução e o arquivo exemplo.lvn será direcionado para a entrar do compilador gerado ao final do script.

```console
make
```
## Especificações da linguagem  

1. Blocos
2. Escopo global
3. Tipo de dados primitivos (int, float, boolean, string e char)
4. Inicialização de Variáveis
5. Matrizes
6. Expressões
7. Expressões Condicionais
8. Comandos de Entrada e Saída
9. Comandos de Laço (for, while e do/while)
10. Comandos de Decisão (if, if/else e switch)
11. Operadores Aritméticos
12. Operadores Relacionais (gerando boolean)
13. Operadores Lógicos (gerando boolean)
14. Operadores Compostos
15. Operadores Unários
16. Conversão de Tipos
17. Detecção de Erros
18. Subprograma (Função)