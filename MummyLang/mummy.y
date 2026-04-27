%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

extern FILE *yyin;
int yylex();
void yyerror(const char *s);

/* ---------- TAC NODE ---------- */
struct node {
    char code[1000][100];
    int size;
    char place[20];
};

/* ---------- HELPERS ---------- */
struct node* newNode() {
    struct node* n = (struct node*)malloc(sizeof(struct node));
    n->size = 0;
    return n;
}

void addLine(struct node* n, char* line) {
    strcpy(n->code[n->size++], line);
}

void merge(struct node* a, struct node* b) {
    for(int i=0;i<b->size;i++)
        strcpy(a->code[a->size++], b->code[i]);
}

/* ---------- TEMP & LABEL ---------- */
int tempCount = 0, labelCount = 0;

char* newTemp() {
    char buf[20];
    sprintf(buf,"t%d",tempCount++);
    return strdup(buf);
}

char* newLabel() {
    char buf[20];
    sprintf(buf,"L%d",labelCount++);
    return strdup(buf);
}

/* ---------- GLOBAL TAC ---------- */
char globalCode[1000][100];
int globalSize = 0;

void storeCode(struct node* n) {
    for(int i=0;i<n->size;i++)
        strcpy(globalCode[globalSize++], n->code[i]);
}

void printTAC() {
    printf("\n--- THREE ADDRESS CODE ---\n");
    for(int i=0;i<globalSize;i++)
        printf("%s\n", globalCode[i]);
}

/* ---------- INTERPRETER ---------- */
int vars[100];
char names[100][20];
int varCount = 0;

int getVarIndex(char* name) {
    for(int i=0;i<varCount;i++)
        if(strcmp(names[i],name)==0) return i;

    strcpy(names[varCount],name);
    return varCount++;
}

int getValue(char* x) {
    if(isdigit(x[0])) return atoi(x);
    return vars[getVarIndex(x)];
}

void executeTAC() {
    printf("\n--- OUTPUT ---\n");

    int pc = 0;

    while(pc < globalSize) {
        char a[20], b[20], c[20];

        /* assignment */
        if(sscanf(globalCode[pc], "%s = %s", a, b) == 2 &&
           !strstr(globalCode[pc], "+") &&
           !strstr(globalCode[pc], "-") &&
           !strstr(globalCode[pc], "*") &&
           !strstr(globalCode[pc], "/") &&
           !strstr(globalCode[pc], "<") &&
           !strstr(globalCode[pc], ">") &&
           !strstr(globalCode[pc], "==")) {

            vars[getVarIndex(a)] = getValue(b);
        }

        /* arithmetic */
        else if(sscanf(globalCode[pc], "%s = %s + %s", a,b,c)==3)
            vars[getVarIndex(a)] = getValue(b) + getValue(c);

        else if(sscanf(globalCode[pc], "%s = %s - %s", a,b,c)==3)
            vars[getVarIndex(a)] = getValue(b) - getValue(c);

        else if(sscanf(globalCode[pc], "%s = %s * %s", a,b,c)==3)
            vars[getVarIndex(a)] = getValue(b) * getValue(c);

        else if(sscanf(globalCode[pc], "%s = %s / %s", a,b,c)==3)
            vars[getVarIndex(a)] = getValue(b) / getValue(c);

        /* conditions */
        else if(sscanf(globalCode[pc], "%s = %s < %s", a,b,c)==3)
            vars[getVarIndex(a)] = getValue(b) < getValue(c);

        else if(sscanf(globalCode[pc], "%s = %s > %s", a,b,c)==3)
            vars[getVarIndex(a)] = getValue(b) > getValue(c);

        else if(sscanf(globalCode[pc], "%s = %s == %s", a,b,c)==3)
            vars[getVarIndex(a)] = getValue(b) == getValue(c);

        else if(sscanf(globalCode[pc], "%s = %s <= %s", a,b,c)==3)
            vars[getVarIndex(a)] = getValue(b) <= getValue(c);

        else if(sscanf(globalCode[pc], "%s = %s >= %s", a,b,c)==3)
            vars[getVarIndex(a)] = getValue(b) >= getValue(c);
        
        else if(sscanf(globalCode[pc], "input %s", a)==1) {
            int idx = getVarIndex(a);
            printf("Enter value for %s: ", a);
            scanf("%d", &vars[idx]);
        }
        /* print */
        else if(sscanf(globalCode[pc], "print %s", a)==1)
            printf("%d\n", getValue(a));

        /* goto */
        else if(sscanf(globalCode[pc], "goto %s", a)==1) {
            char label[20];
            sprintf(label,"%s:",a);
            for(int i=0;i<globalSize;i++) {
                if(strcmp(globalCode[i],label)==0) {
                    pc = i;
                    break;
                }
            }
            continue;
        }

        /* if */
        else if(sscanf(globalCode[pc], "if %s goto %s", a,b)==2) {
            if(getValue(a)) {
                char label[20];
                sprintf(label,"%s:",b);
                for(int i=0;i<globalSize;i++) {
                    if(strcmp(globalCode[i],label)==0) {
                        pc = i;
                        break;
                    }
                }
                continue;
            }
        }

        pc++;
    }
}
%}

