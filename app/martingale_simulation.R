simulate_martingale <- function(budget, win_limit, winning_color){
  # Simulate the martingale strategy for Roulette
  # Input: budget = INT (your initial budget)
  #        win_limit = INT (at what amount of won money will you stop)
  #        color = ["black" | "red" | "green"] (on what color do you bet)
  # Output: a list with the following columns:
  #         spin_count = a numerical vector containing the count of spins
  #         color_where_ball_stopped = a numerical vector containing the colors
  #                                    where the ball stopped at each spin
  #         budget = a numerical vector containing your finances at the start of
  #                  each spin
  #         placement = a numerical vector containing the next required
  #                     placement according to the martingal strategy
  #         result = a character variable containing the final outcome of this
  #                  session ("You won" or "You lost")
  
  # define array with roulette colors for a table with 37 holes
  roulette_colors <- c(rep("black", 18), rep("red", 18), "green")
  
  # define upper value where you stop playing
  upper_stop_value <- budget + win_limit
  
  # set starting values for spin count and placement
  spin_count <- 0
  placement <- 1
  
  # create named list for results
  results <- list(
    spin_count = numeric(),
    color_where_ball_stopped = character(),
    budget_before_spin = numeric(),
    placement = numeric(),
    final_outcome = NA
  )
  
  # play roulette
  # - as long as the upper budget limit is not reached or
  # - as long as you still have enough money for the next placement
  #   whose amount is determined by the martingale strategy
  while(budget <= upper_stop_value & budget >= placement){
    
    results$budget_before_spin = c(results$budget_before_spin, budget)
    results$placement = c(results$placement, placement)
    spin_count = spin_count + 1
    results$spin_count <- c(results$spin_count, spin_count)
    
    
    # spin the roulette table
    color_where_ball_stopped <- sample(roulette_colors, 1)
    budget = budget - placement    
    
    # save result
    results$color_where_ball_stopped <- c(results$color,
                                          color_where_ball_stopped)
    
    # Analyse result of this round
    if (color_where_ball_stopped == winning_color){
      # add the won sum to the available budget
      budget <- budget + 2 * placement
      # reset placement to 1
      placement <- 1
    } else {
      # increase placement to try to recover the loss
      placement = 2 * placement
    }
    
  } # end of while
  
  # After existing the while loop:
  # Add the budget and placement for the hypothetical next spin
  results$spin_count <- c(results$spin_count, spin_count + 1)
  results$budget_before_spin <- c(results$budget, budget)
  results$placement <- c(results$placement, placement)
  
  # Result of entire session
  if (budget > upper_stop_value){
    results$final_outcome <- "You won"
  } else if (budget < placement){
    results$final_outcome <- "You lost"
  }
  
  return(results)
  
} # end of function
