%% function to optimize. r (1:3) is x,y,z distance from reference sensor, r(4:5) is orientation, r(6:8) is earth 
function F = lsqnonlinObjFcn_notSym_XYZrhothetaG(r, bz, d, d2)
    
    measured = bz./10^6; 
    G = r(6:8);
    rho = r(5);
    theta = r(4);
    r = r(1:3);
    b = r + d; 
    c = r + d2;
    m = .114.*[cos(theta)*cos(rho),cos(theta)*sin(rho),sin(theta)];
   
    B_sens1 = G +(4*pi*10^-7)/(4*pi*(norm(r)^3))*((dot(3*r,m)./(dot(r,r))*r)-m); 
    B_sens2 = G +(4*pi*10^-7)/(4*pi*(norm(b)^3))*((dot(3*b,m)./(dot(b,b))*b)-m); 
    B_sens3 = G +(4*pi*10^-7)/(4*pi*(norm(c)^3))*((dot(3*c,m)./(dot(c,c))*c)-m); 

    model = [B_sens1, B_sens2, B_sens3];
    model = reshape(model, [1,9]);

    F = model - measured; 

end