%union {
    char* str;
    struct node* node;
}

%token MUMMY YE_HE JAB_TAK AGAR NAHI_TO BOLO PUCHO END
%token ASSIGN SEMICOLON PLUS MINUS MUL DIV LT GT EQ LE GE
%token LPAREN RPAREN
%token <str> ID NUMBER

%type <node> program statement stmt_list declare print_stmt input_stmt expression relational additive term factor if_stmt loop_stmt

%%

program :
    stmt_list { storeCode($1); }
;

stmt_list :
    stmt_list statement { merge($1,$2); $$ = $1; }
  | statement { $$ = $1; }
;

statement :
      MUMMY declare { $$ = $2; }
    | MUMMY print_stmt { $$ = $2; }
    | MUMMY input_stmt { $$ = $2; }
    | MUMMY if_stmt { $$ = $2; }
    | MUMMY loop_stmt { $$ = $2; }
    | ID ASSIGN expression SEMICOLON {
        $$ = newNode();
        merge($$,$3);
        char line[100];
        sprintf(line,"%s = %s",$1,$3->place);
        addLine($$,line);
    }
;

/* DECLARE */
declare :
    YE_HE ID SEMICOLON { $$ = newNode(); }
  | YE_HE ID ASSIGN expression SEMICOLON {
        $$ = newNode();
        merge($$,$4);
        char line[100];
        sprintf(line,"%s = %s",$2,$4->place);
        addLine($$,line);
    }
;

/* PRINT */
print_stmt :
    BOLO expression SEMICOLON {
        $$ = newNode();
        merge($$,$2);
        char line[100];
        sprintf(line,"print %s",$2->place);
        addLine($$,line);
    }
;

/* INPUT */
input_stmt :
    PUCHO ID SEMICOLON {
        $$ = newNode();
        char line[100];
        sprintf(line,"input %s",$2);
        addLine($$,line);
    }
;

/* EXPRESSIONS */
expression : relational { $$ = $1; };

relational :
    additive LT additive { $$ = newNode(); merge($$,$1); merge($$,$3);
        char* t=newTemp(); char line[100];
        sprintf(line,"%s = %s < %s",t,$1->place,$3->place);
        addLine($$,line); strcpy($$->place,t); }
  | additive GT additive { $$ = newNode(); merge($$,$1); merge($$,$3);
        char* t=newTemp(); char line[100];
        sprintf(line,"%s = %s > %s",t,$1->place,$3->place);
        addLine($$,line); strcpy($$->place,t); }
  | additive EQ additive { $$ = newNode(); merge($$,$1); merge($$,$3);
        char* t=newTemp(); char line[100];
        sprintf(line,"%s = %s == %s",t,$1->place,$3->place);
        addLine($$,line); strcpy($$->place,t); }
  | additive LE additive { $$ = newNode(); merge($$,$1); merge($$,$3);
        char* t=newTemp(); char line[100];
        sprintf(line,"%s = %s <= %s",t,$1->place,$3->place);
        addLine($$,line); strcpy($$->place,t); }
  | additive GE additive { $$ = newNode(); merge($$,$1); merge($$,$3);
        char* t=newTemp(); char line[100];
        sprintf(line,"%s = %s >= %s",t,$1->place,$3->place);
        addLine($$,line); strcpy($$->place,t); }
  | additive { $$ = $1; }
