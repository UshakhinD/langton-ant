function Lenghton
f=figure('Units','pixels','Position',[200,100,600,650],'menubar','none');
a=axes('Units','pixels','position',[50,10,500,500],'XTick',[],'YTick',[]);
s=uicontrol('Style','pushbutton','Position',[50,540,100,30],'String','Start','Callback',@start);
popType = uicontrol('Style', 'popup','String', {'Rectangular','Hexagonal'},'Value',1,'Position', [50,580,100,45],'Callback',@styletype);
popExpnd = uicontrol('Style', 'popup','String', {'Stop','Mirror','Expand'},'Value',3,'Position', [180,520,80,45]);
popSpeed = uicontrol('Style', 'popup','String', {'X1','X2','X3','X5','X10','X20'},'Position', [280,520,80,45]);
steptxt = uicontrol('Style', 'text','Position', [360,540,60,30]);
Rule = uicontrol('Style', 'edit','String','RL', 'Position', [420,540,100,30]);
Steprul = uicontrol('Style', 'edit', 'String', '0', 'Position', [420, 580, 100, 30]);
steptxt.String = {'step # '};
count = 20; % start demansion of field
newcount = 0; % temp var for mirror method
expand = 10;
step = 0;
shape = [];
m = [];
ant = [];
styletype
    function styletype(~,~)
        cla;
        if popType.Value == 1
            shape = [];
            m = zeros(count,count);
            for i=0:count-1
                for j=0:count-1
                    shape(i+1,j+1)=rectangle('Position',[i,j,1,1],'FaceColor','w', 'EdgeColor', 'k','LineWidth', 1);
                end
            end
        else
            shape = [];
            m = zeros(count*2,floor(count*sqrt(3)/4));
            for i=0:count-1
                for j=0:count*sqrt(3)/4-1
                    shape(i+1,j+1) = patch((1-mod(i,2))*1.5 + [0,-1/2,0,1,3/2,1] + j*3, (sqrt(3)/2)*i + [0,sqrt(3)/2,sqrt(3),sqrt(3),sqrt(3)/2,0], 'w');
                end
            end
        end
        ant=[size(shape,1)/2,size(shape,2)/2];
        axis equal
        axis tight
        axis off
    end
