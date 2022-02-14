library(tidyverse)
data("midwest")
theme_set(theme_minimal())

jebes<-c("#FE2557","#6BF6A2","#FE9106","#F0E728","#10FADA")



midwest %>% 
  ggplot(aes(x=state,y=poptotal, color=area))+
  geom_bar(width =1.5, stat="identity",fill="#930AF1")+
  theme(plot.background = element_rect(fill="#e5ff00"))+
  theme(plot.background = element_rect(fill="#e5ff00"),
        axis.text.x=element_text(size=20, face="bold", color="#18ed3f"),
        axis.ticks.x=element_line(lineend ="square",size =10, color="pink"),
        axis.text.y=element_text(face="bold",size=15,color="#788eb3"),
        axis.title.x= element_text(angle=180,face="bold.italic", size=50,color="#14ff86"),
        axis.title.y=element_text(angle=180, hjust=0.5, vjust=0.6,face="bold", size=75, color="#1420ff"),
        plot.title=element_text(color="Red2",size=50, angle=20,hjust=0.5,vjust=0.2))+
  scale_colour_gradientn(colors = jebes )+
  labs(x="coleg", 
       y="tobal",
       color="a",
       title="%%%% VS POP")+
  facet_grid(~area)

  
midwest %>% 
  ggplot(aes(x=percollege,y=poptotal, color=area))+
  geom_point(size=20)+
  geom_smooth(method="lm",aes(group=area), color="Red")+
  scale_y_continuous(trans="log10")+
  scale_x_continuous(trans="log2")+
  theme(plot.background = element_rect(fill="#e5ff00"),
        axis.text.x=element_text(size=20, face="bold", color="#18ed3f"),
        axis.ticks.x=element_line(lineend ="square",size =10, color="pink"),
        axis.text.y=element_text(face="bold",size=15,color="#788eb3"),
        axis.title.x= element_text(angle=45,face="bold.italic", size=55,color="#14ff86"),
        axis.title.y=element_text(angle=300, hjust=0.5, vjust=0.6,face="bold", size=60, color="#1420ff"),
        plot.title=element_text(color="Red2",size=40, angle=20,hjust=0.5,vjust=0.2))+
  scale_colour_gradientn(colors = jebes )+
  labs(x="coleg", 
       y="tobal",
       color="a",
       title="%%%% VS POP")+
  facet_wrap(~area)+coord_flip()
  
