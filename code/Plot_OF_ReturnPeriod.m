% --- plot statistics of outflow vs return period of daily rainfall
figure(3)
clf
subplot (2,2,1)
plot (Ret_P,Rout_eff,'ko','markersize',5,'linewidth',3)
ylabel ('\it{<O>/<I>}','fontweight','bold','fontsize',10)

subplot (2,2,2)
plot (Ret_P,Rout_dissip,'ko','markersize',5,'linewidth',3)
ylabel ('\it{Std(O)/Std(I)}','fontweight','bold','fontsize',10)

subplot (2,2,3)
plot (Ret_P,OutF_CV,'ko','markersize',5,'linewidth',3)
xlabel ('\it{Return Period (d)}','fontweight','bold','fontsize',10)
ylabel ('\it{CV(O)}','fontweight','bold','fontsize',10)

subplot (2,2,4)
plot (Ret_P,OutF_exe,'ko','markersize',5,'linewidth',3)
xlabel ('\it{Return Period (d)}','fontweight','bold','fontsize',10)
ylabel ('\it{Pr(O<EF m^3 s^{-1})}','fontweight','bold','fontsize',10)

