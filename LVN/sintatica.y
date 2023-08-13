%{
#include <iostream>
#include <string>
#include <sstream>
#include <vector>

#define YYSTYPE atributos
#define RESET   "\033[0m"
#define RED     "\033[31m"
#define GREEN   "\033[32m"
#define YELLOW  "\033[33m"
#define BLUE    "\033[34m"
#define MAGENTA "\033[35m"
#define CYAN    "\033[36m"
#define WHITE   "\033[37m"

using namespace std;


struct atributos
{
	string label;
	string traducao;
	string tipo;
	string nome;
	string apelido;
	string global;

};

struct simbolo_tipo
{
	string nome;
	string tipo;
	string apelido;
	int tamanho_string;

}typedef simbolo_tipo;



struct loop
{
	string inicio_loop;
	string fim_loop;
	string nome;

} typedef loop;

struct funcao 
{
	string nome;
	string retorno;
	string traducao;
	string apelido;
	vector<simbolo_tipo> parametros;

} typedef funcao;

struct elemento
{
	string nome_matriz;
	string nome;
	string pos_linha;
	string pos_coluna;

} typedef elemento_matriz;

struct matriz
{
	string nome;
	string apelido;
	string tipo;
	string tam_linha;
	string tam_coluna;

} typedef matriz;

vector<matriz> matrizes;
vector<simbolo_tipo> tabela_simbolos;
vector<string> swit;
vector<loop> limites_loop;
vector<vector<simbolo_tipo>> mapa;
vector<loop> loops;
vector<string> funcao_mapa;
vector<funcao> mapa_funcoes;
vector<simbolo_tipo> tabela_global;



int yylex(void);
void yyerror(string);
void adiciona_contexto();
void retira_contexto();
void adiciona_variavel_tabela_simbolos(string, string, string );
void adiciona_variavel_swit(string );
void adiciona_string_tabela_simbolos(string, string, string, int);
void adiciona_limite_loop(string inicio,string fim, string nome);
void verifica_tipo_condicao(string tipo);
void verifica_tipo_relacional(string tipo1 , string tipo2);
void verifica_variavel_tabela_simbolos(string );
void verifica_tipo_expo(string name ,string name2);
void verifica_variavel_declarada(string );
void funcoes_traducao();
void verifica_tipo_condicao_IF(string nome);
void adiciona_loop();
void adiciona_loop_switch();
void retira_loop_switch();
void contador_linha();
void adiciona_matriz(string name,string nick,string type,string linha , string coluna);
void verifica_posicao_elemento_matriz(string name , string pos_linha ,string pos_coluna);
void adiciona_tabela_global(struct atributos );
bool verifica_string(struct atributos, struct atributos);
bool verifica_tipo_entre_variavel(string, string);
bool verifica_tipo_logico(string tipo1 , string tipo2);
string print_declaracoes();
string verifica_declaracao_tipo(string);
string puxa_apelido_tabela_simbolos(string);
string puxa_tipo_tabela_simbolos(string name);
string puxa_apelido_swit();
string puxa_fim_loop();
string puxa_inicio_loop();
string verifica_tamanho_traducao(struct atributos);
string conversao_bool_int(string );
string puxa_tipo_tabela_simbolos_IF(string name);
string puxa_apelido_tabela_simbolos_IF(string name);
string printa_tabela_global();
string puxa_apelido_funcao(string );
struct atributos conversao_implicita(struct atributos,struct atributos);
struct atributos operacao(struct atributos, struct atributos, string );
struct atributos operacao_condicional(struct atributos , struct atributos , string );
struct atributos operacao_string(struct atributos, struct atributos);
struct atributos operacao_unitarios(struct atributos atr_1, struct atributos atr_2, string op);
struct atributos operacao_pot(struct atributos atr_1, struct atributos atr_2, string op);
struct atributos operacao_composto(struct atributos atr_1, struct atributos atr_2, string op);
struct atributos guarda_declaracao_parametro(string , string);
struct atributos guarda_declaracao_funcao(string , string);

string traducao_funcao = "";
string traducao_variaveis = "";
string qtd_linha = "1";

int contexto_funcao = 0;
int label_i = 1;
int cond_i = 1;
int cond_forr = 1;
int cond_iff =1;
int cas_i = 1;
int inicio_i = 1;
int fim_i = 1;
int cont_loop = 0;
int contador_loop = 0;
int contador = 0;
int cont_linha = 1;
int contexto = 0;


std::string gen_label(){
	std::stringstream label;	
    label << "temp" << label_i++;
    return label.str();
}

std::string gen_cond(){
	std::stringstream cond;	
    cond << "_" << cond_i++;
    return cond.str();
}

std::string gen_cond_if_expo(){
	std::stringstream cond_if;	
    cond_if << "_" << cond_iff++;
    return cond_if.str();
}

std::string gen_cond_for_expo(){
	std::stringstream cond_for;	
    cond_for << "_" << cond_forr++;
    return cond_for.str();
}

std::string gen_cas(){
	std::stringstream cas;	
    cas << "case_" << cas_i++;
    return cas.str();
}

std::string gen_inicio_loop(){
	std::stringstream labe;	
    labe << "_" << inicio_i++;
    return labe.str();
}

std::string gen_fim_loop(){
	std::stringstream labe;	
    labe << "_" << fim_i++;
    return labe.str();
}

std::string inicio_loop(){
	std::stringstream labe;	
    labe << "_" << contador;
    return labe.str();
}

std::string fim_loop(){
	std::stringstream labe;	
    labe << "_" << contador;
    return labe.str();
}

%}


%token TK_NUM TK_REAL TK_CHAR TK_STRING 
%token TK_ID TK_TIPO_INT TK_TIPO_FLOAT TK_TIPO_CHAR TK_TIPO_BOOL TK_TIPO_STRING TK_MATRIX TK_VECTOR 
%token TK_LOGICO TK_MENOR_IGUAL TK_MAIOR_IGUAL TK_DIFERENTE TK_IGUALDADE TK_MAIS_MAIS TK_MENOS_MENOS TK_OR TK_AND TK_MAIS_IGUAL TK_MENOS_IGUAL TK_MULTI_IGUAL TK_DIV_IGUAL
%token TK_IF TK_ELSE TK_SWITCH TK_CASE TK_WHILE TK_DEFAULT TK_FOR TK_DO TK_BREAK TK_CONTINUE TK_SCANF TK_PRINTF TK_FUNCTION TK_RETURN TK_MAIN
%token TK_FIM TK_ERROR

%start S

%left '=' 
%left TK_OR TK_AND
%left '>' '<' TK_DIFERENTE TK_IGUALDADE TK_MAIOR_IGUAL TK_MENOR_IGUAL TK_MAIS_IGUAL TK_MENOS_IGUAL TK_MULTI_IGUAL TK_DIV_IGUAL
%left '+' '-' 
%left '*' '/' '%'
%left TK_POTENCIA 


%%

S             : INICIO 
			{
				
				cout <<"/*Compilador LVN*/\n#include <iostream>\n#include <string.h>\n#include <stdio.h> \n\n"<< printa_tabela_global() << endl; funcoes_traducao(); cout << "int main(void)\n{\n"+ traducao_variaveis + ""  << $1.traducao << "\n\n";
			}
			;

INICIO        : DECLARA_TIPOS ';' INICIO
			{
				
				adiciona_tabela_global($1);
				$$.apelido =  $1.apelido;
				$$.label = $1.label;
				$$.tipo = $1.tipo;
				$$.traducao = $3.traducao;
			}
			| FUNCTION INICIO
			{
				$$.traducao = $2.traducao;		
			}

			| TK_TIPO_INT TK_MAIN '(' ')' BLOCO 
			{
				$$.traducao = $5.traducao + "\n}" ;
			}
			|
			{

			}
			;
FUNCTION      : TK_FUNCTION TYPES  '(' PARAMETRO ')' BLOCO
			{  
				int i = contexto_funcao; 
				
				mapa_funcoes[i].nome = $2.label;
				mapa_funcoes[i].retorno = $2.tipo;
				mapa_funcoes[i].apelido = $2.apelido;
				
				traducao_funcao = $2.tipo  +" "+ $2.apelido + "(" + $4.traducao + "){\n" + traducao_variaveis;
				
				traducao_funcao += $6.traducao + "}\n";
				funcao_mapa.push_back(traducao_funcao);
				traducao_funcao = " ";
				traducao_variaveis = "";
				contexto_funcao++;
			}
			;
