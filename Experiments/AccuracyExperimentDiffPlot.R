# Experiment 6D ca-HepTh

results <- read.table("AccuracyResutls10diff.txt",col.names=c("meanS","stdS","meanQ","stdQ"))
static <- as.data.frame(cbind(results$meanS,results$stdS));
static$mm = static$V1 - static$V2;
static$mp = static$V1 + static$V2;
query <- as.data.frame(cbind(results$meanQ,results$stdQ));
query$mm = query$V1 - query$V2;
query$mp = query$V1 + query$V2;

static$type = "Static (eps = 0.1)"
query$type = "Query (eps = 0.1)"
static$ed = 1:length(results$meanS)
query$ed = 1:length(results$meanS)

CA = rbind(static[seq(2000,length(results$meanS)-500,80),],query[seq(2000,length(results$meanS)-500,80),])

gg <- ggplot(CA,aes(x=ed,y=V1,fill=type,ymin=mm,ymax=mp)) + 
  geom_line(aes(colour=type)) + geom_ribbon(alpha=0.2) +
  ylab("Absolute error (mean)") + 
  xlab("Edge index")+ 
  theme(panel.background = element_rect(fill = "white")) + 
  labs(title="ca-GrQc (epsilon=0.1)")

ggsave(gg, file="data10diff.png", width=8, height=4.5)
ggsave(gg, file="data10diff.pdf", width=8, height=4.5)

# Experiment 6D ca-HepTh

results <- read.table("AccuracyResutls100diff.txt",col.names=c("meanS","stdS","meanQ","stdQ"))
static1 <- as.data.frame(cbind(results$meanS,results$stdS));
static1$mm = static1$V1 - static1$V2;
static1$mp = static1$V1 + static1$V2;
query1 <- as.data.frame(cbind(results$meanQ,results$stdQ));
query1$mm = query1$V1 - query1$V2;
query1$mp = query1$V1 + query1$V2;

static1$type = "Static (eps = 0.01)"
query1$type = "Query  (eps = 0.01)"

static1$ed = 1:length(results$meanS)
query1$ed = 1:length(results$meanS)

CA = rbind(static1[seq(2000,length(results$meanS)-500,80),],query1[seq(2000,length(results$meanS)-500,80),])

gg <- ggplot(CA,aes(x=ed,y=V1,fill=type,ymin=mm,ymax=mp)) + 
  geom_line(aes(colour=type)) + geom_ribbon(alpha=0.2) +
  ylab("Absolute error (mean)") + 
  xlab("Edge index")+ 
  theme(panel.background = element_rect(fill = "white")) + 
  labs(title="ca-GrQc (epsilon=0.01)")

ggsave(gg, file="data100diff.png", width=8, height=4.5)
ggsave(gg, file="data100diff.pdf", width=8, height=4.5)

CA = rbind(static1,query1,static,query);


gg <- ggplot(CA,aes(x=type,y=V2)) + 
  geom_boxplot(aes(colour=type)) +
  xlab("Algorithm Version")+
  ylab("Absolute error Standart Deviation")+
  theme(panel.background = element_rect(fill = "white")) + 
  labs(title="ca-GrQc")

ggsave(gg, file="dataSTDdiff.png", width=8, height=4.5)
ggsave(gg, file="dataSTDdiff.pdf", width=8, height=4.5)
