#create a set of high frequency words and pseudowords for ortho localizer task

library(caret)
library(Matching)
library(stringdist)

########## Load the data files
ewfg<-read.csv('ewfg.csv',)

#get an initial subset of ewfg words to upload to ELP
ewfg$nchar<-unlist(lapply(as.character(ewfg$word), nchar))
ewfg<-subset(ewfg, nchar > 2 & nchar < 7 & gr1>0)
write.table(ewfg$word, file='forelp_words.txt', col.names=FALSE, row.names=FALSE, quote=FALSE)


elp<-read.csv('elp.csv')
mrc<-read.table('mrc.txt', header=TRUE)
mrc$WORD<-unlist(lapply(as.character(mrc$WORD), tolower))

words<-merge(ewfg, elp, by.x='word', by.y='Word')
words<-merge(words, mrc, by.x='word', by.y='WORD')


############ restrict words
# don't use words in the adaptation task
adapt_words<-NULL
for (i in 1:3) {
	adapt_words<-rbind(adapt_words, read.csv(sprintf('~/OneDrive - University of Connecticut/Projects/IVF_Language/repo/protocol/tasks/adaptation/stimuli/trial_block_%d.csv', i)))
}

used_words<-c(as.character(adapt_words$word1), as.character(adapt_words$word2))

words<-subset(words, !(word%in%used_words))

#monomorphemic
words<-subset(words, NMorph==1)
#1 syllab;e
words<-subset(words, NSyll==1)

#nouns-too restrictive to use words with NN as primary sense
words<-subset(words, grepl('.*NN.*',POS))

#imageable
words<-subset(words, IMG>300)

#phonologically simple
#words<-subset(words, NPhon==Length)

#frequency
words$gr1lf<-log10(words$gr1/584693*1e6)
words<-subset(words, gr1lf>1)


####### match pseudowords
arc<-read.table('arc_nonwords.txt', header=TRUE, comment.char="")
arc$used<-FALSE
n_words<-dim(words)[1]
words$PSW<-NA
arc$used<-FALSE
for(i in 1:n_words ) {
	lv_dist<-stringdist(words$word[i], arc$W, method='lv')
	possible_matches<-which(arc$NL==words$NLET[i] & arc$NP==words$NPHN[i] & !arc$used & lv_dist==1)
	if (length(possible_matches)>0) {
		if(length(possible_matches)>1) {
			arc_idx<-sample(possible_matches)[1]
		}
		else {
			arc_idx<-possible_matches
		}
		arc$used[arc_idx]<-TRUE
		words$PSW[i]<-as.character(arc$W[arc_idx])
	}
}



#words that have a PSW match
words<-subset(words, !is.na(PSW))


###### try to create 12 blocks of 12 stimuli matched on too many dimensions

N_BLOCKS<-12
N_STIM<-12

n_words<-dim(words)[1]

best_blocks<-NULL
best_distance<-1e6

for(k in 1:1000) {
	word_order<-sample.int(n_words)
	word_features<-scale(words[word_order, c('NLET', 'Ortho_N', 'Phono_N', 'CNC', 'IMG', 'NPHN')])
	block<-rep(0,dim(word_features)[1])
	block[sample.int(n_words, N_STIM)] = 1
	m<-Match(Tr=block, X=word_features, M=N_BLOCKS-1, replace=FALSE)
	
	for(i in which(block==1)) {
		block[m$index.control[m$index.treated==i]] <- 2:(N_BLOCKS+1)
	}
	
	feature_dist<-as.matrix(dist(word_features))
	block_dist<-matrix(NA, N_BLOCKS, N_BLOCKS)
	for (i in 1:N_BLOCKS) {
		for (j in i:N_BLOCKS) {
			block_dist[i,j]<-mean(feature_dist[block==i, block==j])
		}
	}
	
	if(sd(block_dist,na.rm=TRUE) < best_distance) {
		
		best_blocks<-as.data.frame(words[word_order,])
		best_blocks$block<-block
		best_distance<-sd(block_dist,na.rm=TRUE)
	}
}

########
best_blocks<-subset(best_blocks, block!=0)
best_blocks<-merge(best_blocks, arc, by.x='PSW', by.y='W')

### Save
write.csv(best_blocks, file='stimuli_stats.csv',  row.names=FALSE, quote=FALSE)
write.csv(best_blocks[,c('word', 'PSW', 'block')], file='stimuli.csv', row.names=FALSE, quote=FALSE)

#stats
block_stats<-aggregate(.~block, best_blocks[,c('NLET', 'Ortho_N', 'Phono_N', 'CNC', 'IMG', 'NPHN', 'block', 'gr1lf', 'BG_Mean')], mean)
write.csv(block_stats, file='block_word_stats.csv')