TYPES		  : TK_TIPO_INT TK_ID
			{	
				$$ = guarda_declaracao_funcao($2.label,"int");
			}
			| TK_TIPO_FLOAT TK_ID
			{
				$$ = guarda_declaracao_funcao($2.label,"float");
			}
			;
PARAMETRO     : DECLARA_TIPOS
			{
				
				funcao f;
				simbolo_tipo simbolo;
				simbolo.nome = $1.label;
				simbolo.tipo = $1.tipo;
				simbolo.apelido = $1.apelido;
				f.parametros.push_back(simbolo);
				mapa_funcoes.push_back(f);
				$$.traducao = $1.tipo + " " + simbolo.apelido;
				adiciona_variavel_tabela_simbolos(simbolo.nome, simbolo.tipo, simbolo.apelido);
			}
			| DECLARA_TIPOS ',' PARAMETRO
			{
				funcao f;
				simbolo_tipo simbolo;
				simbolo.nome = $1.label;
				simbolo.tipo = $1.tipo;
				simbolo.apelido = $1.apelido;
				f.parametros.push_back(simbolo);
				mapa_funcoes.push_back(f);
				
				$$.traducao = $1.tipo + " " + simbolo.apelido + ", "+$3.traducao;
				adiciona_variavel_tabela_simbolos(simbolo.nome, simbolo.tipo, simbolo.apelido);	
			}
			|	
			{
				funcao f;
				mapa_funcoes.push_back(f);
				$$.traducao = "";
			}
			;
DECLARA_TIPOS : TK_TIPO_INT TK_ID
			{
				verifica_variavel_declarada($2.label);
				$$ = guarda_declaracao_parametro($2.label, "int");
			}
			| TK_TIPO_FLOAT TK_ID
			{
				verifica_variavel_declarada($2.label);
				$$ = guarda_declaracao_parametro($2.label, "float");
			}
			| TK_TIPO_CHAR TK_ID 
			{
				verifica_variavel_declarada($2.label);
				$$ = guarda_declaracao_parametro($2.label, "char");				
			}
			| TK_TIPO_BOOL TK_ID
			{
				verifica_variavel_declarada($2.label);
				$$ = guarda_declaracao_parametro($2.label, "bool");			
			}
			| TK_TIPO_STRING TK_ID 
			{
				verifica_variavel_declarada($2.label);
				$$ = guarda_declaracao_parametro($2.label, "string");	
			}
			;
BLOCO		  :'{' COMANDOS '}'  
			{
				$$.traducao = $2.traducao;
			}
			;



COMANDOS	  : COMANDO COMANDOS
			{
				$$.traducao = $1.traducao + $2.traducao;
			}
			| BLOCO	
			{
				$$.traducao = $1.traducao;
			}
			| SELECAO COMANDOS
			{
				$$.traducao = $1.traducao + $2.traducao;
			} 
			| REPETICAO COMANDOS
			{
				$$.traducao = $1.traducao + $2.traducao;
			}
			| RETURN COMANDOS
			{
				$$.traducao = $1.traducao;
			}
			|
			{
				$$.traducao = "";
			}
			| CHAMADA COMANDOS
			{
				$$.traducao = $1.traducao + $2.traducao;
			}
			;
CHAMADA       : TK_ID '('')'
			{
				string apelido = puxa_apelido_funcao($1.label);
				$$.traducao ="\t" + apelido + "();\n";
			}
			| TK_ID '(' ARGUMENTO ')'
			{
				string apelido = puxa_apelido_funcao($1.label);
				$$.traducao ="\t" + apelido + "(" + $3.traducao + ");\n";
			}
			;
ARGUMENTO     : TK_ID 
			{
				string apelido = puxa_apelido_tabela_simbolos($1.label);
				$$.traducao = apelido;
			}
			| TK_ID ',' ARGUMENTO
			{
				string apelido = puxa_apelido_tabela_simbolos($1.label);
			 	$$.traducao =  apelido +","+ $3.traducao;
			}
			;
RETURN        : TK_RETURN E ';'
			{
				string apelido  = puxa_apelido_tabela_simbolos($2.label);
				$$.traducao = "\n\treturn " + apelido + ";\n";
			}
			;

REPETICAO	  : TK_WHILE '(' E ')' BLOCO 
			{
				$$.label = gen_label();
				string inicio_loop = loops[contador-1].inicio_loop;
				string fim_loop = loops[contador-1].fim_loop;
				string apelido =  puxa_apelido_tabela_simbolos($3.label);
				adiciona_variavel_tabela_simbolos($$.label,"bool",$$.label);
				verifica_tipo_condicao($3.label);
				
				$$.traducao = "INICIO_L"+inicio_loop  + ":\n" +  $3.traducao + "\t"
				+ $$.label + " = !" + apelido + ";\n" +"\t"+
				"if(" + $$.label + ") goto " +  "FIM_L" + fim_loop + ";\n"
				+ $5.traducao + "\t" + "goto "+ "INICIO_L"+inicio_loop +";\n"+ "FIM_L" + fim_loop +":\n";	
				contador--;
				contador_loop--;
			}
			| TK_DO BLOCO TK_WHILE '(' E ')' ';'
			{
				$$.label = gen_label();
				string inicio_loop = loops[contador-1].inicio_loop;
				string fim_loop = loops[contador-1].fim_loop;
				string apelido =  puxa_apelido_tabela_simbolos($5.label);
				adiciona_variavel_tabela_simbolos($$.label,"bool",$$.label);
				verifica_tipo_condicao($5.label);
				
				$$.traducao = "INICIO_L"+inicio_loop + ":\n" + $2.traducao +
				$5.traducao + "\t" +$$.label +" = !" + $5.label +"\n"
				+ "\tif(" + $$.label + ")goto " + "FIM_L" + fim_loop  + ";\n"
				"\tgoto INICIO_L"+inicio_loop +";\n"   + "FIM_L" + fim_loop  + ";\n";
				 contador--; 
			}
			| TK_FOR '(' ATRIBUICAO ';' RELACIONAL ';' E ')' BLOCO 
			{
				$$.label = gen_label();	
				string inicio_loop = loops[contador-1].inicio_loop;
				string fim_loop = loops[contador-1].fim_loop;
				string apelido =  puxa_apelido_tabela_simbolos($7.label);
				adiciona_variavel_tabela_simbolos($$.label,"bool",$$.label);
				
				$$.traducao =  $3.traducao +
				"INICIO_L"+inicio_loop + ":\n" + $5.traducao + "\t"+$$.label + " = !"+$5.label
				+ ";\n\tif(" + $$.label + ")"+ " goto "+ "FIM_L" + fim_loop
				+ ";\t\n" + $9.traducao + 
				$7.traducao + "\tgoto " +"INICIO_L"+inicio_loop + ";\n" +"FIM_L" + fim_loop +":\n" ;
				contador--;
			}
			;

SELECAO		  : TK_IF '(' E ')' BLOCO 
			{
				verifica_tipo_condicao_IF($3.label);
				$$.label = gen_label();
				string inicio_fim = gen_cond();
				string apelido =  puxa_apelido_tabela_simbolos_IF($3.label);
				adiciona_variavel_tabela_simbolos($$.label,"int",$$.label);

				$$.traducao = $3.traducao + "\t" 
				+ $$.label + " = !" +  apelido + ";\n" + "\t" +"INICIO_IF"+inicio_fim +":\n" + "\t" 
				"if(" + $$.label + ") goto " + "FIM_IF"+ inicio_fim  + ";\n"
				+ $5.traducao + "\t" + "FIM_IF"+ inicio_fim + ":\n" ;	 
			}
			| TK_IF '(' E ')'  BLOCO TK_ELSE BLOCO
			{
				$$.label = gen_label();
				string inicio_fim = gen_cond();
				string apelido =  puxa_apelido_tabela_simbolos($3.label);
				verifica_tipo_condicao($3.label);
				adiciona_variavel_tabela_simbolos($$.label,"bool",$$.label);
	
				$$.traducao = $3.traducao + "\t" 
				+ $$.label + " = !" + $3.label + ";\n" +"INICIO_IF"+inicio_fim  +":\n\t"+
				"if(" + $$.label + ") goto else"+ inicio_fim+ ";\n" + $5.traducao  + "\tgoto FIM_IF"+ inicio_fim + ";\n" +
				"else"+inicio_fim +":\n" + $7.traducao +"FIM_IF"+ inicio_fim +":\n" ;
			}
			| SWITCH '{' CASES DEFAULT'}' 
			{
				int i = cont_loop-1;
				$$.traducao = "\n\tINICIO_SWITCH" + limites_loop[i].inicio_loop +":" +$1.traducao + $3.traducao + $4.traducao;
			}
			;

