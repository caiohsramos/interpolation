1;

#{
Caio Henrique Silva Ramos - NUSP 9292991
EP3

Linhas que podemos modificar para os testes:
  -Linhas abaixo do comentario "Parametros"
  -Descomentar linhas 135 ou 136 (bilinear ou bicubico)
  -Modificar f e suas derivadas nas funcoes "gerar..."
  -Linhas do "passox" e "passoy" 
    (tamanho do passo para recuperar imagem original)
  -Descomentar ultimas linhas do programa para modificar o plot desejado
    (deixar descomentado somente uma)
#}

function res = avalia(nx, ny, ax, bx, ay, by, f, f_x, f_y, f_xy, x, y)
  hx = (bx-ax)/nx;
  hy = (by-ay)/ny;
  i = floor((x-ax)/hx);
  j = floor((y-ay)/hy);
  xi = ax + i*hx;
  xi1 = xi + hx;
  yi = ay + j*hy;
  yi1 = yi + hy;
  
  
  u = (x-xi)/hx;
  v = (y-yi)/hy;  
  
  #mais facil para indexar a matriz
  i += 2;
  j += 2;
  
  
  r = [1 0 0 0;0 1 0 0;-3 -2 3 -1;2 1 -2 1];
  s = transpose(r);
  fm = [f(i,j) f_y(i,j) f(i,j+1) f_y(i,j+1);
        f_x(i,j) f_xy(i,j) f_x(i,j+1) f_xy(i,j+1);
        f(i+1,j) f_y(i+1,j) f(i+1,j+1) f_y(i+1,j+1);
        f_x(i+1,j) f_xy(i+1,j) f_x(i+1,j+1) f_xy(i+1,j+1)];
  c = r*fm*s;
  res = [1 u u^2 u^3]*c*[1; v; v^2; v^3];
  
endfunction

function m = gerarf(nx,ny,ax,bx,ay,by)
  m = zeros(nx+1,ny+1);
  hx = (bx-ax)/nx;
  hy = (by-ay)/ny;
  x = ax;
  y = ay;
  for i = 0:nx
    for j = 0:ny
      #modificar essa linha para mudar a f
      f = x^3-y^2+2*x*y-20;
      
      m(i+1,j+1) = f;
      y+=hy;
    endfor
    x+=hx;
    y=ay;
  endfor
endfunction

function m = aproxf_x(nx,ny,ax,bx,ay,by,f)
  m = zeros(nx+1,ny+1);
  hx = (bx-ax)/nx;
  hy = (by-ay)/ny;
  
  for i = 0:nx
    for j = 0:ny
      #modificar essa linha para a devida aproximacao
      #caso especial para as bordas ou usar padarray
      r=(f(i+3,j+2)-f(i+1,j+2))/2*hx;
      
      
      m(i+1,j+1) = r;
    endfor
  endfor
endfunction

function m = aproxf_y(nx,ny,ax,bx,ay,by,f)
  m = zeros(nx+1,ny+1);
  hy = (by-ay)/ny;
  for i = 0:nx
    for j = 0:ny
      #modificar essa linha para a devida aproximacao
      #caso especial para as bordas ou usar padarray
      r=(f(i+2,j+3)-f(i+2,j+1))/2*hy;
      
      m(i+1,j+1) = r;
    endfor
  endfor
endfunction

function m = aproxf_xy(nx,ny,ax,bx,ay,by,f)
  m = zeros(nx+1,ny+1);
  hx = (bx-ax)/nx;
  hy = (by-ay)/ny;
  for i = 0:nx
    for j = 0:ny
      #modificar essa linha para a devida aproximacao
      #caso especial para as bordas ou usar padarray
      r=(f(i+3,j+3)-f(i+3,j+2)-f(i+2,j+3)+2*f(i+2,j+2)-f(i+1,j+2)-f(i+2,j+1)+f(i+1,j+1))/2*hx*hy;
      
      m(i+1,j+1) = r;
    endfor
  endfor
endfunction

#parametros
nx = 30;
ny = 30;
ax = -2;
bx = 2;
ay = -2;
by = 2;

#definindo f e suas derivadas (aqui entraria uma foto)
f = gerarf(nx,ny,ax,bx,ay,by);
f = padarray(f,[1,1], 'replicate');

f_x = aproxf_x(nx,ny,ax,bx,ay,by,f);
f_y = aproxf_y(nx,ny,ax,bx,ay,by,f);
f_xy = aproxf_xy(nx,ny,ax,bx,ay,by,f);

#problemas de fronteira
f_x = padarray(f_x,[1,1], 'replicate');
f_y = padarray(f_y,[1,1], 'replicate');
f_xy = padarray(f_xy,[1,1], 'replicate');

#avaliando v
passox = .02;
passoy = .02;
x = ax:passox:bx;
y = ay:passoy:by;
xplot = [];
yplot = [];
res = [];
fplot = [];
g = inline("x^3-y^2+2*x*y-20");
hold on
for i = x
  for j = y
    res = [res avalia(nx, ny, ax, bx, ay, by, f, f_x,f_y,f_xy,i,j,type)];
    fplot = [fplot g(i,j)];
    xplot = [xplot i];
    yplot = [yplot j];
  endfor
endfor

res_mat = reshape(res, length(x), length(y));

#imagem gerada por f (malha grossa)
#imshow(f, [])

#imagem dos pontos interpolados
imshow(transpose(res_mat), [])

#plot de v e f
#scatter3(xplot, yplot, res, "filled")
#ezmesh(inline("x^3-y^2+2*x*y-20"),[ax bx ay by])

#plot de |f-v|
#plot(fplot.-res)

