library(readr)
data = read.csv("/Users/lennert/Github-projecten//BAP/bachproef/data/uitvoeringstijd-hello-merged.csv", sep=";")
View(data)

demofunctie <- data
output_file <- file("boxplot_uitvoeringstijd_helloworld.txt")
box_uitvoer_tijd <- file("boxplot_uitvoeringstijd_helloworld.txt")



# Voorbereiding (aanmaken vectors)
x <- data.frame(demofunctie$OpenFaaS)
openfaas_vector_tijd <- as.vector(x)
openfaas_vector_tijd <-unlist(openfaas_vector_tijd)

y <- data.frame(demofunctie$Fission)
fission_vector_tijd <- as.vector(y)
fission_vector_tijd <-unlist(fission_vector_tijd)


#spreidingsmaten: 
#standaardafwijking
openfaas_sd_tijd <- sd(data$OpenFaaS)
openfaas_sd_tijd

fission_sd_tijd <- sd(data$Fission)
fission_sd_tijd

#Variantie
openfaas_var_tijd <- var(data$OpenFaaS)
openfaas_var_tijd

fission_var_tijd <- var(data$Fission)
fission_var_tijd

#Kwartielen
openfaas_kwartiel_tijd <- quantile(data$OpenFaaS)


fission_kwartiel_tijd <- quantile(data$Fission)

#Summary
openfaas_summary_tijd <- summary(data$OpenFaaS)

fission_summary_tijd <- summary(data$Fission)


#t test
openfaas_t_tijd <- t.test(openfaas_vector_tijd)
print(openfaas_t_tijd)
fission_t_tijd <- t.test(fission_vector_tijd)

boxplot(data$OpenFaaS,data$Fission,
        names = c("OpenFaaS", "Fission"),
        xlab = "Framework",
        col=c("#f48342","#f48342"),
        ylab = "Uitvoeringstijd in s",
        main=paste("Uitvoeringstijd Hello World Python functie",sep = ""),color = "group")



# write results to text file :')
sink(output_file)
print("OpenFaaS resultaten")
print("summary openfaas_summary_tijd")
print(openfaas_summary_tijd)
print("standaardafwijking openfaas_sd_tijd")
print(openfaas_sd_tijd)
print("variantie openfaas_var_tijd")
print(openfaas_var_tijd)
print("kwartielen openfaas_kwartiel_tijd")
print(openfaas_kwartiel_tijd)
print("t-test openfaas_t_tijd")
print(openfaas_t_tijd)
print("----------------------------------------------------------------------------------------------")
print("Fission resultaten")
print("summary fission_summary_tijd")
print(fission_summary_tijd)
print("standaardafwijking fission_sd_tijd")
print(fission_sd_tijd)
print("variantie fission_var_tijd")
print(fission_var_tijd)
print("kwartielen fission_kwartiel_tijd")
print(fission_kwartiel_tijd)
print("t-test fission_t_tijd")
print(fission_t_tijd)
sink()


