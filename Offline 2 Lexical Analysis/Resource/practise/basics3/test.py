def total_chocolates(n, k):
    chocolates = n  # Initial chocolates
    wrappers = n    # Initial wrappers

    while wrappers >= k:
        new_chocolates = wrappers // k
        chocolates += new_chocolates
        wrappers = new_chocolates + (wrappers % k)

    return chocolates

# Input
input_values = input("Enter values of n and k separated by space: ")
n, k = map(int, input_values.split())

# Output
result = total_chocolates(n, k)
print("Total chocolates Sahil can have:", result)
