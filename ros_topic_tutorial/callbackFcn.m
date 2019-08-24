function callbackFcn(~, msg)
    disp_str = ['Receiving data: Hello ', num2str(msg.Data)];
    disp(disp_str);
    fprintf('\n')
end