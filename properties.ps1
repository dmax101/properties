$User = ''

Function Get-Informa {
    Param ($User)
    
    $OUser = Get-ADUser $User -properties * 

        $Dia = $OUser.createTimeStamp.Date.Day
        $Mes = $OUser.createTimeStamp.Date.Month
        $Ano = $OUser.createTimeStamp.Date.Year
        
        Write-Host "Nome: ", $OUser.name -ForegroundColor Cyan
        Write-Host "Função: ", $OUser.Description
        Write-Host "Login: ", $OUser.SamAccountName
        Write-Host "E-mail: ", $OUser.EmailAddress
        Write-Host "Criado em: ", $Dia"/"$Mes"/"$Ano
        Write-Host "Setor: ", $OUser.physicalDeliveryOfficeName
        Write-Host "Ramal: ", $OUser.pager -ForegroundColor Cyan
        Write-Host "Telefone: ", $OUser.OfficePhone
        Write-Host "Último Login Mal-sucedido: ", $OUser.LastBadPasswordAttempt
        If($OUser.LockedOut -eq 0) {
            Write-Host "A conta está desbloqueada!" -ForegroundColor Green
        } Else {
            $OP = Read-Host -Prompt 'Conta bloqueada! Deseja desbloquear? [0] Sim | [1] Não'
            switch ($OP) {
                0 {
                    Unlock-ADAccount -Identity $OUser.SamAccountName
                    Write-Host "Conta desbloqueada com sucesso" -ForegroundColor Green
                }
                1 {
                    Write-Host "Conta bloqueada!" -ForegroundColor Red
                }
            }
        }
        $OP = Read-Host -Prompt 'Listar informações completas? [0] Sim | [1] Não'
            If ($OP -eq 0) {
                ADUser $User -Properties *
            }
}

Do {


    Write-Host "---------------------------------------"
	$User = Read-Host -Prompt 'Insira o nome de usuário ou 0 para sair ou 1 para contas bloqueadas'
    Write-Host "---------------------------------------"
    
    If ($User -eq 0) {

        Write-Host 'Programa encerrado' -ForegroundColor Yellow
        cmd /c pause;
        cls

    } ElseIf ($User -eq 1) {
        
        Search-ADAccount -lockedout | Select-Object Name, SamAccountName
        cmd /c pause;
        cls

    } Else {

        try { 
            Get-ADUser -Identity $User | Out-Null 
            Write-Host "O usuário $user foi encontrado!" -ForegroundColor Green
            Write-Host "---------------------------------------"

            Get-Informa $User

        } catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            Write-Host "O usuário $User Não foi encontrado!" -ForegroundColor Red 
        } catch { 
            Write-Output "Something else bad happend" 
        } 

            
    cmd /c pause;
    Clear-Variable $OUser
    cls

    }

} While($User -ne 0)