SWITCH		  : TK_SWITCH '(' E ')' 
			{
				adiciona_loop_switch();		
				string apelido =  puxa_apelido_tabela_simbolos($3.label);
				adiciona_variavel_swit(apelido);
				$$.traducao = "";	
			}


CASES		  : CASE_LIST CASES
			{
				$$.traducao = $1.traducao + $2.traducao;
			}
			|
			{
				$$.traducao = "";
			}
			;

CASE_LIST	  : TK_CASE E':' COMANDOS
			{	
				$$.label = gen_label();
				string apelido =  puxa_apelido_tabela_simbolos($3.label);
				string var_switch = swit[0];
				string cas = gen_cas();
				string nega = gen_label();
				adiciona_variavel_tabela_simbolos($$.label, "bool",$$.label);
				adiciona_variavel_tabela_simbolos(nega, "int",nega);

				$$.traducao ="\n\n\tINICIO_" + cas +  ":\n"+$2.traducao +
				"\t"+$$.label + " = " + var_switch +" == " + $2.label  +";\n\t"+
				nega + " = !" + $$.label + 
				";\n\tif(!" + nega +") goto FIM_"+ cas+":\n" + $4.traducao + "\tFIM_"+ cas + ":\n";
			}
			;

DEFAULT		  : TK_DEFAULT':' COMANDOS
			{
				int i = cont_loop-1;	
				$$.traducao = "\n\tdefault:\n" + $3.traducao + "\tFIM_SWITCH" + limites_loop[i].fim_loop +":\n";
			}
			;

JUMP		  : TK_BREAK ';' 
			{
				int i = contador_loop -1;
				if( limites_loop.size() > 0){
					if(limites_loop[i].nome == "switch"){
						$$.traducao = "\tgoto FIM_SWITCH" + limites_loop[i].fim_loop + ":\n"; 
					}
				}
				if(loops[i].nome == "loop"){
				int ultimo_laco = contador_loop - 1;
				
				if(ultimo_laco > 0){					
					$$.traducao = "\tgoto  FIM_L" + loops[ultimo_laco].fim_loop + ":\n";
					contador_loop--;
				}
				$$.traducao = "\tgoto  FIM_L" + loops[ultimo_laco].fim_loop + ":\n"; 
					contador_loop--; 
				}
			}
			| TK_CONTINUE ';'
			{
								
				$$.traducao = "\tgoto INICIO_L" + loops[contador-1].inicio_loop + ":\n";
 			}
			;

COMANDO 	  : E ';'
			{
				$$.traducao  =  $1.traducao;
			}
			| RELACIONAL
			{
				$$.traducao = $1.traducao;
			}
			| JUMP 
			{
				$$.traducao = $1.traducao;
			}
			| LOGICOS
			{
				$$.traducao = $1.traducao;
			} 
			;

E 			  : TK_ID
			{	

				verifica_variavel_tabela_simbolos($1.label);
			}
			| TIPOS
			{
				$$.traducao = $1.traducao;
			}
			| ATRIBUICAO
			{
				$$.traducao = $1.traducao;
			}
			| UNITARIOS
			{
				$$.traducao = $1.traducao;
			}
			| IN_OUT
			{
				$$.traducao = $1.traducao;
			}
			| OPERACOES
			{
				$$.traducao = $1.traducao;
			}
			| MATRIZ 
			{
				$$.traducao = $1.traducao;
			}
			| ATRI_MATRIZ 
			{
				$$.traducao = $1.traducao;
			}
			| VIRGULA
			{
				$$.traducao = $1.traducao;
			}
			;
VIRGULA		  : DECLARA_TIPO '=' '(' E ',' E ',' E ')'
			{
				string apelido = puxa_apelido_tabela_simbolos($1.label);
				$$.traducao = $4.traducao + $6.traducao + $8.traducao + "\t" + apelido + " = " + $8.label + ";\n";
			}

OPERACOES     : ARITMETICO
			{
				$$.traducao = $1.traducao;
			}
			| LOGICOS
			{
				$$.traducao = $1.traducao;
			}
			| RELACIONAL
			{
				$$.traducao = $1.traducao;
			}
			| COMPOSTO
			{
				$$.traducao = $1.traducao;
			}
			;
LOGICOS 	  : E TK_OR E
			{	
				bool flag = verifica_tipo_logico($1.tipo,$3.tipo);
			
				if(!flag){
					$$.label = gen_label();
					$$.tipo = "bool";
					$$.traducao = $1.traducao + $3.traducao + 
					"\t" + $$.label + " = " + $1.label + " || " + $3.label+";\n";
					adiciona_variavel_tabela_simbolos($$.label, "int",$$.label);
				}else{
					yyerror("tipo incompativel , operador lógico aceita apenas operadores do tipo bool");
				}
			}
			| E TK_AND E
			{
				bool flag = verifica_tipo_logico($1.tipo,$3.tipo);
				if(!flag){
					$$.label = gen_label();
					$$.tipo = "bool";
					$$.traducao = $1.traducao + $3.traducao + 
					"\t" + $$.label + " = " + $1.label + " && " + $3.label+";\n";
					adiciona_variavel_tabela_simbolos($$.label, "int",$$.label);
				}else{
					yyerror("tipo incompativel , operador lógico aceita apenas operadores do tipo bool");
				}
			}
			;

IN_OUT		  : TK_SCANF '(' TK_ID ')'
			{
				string apelido = puxa_apelido_tabela_simbolos($3.label);
				$$.traducao = "\t" "cin >> " + apelido + ";\n";
			}
			| TK_PRINTF '(' E ')' 
			{
				string apelido = puxa_apelido_tabela_simbolos($3.label);
				string traducao = verifica_tamanho_traducao($3);
				$$.traducao = "\tcout << " + apelido + ";\n";
			}
			;
TIPOS 		  : TK_LOGICO
			{
				$$.label = gen_label();
				$$.tipo = "bool";
				string traducao = conversao_bool_int($1.traducao);
				$$.apelido = $$.label;
				$$.traducao = "\t" + $$.label + " = " + traducao +";\n";
				adiciona_variavel_tabela_simbolos($$.label, "bool", $$.label);
				traducao_variaveis += "\tint " + $$.label+";\n";

			}
			| TK_NUM
			{
				$$.label = gen_label();
				$$.tipo = "int";
				$$.apelido = $$.label;
				adiciona_variavel_tabela_simbolos($$.label, $$.tipo,$$.label);
				$$.traducao = "\t" + $$.label + " = " + $1.traducao + ";\n";
				traducao_variaveis += "\tint " + $$.label+";\n";

			}
			| TK_REAL
			{
				$$.label = gen_label();
				$$.tipo = "float";
				$$.apelido = $$.label;
				adiciona_variavel_tabela_simbolos($$.label, $$.tipo,$$.label);
				$$.traducao = "\t" + $$.label + " = " + $1.traducao + ";\n";
				traducao_variaveis += "\tfloat " + $$.label+";\n";
			}
			| TK_CHAR
			{	
				string tipo = $1.label;
				$$.tipo = verifica_declaracao_tipo(tipo);
				$$.label = gen_label();
				$$.apelido = $$.label;
				$$.traducao = "\t" + $$.label + " = " + $1.traducao + ";\n";
				adiciona_variavel_tabela_simbolos($$.label, $$.tipo,$$.label);
				traducao_variaveis += "\tchar " + $$.label+";\n";
			}
			| TK_STRING
			{
				string tipo = $1.label;
				$$.tipo = verifica_declaracao_tipo(tipo);
				$$.label = gen_label();
				$$.apelido = $$.label;
				$$.traducao = "\tstrcpy(" + $$.label + " , " +  $1.traducao + ");\n";
				int tamanho = $1.traducao.size() - 1;
				adiciona_string_tabela_simbolos($$.label, $$.tipo, $$.label, tamanho);
				traducao_variaveis += "\tchar[" + std::to_string(tamanho)  + "] " + $$.label+";\n";
			}
			;



