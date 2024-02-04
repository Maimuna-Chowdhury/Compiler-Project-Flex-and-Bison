%{
    #include<stdio.h>
    extern int yylex();
    void yyerror(char *s);
    char sym[40][5];
    char func_sym[40][5];
    char while_sym[40][5];
    char for_sym[40][5];
    char functions[40][5];
    int var_total=0,func_total=0;
    typedef struct {
    char key[5];
    int int_val;
    float float_val;
    } KeyValuePair;
    KeyValuePair myMap[1000];
    int map_index=0;


    int declareAssign(char *s)
    {
         int p;
                                   for(p=0;p<var_total;p++)  
                                   {
                                    if(strcmp(sym[p],s)==0)
                                    {
                                        printf("\nvariable %s is already declared\n",s);
                                        return 0;
                                    }
                                   }
                                   
                                    strcpy(sym[var_total],s);
                                    var_total++;
                                    printf("\nvariabe name:%s\n",s);
                                    return 1;
                                   
    }
  void  func_declareAssisn(char *s)
  {
    strcpy(functions[func_total],s);
     func_total++;
    printf("\nFunction name:%s\n",s);
  }  
  int is_func_declared(char *s)
  {
    int p;
                                   for(p=0;p<func_total;p++)  
                                   {
                                    if(strcmp(functions[p],s)==0)
                                    {
                                        return 1;
                                    }
                                   }
                                   return 0;
  }
  int isdeclared(char *s)
  {
                                     int p;
                                   for(p=0;p<var_total;p++)  
                                   {
                                    if(strcmp(sym[p],s)==0)
                                    {
                                        return 1;
                                    }
                                   }
                                   return 0;
  } 
 


%}


%union
{
    int intValue;
    float floatValue;
    char *stringValue;
    int exp;
    float fexp;

};


%error-verbose
%token <stringValue>  ID
%token <intValue>  INT_NUM
%token <floatValue>  FLOAT_NUM
%token <stringValue>  STRING
%type<exp> if_while_expression
%type<exp> func_parameters
%type<exp> in_element
%type<exp> out_element



%token HEADER MAIN COMMENT PRINT ARRAY INT GT LT FLOAT CHAR  AND ASSIGN EQUAL LPAREN RPAREN LBRACE RBRACE IF WHILE ADD SUB MUL DIV PERCENT POW MAX MIN SEMI COMMA LBRACKET RBRACKET FUNCTION FOR ELSE QUOTATION CHAR_TYPE SINGLE_QUOTATION STRING_TYPE INPUT  SWITCH CASE COLON BREAK DEFAULT RETURN MULTICOMMENT
%start start
%nonassoc MAIN
%nonassoc ELSE
%nonassoc IFX
%nonassoc FOR
%nonassoc GENERAL
%type<exp> expressions
%type<fexp> float_expressions







%%


start:statement| ;
statement:statement var_stmt|func_statement|for_statement|while_statement|if_else_statement1|if_else_statement|main_statement|array_declaration|array_initialization|array_access|function_call|print_statement|input_statement|break_statement|header_statement|comment_statement|multi_comment_statement|general_expressions|float_general_expressions|return_statement|   {printf("\nstatement\n");} ;
header_statement:statement HEADER "stdio.h"|statement HEADER "stdlib.h"|statement HEADER "math.h" {printf("\nheader\n");};
main_statement:statement type MAIN LPAREN RPAREN LBRACE statement RBRACE 
{printf("MAIN");}; 
comment_statement:statement COMMENT {printf("\nsingle line comment\n");}; 
multi_comment_statement:statement MULTICOMMENT {printf("\nmultiple line comment\n");}; 
var_stmt:type ID var_stmt SEMI { 
                                   declareAssign($2);
                                  }                        
          |type ID ASSIGN INT_NUM var_stmt SEMI {if(declareAssign($2)){
                                                              strcpy(myMap[map_index].key,$2);
                                                               myMap[map_index].int_val =$4;
                                                               map_index++;
                                                                 }
                                            
                                            }  
           |type ID ASSIGN FLOAT_NUM var_stmt SEMI {if(declareAssign($2)){
                                                              strcpy(myMap[map_index].key,$2);
                                                               myMap[map_index].float_val =$4;
                                                               map_index++;
                                                                 }
                                            }                               
          | COMMA ID var_stmt   {declareAssign($2);}
          |COMMA ID ASSIGN INT_NUM var_stmt{
                                            if(declareAssign($2)){
                                                              strcpy(myMap[map_index].key,$2);
                                                               myMap[map_index].int_val =$4;
                                                               map_index++;
                                                                 }
                                            }
          |COMMA ID ASSIGN FLOAT_NUM var_stmt {
                                          if(declareAssign($2)){
                                                              strcpy(myMap[map_index].key,$2);
                                                               myMap[map_index].float_val =$4;
                                                               map_index++;
                                                                 }
                                            }                                  
          |
          ;
 

