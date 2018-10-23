%{
#include<stdio.h>
#include<stdlib.h>
#define YYDEBUG 1
%}
%unin{
    int     int_value;
    double  double_value;
}

%token <double_value>   DOUBLE_LITERAL
%token ADD SUB MUL DIV CR
%type <double_value> expression term primary_expression
%%

line_list /*多行的规则*/
    :line /*单行*/
    |line_list line /*或者是一个多行后接单行*/
    ;
line   /*单行的规则*/
    :expression CR /*一个表达式后接换行符*/
    {
        printf(">>%lf\n",$1);
    }
expression /*表达式的规则*/
    :term  /*项目*/
    |expression ADD term /* 或表达式+和项*/
    {
        $$=$1+$3;
    }
    |expression SUB term /*或表达式-和项*/
    {
        $$=$1-$3;
    }
    ;
term /* 和项的规则 */
    :primary_expression /* 一元表达式*/
    |term MUL primary_expression /*或 项目 * 一元表达式 */
    {
        $$=$1*$3;
    }
    |term DIV primary_expression /*或 项目 / 一元表达式 */
    {
        $$=$1/$3;
    }
    ;
primary_expression /* 一元表达式的规则 */
    :DOUBLE_LITERAL /* 实数的源文本*/
    ;
%%
int
yyerror(char const *str)
{
    extern char *yytext;
    fprintf(stderr,"parser error near %s\n",yytext);
    return 0;
}

int main(void)
{
    extern int yyparse(void);
    extern FILE *yyin;

    yyin=stdin;
    if(yyparse()){
        fprintf(stderr,"Error ! Error ! Error !\n");
        exit(1);
    }
}




























