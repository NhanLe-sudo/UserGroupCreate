# Make a function named UserGroupCreate to store each input and cmdlets 

function UserGroupCreate {

    # Assign variable le000173_usr for user to input local host

    $le000173_usr = Read-Host "Please Enter name of local host: "

    # Assign variable Password for user to input an encrypted password 

    $Password = Read-Host -AsSecureString 

    # Assign variable le000173_grp for user to input of new local group

    $le000173_grp = Read-Host "Please enter name of group: "

    # create variables localuser and localgroup to store cmdlets that looks for prompted names

    $localuser = Get-LocalUser $le000173_usr 2> $null

    $localgroup = Get-LocalGroup $le000173_grp 2> $null

    # Conditonal statement indicates that if username already exists in localgroup, which is true, then inform user it already exists

    if ($le000173_usr -eq $localuser){

        Write-Host "$le000173_usr already exists!"   

    }else { 

        New-LocalUser -Name $le000173_usr -Description "User Example" -Password $Password 2> $null

        Write-Host "$le000173_usr was created !"
    
    }

    # If statement that checks group name already exists 

    if ($le000173_grp -eq $localgroup){

        Write-Host "$le000173_grp already exists!"

    }else {
    
        New-LocalGroup -Name $le000173_grp -Description "Local Group Example" 2> $null

        Write-Host "$le000173_grp was created !"

    }

    

    if ($localgroup -contains $localuser 2> $null) {
        
        Write-Host "$le000173_usr is already in the group !"
       
    }else {

        Add-LocalGroupMember -Group $le000173_grp -Member $le000173_usr 2> $null

    }

    $HOMEDIR = "C" + ":\$le000173_usr"

    New-Item -PATH $HOMEDIR -ItemType Directory 2> $null

    if (-not (Test-Path -LiteralPath C:\$le000173_usr)){

        Write-Host "Creating folder $le000173_usr in local disk"

    }else {

        Write-Host "Folder $le000173_usr already exists !"

     }
   

    $Shared_Drive = Read-Host "Please assign a drive letter for shared drive: "

    $Share_exists = Get-SmbShare "$le000173_usr-Share" 2> $null

    $Drive_exists = Get-PSDrive $Shared_Drive 2> $null


    if ($Share_exists -eq $Shared_Drive){

        Write-Host "Share already exists"

    }else {
    
        $SHARE = New-SmbShare -Name "$le000173_usr-Share" -Path $HOMEDIR 2> $null

    } 


    if ($Drive_exists -eq $Shared_Drive){

        Write-Host "Drive $Shared_Drive already exists"

    }else {

        New-PSDrive -Name $Shared_Drive -PSProvider FileSystem -Root "C:\David" -Description "Mapped Local Drive Example"

        Write-Host "Created shared folder in Drive $Shared_Drive" 

    }


    # Creates a new powershell script
    <#

    $comments1 = "Hi there"

    $comments2 = "First PowerShell script"
    
    $comments3 = "Not too bad"
    #>

    "Write-Output ""Hi there"""  | Add-Content "$HOMEDIR\$le000173_usr.ps1"

    Write-Output "First PowerShell script" | Add-Content "$HOMEDIR\$le000173_usr.ps1"

    Write-Output "Not too bad" | Add-Content "$HOMEDIR\$le000173_usr.ps1"

    New-PSDrive -Name "T" -PSProvider FileSystem -Root "C:\David" -Description "Mapped Local Drive Example" > "$HOMEDIR\$le000173_usr.ps1"

}

UserGroupCreate