array_declaration:statement type ID LPAREN INT_NUM RPAREN SEMI {
                                                         printf("\narray declaration\n");
                                                         printf("\narray name:%s\n",$3);
                                                         printf("\narray size:%d\n",$5);
                                                         };
array_initialization:statement type ID LPAREN INT_NUM RPAREN ASSIGN LBRACE element RBRACE SEMI   {
                                                                                                 printf("\narray initialization\n");
                                                                                                 printf("\narray name:%s\n",$3);
                                                                                                 printf("\narray size:%d\n",$5);
                                                                                                 };
element:INT_NUM COMMA element {printf("\narray element:%d\n",$1);}
        |FLOAT_NUM COMMA element  {printf("\narray element:%f\n",$1);}
        |INT_NUM                  {printf("\narray element:%d\n",$1);}
        |FLOAT_NUM                {printf("\narray element:%f\n",$1);}
        ;
array_access:statement ID LPAREN INT_NUM RPAREN ASSIGN INT_NUM SEMI {
                                                                printf("\narray element access\n");
                                                                 printf("\narray name:%s\n",$2);
                                                                 printf("\narray index:%d\n",$4);
                                                                 printf("\nassigned value:%d\n",$7);
                                                                 }
             |statement ID LPAREN FLOAT_NUM RPAREN ASSIGN INT_NUM SEMI  {
                                                                printf("\narray element access\n");
                                                                 printf("\narray name:%s\n",$2);
                                                                 printf("\narray index:%d\n",$4);
                                                                 printf("\nassigned value:%f\n",$7);
                                                                 }
             ;                                                    
if_else_statement:statement IF LPAREN if_while_expression RPAREN LBRACE statement RBRACE %prec IFX {
                                                                                                 if($4)
                                                                                                 {
                                                                                                    printf("\nif block\n");
                                                                                                 }
                                                                                                 else
                                                                                                 {
                                                                                                    printf("\nif condition false\n");
                                                                                                 }
                                                                                                   };
if_else_statement1:statement IF LPAREN if_while_expression RPAREN LBRACE statement RBRACE ELSE LBRACE statement RBRACE {
                                        
                                                                                                        if($4)
                                                                                                          {
                                                                                                          printf("\nif block\n");
                                                                                                          }
                                                                                                         else
                                                                                                         {
                                                                                                          printf("\nelse block\n");
                                                                                                         }
                                                                                                         };
break_statement:statement BREAK SEMI {printf("\nbreak statement\n");};
func_statement:statement FUNCTION ID LBRACKET func_arguments RBRACKET LPAREN statement RPAREN { func_declareAssisn($3);};
func_arguments:type ID COMMA func_arguments|type ID {printf("\nfunction argument\n");};
function_call:statement ID LPAREN func_parameters RPAREN SEMI {
                                                                if(!is_func_declared($2))
                                                                {
                                                                  printf("\nInvalid function call:function not declared\n"); 
                                                                }
                                                                if($4)
                                                                {
                                                                   printf("\nvalid function call\n"); 
                                                                }
                                                                else
                                                                {
                                                                 printf("\nInvalid function call:Parameters not declared\n"); 
                                                                }
                                                                 
                                                              };
