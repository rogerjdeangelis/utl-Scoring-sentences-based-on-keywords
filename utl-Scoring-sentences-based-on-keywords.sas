
Scoring sentences based on keywords;                                                                           
                                                                                                               
Great question Thanks.                                                                                         
                                                                                                               
You seem to have tiny datasets like 3,000,000 sentences and 100 keywords                                       
Probably does not matter which algorithm you use?                                                              
                                                                                                               
I scored the three million in ~6 seconds using 100 words..                                                     
It can probably be done in less than a second on my boat anchor computer using 7 parallel tasks.               
                                                                                                               
github                                                                                                         
https://tinyurl.com/ycbd5yzv                                                                                   
https://github.com/rogerjdeangelis/utl-Scoring-sentences-based-on-keywords                                     
                                                                                                               
SAS Forum                                                                                                      
https://tinyurl.com/y7wsm7bg                                                                                   
https://communities.sas.com/t5/SAS-Programming/Scoring-text-strings-in-big-dataset/m-p/521078                  
                                                                                                               
Kurt Bremser                                                                                                   
https://communities.sas.com/t5/user/viewprofilepage/user-id/11562                                              
                                                                                                               
                                                                                                               
INPUT                                                                                                          
=====                                                                                                          
                                                                                                               
 WORK.LUP total obs=104                                                                                        
                                                                                                               
   Obs    WRD     SCORE                                                                                        
                                                                                                               
     1    a123      24                                                                                         
     2    a345       8                                                                                         
     3    a678      38                                                                                         
   ....                                                                                                        
   102    z345      82                                                                                         
   103    z678      10                                                                                         
   104    z900      74                                                                                         
                                                                                                               
                                                                                                               
 WORK.SENTENCE total obs=3,000,000                                                                             
                                                                                                               
     Obs                         SENTENCE                                                                      
                                                                                                               
       1    He sold sea shells by the sea shore f900                                                           
       2    She purchased sea shells by the sea shor f900 j345                                                 
       3    He stole sea shells by the sea shore j345 g345                                                     
       4    She sent sea shells by the sea shore a678                                                          
     ...                                                                                                       
 2999998    She purchased sea shells by the sea shor n678                                                      
 2999998    He stole sea shells by the sea shore o900                                                          
 3000000    She sent sea shells by the sea shore i678                                                          
                                                                                                               
                                                                                                               
EXAMPLE OUTPUT                                                                                                 
--------------                                                                                                 
                                                                                                               
 WORK.WANT total obs=3,000,000                                                                                 
                                                                                                               
                                                                TOTAL_                                         
   Obs                         SENTENCE                          SCORE                                         
                                                                                                               
     1    He sold sea shells by the sea shore f900                 43                                          
     2    She purchased sea shells by the sea shor f900 j345      140                                          
     3    He stole sea shells by the sea shore j345 g345          168                                          
     4    She sent sea shells by the sea shore a678                38                                          
                                                                                                               
                                                                                                               
                                                                                                               
PROCESS                                                                                                        
=======                                                                                                        
                                                                                                               
data want;                                                                                                     
                                                                                                               
  set sentence;                                                                                                
                                                                                                               
  length                                                                                                       
    word $8                                                                                                    
    score 8;                                                                                                   
                                                                                                               
  if _n_ = 1 then do;                                                                                          
    declare hash sc(dataset:'scores');                                                                         
    sc.definekey('word');                                                                                      
    sc.definedata('score');                                                                                    
    sc.definedone();                                                                                           
    call missing(word,score);                                                                                  
  end;                                                                                                         
                                                                                                               
  total_score = 0;                                                                                             
                                                                                                               
  do i = 1 to countw(sentence);                                                                                
    word = scan(sentence,i);                                                                                   
    if not sc.find() then total_score + score;                                                                 
  end;                                                                                                         
                                                                                                               
  drop sentence total_score;                                                                                   
                                                                                                               
run;                                                                                                           
                                                                                                               
NOTE: There were 104 observations read from the data set WORK.SCORES.                                          
NOTE: There were 3000000 observations read from the data set WORK.SENTENCE.                                    
NOTE: The data set WORK.WANT has 3000000 observations and 3 variables.                                         
NOTE: DATA statement used (Total process time):                                                                
      real time           6.22 seconds                                                                         
      user cpu time       5.92 seconds                                                                         
      system cpu time     0.29 seconds                                                                         
      memory              2949.06k                                                                             
      OS Memory           23544.00k                                                                            
      Timestamp           12/14/2018 04:19:12 PM                                                               
      Step Count           450  Switch Count  0                                                                
                                                                                                               
*                _              _       _                                                                      
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _                                                               
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |                                                              
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |                                                              
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|                                                              
                                                                                                               
;                                                                                                              
data scores;                                                                                                   
 length word $4;                                                                                               
 do prefix=&lettersq;                                                                                          
  do sufix= "123","345","678","900";                                                                           
    word=lowcase(cats(prefix,sufix));                                                                          
    score=int(100*uniform(1234));                                                                              
    output;                                                                                                    
  end;                                                                                                         
 end;                                                                                                          
 keep word score;                                                                                              
 stop;                                                                                                         
run;quit;                                                                                                      
                                                                                                               
                                                                                                               
data sentence;                                                                                                 
                                                                                                               
    length sentence $50;                                                                                       
    array str[0:4] $40 (                                                                                       
          'He sold sea shells by the sea shore',                                                               
          'She purchased sea shells by the sea shore',                                                         
          'He stole sea shells by the sea shore',                                                              
          'She sent sea shells by the sea shore',                                                              
          'He drove sea shells by the sea shore');                                                             
                                                                                                               
    do rec=1 to 3000000;                                                                                       
       pnt=int(uniform(1234)*101);                                                                             
       set scores point=pnt;                                                                                   
       idx=mod(rec-1,5);                                                                                       
       wordPre=lag(word);                                                                                      
       if uniform(1234)<.10 then sentence=catx(" ",str[idx],wordpre,word);                                     
       else sentence=catx(" ",str[idx],word);                                                                  
       output;                                                                                                 
    end;                                                                                                       
                                                                                                               
    keep sentence;                                                                                             
    stop;                                                                                                      
run;quit;                                                                                                      
                                                                                                               
                                                                                                               