ARITMETICO	  : E '+' E
			{	
				$$ = operacao($1,$3," + ");
			}
			| E '-' E
			{
				$$ = operacao($1,$3," - ");
			}
			| E '*' E
			{
				$$ = operacao($1,$3," * ");
			}
			| E '/' E
			{
				$$ = operacao($1,$3," / ");
			}
			| E '%' E
			{
				$$ = operacao($1,$3," % ");
			}
			| E TK_POTENCIA E
			{
				verifica_tipo_expo($1.label,$3.label);
				$$ = operacao_pot($1,$3," ** ");
			}
			;

COMPOSTO	  : TK_ID TK_MAIS_IGUAL E
			{
				$$ = operacao_composto($1,$3," + ");
			}
			| TK_ID TK_MENOS_IGUAL E
			{
				$$ = operacao_composto($1,$3," - ");
			}
			| TK_ID TK_MULTI_IGUAL E
			{
				$$ = operacao_composto($1,$3," * ");
			}
			| TK_ID TK_DIV_IGUAL E
			{
				$$ = operacao_composto($1,$3," * ");
			}
			;

UNITARIOS	  : TK_ID TK_MAIS_MAIS
			{
				$$ = operacao_unitarios($1,$2 ," + ");
			}
			| TK_ID TK_MENOS_MENOS
			{
				$$ = operacao_unitarios($1,$2 ," - ");
			}
			;

ATRIBUICAO    : TK_ID '=' E
			{	
				struct atributos atr, atr_aux;		
				atr.label = puxa_apelido_tabela_simbolos($1.label);
				atr.tipo = puxa_tipo_tabela_simbolos($1.label);
				atr_aux.label = puxa_apelido_tabela_simbolos($3.label);
				atr_aux.tipo = puxa_tipo_tabela_simbolos($3.label);
				$1.tipo = atr.tipo;
				verifica_variavel_tabela_simbolos($1.label);
						
				if(verifica_tipo_entre_variavel(atr.tipo,atr_aux.tipo)){
					yyerror("atribuicao com tipo incompativel, variavel \033[32m"+$1.label +"\033[0m aceita apenas tipo "+ atr.tipo);
				} 
				$$.label = atr.label;
				$$.tipo = atr_aux.tipo;
				$$.traducao = $3.traducao + "\t" + atr.label + " = "+ atr_aux.label + ";\n";
				
				if(verifica_string($1,$3)){
					$$ = operacao_string($1,$3);
				}
				
			}
			| DECLARA_TIPO '=' E
			{
				string apelido = puxa_apelido_tabela_simbolos($1.label);
				string tipo = puxa_tipo_tabela_simbolos($1.label);
				if(verifica_tipo_entre_variavel(tipo,$3.tipo)){
					yyerror("atribuicao com tipo incompativel, variavel \033[32m"+$1.label +"\033[0m aceita apenas tipo "+ tipo);
				}
				$$.traducao =  $3.traducao + "\t" + apelido + " = " +
				$3.label + ";\n";
				if(verifica_string($1,$3)){
					$$ = operacao_string($1,$3);
				}
			}
			| '(' TK_TIPO_FLOAT ')' TK_NUM
			{
				$$.label = gen_label();
				$$.tipo = "int";
				$$.traducao = "\t" + $$.label + " = " + $4.traducao+";\n";
				adiciona_variavel_tabela_simbolos($$.label, $$.tipo, $$.label);
			}
			| DECLARA_TIPO
			{
				$$.traducao = $1.traducao;
			}
			;
MATRIZ 		  : TK_MATRIX TK_TIPO_INT TK_ID'[' TK_NUM']''[' TK_NUM']'
			{
				verifica_variavel_declarada($2.label);
				$$.label = $3.label;
				$$.tipo = "int";
				
				string apelido = gen_label();
				string tamanho = gen_label();
				string coluna = gen_label();
		
				adiciona_variavel_tabela_simbolos($$.label, "matrix",apelido);
				adiciona_variavel_tabela_simbolos($5.traducao, $$.tipo,tamanho);
				adiciona_variavel_tabela_simbolos($8.traducao, $$.tipo,coluna  );
				adiciona_matriz($$.label,apelido,$$.tipo,$5.traducao, $8.traducao);

				traducao_variaveis += "\tint " + apelido+";\n\tint " + tamanho +";\n\tint " + coluna +";\n";
				$$.traducao ="\n\t" + tamanho + " = " + $5.traducao + ";\n\t"+coluna + " = " + $8.traducao + ";\n\t"  + apelido + "[" + tamanho + "][" +coluna +"];\n" ;

			}
			| TK_VECTOR TK_TIPO_INT TK_ID'[' TK_NUM']'
			{
				verifica_variavel_declarada($2.label);
				$$.label = $3.label;
				$$.tipo = "int";
				string apelido = gen_label();
				string tamanho = gen_label();
				adiciona_variavel_tabela_simbolos($$.label, "vector",apelido );
				adiciona_variavel_tabela_simbolos($5.traducao, $$.tipo,tamanho );
				adiciona_matriz($$.label,apelido,$$.tipo,"1", $5.traducao);
				
				traducao_variaveis += "\tint " + apelido+";\n\tint " + tamanho +";\n" ;
				$$.traducao ="\n\t" + tamanho + " = " + $5.traducao
				 + ";\n\t"  + apelido + "[" + tamanho + "];\n" ;



			}

ATRI_MATRIZ   : TK_ID'[' TK_NUM']''[' TK_NUM']' '=' E
			{
				verifica_variavel_tabela_simbolos($1.label);
				
				string apelido = puxa_apelido_tabela_simbolos($1.label);
				string linha = gen_label();
				string coluna = gen_label();

				adiciona_variavel_tabela_simbolos($3.traducao, "int",linha );
				adiciona_variavel_tabela_simbolos($6.traducao, "int",coluna );
				verifica_posicao_elemento_matriz($1.label ,$3.traducao ,$6.traducao);

				traducao_variaveis += "\tint "+ $9.label +";\n\tint " + linha +";\n\tint " + coluna +";\n";
				
				$$.traducao ="\n\t" + linha + " = " + $3.traducao + ";\n\t"+coluna + " = " +
				$6.traducao + ";\n"  + $9.traducao + "\t"+apelido + "[" + linha + "][" +coluna +"] = "+ $9.label +";\n" ;
			}
			| TK_ID'[' TK_NUM']' '=' E
			{
				verifica_variavel_tabela_simbolos($1.label);
				string apelido = puxa_apelido_tabela_simbolos($1.label);
				string coluna = gen_label();
				
				adiciona_variavel_tabela_simbolos($3.traducao, "int",coluna );
				verifica_posicao_elemento_matriz($1.label , $3.traducao,"1");
				traducao_variaveis += "\tint "+ $6.label +";\n\tint " + coluna + ";\n";
				
				$$.traducao = "\n\t"+coluna + " = " +
				$3.traducao + ";\n"  + $6.traducao + "\t"+apelido + "[" +coluna +"] = "+ $6.label +";\n" ;
			}
			|  MATRIZ '=' '[' VETOR_VETOR ']'
			{
				$$.traducao = $1.traducao + $4.traducao;
			}
			;
VETOR_VETOR   : VECTOR VETOR_VETOR
			{
				$$.traducao = $1.traducao + $2.traducao;
			}
			|
			{
				$$.traducao = "";
			}
			;
VECTOR		  : '(' E ')'
			{
				traducao_variaveis += "\tint "+ $2.label ;
			}


