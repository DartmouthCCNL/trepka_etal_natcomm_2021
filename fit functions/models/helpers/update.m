function value =  update(initial_value, zeta, reward)
    value = initial_value + zeta*(reward-initial_value);
end