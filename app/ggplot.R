library(ggplot2)

create_ggplot <- function(martingale_result, initial_budget, win_limit){
  # Create ggplot based on a martingale simulation
  # Input: martingale_result = list produced by the simulate_martingale function
  #       initial budget = integer (initial budget)
  #       win_limit = integer (at what amount of won money will you stop)
  # Output: a ggplot object
  
  df <- data.frame(
    spin = c(martingale_result$spin_count),
    budget = c(martingale_result$budget_before_spin),
    placement = c(martingale_result$placement),
    color = c(martingale_result$color_where_ball_stopped, ""),
    dummy = rep(-10, length(martingale_result$spin_count))
  )
  
  p <- ggplot(data = df, aes(x = spin, y = budget)) +
    geom_point(size = 1.5, color = "darkviolet") +
    geom_line(color = "darkviolet") +
    geom_point(aes(y = placement), size = 1.5, color = "#e6ac00") +
    geom_line(aes(y = placement), color = "#e6ac00") +
    geom_hline(yintercept = 0, color = "black") +
    geom_hline(yintercept = win_limit + initial_budget, color = "blue",
               linetype = "dashed") +
    ylim(0, max(200, df$budget)) +
    scale_y_continuous(name = "available budget",
                       sec.axis = sec_axis(~. * 1,
                                           name = "required placement")) +
    theme(axis.title.y.left = element_text(color = "darkviolet"),
          axis.text.y.left = element_text(color = "darkviolet"),
          axis.title.y.right = element_text(color = "#e6ac00"),
          axis.text.y.right = element_text(color = "#e6ac00")) +
    ggtitle("Martingale roulette strategy simulation") +
    geom_point(aes(y = dummy, color = color, shape = color), size = 1.5) +
    scale_color_manual(values = c("black" = "black", "green" = "green",
                                  "red" = "red", "blue" = "blue",
                                  "#e6ac00" = "#e6ac00",
                                  "darkviolet" = "darkviolet")) +
    scale_shape_manual(values = c("black" = 19, "green" = 19,
                                  "#e6ac00" = 19, "red" = 19,
                                  "darkviolet" = 19))
  return(p)
} 