DECLARA_TIPO  : TK_TIPO_INT TK_ID
			{
				verifica_variavel_declarada($2.label);
				$$.label = $2.label;
				$$.tipo = "int";
				$$.traducao = "";
				string apelido = gen_label();
				$$.apelido = apelido;
				traducao_variaveis += "\tint " + apelido+";\n";
				adiciona_variavel_tabela_simbolos($$.label, $$.tipo,apelido );	
			}
			| TK_TIPO_FLOAT TK_ID
			{
				verifica_variavel_declarada($2.label);
				$$.label = $2.label;
				$$.tipo = "float";
				$$.traducao = "";
				string apelido = gen_label();
				traducao_variaveis += "\tfloat " + apelido+";\n";
				adiciona_variavel_tabela_simbolos($$.label, $$.tipo,apelido);
			}
			| TK_TIPO_CHAR TK_ID 
			{
				verifica_variavel_declarada($2.label);
				$$.label = $2.label;
				$$.tipo = "char";
				$$.traducao = " ";
				string apelido = gen_label();
				traducao_variaveis += "\tchar " + apelido+";\n";
				adiciona_variavel_tabela_simbolos($$.label, $$.tipo, apelido);	
			}
			| TK_TIPO_BOOL TK_ID
			{
				verifica_variavel_declarada($2.label);
				$$.label = $2.label;
				$$.tipo = "bool";
				$$.traducao = " ";
				string apelido = gen_label();
				traducao_variaveis += "\tint " + apelido+";\n";
				adiciona_variavel_tabela_simbolos($$.label, $$.tipo,apelido);
			}
			| TK_TIPO_STRING TK_ID 
			{
				verifica_variavel_declarada($2.label);
				$$.label = $2.label;
				$$.tipo = "string";
				$$.traducao = " ";
				string apelido = gen_label();
				traducao_variaveis += "\tchar[255] " + apelido+";\n"; 
				adiciona_string_tabela_simbolos($$.label, $$.tipo, apelido, 255);
			}
			;

RELACIONAL 	  : E '>' E
			{	
				verifica_tipo_relacional($1.label, $3.label);
				$$ = operacao_condicional($1,$3," > ");
			}
			|  E '<' E
			{
				verifica_tipo_relacional($1.label, $3.label);
				$$ = operacao_condicional($1,$3, " < ");
			}
			| E TK_DIFERENTE E
			{
				$$ = operacao_condicional($1,$3, $2.traducao);			
			}
			| E TK_IGUALDADE E
			{
				$$ = operacao_condicional($1,$3, $2.traducao);	
			}
			| E TK_MENOR_IGUAL E
			{
				verifica_tipo_relacional($1.label, $3.label);
				$$ = operacao_condicional($1,$3, $2.traducao);	
			}
			| E TK_MAIOR_IGUAL E
			{
				verifica_tipo_relacional($1.label, $3.label);
				$$ = operacao_condicional($1,$3, $2.traducao);		
			}
			;


%%

#include "lex.yy.c"

int yyparse();

struct atributos operacao_condicional(struct atributos atr_1, struct atributos atr_2, string op){
	struct atributos resultado,aux_atr, atr, troca;
	string aux_op;

	if(atr_1.tipo == "" && atr_2.tipo == ""){
		for(int i = 0; i < tabela_simbolos.size(); i++){
			if(atr_1.label == tabela_simbolos[i].nome){
				atr.label = tabela_simbolos[i].apelido;
				atr_1.tipo = tabela_simbolos[i].tipo;
			
			}else if(atr_2.label == tabela_simbolos[i].nome){
				aux_atr.label = tabela_simbolos[i].apelido;
				atr_2.tipo = tabela_simbolos[i].tipo;
			}
		}
		if(verifica_tipo_entre_variavel(atr_1.tipo,atr_2.tipo)){
			struct atributos variavel = conversao_implicita(atr_1,atr_2);
			string apelido1 = puxa_apelido_tabela_simbolos(atr_1.label);
			string apelido2 = puxa_apelido_tabela_simbolos(atr_2.label);
			
			string cond1 = apelido1;
			string cond2 = apelido2;
				
			if(variavel.nome == atr_1.label){
				cond1 = variavel.label;
			}
			if(variavel.nome == atr_2.label){
				cond2 = variavel.label;
			}
			resultado.label = gen_label();
			resultado.tipo = "bool";
			traducao_variaveis += "\tint " + resultado.label+";\n";
			resultado.traducao = variavel.traducao + "\t" + resultado.label + " = " + cond1 + op + cond2 + ";\n";
			adiciona_variavel_tabela_simbolos(resultado.label, "bool", resultado.label);
			return resultado;
		
		}else{
			resultado.label = gen_label();
			traducao_variaveis += "\tint " + resultado.label+";\n";

			resultado.tipo = "bool";
			adiciona_variavel_tabela_simbolos(resultado.label, "bool",resultado.label);
			if(atr_1.traducao.size() < 2){
				resultado.traducao = "\t" + resultado.label + " = " + atr.label + op + aux_atr.label + ";\n" ;
			}else{
				resultado.traducao = atr_1.traducao + atr_2.traducao + "\t" + resultado.label + " = " + atr.label + op + atr_2.label + ";\n" ;
			}
			return resultado;
		}
	}

	for(int i = 0; i < tabela_simbolos.size(); i++){
		if(atr_1.label == tabela_simbolos[i].nome){
			atr.label = tabela_simbolos[i].apelido;
			atr_1.tipo = tabela_simbolos[i].tipo;
		}
		else if(atr_2.label == tabela_simbolos[i].nome){
				atr_2.tipo = tabela_simbolos[i].tipo;
			}
		}
		if(verifica_tipo_entre_variavel(atr_1.tipo,atr_2.tipo)){
			struct atributos variavel = conversao_implicita(atr_1,atr_2);
			string apelido1 = puxa_apelido_tabela_simbolos(atr_1.label);
			string apelido2 = puxa_apelido_tabela_simbolos(atr_2.label);
			
			string cond1 = apelido1;
			string cond2 = apelido2;

			if(variavel.nome == atr_1.label){
				cond1 = variavel.label;
			}
			if(variavel.nome == atr_2.label){
				cond2 = variavel.label;
			}
			resultado.label = gen_label();
			resultado.tipo = "bool";
			resultado.traducao = atr_1.traducao + atr_2.traducao + variavel.traducao + "\t" + resultado.label + " = " + cond1 + op + cond2 + ";\n";
			
			adiciona_variavel_tabela_simbolos(resultado.label, resultado.tipo , resultado.label);
			return resultado;
		}else{
			resultado.label = gen_label();
			resultado.tipo = "bool";
			adiciona_variavel_tabela_simbolos(resultado.label, resultado.tipo ,resultado.label);
			resultado.traducao = atr_1.traducao + atr_2.traducao + "\t" + resultado.label + " = " + atr.label + op + atr_2.label + ";\n" ;		
		}
		return resultado;
}

struct atributos operacao_unitarios(struct atributos atr_1, struct atributos atr_2, string op){
	struct atributos resultado,aux_atr, atr, troca;
	string aux_op;
	string op_unitario;
	vector<simbolo_tipo> tabela_simbolo;
		
	int achou = 0;

	if(atr_2.traducao == "++" || atr_2.traducao == "--"){
		for(int j = mapa.size()-1; j > 0; j--){
			tabela_simbolo = mapa[j]; 
			for(int i = 0; i < tabela_simbolo.size(); i++){
				if(atr_2.label == tabela_simbolo[i].nome){
					atr.label = tabela_simbolo[i].apelido;
					atr.tipo = tabela_simbolo[i].tipo;
					achou = 1;
				}
			}
			if(achou == 1){
				break;
			}
		} 
		resultado.label = atr.label;
		traducao_variaveis += "\tint " + resultado.label+";\n";

		resultado.tipo = atr.tipo;
		resultado.traducao = "\t" + resultado.label + " = " + resultado.label + op + "1" + ";\n";
	}
	return resultado;
}

struct atributos operacao_pot(struct atributos atr_1, struct atributos atr_2, string op){
	struct atributos resultado,aux_atr, atr, troca  ;
	string aux_op;
	string op_unitario;
	vector<simbolo_tipo> tabela_simbolo;
	int achou = 0;