func_parameters:ID COMMA func_parameters  {
                                           if(isdeclared($1)==0)
                                           {
                                             $$=0;
                                           }
                                           else
                                           {
                                            $$=1;
                                           }
                                          }
                |INT_NUM COMMA func_parameters {$$=1;}
                |FLOAT_NUM COMMA func_parameters {$$=1;}
                |ID {
                    if(isdeclared($1)==0)
                                           {
                                             $$=0;
                                           }
                                           else
                                           {
                                            $$=1;
                                           }
                }
                |INT_NUM {$$=1;}
                |FLOAT_NUM {$$=1;};
                ;
for_statement:statement FOR LPAREN type ID ASSIGN INT_NUM SEMI  SEMI ID LT INT_NUM SEMI  SEMI ID ASSIGN ID ADD INT_NUM RPAREN LBRACE statement RBRACE {
                                                                                                                                
                                                                                                                               
                                                                                                                               if((strcmp($10,$5)!=0 && !isdeclared($10)) ||(strcmp($15,$5)!=0 && !isdeclared($15)) )
                                                                                                                               {
                                                                                                                                printf("\nInvalid for statement:variable is not declared\n");
                                                                                                                               }
                                                                                                                               else
                                                                                                                               {
                                                                                                                                for(int p=$7;p<$12;p=p+$19)
                                                                                                                                {
                                                                                                                                     printf("\nfor loop traversal:%d\n",p);
                                                                                                                                }
                                                                                                                               }
                                                                                                                               }  
                | statement FOR LPAREN type ID ASSIGN INT_NUM SEMI  SEMI ID GT INT_NUM SEMI  SEMI ID ASSIGN ID SUB INT_NUM RPAREN LBRACE statement RBRACE {
                                                                                                                               if((strcmp($10,$5)!=0 && !isdeclared($10)) ||(strcmp($15,$5)!=0 && !isdeclared($15)))
                                                                                                                               {
                                                                                                                                printf("\nInvalid for statement:variable is not declared\n");
                                                                                                                               }
                                                                                                                               else
                                                                                                                               {
                                                                                                                                for(int p=$7;p>$12;p=p-$19)
                                                                                                                                {
                                                                                                                                     printf("\nfor loop traversal:%d\n",p);
                                                                                                                                }
                                                                                                                               }
                                                                                                                               }  
                |statement FOR LPAREN ID ASSIGN INT_NUM SEMI  SEMI ID LT INT_NUM SEMI  SEMI ID ASSIGN ID ADD INT_NUM RPAREN LBRACE statement RBRACE {
                                                                                                                                 if(!isdeclared($4)||!isdeclared($9)||!isdeclared($14)||!isdeclared($16))
                                                                                                                               {
                                                                                                                                printf("\nInvalid for statement:variable is not declared\n");
                                                                                                                               }
                                                                                                                               else
                                                                                                                               {
                                                                                                                                for(int p=$6;p<$11;p=p+$18)
                                                                                                                                {
                                                                                                                                     printf("\nfor loop traversal:%d\n",p);
                                                                                                                                }
                                                                                                                               }
 
                                                                                                                               }  
                |statement FOR LPAREN ID ASSIGN INT_NUM SEMI  SEMI ID GT INT_NUM SEMI  SEMI ID ASSIGN ID SUB INT_NUM RPAREN LBRACE statement RBRACE { if(!isdeclared($4)||!isdeclared($9)||!isdeclared($14)||!isdeclared($16))
                                                                                                                               {
                                                                                                                                printf("\nInvalid for statement:variable is not declared\n");
                                                                                                                               }
                                                                                                                               else
                                                                                                                               {
                                                                                                                                for(int p=$6;p>$11;p=p-$18)
                                                                                                                                {
                                                                                                                                     printf("\nfor loop traversal:%d\n",p);
                                                                                                                                }
                                                                                                                               }
                                                                                                                            };
while_statement:statement WHILE LPAREN if_while_expression RPAREN LBRACE statement RBRACE {
                                                                                          if($4)
                                                                                          {
                                                                                           printf("\nwhile block\n");
                                                                                          }
                                                                                          else
                                                                                          {
                                                                                            printf("\noutside while block:condition false\n");
                                                                                          }
                                                                                          };
print_statement:statement PRINT LPAREN  STRING  out_element RPAREN SEMI  {printf("\nprint statement\n");};
input_statement:statement INPUT LPAREN STRING in_element RPAREN SEMI {
                                                                        if($5)
                                                                        {
                                                                         printf("\ninput statement\n");
                                                                        }
                                                                        else
                                                                        {
                                                                         printf("\nInvalid input statement:variable not declared\n");
                                                                        }
                                                                        };
