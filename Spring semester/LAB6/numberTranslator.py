def toBASEint(num, base):
    alpha = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    n = abs(num)
    b = alpha[n % base] 
    while n >= base :
        n = n // base
        b += alpha[n % base] 
    return ('' if num >= 0 else '-') + b[::-1] 
    
def toBaseFrac(frac, base, n = 10) :
    alpha = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    b = ''
    while n :
        frac *= base
        frac = round(frac,n)
        b += str(int(frac))
        frac -= int(frac)
        n -= 1
    return b

def calc(num, inC, outC):
    Number = num
    Basein = inC
    Baseout = outC
    alpha = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    if '.' in Number :
        num, frac = map(str,Number.split('.'))
        num = int(num,Basein)
        a = toBASEint(num,Baseout)
        b = 0
        k = Basein
        for i in frac :
            b += alpha.index(i) / k
            k *= Basein
        b = toBaseFrac(b, Baseout)
        return(a+'.'+b)
    else :
        return(toBASEint(int(Number,Basein),Baseout))

print('Enter a 32-bit real number')
x = input()
isNumberNegative = bool(int(x[0]))
exponent = x[1:9]
mantissa = '1.'
mantissa += x[9::]
mantissa = mantissa[0:mantissa.rindex('1')  + 1]
y = x[0] + ' ' + x[1:9] + ' ' + x[9::]
res = round(float(calc(mantissa, 2, 10)) * pow(2, int(calc(exponent, 2, 10)) - 127), 3)
print('{} = {}'.format(y, -res if isNumberNegative else res))
