function Lenghton
m = ones(20,20);
f=figure('Units','pixels','Position',[200,100,500,500],'menubar','none');
a=axes('Units','pixels','position',[50,10,390,390],'XTick',[],'YTick',[]);
s=uicontrol('Style','pushbutton','Position',[50,420,100,30],'String','Start','Callback',@start);
pop = uicontrol('Style', 'popup','String', {'Stop','Mirror','Expand'},'Position', [200,400,100,45]);
count = 20; % demansion of field
newcount = 0; % temp var for mirror method
expand = 10;
for i=0:count-1
    for j=0:count-1
        rec(i+1,j+1)=rectangle('Position',[i,j,1,1],'FaceColor','w', 'EdgeColor', 'k','LineWidth', 0.1);
    end
end
axis tight
ant=[10,10];
Direct=0;
    function start(~,~)
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
            switch pop.Value
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
                       newm = ones(newcount); 
                       %rec = zeros(newcount);
                       newm(((newcount-count)/2+1):newcount-((newcount-count)/2),((newcount-count)/2+1):newcount-((newcount-count)/2)) = m;
                       m = newm;
                       cla;
                       for i=1:newcount
                           for j=1:newcount
                               rec(i,j)=rectangle('Position',[i,j,1,1],'FaceColor',[m(i,j),m(i,j),m(i,j)], 'EdgeColor', 'k','LineWidth', 1);
                           end
                       end
                       ant(1) = ant(1) + expand/2;
                       ant(2) = ant(2) + expand/2;
                       count = newcount;
                    end
            end
            if (m(ant(1),ant(2)) == 1)
                Direct = mod(Direct +1, 4);
            else
                Direct = mod(Direct -1, 4);
            end
            m(ant(1),ant(2)) = 1 - m(ant(1),ant(2));
            p = rec(ant(1), ant(2));
            p.FaceColor = [1, 1, 1] - p.FaceColor;
            drawnow
        end
    end
end