	if(atr_1.tipo == "" && atr_2.tipo == ""){  
		for(int j = mapa.size()-1; j > 0; j--){
			tabela_simbolo = mapa[j]; 
			for(int i = 0; i < tabela_simbolo.size(); i++){
				if(atr_1.label == tabela_simbolo[i].nome){
					atr_1.traducao = tabela_simbolo[i].apelido;
					atr_1.tipo = tabela_simbolo[i].tipo;
					achou++;
				}else if(atr_2.label == tabela_simbolo[i].nome){
					atr_2.traducao = tabela_simbolo[i].apelido;
					atr_2.tipo = tabela_simbolo[i].tipo;
					achou++;
				}
			}
			if(achou == 2){
				break;
			}
		} 
		resultado.label = gen_label();
		resultado.tipo = atr_1.tipo;
		traducao_variaveis += "\tint " + resultado.label+";\n";

		aux_atr.label = gen_label();
		aux_atr.tipo = "bool";
		troca.label = gen_label();
		troca.tipo = "bool";
		atr.label = gen_label();
		atr.tipo = "bool";
		string aux1 = gen_label();
		adiciona_variavel_tabela_simbolos(resultado.label, resultado.tipo, resultado.label);
		adiciona_variavel_tabela_simbolos(aux_atr.label, aux_atr.tipo, aux_atr.label);
		adiciona_variavel_tabela_simbolos(troca.label, troca.tipo, troca.label);
		adiciona_variavel_tabela_simbolos(atr.label, atr.tipo, atr.label);
		adiciona_variavel_tabela_simbolos(aux1, "bool", aux1);			

		string for_expo = gen_cond_for_expo();
		string for_expo2 = gen_cond_for_expo();

		string if_expo = gen_cond_if_expo();
		
		resultado.traducao ="\n\t"+resultado.label + " = 1;\n\n\tINICIO_IF_expo"+if_expo+":\n\t" + aux_atr.label + " = "+atr_2.traducao +" >= 0;\n\tif( !"+ aux_atr.label +" ) goto ELSE_expo" + if_expo + ":"+ 
		"\n\t"+atr.label +" = 0;\n\tINICIO_FOR" +for_expo +":\n\t" + troca.label +" = " + atr.label + " < " +atr_2.traducao +";\n\t" + aux1 +" = !" + troca.label + 
		";\n\tif(" +aux1 +") goto FIM_FOR_expo"+for_expo + ":\n\t" + 
		resultado.label + " = " + resultado.label + " * " + atr_1.traducao + ";\n\t"+atr.label +" = "+ atr.label +" + 1;\n\t" +"FIM_FOR_expo" + for_expo +":\n\tgoto FIM_IF_expo"+if_expo +"\n\n\tELSE_expo" + if_expo + ":\n\t"+
			atr.label +" = 0;\n\tINICIO_FOR" +for_expo2 +":\n\t" + troca.label +" = " + atr.label + " > " +atr_2.traducao +";\n\t" + aux1 +" = !" + troca.label + 
		";\n\tif(" +aux1 +") goto FIM_FOR_expo"+for_expo2 + ":\n\t" + resultado.label + " = " + resultado.label + " / " + atr_1.traducao + ";\n\t"+atr.label +" = "+ atr.label +" - 1;\n\tFIM_FOR_expo" + for_expo2 
		+ ":\n\tFIM_IF_expo"+if_expo ;
	}
	return resultado;
}

struct atributos operacao_composto(struct atributos atr_1, struct atributos atr_2, string op){
	struct atributos resultado,aux_atr, atr, troca;
	string aux_op;
	string op_unitario;
	vector<simbolo_tipo> tabela_simbolo;
		
	int achou = 0;

	for(int j = mapa.size()-1; j > 0; j--){
		tabela_simbolo = mapa[j]; 
		for(int i = 0; i < tabela_simbolo.size(); i++){
			if(atr_1.label == tabela_simbolo[i].nome){
				atr.label = tabela_simbolo[i].apelido;
				atr.tipo = tabela_simbolo[i].tipo;
				achou = 1;
			}else if(atr_2.label == tabela_simbolo[i].nome){
				atr_2.tipo = tabela_simbolo[i].tipo;
				achou = 1;
			}
		}
		if(achou){
			break;
		}
	} 
	
	if(verifica_tipo_entre_variavel(atr.tipo,atr_2.tipo)){
		struct atributos variavel = conversao_implicita(atr_1,atr_2);
		string apelido1 = puxa_apelido_tabela_simbolos(atr_1.label);
		string apelido2 = puxa_apelido_tabela_simbolos(atr_2.label);
		
		string cond1 = apelido1;
		string cond2 = apelido2;

		if(variavel.nome == atr_1.label){
			cond1 = variavel.label;
		}
		if(variavel.nome == atr_2.label){
			cond2 = variavel.label;
		}
		resultado.label = gen_label();
		traducao_variaveis += "\tint " + resultado.label+";\n";

		resultado.tipo = "float";
		adiciona_variavel_tabela_simbolos(resultado.label, resultado.tipo,resultado.label);

		if(verifica_tipo_entre_variavel(atr.tipo,resultado.tipo)){
					yyerror("atribuicao com tipo incompativel, variavel \033[32m"+atr_1.label +"\033[0m aceita apenas tipo "+ atr.tipo);
				} 
		resultado.traducao = atr_1.traducao + atr_2.traducao + variavel.traducao + "\t" + resultado.label + " = " + cond1 + op + cond2 + ";\n\t" 
		+ cond1 + " = " + resultado.label + ";\n" ;
		
		return resultado;
	}else{
		resultado.label = gen_label();
		resultado.tipo = atr.tipo;
		traducao_variaveis += "\tint " + resultado.label+";\n";
		adiciona_variavel_tabela_simbolos(resultado.label, resultado.tipo, resultado.label);
		if(atr_1.traducao.size() < 2){
			resultado.traducao = atr_2.traducao + "\t" + resultado.label + " = " + atr.label + op + atr_2.label + ";\n\t" 
			+ atr.label + " = " + resultado.label + ";\n" ;
		}else {	
			resultado.traducao = atr_1.traducao + atr_2.traducao + "\t" + resultado.label + " = " + atr.label + op + atr_2.label + ";\n\t" 
			+ atr.label + " = " + resultado.label + ";\n" ;
		}
		return resultado;
	}
}

struct atributos operacao(struct atributos atr_1, struct atributos atr_2, string op){
	struct atributos resultado,aux_atr, atr, troca;
	string aux_op;
	string op_unitario;
	vector<simbolo_tipo> tabela_simbolo;
		
	int achou = 0;

	 
	if(atr_1.tipo == "" && atr_2.tipo == ""){  
		for(int j = mapa.size()-1; j > 0; j--){
			tabela_simbolo = mapa[j]; 
			for(int i = 0; i < tabela_simbolo.size(); i++){
				if(atr_1.label == tabela_simbolo[i].nome){
					atr_1.apelido = tabela_simbolo[i].apelido;
					atr_1.tipo = tabela_simbolo[i].tipo;
					achou++;
				}else if(atr_2.label == tabela_simbolo[i].nome){
					atr_2.apelido = tabela_simbolo[i].apelido;
					atr_2.tipo = tabela_simbolo[i].tipo;
					achou++;
				}
			}
			if(achou == 2){
				break;
			}
		} 
		atr_1.apelido = puxa_apelido_tabela_simbolos(atr_1.label);
		atr_2.apelido = puxa_apelido_tabela_simbolos(atr_2.label);

		if(verifica_tipo_entre_variavel(atr_1.tipo,atr_2.tipo)){
			struct atributos variavel = conversao_implicita(atr_1,atr_2);
			string apelido1 = puxa_apelido_tabela_simbolos(atr_1.label);
			string apelido2 = puxa_apelido_tabela_simbolos(atr_2.label);
			string cond1 = apelido1;
			string cond2 = apelido2;

			if(variavel.nome == atr_1.label){
				cond1 = variavel.label;
			}
			if(variavel.nome == atr_2.label){
				cond2 = variavel.label;
			}
			resultado.label = gen_label();
			resultado.tipo = "float";
			resultado.traducao = variavel.traducao + "\t" + resultado.label + " = " + cond1 + op + cond2+ ";\n";
			adiciona_variavel_tabela_simbolos(resultado.label, resultado.tipo,resultado.label);
			return resultado;
		}else{
			resultado.label = gen_label();
			resultado.tipo = atr_1.tipo;
			traducao_variaveis += "\tint " + resultado.label+";\n";

			adiciona_variavel_tabela_simbolos(resultado.label, resultado.tipo, resultado.label);
			resultado.traducao = "\t" + resultado.label + " = " + atr_1.apelido + op + atr_2.apelido + ";\n" ;
			return resultado;
		}
	}
	

