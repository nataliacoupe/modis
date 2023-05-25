% Downloads products from the NASA url
% Natalia Restrepo Coupe
% nataliacoupe@gmail.com
% Toronto Canada September 13, 2016
%%.........................................................................
% I wish I could better document however I do not have the time.
% you only need to change user name and password
% change folder names as they apply to your own locations
% Share your code if you want to make a better world
%%.........................................................................
warning('off','all')
warning

%Folder where data is to be stored
FolderMODIS = [directory where you want to upload the data to in brakets ''];
slash = '/';  %[change if in msoffice]
%Years to be downloaded
yearMODIS = (2019:2023)'; %years you want to download
weekMODIS = [];                   NameWeek = [];        NameWeekAQ = [];
eightMODIS = [];                  NameEight = [];       weekMODISaq = [];
eightMODISaq = [];                NameEightAQ = [];

for ik = 1:length(yearMODIS)
    weekMODIS = [weekMODIS;datenum(yearMODIS(ik),1,(1:16:365)')];
    NameWeek = [NameWeek;num2str((1:16:365)','%03.0f')];
    weekMODISaq = [weekMODISaq;datenum(yearMODIS(ik),1,(4:16:365)')];
    NameWeekAQ = [NameWeekAQ;num2str((4:16:365)','%03.0f')];
    eightMODIS = [eightMODIS;datenum(yearMODIS(ik),1,(1:8:365)')];
    NameEight = [NameEight;num2str((1:8:365)','%03.0f')];
    eightMODISaq = [eightMODISaq;datenum(yearMODIS(ik),1,(1:8:365)')];
    NameEightAQ = [NameEightAQ;num2str((1:8:365)','%03.0f')];
end
dayMODIS = (datenum(yearMODIS(1),1,1):1:datenum(yearMODIS(end),12,31))';
dayMODIS(dayMODIS<datenum(2000,2,24))=[];
[Yday,Mday,Dday]             = datevec(dayMODIS);
NameDay = num2str(dayMODIS-datenum(Yday,0,1)+1,'%03.0f');

ind = find(weekMODIS<datenum(2000,2,23));     NameWeek(ind,:)    = [];   weekMODIS(ind,:)    = [];
ind = find(weekMODISaq<datenum(2002,7,4));    NameWeekAQ(ind,:)  = [];   weekMODISaq(ind,:)  = [];
ind = find(eightMODIS<datenum(2000,2,23));    NameEight(ind,:)   = [];   eightMODIS(ind,:)   = [];
ind = find(eightMODISaq<datenum(2002,7,4));   NameEightAQ(ind,:) = [];   eightMODISaq(ind,:) = [];
[Yweek,Mweek,Dweek]       = datevec(weekMODIS);
[YweekAQ,MweekAQ,DweekAQ] = datevec(weekMODISaq);
[Yeight,Meight,Deight]    = datevec(eightMODIS);
[YeightAQ,MeightAQ,DeightAQ] = datevec(eightMODISaq);
NameYearWeek    = num2str(Yweek,'%4.0f');     NameMonthWeek    = num2str(Mweek,'%02.0f');    NameDayWeek    = num2str(Dweek,'%02.0f');
NameYearWeekAQ  = num2str(YweekAQ,'%4.0f');   NameMonthWeekAQ  = num2str(MweekAQ,'%02.0f');  NameDayWeekAQ  = num2str(DweekAQ,'%02.0f');
NameYearEight   = num2str(Yeight,'%4.0f');    NameMonthEight   = num2str(Meight,'%02.0f');   NameDayEight   = num2str(Deight,'%02.0f');
NameYearEightAQ = num2str(YeightAQ,'%4.0f');  NameMonthEightAQ = num2str(MeightAQ,'%02.0f'); NameDayEightAQ = num2str(DeightAQ,'%02.0f');
NameYearDay     = num2str(Yday,'%4.0f');      NameMonthDay     = num2str(Mday,'%02.0f');     NameDayDay     = num2str(Dday,'%02.0f');
%Tiles to be downloaded
TileName = ['h11v10.006';'h12v09.006'
   'h10v08.006';...
   'h11v08.006';'h12v08.006';'h13v08.006';...
   'h10v09.006';'h13v09.006';...
   'h11v09.006';'h13v10.006';...
   'h10v10.006';'h12v10.006';...
    ];
% K67 tile h12v09  K34:h11v09     
%%%% not working
VersionName  =  '006';
% % BRDF-Albedo Model Parameters 16-Day L3 Global 1km 	MCD43A1
% % BRDF-Albedo Quality 16-Day L3 Global 1km 	MCD43A2
% % Albedo 16-Day L3 Global 1km 	MCD43A3

ProductName  =  ['MOD13Q1';'MCD43A1';'MCD43A2';'MOD09Q1';'MYD09Q1';'MOD11A2';'MOD09A1';'MCD43A3';...
    'MCD43C1';'MOD11C1'];
% MCD43Ax: 500m products  DAILY  MCD43Ax: 1km products 16-DAY
% x: 1 = BRDF/Albedo model parameters, 2 = BRDF/Albedo quality, 3 = Albedo(black-sky and white-sky albedo), and 4 = NBAR (Nadir BRDF Adjusted Reflectance).
% Correspondent server name for each product
% Land Surface Temperature/Emissivity 8-Day L3 Global 0.05Deg CMG 	MOD11C2 	MYD11C2
ServerName  =  ['MOLT';'MOTA';'MOTA';'MOLT';'MOLA';'MOLT';'MOLT';'MOTA';...
    'MOTA';'MOLT'];
[a,b] = size(ProductName);

for in = 2:length(ProductName)     %   1 -2 missing                                                % products
    ProductNameRun = ProductName(in,:);
    CountTile = 2;
    if (strncmp(ProductNameRun,'MOD13Q1',7))||(strncmp(ProductNameRun,'MOD11A2',7))
        CountTile = 3;
    end
    if (strncmp(ProductNameRun,'MOD13Q1',7))|(strncmp(ProductNameRun,'MOD09Q1',7))       % MOD13
        for ik =1:length(weekMODIS)                                                      % the number of years
            GetListFiles = 0;                         FoundStringName = [];
            if GetListFiles == 0
                url  =  ['https://e4ftl01.cr.usgs.gov/' ServerName(in,:) '/' ProductName(in,:) '.' VersionName '/'...
                    NameYearWeek(ik,:) '.' NameMonthWeek(ik,:) '.'...
                    NameDayWeek(ik,:) '/'];
                FileName  =  [FolderMODIS slash ProductName(in,:) slash ProductName(in,:) '.A' NameYearWeek(ik,:)...
                    NameMonthWeek(ik,:) NameDayWeek(ik,:) '.txt'];
                Options  =  weboptions('username',[your username in brakets ''],'password',[your password in brakets ''],...
                    'Timeout',50);
                OutFileName  =  websave(FileName,url,'term',FileName,Options);
               %Reads and finds the compleate name of the file so it can be downloaded
                GetListFiles = 1;
            end
            for im = 1:height(TileName)
                SearchedString  =  [ProductName(in,:) '.A' NameYearWeek(ik,:)...
                    NameWeek(ik,:) '.' TileName(im,:) '.'];
                FID  =  fopen(OutFileName, 'r');
                Data =  textscan(FID, '%s', 'delimiter', '\n', 'whitespace', '');
                CStr =  Data{1};
                fclose(FID);
                [c,d] = size(CStr);
                count = 0;
                for ip = 1:c
                    IndexC  =  strfind(CStr{ip,1}, SearchedString);
                    if ~isempty(IndexC)
                        count = 1+count;                                    % Because the first two files would be jpg
                        if count == CountTile
                            FoundString = CStr{ip,1};
                            FoundStringName = FoundString(IndexC(1):FoundString+37);
                        end
                    end
                end
                % Check if the file is there, if so, skip
                FileName  =  [FolderMODIS slash ProductName(in,:) slash ProductName(in,:) '.A' NameYearWeek(ik,:)...
                    NameWeek(ik,:) '.' TileName(im,:) '.hdf'];
                FileIsThere =  exist(FileName, 'file');
                if FileIsThere == 0
                    url  =  ['https://e4ftl01.cr.usgs.gov/' ServerName(in,:) '/' ProductName(in,:) '.' VersionName '/' NameYearWeek(ik,:) '.' NameMonthWeek(ik,:) '.'...
                        NameDayWeek(ik,:) '/' FoundStringName];
                    options  =  weboptions('username',[your username in brakets ''],'password',[your password in brakets ''],...
                        'Timeout',2000);
                    outfilename  =  websave(FileName,url,options);
                    disp(FileName)
                end
            end
        end
    end
    %AQUA..................................................................
    if (strncmp(ProductNameRun,'MYD09Q1',7)) % MYD13
        % CountTile = 1 for MOD09Q1 before ik = 105, then CountTile = 2
        if (eightMODISaq<datenum(2008,10,20))
            CountTile = 1; 
        else
            CountTile = 2;    
        end
        for ik = 1:length(eightMODISaq)                   % 13 the number of years 667
            GetListFiles = 0;
            if GetListFiles == 0
                url  =  ['https://e4ftl01.cr.usgs.gov/' ServerName(in,:) '/' ProductName(in,:) '.' VersionName '/' NameYearEightAQ(ik,:) '.' NameMonthEightAQ(ik,:) '.'...
                    NameDayEightAQ(ik,:) '/'];
                FileName  =  [FolderMODIS slash ProductName(in,:) slash ProductName(in,:) '.A' NameYearEightAQ(ik,:)...
                    NameMonthEightAQ(ik,:) NameDayEightAQ(ik,:) '.txt'];
                Options  =  weboptions('username',[your username in brakets ''],'password',[your password in brakets ''],...
                    'Timeout',50);
                OutFileName  =  websave(FileName,url,'term',FileName,Options);
                % Reads and finds the compleate name of the file so it can be downloaded
                GetListFiles = 1;
            end
            for im = 1:height(TileName)
                SearchedString  =  [ProductName(in,:) '.A' NameYearEightAQ(ik,:)...
                    NameEightAQ(ik,:) '.' TileName(im,:) '.'];
                FID  =  fopen(OutFileName, 'r');
                Data =  textscan(FID, '%s', 'delimiter', '\n', 'whitespace', '');
                CStr =  Data{1};
                fclose(FID);
                [e,f] = size(CStr);
                count = 0;
                for ip = 1:e
                    IndexC  =  strfind(CStr{ip,1}, SearchedString);
                    if ~isempty(IndexC)
                        count = 1+count;              % Because the first two files would be jpg
                        if count == CountTile
                            FoundString = CStr{ip,1};
                            FoundStringName = FoundString(IndexC(1):FoundString+37);
                        end
                    end
                end
                % Check if the file is there, if so, skip
                FileName  =  [FolderMODIS slash ProductName(in,:) slash ProductName(in,:) '.A' NameYearEightAQ(ik,:)...
                    NameEightAQ(ik,:) '.' TileName(im,:) '.hdf'];
                FileIsThere =  exist(FileName, 'file');
                if FileIsThere == 0
                    url  =  ['https://e4ftl01.cr.usgs.gov/' ServerName(in,:) '/' ProductName(in,:) '.' VersionName '/' NameYearEightAQ(ik,:) '.' NameMonthEightAQ(ik,:) '.'...
                        NameDayEightAQ(ik,:) '/' FoundStringName];
                    options  =  weboptions('username',[your username in brakets ''],'password',[your password in brakets ''],...
                        'Timeout',2000.0);
                    outfilename  =  websave(FileName,url,options);
                    disp (FileName)
                end
            end
        end
    end
    
    %% Eight days...........................................................
    if (strncmp(ProductNameRun,'MCD43A1',7)||strncmp(ProductNameRun,'MCD43A2',7))||...
            (strncmp(ProductNameRun,'MOD11A2',7))||(strncmp(ProductNameRun,'MOD09A1',7))||...
            (strncmp(ProductNameRun,'MCD43A3',7))
        for ik = 1:length(eightMODIS)          % 457 61-71499:the number of years
            GetListFiles = 0;
            if GetListFiles == 0
                url  =  ['https://e4ftl01.cr.usgs.gov/' ServerName(in,:) '/' ProductName(in,:) '.' VersionName '/' NameYearEight(ik,:) '.' NameMonthEight(ik,:) '.'...
                    NameDayEight(ik,:) '/'];
                FileName  =  [FolderMODIS slash ProductName(in,:) slash ProductName(in,:) '.A' NameYearEight(ik,:)...
                    NameEight(ik,:) '.txt'];
                Options  =  weboptions('username',[your username in brakets ''],'password',[your password in brakets ''],...
                    'Timeout',2000.0);
                OutFileName  =  websave(FileName,url,'term',FileName,Options);
                % Reads and finds the compleate name of the file so it can be downloaded
                GetListFiles = 1;
            end
            for im = 1:height(TileName)
                SearchedString  =  [ProductName(in,:) '.A' NameYearEight(ik,:)...
                    NameEight(ik,:) '.' TileName(im,:) '.'];
                FID  =  fopen(OutFileName, 'r');
                Data =  textscan(FID, '%s', 'delimiter', '\n', 'whitespace', '');
                CStr =  Data{1};
                fclose(FID);
                [g,h] = size(CStr);
                count = 0;
                for ip = 1:g
                    IndexC  =  strfind(CStr{ip,1}, SearchedString);
                    if ~isempty(IndexC)
                        count = 1+count;              % Because the first two files would be jpg
                        if (strncmp(ProductNameRun,'MCD43A1',7))
                            if count == CountTile
                                FoundString = CStr{ip,1};
                                FoundStringName = FoundString(IndexC(1):FoundString+37);
                            end
                        elseif (strncmp(ProductNameRun,'MCD43A2',7))
                            if count == 1
                                FoundString      =  CStr{ip,1};
                                FoundStringName  =  FoundString(IndexC(1):FoundString+37);
                            end
                        elseif (strncmp(ProductNameRun,'MOD11A2',7))
                            if count == CountTile
                                FoundString      =  CStr{ip,1};
                                FoundStringName  =  FoundString(IndexC(1):FoundString+37);
                            end
                        elseif (strncmp(ProductNameRun,'MOD09A1',7))
                            if count == CountTile
                                FoundString      =  CStr{ip,1};
                                FoundStringName  =  FoundString(IndexC(1):FoundString+37);
                            end
                        elseif (strncmp(ProductNameRun,'MCD43A3',7))
                            if count == CountTile
                                FoundString      =  CStr{ip,1};
                                FoundStringName  =  FoundString(IndexC(1):FoundString+37);
                            end
                        elseif (strncmp(ProductNameRun,'MCD43C1',7))
                            if count == CountTile
                                FoundString      =  CStr{ip,1};
                                FoundStringName  =  FoundString(IndexC(1):FoundString+37);
                            end
                        end
                    end
                end
                % Check if the file is there, if so, skip
                FileName  =  [FolderMODIS slash ProductName(in,:) slash ProductName(in,:) '.A' NameYearEight(ik,:)...
                    NameEight(ik,:) '.' TileName(im,:) '.hdf'];
                FileIsThere =  exist(FileName, 'file');
                if FileIsThere == 0
                    url  =  ['https://e4ftl01.cr.usgs.gov/' ServerName(in,:) slash ProductName(in,:) '.' VersionName '/' NameYearEight(ik,:) '.' NameMonthEight(ik,:) '.'...
                        NameDayEight(ik,:) '/' FoundStringName];
                    options  =  weboptions('username',[your username in brakets ''],'password',[your password in brakets ''],...
                        'Timeout',2000.0);
                    outfilename  =  websave(FileName,url,options);
                    disp(FileName)
                end
            end
        end
    end
    
    %     MCD43C1.A2000055.006.2016190163656.hdf
    % Daily................................................................
    if (strncmp(ProductNameRun,'MCD43C1',7))||(strncmp(ProductNameRun,'MOD11C1',7))
        for ik = 502:length(dayMODIS)          %  2493 4632 5068 6435 6886:the number of days
            GetListFiles = 0;
            if GetListFiles == 0
                url  =  ['https://e4ftl01.cr.usgs.gov/' ServerName(in,:) '/' ProductName(in,:) '.' VersionName '/' NameYearDay(ik,:) '.' NameMonthDay(ik,:) '.'...
                    NameDayDay(ik,:) '/'];
                FileName  =  [FolderMODIS slash ProductName(in,:) slash ProductName(in,:) '.A' NameYearDay(ik,:)...
                    NameDayDay(ik,:) '.txt'];
                Options  =  weboptions('username',[your username in brakets ''],'password',[your password in brakets ''],...
                    'Timeout',100);
                OutFileName  =  websave(FileName,url,'term',FileName,Options);
                % Reads and finds the compleate name of the file so it can be downloaded
                GetListFiles = 1;
            end
            %             for im = 1:height(TileName) only one global file
            SearchedString  =  [ProductName(in,:) '.A' NameYearDay(ik,:)...
                NameDay(ik,:) '.006.'];
            FID  =  fopen(OutFileName, 'r');
            Data =  textscan(FID, '%s', 'delimiter', '\n', 'whitespace', '');
            CStr =  Data{1};
            fclose(FID);
            [g,h] = size(CStr);
            count = 0;
            for ip = 1:g
                IndexC  =  strfind(CStr{ip,1}, SearchedString);
                if ~isempty(IndexC)
                    count = 1+count;              % Because the first two files would be jpg
                    if (strncmp(ProductNameRun,'MCD43C1',7))
                        if count == CountTile
                            FoundString = CStr{ip,1};
                            FoundStringName = FoundString(IndexC(1):FoundString+30);
                        end
                    elseif (strncmp(ProductNameRun,'MOD11C1',7))
                        if count == CountTile
                            FoundString = CStr{ip,1};
                            FoundStringName = FoundString(IndexC(1):FoundString+32);
                        end
                    end
                end
            end
            % Check if the file is there, if so, skip
            FileName  =  [FolderMODIS slash ProductName(in,:) slash ProductName(in,:) '.A' NameYearDay(ik,:)...
                NameDay(ik,:) '.hdf'];
            FileIsThere =  exist(FileName, 'file');
            if FileIsThere == 0
                url  =  ['https://e4ftl01.cr.usgs.gov/' ServerName(in,:) slash ProductName(in,:) '.' VersionName '/' NameYearDay(ik,:) '.' NameMonthDay(ik,:) '.'...
                    NameDayDay(ik,:) '/' FoundStringName ];%'.hdf'
                options  =  weboptions('username',[your username in brakets ''],'password',[your password in brakets ''],...
                    'Timeout',500);
                outfilename  =  websave(FileName,url,options);
                disp(FileName)
            end
            %             end
        end
    end
end