;

additive :
    additive PLUS term { $$ = newNode(); merge($$,$1); merge($$,$3);
        char* t=newTemp(); char line[100];
        sprintf(line,"%s = %s + %s",t,$1->place,$3->place);
        addLine($$,line); strcpy($$->place,t); }
  | additive MINUS term { $$ = newNode(); merge($$,$1); merge($$,$3);
        char* t=newTemp(); char line[100];
        sprintf(line,"%s = %s - %s",t,$1->place,$3->place);
        addLine($$,line); strcpy($$->place,t); }
  | term { $$ = $1; }
;

term :
    term MUL factor { $$ = newNode(); merge($$,$1); merge($$,$3);
        char* t=newTemp(); char line[100];
        sprintf(line,"%s = %s * %s",t,$1->place,$3->place);
        addLine($$,line); strcpy($$->place,t); }
  | term DIV factor { $$ = newNode(); merge($$,$1); merge($$,$3);
        char* t=newTemp(); char line[100];
        sprintf(line,"%s = %s / %s",t,$1->place,$3->place);
        addLine($$,line); strcpy($$->place,t); }
  | factor { $$ = $1; }
;

factor :
    ID { $$ = newNode(); strcpy($$->place,$1); }
  | NUMBER { $$ = newNode(); strcpy($$->place,$1); }
  | LPAREN expression RPAREN { $$ = $2; }
;

/* IF */
if_stmt :
    AGAR LPAREN expression RPAREN stmt_list END {
        $$ = newNode();
        char *L1=newLabel(), *L2=newLabel();
        merge($$,$3);
        char l1[100], l2[100];
        sprintf(l1,"if %s goto %s",$3->place,L1);
        sprintf(l2,"goto %s",L2);
        addLine($$,l1); addLine($$,l2);
        char lab1[20]; sprintf(lab1,"%s:",L1); addLine($$,lab1);
        merge($$,$5);
        char lab2[20]; sprintf(lab2,"%s:",L2); addLine($$,lab2);
    }
  | AGAR LPAREN expression RPAREN stmt_list END NAHI_TO stmt_list END {
        $$ = newNode();
        char *L1=newLabel(), *L2=newLabel(), *L3=newLabel();
        merge($$,$3);
        char l1[100], l2[100];
        sprintf(l1,"if %s goto %s",$3->place,L1);
        sprintf(l2,"goto %s",L2);
        addLine($$,l1); addLine($$,l2);
        char lab1[20]; sprintf(lab1,"%s:",L1); addLine($$,lab1);
        merge($$,$5);
        char go[100]; sprintf(go,"goto %s",L3); addLine($$,go);
        char lab2[20]; sprintf(lab2,"%s:",L2); addLine($$,lab2);
        merge($$,$8);
        char lab3[20]; sprintf(lab3,"%s:",L3); addLine($$,lab3);
    }
;

/* WHILE */
loop_stmt :
    JAB_TAK LPAREN expression RPAREN stmt_list END {
        $$ = newNode();
        char *L1=newLabel(), *L2=newLabel(), *L3=newLabel();
        char start[20]; sprintf(start,"%s:",L1); addLine($$,start);
        merge($$,$3);
        char l1[100], l2[100];
        sprintf(l1,"if %s goto %s",$3->place,L2);
        sprintf(l2,"goto %s",L3);
        addLine($$,l1); addLine($$,l2);
        char body[20]; sprintf(body,"%s:",L2); addLine($$,body);
        merge($$,$5);
        char back[100]; sprintf(back,"goto %s",L1); addLine($$,back);
        char end[20]; sprintf(end,"%s:",L3); addLine($$,end);
    }
;

%%

void yyerror(const char *s) {
    printf("Syntax Error: %s\n", s);
}

int main(int argc, char *argv[]) {
    yyin = fopen(argv[1], "r");

    if (yyparse() == 0) {
        printTAC();
        executeTAC();
    }

    return 0;
}