	for(int j = mapa.size()-1; j > 0; j--){
		tabela_simbolo = mapa[j]; 
		for(int i = 0; i < tabela_simbolo.size(); i++){
			if(atr_1.label == tabela_simbolo[i].nome){
				atr.label = tabela_simbolo[i].apelido;
				atr.tipo = tabela_simbolo[i].tipo;
				achou = 1;
			}else if(atr_2.label == tabela_simbolo[i].nome){
				atr_2.tipo = tabela_simbolo[i].tipo;
				achou = 1;
			}
		}
		if(achou){
			break;
		}
	} 
	
	if(verifica_tipo_entre_variavel(atr.tipo,atr_2.tipo)){
		struct atributos variavel = conversao_implicita(atr_1,atr_2);
		string apelido1 = puxa_apelido_tabela_simbolos(atr_1.label);
		string apelido2 = puxa_apelido_tabela_simbolos(atr_2.label);
		
		string cond1 = apelido1;
		string cond2 = apelido2;

		if(variavel.nome == atr_1.label){
			cond1 = variavel.label;
		}
		if(variavel.nome == atr_2.label){
			cond2 = variavel.label;
		}
		resultado.label = gen_label();
		resultado.tipo = "float";
		traducao_variaveis += "\tint " + resultado.label+";\n";

		resultado.traducao = atr_1.traducao + atr_2.traducao + variavel.traducao + "\t" + resultado.label + " = " + cond1 + op + cond2 + ";\n";
		adiciona_variavel_tabela_simbolos(resultado.label, resultado.tipo,resultado.label);
		
		return resultado;
	}else{
		resultado.label = gen_label();
		resultado.tipo = atr.tipo;
		traducao_variaveis += "\tint " + resultado.label+";\n";

		adiciona_variavel_tabela_simbolos(resultado.label, resultado.tipo, resultado.label);
		if(atr_1.traducao.size() < 2){
			resultado.traducao = atr_2.traducao + "\t" + resultado.label + " = " + atr.label + op + atr_2.label + ";\n" ;
		}else {	
			resultado.traducao = atr_1.traducao + atr_2.traducao + "\t" + resultado.label + " = " + atr.label + op + atr_2.label + ";\n" ;
		}
		return resultado;
	}
		
}

struct atributos conversao_implicita(struct atributos var_1 ,struct atributos var_2 ){
	struct atributos variavel;
	
	string apelido1 =  puxa_apelido_tabela_simbolos(var_1.label);
	string apelido2 =  puxa_apelido_tabela_simbolos(var_2.label);
	if(var_1.tipo == "int"){
		variavel.nome = var_1.label;
		variavel.label = gen_label();
		variavel.tipo = "float";
		variavel.traducao = "\t"+ variavel.label+ " = (float) " + apelido1 +";\n";
		adiciona_variavel_tabela_simbolos(variavel.label, variavel.tipo,variavel.label);
		return variavel;
	}else{
		variavel.nome = var_2.label;
		variavel.label = gen_label();
		variavel.tipo = "float";
		variavel.traducao = "\t"+ variavel.label+ " = (float) " + apelido2 +";\n";
		adiciona_variavel_tabela_simbolos(variavel.label, variavel.tipo,variavel.label);
		return variavel;
	}
}

bool verifica_tipo_entre_variavel(string tipo1, string tipo2){
	bool verifica = false;
	if(tipo1 != tipo2){
		verifica = true;
	}
	return verifica;
}

bool verifica_tipo_logico(string tipo1 , string tipo2){
	
	bool verifica = true;
	if(tipo1 == "bool" && tipo2 == "bool"){
		verifica = false;
	}
	return verifica;
}

string puxa_apelido_tabela_simbolos_IF(string name){
	int i;
	string apelido;
	for(i = 0; i < tabela_simbolos.size(); i++){
		if(tabela_simbolos[i].nome == name){
			apelido = tabela_simbolos[i].apelido;
		}
	}
	return apelido;
}

string puxa_tipo_tabela_simbolos_IF(string name){
	int i;
	string tipo;
	for(i = 0; i < tabela_simbolos.size(); i++){
		if(tabela_simbolos[i].nome == name){
			tipo = tabela_simbolos[i].tipo;
		}
	}
	return tipo;
}

void verifica_tipo_condicao_IF(string nome){
	string tipo = puxa_tipo_tabela_simbolos_IF(nome);
	
	if(tipo != "bool"){
		yyerror("tipo incompativel com estrutura , estrutura aceita apenas booleanos");
	}
}

string puxa_apelido_tabela_simbolos(string name){
	int i ,achou = 0;
	string apelido;
	vector<simbolo_tipo> tabela_simbolo;

		for(int j = mapa.size()-1; j >= 0; j--){
			tabela_simbolo = mapa[j]; 
			for(int i = 0; i < tabela_simbolo.size(); i++){
				if(name == tabela_simbolo[i].nome){
					apelido = tabela_simbolo[i].apelido;
					achou = 1;
				}
			}
			if(achou){
				break;
			}
		} 
	return apelido;
}

string puxa_tipo_tabela_simbolos(string name){
	string tipo;
	int achou = 0;
	string apelido;
	vector<simbolo_tipo> tabela_simbolo;

	for(int j = mapa.size()-1; j >= 0; j--){
		tabela_simbolo = mapa[j]; 
		for(int i = 0; i < tabela_simbolo.size(); i++){
			if(name == tabela_simbolo[i].nome){
				tipo = tabela_simbolo[i].tipo;
				achou = 1;
			}
		}
		if(achou){
			break;
		}
	} 
	for(int i = 0; i < mapa_funcoes.size(); i++){	
		
		tabela_simbolo = mapa_funcoes[i].parametros;
		for(int j = 0; j < tabela_simbolo.size(); j++){
			if(tabela_simbolo[j].apelido == apelido){
				tipo = tabela_simbolo[j].tipo;
			}
		}
	}
	return tipo;
}

string puxa_apelido_swit( ){
	int i;
	string apelido;
	i = swit.size();
	apelido = swit[i];
	return apelido;
}

string puxa_fim_loop(){
	int i;
	i = limites_loop.size();
	string fim;
	fim = limites_loop[i].fim_loop;
	return fim;
}

string puxa_inicio_loop(){
	int i;
	i = limites_loop.size();
	string inicio;
	inicio = limites_loop[i].inicio_loop;
	return inicio;
}

void adiciona_limite_loop(string inicio,string fim, string nome){
	loop limites;
	limites.nome = nome; 
	limites.inicio_loop = inicio;
	limites.fim_loop = fim;
	limites_loop.push_back(limites);
}

void adiciona_loop(){
	loop lop;
	lop.nome = "loop";
	lop.inicio_loop = inicio_loop();
	lop.fim_loop = fim_loop();
	loops.push_back(lop);
	contador++;
	contador_loop++;
}

void retira_loop_switch(){
	
	limites_loop.pop_back();
	cont_loop--;
}

void adiciona_loop_switch(){
	loop lop;
	lop.nome = "switch";
	lop.inicio_loop = gen_inicio_loop();
	lop.fim_loop = gen_fim_loop();
	limites_loop.push_back(lop);
	cont_loop++;
}

void adiciona_matriz(string name,string nick,string type,string linha , string coluna){
					
	matriz matrix;
	matrix.nome = name;
	matrix.apelido = nick;
	matrix.tipo = type;
	matrix.tam_linha = linha;
	matrix.tam_coluna = coluna;
	matrizes.push_back(matrix);
}

void verifica_posicao_elemento_matriz(string name , string pos_linha ,string pos_coluna){
	int i;
	for(i = 0 ; i < matrizes.size();i++){
		if(name == matrizes[i].nome){
			int tam_linha = std::stoi(matrizes[i].tam_linha);
			int tam_coluna = std::stoi(matrizes[i].tam_coluna);
			int tam_row = std::stoi(pos_linha);
			int tam_collum = std::stoi(pos_coluna);
			if(matrizes[i].tipo == "matrix"){
				if(tam_row < 0 || tam_row >= tam_linha){
					yyerror("posicao fora do tamanho da matriz");
				}
					if(tam_collum < 0 || tam_collum >= tam_coluna){
						yyerror("posicao  coluna fora do tamanho da matriz");
					}
					else{
						if(tam_collum < 0 || tam_collum >= tam_coluna){
							yyerror("posicao  coluna fora do tamanho da matriz");
					}
				}
			}
		}
	}
}

string verifica_tamanho_traducao(struct atributos atributo){
	if(atributo.traducao.size() <= 3){
		atributo.traducao = "";
	}
	return atributo.traducao;
}