in_element:COMMA AND ID in_element {
                                      if(!isdeclared($3))
                                        {
                                         $$=0;
                                       }
                                         else
                                       {
                                        $$=1;
                                       }
                                                                 
                                         }                                                 
           |COMMA AND ID  {
                              if(!isdeclared($3))
                               {
                                $$=0;
                                 }
                                else
                                 {
                                  $$=1;
                                  }
                                  }                        
           ;
 out_element: COMMA ID out_element {
                                      if(!isdeclared($2))
                                        {
                                         $$=0;
                                       }
                                         else
                                       {
                                        $$=1;
                                       }
                                                                 
                                         } 
                | { $$=1;}                        
           ;                                   
if_while_expression:ID EQUAL ID {
                                    int p,int_val1,float_val1,int_val2,float_val2;
                                    for(p=0;p<map_index;p++)
                                    {
                                        if(strcmp(myMap[p].key,$1)==0)
                                        {
                                         int_val1=myMap[p].int_val;
                                        float_val1=myMap[p].float_val;
                                        break;
                                        }
                                    }
                                     for(p=0;p<map_index;p++)
                                    {
                                        if(strcmp(myMap[p].key,$3)==0)
                                        {
                                         int_val2=myMap[p].int_val;
                                        float_val2=myMap[p].float_val;
                                        break;
                                        }
                                    }
                                    if(int_val1==int_val2||float_val1==float_val2)
                                    {
                                        $$=1;
                                    }
                                    else
                                    {
                                        $$=0;
                                    }

                                }
                |ID GT ID      {
                                    int p,int_val1,float_val1,int_val2,float_val2;
                                    for(p=0;p<map_index;p++)
                                    {
                                        if(strcmp(myMap[p].key,$1)==0)
                                        {
                                         int_val1=myMap[p].int_val;
                                        float_val1=myMap[p].float_val;
                                        break;
                                        }
                                    }
                                     for(p=0;p<map_index;p++)
                                    {
                                        if(strcmp(myMap[p].key,$3)==0)
                                        {
                                         int_val2=myMap[p].int_val;
                                        float_val2=myMap[p].float_val;
                                        break;
                                        }
                                    }
                                    if(int_val1>int_val2||float_val1>float_val2)
                                    {
                                        $$=1;
                                    }
                                    else
                                    {
                                        $$=0;
                                    }

                                }
                |ID LT ID    {
                                    int p,int_val1,float_val1,int_val2,float_val2;
                                    for(p=0;p<map_index;p++)
                                    {
                                        if(strcmp(myMap[p].key,$1)==0)
                                        {
                                         int_val1=myMap[p].int_val;
                                        float_val1=myMap[p].float_val;
                                        break;
                                        }
                                    }
                                     for(p=0;p<map_index;p++)
                                    {
                                        if(strcmp(myMap[p].key,$3)==0)
                                        {
                                         int_val2=myMap[p].int_val;
                                        float_val2=myMap[p].float_val;
                                        break;
                                        }
                                    }
                                    if(int_val1<int_val2||float_val1<float_val2)
                                    {
                                        $$=1;
                                    }
                                    else
                                    {
                                        $$=0;
                                    }

                                }
                |ID EQUAL INT_NUM {
                                    int p,int_val1;
                                    for(p=0;p<map_index;p++)
                                    {
                                        if(strcmp(myMap[p].key,$1)==0)
                                        {
                                         int_val1=myMap[p].int_val;
                                        break;
                                        }
                                    }
                                    if(int_val1==$3)
                                    {
                                        $$=1;
                                    }
                                    else
                                    {
                                        $$=0;
                                    }

                                }
                |ID GT INT_NUM  {
                                    int p,int_val1;
                                    for(p=0;p<map_index;p++)
                                    {
                                        if(strcmp(myMap[p].key,$1)==0)
                                        {
                                         int_val1=myMap[p].int_val;
                                        break;
                                        }
                                    }
                                    if(int_val1>$3)
                                    {
                                        $$=1;
                                    }
                                    else
                                    {
                                        $$=0;
                                    }

                                }
                |ID LT INT_NUM  {
                                    int p,int_val1;
                                    for(p=0;p<map_index;p++)
                                    {
                                        if(strcmp(myMap[p].key,$1)==0)
                                        {
                                         int_val1=myMap[p].int_val;
                                        break;
                                        }
                                    }
                                    if(int_val1<$3)
                                    {
                                        $$=1;
                                    }
                                    else
                                    {
                                        $$=0;
                                    }

                                }
                |ID EQUAL FLOAT_NUM {
                                    int p,float_val1;
                                    for(p=0;p<map_index;p++)
                                    {
                                        if(strcmp(myMap[p].key,$1)==0)
                                        {
                                         float_val1=myMap[p].float_val;
                                        break;
                                        }
                                    }
                                    if(float_val1==$3)
                                    {
                                        $$=1;
                                    }
                                    else
                                    {
                                        $$=0;
                                    }

                                }
                |ID GT FLOAT_NUM   {
                                    int p,float_val1;
                                    for(p=0;p<map_index;p++)
                                    {
                                        if(strcmp(myMap[p].key,$1)==0)
                                        {
                                         float_val1=myMap[p].float_val;
                                        break;
                                        }
                                    }
                                    if(float_val1>$3)
                                    {
                                        $$=1;
                                    }
                                    else
                                    {
                                        $$=0;
                                    }

                                }
                |ID LT FLOAT_NUM {
                                    int p,float_val1;
                                    for(p=0;p<map_index;p++)
                                    {
                                        if(strcmp(myMap[p].key,$1)==0)
                                        {
                                         float_val1=myMap[p].float_val;
                                        break;
                                        }
                                    }
                                    if(float_val1<$3)
                                    {
                                        $$=1;
                                    }
                                    else
                                    {
                                        $$=0;
                                    }

                                }               
                ;
 expressions: INT_NUM	{ $$ = $1;}
                         |INT_NUM ADD INT_NUM {$$=$1+$3;}  
                           |INT_NUM SUB INT_NUM{$$=$1-$3;}  
                           |INT_NUM MUL INT_NUM{$$=$1*$3;}
                           |INT_NUM DIV INT_NUM{$$=$1/$3;}
                           |INT_NUM PERCENT INT_NUM{$$=$1%$3;}
                           |INT_NUM POW INT_NUM{$$=pow($1,$3);}
                           |ID ADD INT_NUM {
                                 
                                  for(int p=0;p<map_index;p++)
                            {
                              
                                if(strcmp(myMap[p].key,$1)==0)
                                {
                                    $$=myMap[p].int_val+$3;
                                    printf("\nadd:%d\n",$$);
                        
                                   
                                }
                                
                            }  
                            
                           }
                           |ID MUL INT_NUM {
                                
                                  for(int p=0;p<map_index;p++)
                            {
                                
                                if(strcmp(myMap[p].key,$1)==0)
                                {
                                    $$=myMap[p].int_val*$3;
                                     printf("\nmultiplication:%d\n",$$);
                                   
                                }
                            }   
                           }
                           |ID DIV INT_NUM {
                                  for(int p=0;p<map_index;p++)
                            {
                                if(strcmp(myMap[p].key,$1)==0)
                                {
                                    $$=myMap[p].int_val/$3;
                                     printf("\ndivision:%d\n",$$);
                                 
                                }
                            }   
                           }
                           |ID PERCENT INT_NUM {
                                  for(int p=0;p<map_index;p++)
                            {
                                if(strcmp(myMap[p].key,$1)==0)
                                {
                                    $$=myMap[p].int_val%$3;
                                     printf("\npercent:%d\n",$$);
                                 
                                }
                            }   
                           }
                           |MAX LPAREN ID COMMA ID RPAREN {
                             int int_val1,int_val2;
                             if(!isdeclared($3)||!isdeclared($5))
                             {
                                printf("\nvariable not declared\n");
                             }
                              for(int p=0;p<map_index;p++)
                              {
                                 if(strcmp(myMap[p].key,$3)==0)
                                 {
                                    int_val1=myMap[p].int_val;
                                 }
                              }
                              for(int p=0;p<map_index;p++)
                              {
                                 if(strcmp(myMap[p].key,$5)==0)
                                 {
                                    int_val2=myMap[p].int_val;
                                 }
                              }
                              if(int_val1>int_val2)
                              {
                                $$=int_val1;
                                 printf("\nmax:%d\n",$$);
                              }
                              else
                              {
                                $$=int_val2;
                                 printf("\nmax:%d\n",$$);
                              }
                            
                            }
                            |MIN LPAREN INT_NUM COMMA INT_NUM RPAREN {
                           
                             int int_val1,int_val2;
                             if(!isdeclared($3)||!isdeclared($5))
                             {
                                printf("\nvariable not declared\n");
                             }
                              for(int p=0;p<map_index;p++)
                              {
                                 if(strcmp(myMap[p].key,$3)==0)
                                 {
                                    int_val1=myMap[p].int_val;
                                 }
                              }
                              for(int p=0;p<map_index;p++)
                              {
                                 if(strcmp(myMap[p].key,$5)==0)
                                 {
                                    int_val2=myMap[p].int_val;
                                 }
                              }
                              if(int_val1<int_val2)
                              {
                                $$=int_val1;
                                 printf("\nmin:%d\n",$$);
                              }
                              else
                              {
                                $$=int_val2;
                                 printf("\nmin:%d\n",$$);
                              }
                            
                            }
                           ;   
