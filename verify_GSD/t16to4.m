function msg = t16to4(msg)
    for i = 0: length(msg)/4-1
        msgpiece = msg(1+i*4: 2+i*4);
        v = msgpiece(1)*2 + msgpiece(2);
        switch v
            case 0; msg(i*4+4) = ~msg(i*4+4);msg(i*4+3) = ~msg(i*4+3);
            case 1; msg(i*4+3) = ~msg(i*4+3);
            case 2; msg(i*4+4) = ~msg(i*4+4);
            case 3; 
        end
    end
    msg1 = reshape(msg,4,[]);
    msg2 = [msg1(1:2,:), msg1(3:4,:)];
    msg = reshape(msg2,[],1);
end