function [output] = trans_Log(input)
output = log10(input);
output(output~=real(output))=NaN;
output(isinf(output))=NaN;
end