float_expressions: statement FLOAT_NUM {$$=$2;}  
                  |statement FLOAT_NUM ADD FLOAT_NUM {$$=$2+$4;}  
                           |statement FLOAT_NUM SUB FLOAT_NUM{$$=$2-$4;}  
                           |statement FLOAT_NUM MUL FLOAT_NUM{$$=$2*$4;}
                           |statement FLOAT_NUM DIV FLOAT_NUM{$$=$2/$4;}
                           |statement ID ADD FLOAT_NUM {
                                  for(int p=0;p<map_index;p++)
                            {
                                if(strcmp(myMap[p].key,$2)==0)
                                {
                                    $$=myMap[p].float_val+$4;
                                }
                            }   
                           }
                           |statement MAX LPAREN FLOAT_NUM COMMA FLOAT_NUM RPAREN {
                            if($4>$6)
                            {
                                $$=$4;
                            }
                            else
                            {
                                 $$=$6; 
                            }
                            }
                            |statement MIN LPAREN FLOAT_NUM COMMA FLOAT_NUM RPAREN {
                            if($4<$6)
                            {
                                $$=$4;
                            }
                            else
                            {
                                 $$=$6; 
                            }
                            
                            }
                           ; 

general_expressions:statement ID ASSIGN expressions SEMI %prec GENERAL {
                            int f=0;
                             if(isdeclared($2))
                             {
                                 for(int p=0;p<map_index;p++)
                            {
                                if(strcmp(myMap[p].key,$2)==0)
                                {
                                    myMap[p].int_val=$4;
                                     printf("\nresult:%d\n",$4);
                                     f++;
                                }
                            }
                            if(!f)
                            {
                                strcpy(myMap[map_index].key,$2);
                                 myMap[map_index].int_val=$4;
                                map_index++;
                                printf("\nresult:%d\n",$4);

                            }

                             }
                          
                                          }                         
              ;
float_general_expressions:statement ID ASSIGN float_expressions SEMI {if(!isdeclared($2))
                                           {printf("\nvariable %s is not declared\n",$2);}
                                           else
                                           {
                                            for(int p=0;p<map_index;p++)
                            {
                                if(strcmp(myMap[p].key,$2)==0)
                                {
                                    myMap[p].float_val=$4;
                                     printf("\nresult:%f\n",$4);
                                }
                            }
                                           }
                                          };   

 return_statement:statement RETURN INT_NUM SEMI{printf("\nreturn %d\n",$3);}
                  |statement RETURN FLOAT_NUM SEMI {printf("\nreturn %f\n",$3);}
                  |statement RETURN ID SEMI{printf("\nreturn %s\n",$3);};                                                                                                             
                                                           
type:INT|FLOAT|CHAR_TYPE|STRING_TYPE;
%%




int yywrap()
{
    return 1;
}
yyerror(char *s)
{
    printf("%s\n",s);
}