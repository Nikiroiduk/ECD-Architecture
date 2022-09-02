def toBASEint(num, base):
    alpha = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    n = abs(num)
    b = alpha[n % base] 
    while n >= base:
        n = n // base
        b += alpha[n % base] 
    return ('' if num >= 0 else '-') + b[::-1] 
    
def toBaseFrac(frac, base, n = 10):
    alpha = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    b = ''
    while n:
        frac *= base
        frac = round(frac,n)
        b += str(int(frac))
        frac -= int(frac)
        n -= 1
    return b

def calc(number, inC, outC):
    alpha = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    if '.' in number:
        num, frac = map(str, number.split('.'))
        num = int(num,inC)
        a = toBASEint(num,outC)
        b = 0
        k = inC
        for i in frac :
            b += alpha.index(i) / k
            k *= inC
        b = toBaseFrac(b, outC)
        return(a+'.'+b)
    else:
        return(toBASEint(int(number,inC),outC))


x = input('Enter a 32-bit real number')
isNumberNegative = bool(int(x[0]))
exponent = x[1:9]
mantissa = '1.' + x[9::]
mantissa = mantissa[0:mantissa.rindex('1')  + 1]
res = round(float(calc(mantissa, 2, 10)) * pow(2, int(calc(exponent, 2, 10)) - 127), 3)
print('{} {} {} = {}'.format(x[0], x[1:9], x[9::], -res if isNumberNegative else res))
