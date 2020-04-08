z <- runif(300,0,100)

B <- 1000
n <- length(z)


# sample mean
mean(z)

boot_samples <- matrix(sample(z, size = (B*n), replace = TRUE), B, n)
boot_results <- apply(boot_samples, 1, mean)
sd(boot_samples)

sd(z)/sqrt(length(z))

# sample median
median(z)

boot_samples <- matrix(sample(z, size = (B*n), replace = TRUE), B, n)
boot_results <- apply(boot_samples, 1, median)
sd(boot_samples)


# custom estimator
my_estimator <- funciton(z){
    mean(z) + (1000/lenght(z))
}
boot_samples <- matrix(sample(z, size = (B*n), replace = TRUE), B, n)
boot_results <- apply(boot_samples, 1, my_estimator)

##################################################################33
beta0 <- 1
beta1 <- 2
beta2 <- -3

x1 <- runif(1000, 0, 50)
x2 <- runif(1000, 0, 50)
epsilon <- rnorm(1000,0,1)
y <- beta0 + beta1*x1 + beta2*x2 + epsilon

df <- data.fame(y, x1, x2)

summary(lm(df$y~df$x1+df$x2))

B <- 100
n <- length(y)

boot_sample <- lapply(1:B , function(x) df[sample(1:n , B, replace=TRUE),]