colors = ['w','k','r','y','m','b','g','c'];
Direct=0;
rules = 0;

    function start(~,~)
        rules = Rule.String;
        if popType.Value == 1
            Recstart
        else
            Hexstart;
        end
        
    end
    function Recstart(~,~)
        while 1
            switch Direct
                case 0
                    ant(2)=ant(2)+1;
                case 1
                    ant(1)=ant(1)+1;
                case 2
                    ant(2)=ant(2)-1;
                case 3
                    ant(1)=ant(1)-1;
            end
            switch popExpnd.Value
                case 1
                    if(ant(1)>count && ant(1)<1 && ant(2)>count && ant(2)<1)
                        return;
                    end
                case 2
                    if(ant(1)>count)
                        ant(1) = 1;
                    elseif(ant(1)<1)
                        ant(1) = count;
                    end
                    if(ant(2)>count)
                        ant(2) = 1;
                    elseif(ant(2)<1)
                        ant(2) = count;
                    end
                case 3
                    if(ant(1)>count || ant(1)<1 || ant(2)>count || ant(2)<1) % if out of field => expand field
                        newcount = count + expand;
                        newm = zeros(newcount);
                        %rec = zeros(newcount);
                        newm(((newcount-count)/2+1):newcount-((newcount-count)/2),((newcount-count)/2+1):newcount-((newcount-count)/2)) = m;
                        m = newm;
                        cla;
                        for i=1:newcount
                            for j=1:newcount
                                shape(i,j)=rectangle('Position',[i,j,1,1],'FaceColor',colors(m(i,j)+1), 'EdgeColor', 'k','LineWidth', 0.1);
                            end
                        end
                        ant(1) = ant(1) + expand/2;
                        ant(2) = ant(2) + expand/2;
                        count = newcount;
                    end
            end
            R = rules(m(ant(1),ant(2))+1);
            if (strcmp(R,'R'))
                Direct = mod(Direct +1, 4);
            else
                Direct = mod(Direct -1, 4);
            end
            m(ant(1),ant(2)) = mod(m(ant(1),ant(2))+1,length(rules));
            p = shape(ant(1), ant(2));
            set(p,'facecolor',colors(m(ant(1),ant(2))+1));
            step = step + 1;
            steptxt.String = {'step # ', num2str(step)};
            Speedcontrol;
        end
    end

    function Hexstart(~,~)
        hexCountRaw = size(m,1);
        hexCountCol = size(m,2);
        expandRaw = 16;   %floor(hexCountRaw/2)
        expandCol = 8;
        missSteps = str2num(Steprul.String);
        paintflag = false;
        while 1
            dopaint = missSteps < step;
            if  dopaint && ~paintflag && missSteps > 0
                cla;
                for i=1:size(m, 1)
                    for j=1:size(m, 2)
                        shape(i,j)= patch((1-mod(i,2))*1.5 + [0,-1/2,0,1,3/2,1] + j*3, (sqrt(3)/2)*i + [0,sqrt(3)/2,sqrt(3),sqrt(3),sqrt(3)/2,0], colors(m(i,j)+1));
                    end
                end
            end
            switch Direct
                case 0
                    ant(1)=ant(1)+2;
                case 1
                    ant(1)=ant(1)+1;
                    if(mod(ant(1),2) == 1)
                        ant(2) = ant(2)+1;
                    end
                case 2
                    if(mod(ant(1),2) == 1)
                        ant(1)=ant(1)-1;
                        ant(2)=ant(2)+1;
                    else
                        ant(1)=ant(1)-1;
                    end
                case 3
                    ant(1)=ant(1)-2;
                case 4
                    if(mod(ant(1),2) == 1)
                        ant(1) = ant(1)-1;
                    else
                        ant(1) = ant(1)-1;
                        ant(2) = ant(2)-1;
                    end
                case 5
                    if(mod(ant(1),2) == 1)
                        ant(1)=ant(1)+1;
                    else
                        ant(1)=ant(1)+1;
                        ant(2)=ant(2)-1;
                    end
            end
            if(ant(1)>hexCountRaw || ant(1)<1 || ant(2)>hexCountCol || ant(2)<1) % if out of field => expand field
                newhexCountRaw = hexCountRaw + expandRaw;
                newhexCountCol = hexCountCol + expandCol;
                newm = zeros(newhexCountRaw,newhexCountCol);
                %rec = zeros(newcount);
                newm(((newhexCountRaw-hexCountRaw)/2+1):newhexCountRaw-((newhexCountRaw-hexCountRaw)/2),((newhexCountCol-hexCountCol)/2+1):newhexCountCol-((newhexCountCol-hexCountCol)/2)) = m;
                m = newm;
                if dopaint
                    cla;
                    for i=1:newhexCountRaw
                        for j=1:newhexCountCol
                            shape(i,j)= patch((1-mod(i,2))*1.5 + [0,-1/2,0,1,3/2,1] + j*3, (sqrt(3)/2)*i + [0,sqrt(3)/2,sqrt(3),sqrt(3),sqrt(3)/2,0], colors(m(i,j)+1));
                        end
                    end
                end
                ant(1) = ant(1) + expandRaw/2;
                ant(2) = ant(2) + expandCol/2;
                hexCountRaw = newhexCountRaw;
                hexCountCol = newhexCountCol;
            end
            
            R = rules(m(ant(1),ant(2))+1);
            if (strcmp(R,'B'))
                Direct = mod(Direct +1, 6);
            elseif (strcmp(R,'C'))
                Direct = mod(Direct +2, 6);
            elseif (strcmp(R,'D'))
                Direct = mod(Direct +3, 6);
            elseif (strcmp(R,'E'))
                Direct = mod(Direct +4, 6);
            elseif (strcmp(R,'F'))
                Direct = mod(Direct +5, 6);
            end
            m(ant(1),ant(2)) = mod(m(ant(1),ant(2))+1,length(rules));
            if dopaint
                p = shape(ant(1), ant(2));
                set(p,'facecolor',colors(m(ant(1),ant(2))+1));
                Speedcontrol;
            end
            step = step + 1;
            steptxt.String = {'step # ', num2str(step)};
        end
    end

    function Speedcontrol(~,~)
        switch popSpeed.Value
            case 1
                drawnow
            case 2
                if(mod(step,2) == 1)
                    drawnow
                end
            case 3
                if(mod(step,3) == 1)
                    drawnow
                end
            case 4
                if(mod(step,5) == 1)
                    drawnow
                end
            case 5
                if(mod(step,10) == 1)
                    drawnow
                end
            case 6
                if(mod(step,20) == 1)
                    drawnow
                end
        end
    end
end