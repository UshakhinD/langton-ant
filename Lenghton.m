function Lenghton
m = zeros(20,20);
f=figure('Units','pixels','Position',[200,100,600,600],'menubar','none');
a=axes('Units','pixels','position',[50,10,500,500],'XTick',[],'YTick',[]);
s=uicontrol('Style','pushbutton','Position',[50,540,100,30],'String','Start','Callback',@start);
popExpnd = uicontrol('Style', 'popup','String', {'Stop','Mirror','Expand'},'Value',3,'Position', [180,520,80,45]);
popSpeed = uicontrol('Style', 'popup','String', {'X1','X2','X3','X5','X10','X20'},'Position', [280,520,80,45]);
steptxt = uicontrol('Style', 'text','Position', [360,540,60,30]);
Rule = uicontrol('Style', 'edit','String','RL', 'Position', [420,540,100,30]);
steptxt.String = {'step # '};
count = 20; % demansion of field
newcount = 0; % temp var for mirror method
expand = 10;
step = 0;
for i=0:count-1
    for j=0:count-1
        rec(i+1,j+1)=rectangle('Position',[i,j,1,1],'FaceColor','w', 'EdgeColor', 'k','LineWidth', 1);
    end
end
axis tight
ant=[10,10];
colors = ['w','k','r','y','m','b','g','c'];
Direct=0;
    function start(~,~)
        rules = Rule.String;
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
                               rec(i,j)=rectangle('Position',[i,j,1,1],'FaceColor',colors(m(i,j)+1), 'EdgeColor', 'k','LineWidth', 0.1);
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
            p = rec(ant(1), ant(2));
            p.FaceColor = colors(m(ant(1),ant(2))+1);
            step = step + 1;
            steptxt.String = {'step # ', num2str(step)};
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
end