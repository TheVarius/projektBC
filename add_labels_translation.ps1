# Skrypt add_labels_translation.ps1
# Automatyzuje dodawanie nowych, brakujących tłumaczeń etykiet i komunikatów błędów do pliku .xlf (XLIFF).
# Rozwiązuje problem ręcznego edytowania pliku tłumaczeń po wygenerowaniu go z poziomu kompilatora AL.
$pl_path = "c:\Users\Adam\Desktop\jasjsaj\projektBC\Translations\projekt.pl.xlf"
[xml]$pl = Get-Content -Raw $pl_path
$ns = New-Object System.Xml.XmlNamespaceManager($pl.NameTable)
$ns.AddNamespace("x", "urn:oasis:names:tc:xliff:document:1.2")

$group = $pl.SelectSingleNode("//x:group[@id='body']", $ns)

$labels = @(
    @{
        id = "Table 2143111931 - NamedType 240229828"
        source = "Only Planning or Cancelled registrations can be deleted."
        target = "Tylko rejestracje o statusie Planowane lub Anulowane mogą być usunięte."
        note = "Table Seminar Registration Header - NamedType DeleteStatusErr"
    },
    @{
        id = "Table 2143111931 - NamedType 430254759"
        source = "Changing registration number is not allowed."
        target = "Zmiana numeru rejestracji jest niedozwolona."
        note = "Table Seminar Registration Header - NamedType RenameErr"
    },
    @{
        id = "Table 2143111931 - NamedType 2856695092"
        source = "Room capacity is lower than maximum seminar participants."
        target = "Pojemność sali jest mniejsza niż maksymalna liczba uczestników szkolenia."
        note = "Table Seminar Registration Header - NamedType RoomCapacityWarnMsg"
    },
    @{
        id = "Table 2143111931 - NamedType 3882435575"
        source = "Seminar with registered lines cannot be modified."
        target = "Szkolenie z zarejestrowanymi wierszami nie może być modyfikowane."
        note = "Table Seminar Registration Header - NamedType SeminarWithRegisteredLinesModifyErr"
    },
    @{
        id = "Table 2143111931 - NamedType 720642727"
        source = "Starting Date can only be changed for Planning status."
        target = "Data początkowa może być zmieniona tylko dla statusu Planowane."
        note = "Table Seminar Registration Header - NamedType StartingDateStatusErr"
    },
    @{
        id = "Table 2143111931 - NamedType 3091254118"
        source = "Do you want to update seminar price on all unregistered lines?"
        target = "Czy chcesz zaktualizować cenę szkolenia we wszystkich niezarejestrowanych wierszach?"
        note = "Table Seminar Registration Header - NamedType UpdateLinesQst"
    },
    @{
        id = "Table 2235904756 - NamedType 4122121529"
        source = "Bill-to Customer No. can only be changed for unregistered lines."
        target = "Nr odbiorcy faktury może być zmieniony tylko dla niezarejestrowanych wierszy."
        note = "Table Seminar Registration Line - NamedType ChangeCustomerErr"
    },
    @{
        id = "Table 2235904756 - NamedType 2922829552"
        source = "Registered lines cannot be deleted."
        target = "Zarejestrowane wiersze nie mogą być usunięte."
        note = "Table Seminar Registration Line - NamedType DeleteRegisteredErr"
    },
    @{
        id = "Table 4239863583 - Field 4287340734 - Property 62802879"
        source = "Worker,Subcontractor"
        target = "Pracownik,Podwykonawca"
        note = "Table Instructor - Field Worker/Subcontractor - Property OptionCaption"
    },
    @{
        id = "Table 2143111931 - Field 513339096 - Property 62802879"
        source = "Planning,Registration,Finished,Cancelled"
        target = "Planowane,Rejestracja,Zakończone,Anulowane"
        note = "Table Seminar Registration Header - Field Status - Property OptionCaption"
    }
)

foreach ($l in $labels) {
    # Check if the id is already in the document to prevent duplicates
    $existing = $pl.SelectSingleNode("//x:trans-unit[@id=""$($l.id)""]", $ns)
    if ($existing -eq $null) {
        $tu = $pl.CreateElement("trans-unit", "urn:oasis:names:tc:xliff:document:1.2")
        $tu.SetAttribute("id", $l.id)
        $tu.SetAttribute("size-unit", "char")
        $tu.SetAttribute("translate", "yes")
        $tu.SetAttribute("xml:space", "preserve")
        
        $src = $pl.CreateElement("source", "urn:oasis:names:tc:xliff:document:1.2")
        $src.InnerText = $l.source
        [void]$tu.AppendChild($src)
        
        $tgt = $pl.CreateElement("target", "urn:oasis:names:tc:xliff:document:1.2")
        $tgt.InnerText = $l.target
        [void]$tu.AppendChild($tgt)
        
        $n1 = $pl.CreateElement("note", "urn:oasis:names:tc:xliff:document:1.2")
        $n1.SetAttribute("from", "Developer")
        $n1.SetAttribute("annotates", "general")
        $n1.SetAttribute("priority", "2")
        [void]$tu.AppendChild($n1)
        
        $n2 = $pl.CreateElement("note", "urn:oasis:names:tc:xliff:document:1.2")
        $n2.SetAttribute("from", "Xliff Generator")
        $n2.SetAttribute("annotates", "general")
        $n2.SetAttribute("priority", "3")
        $n2.InnerText = $l.note
        [void]$tu.AppendChild($n2)
        
        [void]$group.AppendChild($tu)
    }
}

$pl.Save($pl_path)
Write-Host "SUCCESS"
