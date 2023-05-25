%% Reads the BRDF files calculates the reflectance for SZA = 15 deg and observer at zenit
% Calculates the mean value for the 8-day composit (46 periods)
% mex ambralsfor.c
% mex -largeArrayDims one_ref_mod.c -I"C:\gsl-1.16" -L"C:\gsl-1.16\lib\x64\Release"
flag_unix = 0;

if flag_unix==1
    slash='\';
    addpath \Users\ncoupe\Documents\OZ\
    addpath \Users\ncoupe\Documents\Amazon\
elseif flag_unix==0
    slash='/';
    addpath /home/ncoupe/Documents/OZ/;
    addpath /home/ncoupe/Documents/Amazon/;
    FolderMODIS = '/media/ncoupe/seagate/Data/AmazonRS/MODIS';
end
%..........................................................................
%%.........................................................................
%Years to be downloaded
yearMODIS = (2000:2018)';

eight = (1:8:365)';

eightMODIS = [];                  NameEight = [];       weekMODISaq = [];
eightMODISaq = [];                NameEightAQ = [];
for ik = 1:length(yearMODIS)
    eightMODIS = [eightMODIS;datenum(yearMODIS(ik),1,(1:8:365)')];
    NameEight = [NameEight;num2str((1:8:365)','%03.0f')];
    eightMODISaq = [eightMODISaq;datenum(yearMODIS(ik),1,(1:8:365)')];
    NameEightAQ = [NameEightAQ;num2str((1:8:365)','%03.0f')];
end

ind = find(eightMODIS<datenum(2000,2,23));    NameEight(ind,:)   = [];   eightMODIS(ind,:)   = [];
ind = find(eightMODISaq<datenum(2002,7,4));   NameEightAQ(ind,:) = [];   eightMODISaq(ind,:) = [];
[Yeight,Meight,Deight]    = datevec(eightMODIS);
[YeightAQ,MeightAQ,DeightAQ] = datevec(eightMODISaq);
NameYearEight   = num2str(Yeight,'%4.0f');    NameMonthEight   = num2str(Meight,'%02.0f');   NameDayEight   = num2str(Deight,'%02.0f');
NameYearEightAQ = num2str(YeightAQ,'%4.0f');  NameMonthEightAQ = num2str(MeightAQ,'%02.0f'); NameDayEightAQ = num2str(DeightAQ,'%02.0f');
%Tiles to be downloaded
TileName = ['h10v08.006';'h11v08.006';'h12v08.006';'h13v08.006';...
    'h10v09.006';'h11v09.006';'h12v09.006';'h13v09.006';...
    'h10v10.006';'h11v10.006';'h12v10.006';'h13v10.006'];
VersionName  =  '006';
ProductName  =  ['MOD13Q1';'MCD43A1';'MCD43A2';'MOD09Q1';'MYD09Q1';'MOD11A2';'MOD09A1'];
% MCD43Ax: 500m products    MCD43Bx: 1km products
% x: 1 = BRDF/Albedo model parameters, 2 = BRDF/Albedo quality, 3 = Albedo(black-sky and white-sky albedo), and 4 = NBAR (Nadir BRDF Adjusted Reflectance).
% Correspondent server name for each product
ServerName  =  ['MOLT';'MOTA';'MOTA';'MOLT';'MOLA';'MOLT';'MOLT'];
[a,b] = size(ProductName);

% MCD43A1b1redTMP = NaN(1,1,1); MCD43A1b2nirTMP = NaN(1,1,1); MCD43A1b3blueTMP = NaN(1,1,1);
iq = 2;                                            % product
ProductNameRun = ProductName(iq,:);

% load('matlab_h12v10.mat')
Counter = 1;
for in = 1:length(TileName)
    %% Band number..........................................................
    for ir = 1:3            %1:3
        % Eight days...........................................................
        for ip = 35:length(eight)
            NameEight = [num2str(eight(ip),'%03.0f')];
            if (ir==1)&(ip==1);     MCD43A1sza15 = [];  end
            
            for im = 1:length(yearMODIS)
                
                NameYearEight = yearMODIS(im);
                
                FileName  =  [FolderMODIS slash ProductNameRun slash ProductNameRun '.A' num2str(NameYearEight)...
                    NameEight '.' TileName(in,:) '.hdf'];
                
                MODdateloc = datenum(NameYearEight,1,str2double(NameEight));
                if ((MODdateloc>datenum(2000,1,56))&&(MODdateloc<datenum(2018,11,11)))
                    % ........................................................................
                    % ........................................................................
                    % Band1  (620-670 nm) Red
                    FieldName = ['BRDF_Albedo_Parameters_Band' num2str(ir)];
                    BRDF_Albedo_Parameters_Band = hdfread(FileName,...
                        'MOD_Grid_BRDF', 'Fields', FieldName);
                    BRDF_Albedo_Parameters_Band = single(BRDF_Albedo_Parameters_Band);
                    BRDF_Albedo_Parameters_Band(BRDF_Albedo_Parameters_Band==32767) = NaN;
                    BRDF_Albedo_Parameters_Band(BRDF_Albedo_Parameters_Band==0) = NaN;
                    % Band2  (841-876 nm) NIR
                    % Band3  (459-479 nm) Blue
                    Counter = Counter+1;
                    if Counter == 1
                        [c,d] = size(BRDF_Albedo_Parameters_Band(:,:,1));
                        MCD43A1tmp  = NaN(c,d,length(yearMODIS));
                    end
                    
                    %% QA......................................................................
                    FieldName=['BRDF_Albedo_Band_Mandatory_Quality_Band' num2str(ir)];
                    BRDF_Albedo_Band_Mandatory_Quality_Band = hdfread(FileName,...
                        'MOD_Grid_BRDF', 'Fields', FieldName);
                    BRDF_Albedo_Band_Mandatory_Quality_Band = cast(uint8(BRDF_Albedo_Band_Mandatory_Quality_Band),'single');
                    BRDF_Albedo_Band_Mandatory_Quality_Band(BRDF_Albedo_Band_Mandatory_Quality_Band==255) = NaN;
                    BRDF_Albedo_Band_Mandatory_Quality_Band(BRDF_Albedo_Band_Mandatory_Quality_Band==1) = NaN;
                    BRDF_Albedo_Band_Mandatory_Quality_Band(BRDF_Albedo_Band_Mandatory_Quality_Band==0) = 1;
                    % % class(BRDF_Albedo_Band_Mandatory_Quality_Band(1,1));
                    % % *Mandatory QA bit index:
                    % % 0 = processed, good quality (full BRDF inversions)
                    % % 1 = processed, see other QA (magnitude BRDF inversions)
                    % % 255 = Fill Value
                    
                    BRDF_Albedo_Parameters_Band=BRDF_Albedo_Parameters_Band.*BRDF_Albedo_Band_Mandatory_Quality_Band;
                    
                    %% Initialize matrices.....................................................
                    [c,d,e] = size(BRDF_Albedo_Parameters_Band);
                    TMPband  = NaN(c,d);
                    for ij=1:c
                        for ik = 1:d
                            geom.szen=15.0;
                            geom.vzen=0.0;
                            geom.relaz=0.0;
                            
                            %         params.iso=0.12089;
                            %         params.vol=0.0;
                            %         params.geo=0.063989;
                            
                            params.iso = (BRDF_Albedo_Parameters_Band(ij,ik,1)).*0.001;
                            params.vol = (BRDF_Albedo_Parameters_Band(ij,ik,2)).*0.001;
                            params.geo = (BRDF_Albedo_Parameters_Band(ij,ik,3)).*0.001;
                            if ((~isnan(params.vol))&&(~isnan(params.iso))&&(~isnan(params.geo)))
                                TMPband(ij,ik) = ambralstrans(geom,params);
                            end
                        end
                    end
                    
                    % ........................................................................
                    MCD43A1tmp(:,:,im)  = TMPband;
                end
            end
            clear ('BRDF_Albedo_Band_Mandatory_Quality_Band','BRDF_Albedo_Parameters_Band')
            [c,d,e] = size(MCD43A1tmp);
            % .........................................................................
            %% Clean...................................................................
            for ij=1:c
                for ik = 1:d
                    TMPband = MCD43A1tmp(ij,ik,:);
                    TMPband = reshape(TMPband,[e,1]);
                    MCD43A1tmp(ij,ik,:)  = AM_rm_outlier(TMPband,2);
                end
            end
            display (['week:' num2str(ip) ' band:' num2str(ir) ' tile:' TileName(in,:)])
            
            %% Back to eigth...............................................
            TMPband = nanmean(MCD43A1tmp,3);
            MCD43A1sza15.mean(:,:,ip) = uint16(TMPband.*1000);
            TMPband = nanstd(MCD43A1tmp,[],3);
            MCD43A1sza15.std(:,:,ip)  = uint16(TMPband.*1000);
            TMPband = nanmax(MCD43A1tmp,[],3);
            % %         MCD43A1sza15.max(:,:,ip)  = uint16(TMPband);
            % %         display (['week:' num2str(ip) ' band:' num2str(ir) ' tile:' TileName(in,:)])
            
            ProductName = ['MCD43A1sza15_' TileName(in,1:end-4) '_Band' num2str(ir)];
            assignin ('base',ProductName,MCD43A1sza15);
            clear ('MCD43A1tmp')
            %             pack;
            
            ProductName = ['matlab_' TileName(in,1:end-4) '.mat'];
            VariableName = ['MCD43A1sza15_' TileName(in,1:end-4) '*'];
            save(ProductName,VariableName,'-v7.3');
            %              save('matlab.mat','*','-v7.3');
        end
    end
    ProductName = ['matlab_' TileName(in,1:end-4) '.mat'];
    VariableName = ['MCD43A1sza15_' TileName(in,1:end-4) '*'];
    save(ProductName,VariableName,'-v7.3');
end
