function [dados]=carrega_dados(arquivo)

[~,sheet_name]=xlsfinfo(arquivo);

for k=1:numel(sheet_name)
  dados{k}=xlsread(arquivo,sheet_name{k});
end

end