void adiciona_variavel_tabela_simbolos(string name, string type, string nick){
	simbolo_tipo variavel;
	variavel.tipo = type;
	variavel.nome = name;
	variavel.apelido = nick;
	tabela_simbolos.push_back(variavel);
 	int val_contexto = mapa.size()-1;
	mapa[val_contexto].push_back(variavel);

}

void adiciona_contexto(){
	vector<simbolo_tipo> tabela_simbolos;
	mapa.push_back(tabela_simbolos);
}

void retira_contexto(){
	mapa.pop_back();
}

void adiciona_string_tabela_simbolos(string name, string type, string nick, int tamanho){
	simbolo_tipo variavel;
	variavel.tipo = type;
	variavel.nome = name;
	variavel.apelido = nick;
	variavel.tamanho_string = tamanho;
	tabela_simbolos.push_back(variavel);
	int val_contexto = mapa.size() - 1;
	
	mapa[val_contexto].push_back(variavel);

}

void adiciona_variavel_swit(string nome ){
	swit.push_back(nome);
}

string print_declaracoes(){
	stringstream ss;
	int i, j;

	int contexto = mapa.size() - 1;
	vector<simbolo_tipo> tabela_simbolo;
	tabela_simbolo = mapa[contexto];
	
	for(i = 0; i < tabela_simbolo.size(); i++){
		if(tabela_simbolo[i].tipo != "string"){
			if(tabela_simbolo[i].tipo != "bool"){
				ss << "\t" << tabela_simbolo[i].tipo + " " + tabela_simbolo[i].apelido <<";\n";
			} else{
				ss << "\t" << "int " + tabela_simbolo[i].apelido <<";\n";
			}
			
		}else{
	 	ss << "\t" << "char["  << tabela_simbolo[i].tamanho_string << "] " + tabela_simbolo[i].apelido <<";\n";
		}
	} 
	 ss << "\n";
	 return ss.str();
}

bool verifica_string(struct atributos atr_1,struct atributos atr_2 ){
	if(atr_1.tipo == "string"){
		return true;
	}
	return false;
}

struct atributos operacao_string(struct atributos atr_1,struct atributos atr_2 ){
	struct atributos variavel, atr;
	
	for(int i = 0; i < tabela_simbolos.size(); i++){
		if(atr_1.label == tabela_simbolos[i].nome){
			atr.label = tabela_simbolos[i].apelido;
			atr.tipo = tabela_simbolos[i].tipo;
		}
		else if(atr_2.label == tabela_simbolos[i].nome){
				atr_2.tipo = tabela_simbolos[i].tipo;
		}
	}

	variavel.label = atr.label;
	variavel.tipo = atr_2.tipo;
	variavel.traducao = atr_2.traducao + "\tstrcpy(" + atr.label + " , " +  atr_2.label + ");\n";
	return variavel;
}

string verifica_declaracao_tipo(string name){
	bool flag = false;
	simbolo_tipo variavel;
	for(int i = 0; i < tabela_simbolos.size(); i++){
		if(tabela_simbolos[i].nome == name){
			variavel = tabela_simbolos[i];
			flag = true;
		}
	}
	if(!flag){
		yyerror("\033[0mvariavel \033[32m"+ name  +"\033[0m nao declarada ");
	}
	return variavel.tipo;
}

void verifica_variavel_tabela_simbolos(string name){
	
	vector<simbolo_tipo> tabela_simbolo;
	
	bool variavel_declarada = false;
	for( int j = mapa.size()-1; j >= 0; j--){
		tabela_simbolo = mapa[j]; 
		for(int i = 0; i < tabela_simbolo.size(); i++){
			if(tabela_simbolo[i].nome == name){
				variavel_declarada = true;
			}
		}
	} 
	for(int i = 0; i < mapa_funcoes.size(); i++){
		tabela_simbolo = mapa_funcoes[i].parametros;
		for(int j = 0; j < tabela_simbolo.size(); j++){
			if(tabela_simbolo[j].nome == name){
				variavel_declarada = true;
			}
		}
	}
	
	if(!variavel_declarada){
		yyerror( "\033[0mvariavel \033[32m"+ name  +"\033[0m nao declarada " );
	}
}

 void verifica_tipo_condicao(string nome){
	string tipo = puxa_tipo_tabela_simbolos(nome);

	if(tipo != "bool"){
		yyerror("tipo\033[32m "+ nome +"\033[0m incompativel com estrutura , estrutura aceita apenas booleanos");
	}
}

 void verifica_tipo_relacional(string nome1 , string nome2){
	string tipo1 = puxa_tipo_tabela_simbolos(nome1);
	string tipo2 = puxa_tipo_tabela_simbolos(nome2);

	if(tipo1 == "bool" || tipo2 == "bool"){
		yyerror("tipo \033[32mbool\033[0m incompatível com relacional");

	}
}

void verifica_tipo_expo(string name , string name2){
	string tipo = puxa_tipo_tabela_simbolos(name);
	string tipo1 = puxa_tipo_tabela_simbolos(name2);
	
	if(tipo == "bool" || tipo == "string" || tipo == "char" ){
		yyerror("tipo da base não compativel, precisa ser inteiro ou float");
	}
	if(tipo1 != "int"){
		yyerror("expoente precisa ser inteiro ");
	}
}

void verifica_variavel_declarada(string name){
	
	int contador_variavel = 0;
	bool variavel_declarada = false;
	vector<simbolo_tipo> tabela_simbolo;
	tabela_simbolo = mapa[mapa.size()-1];

	
	for(int i = 0; i < tabela_simbolo.size(); i++){
		if(tabela_simbolo[i].nome == name){
			variavel_declarada = true;
		}
		
	}

	if(variavel_declarada ){
		yyerror("variavel \033[32m"+ name + RESET  + " ja declarada");
	}
	 
}

string conversao_bool_int(string traducao){
	if(traducao == "true"){
		return "1";
	}
	return "0";
}

string puxa_variaveis_funcao(){
	int i;
	int contexto = mapa.size()-1;
	vector<simbolo_tipo> tabela_simbolo;
	tabela_simbolo = mapa[contexto];
	for(i = 0; i < tabela_simbolo.size(); i++){
		traducao_funcao +="\t" + tabela_simbolo[i].tipo +" "+tabela_simbolo[i].apelido +"\n";
	}
	return traducao_funcao;
}

void funcoes_traducao(){
	for( int i = 0; i < funcao_mapa.size(); i++){
		cout << funcao_mapa[i]<< endl;
	}
}

void adiciona_funcao(){
	funcao f;
	f.nome = gen_label();
}

void contador_linha(){
	cont_linha++;
	qtd_linha = std::to_string(cont_linha);
}

string  printa_tabela_global(){
	string traducao = "";
	for( int i = 0; i < tabela_global.size(); i++){
		traducao += tabela_global[i].tipo + " " + tabela_global[i].apelido + ";\n";	
	}
	return traducao;
}

void adiciona_tabela_global(struct atributos variavel){
	simbolo_tipo var;
	var.nome = variavel.label;
	var.tipo = variavel.tipo;
	var.apelido = variavel.apelido;
	tabela_global.push_back(var);	
}

struct atributos guarda_declaracao_parametro(string nome, string type){
	struct atributos var;
	var.label = nome;
	var.tipo = type;
	var.traducao = "";
	string apelido = gen_label();
	var.apelido = apelido;
	adiciona_variavel_tabela_simbolos(var.label, var.tipo, apelido );
	return var;
}
	
struct atributos guarda_declaracao_funcao(string nome, string type){
	struct atributos var;
	var.label = nome;
	var.apelido = gen_label();
	var.tipo = type;
	return var;
}

string puxa_apelido_funcao(string nome){
	string apelido = "";
	for(int i = 0; i < mapa_funcoes.size(); i++){
		if(mapa_funcoes[i].nome == nome){
			apelido = mapa_funcoes[i].apelido;
		}
	}
	return apelido;
}


int main( int argc, char* argv[] ){
	mapa.push_back(tabela_simbolos);
	yyparse();

	return 0;
}

void yyerror( string MSG ){
	cout<<"\033[31m"<<"ERROR na linha "<<"\033[35m"<<qtd_linha<<"\033[0m" <<endl;
	cout << MSG << endl;
	exit (0);
}