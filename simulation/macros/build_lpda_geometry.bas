'#Language "Wwb-COM"

Sub Main
    Dim i As Integer

    ' Fixe les unites globales pour eviter les distorsions geometriques
    Units.Geometry "mm"
    Units.Frequency "ghz"
    Units.Time "ns"

    ' ----------------------------------------------------
    ' 1. INJECTION DE TOUS LES PARAMÈTRES DANS LA "PARAMETER LIST"
    ' ----------------------------------------------------
    StoreParameter "w_boom", 2.4
    StoreParameter "feed_gap", 1.5
    StoreParameter "H_sub", 1.6

    ' Injection des 16 Longueurs des dipoles (L_1 a L_16)
    StoreParameter "L_1", 115.11: StoreParameter "L_2", 101.30: StoreParameter "L_3", 89.14:  StoreParameter "L_4", 78.44
    StoreParameter "L_5", 69.03:  StoreParameter "L_6", 60.75:  StoreParameter "L_7", 53.46:  StoreParameter "L_8", 47.04
    StoreParameter "L_9", 41.40:  StoreParameter "L_10", 36.43: StoreParameter "L_11", 32.06: StoreParameter "L_12", 28.21
    StoreParameter "L_13", 24.83: StoreParameter "L_14", 21.85: StoreParameter "L_15", 19.23: StoreParameter "L_16", 16.92

    ' Injection des 15 Espacements (R_1 a R_15)
    StoreParameter "R_1", 34.53: StoreParameter "R_2", 30.39: StoreParameter "R_3", 26.74: StoreParameter "R_4", 23.53
    StoreParameter "R_5", 20.71: StoreParameter "R_6", 18.22: StoreParameter "R_7", 16.04: StoreParameter "R_8", 14.11
    StoreParameter "R_9", 12.42: StoreParameter "R_10", 10.93: StoreParameter "R_11", 9.62: StoreParameter "R_12", 8.46
    StoreParameter "R_13", 7.45: StoreParameter "R_14", 6.55: StoreParameter "R_15", 5.77

    ' Injection des 16 Largeurs de pistes des dipoles (W_1 a W_16)
    For i = 1 To 16
        StoreParameter "W_" & CStr(i), Evaluate("L_" & CStr(i)) * 0.025
    Next i

    Rebuild

    ' ----------------------------------------------------
    ' 2. CREATION DU SUBSTRAT DIELECTRIQUE FR4
    ' ----------------------------------------------------
    With Material
        .Name "FR4_Dielectric"
        .Folder ""
        .Type "Normal"
        .Epsilon "4.3"
        .Mue "1.0"
        .Sigma "0.0"
        .Colour "0.2", "0.6", "0.2"
        .Wireframe "False"
        .Reflection "False"
        .Create
    End With

    Component.New "Substrate"
    With Brick
        .Name "PCB_Board"
        .Component "Substrate"
        .Material "FR4_Dielectric"
        .Xrange "-100", "100"
        .Yrange "-135", "135"
        .Zrange "0.0", "H_sub"
        .Create
    End With

    ' ----------------------------------------------------
    ' 3. DEFINITION DU COMPOSANT POUR LES METAUX (PEC)
    ' ----------------------------------------------------
    Component.New "Antenna_Elements"

    ' ----------------------------------------------------
    ' 4. BOUCLE DE DESSIN STRUCTURELLE ET RETOUR CHRONOLOGIQUE
    ' ----------------------------------------------------
    ' Pour forcer CST a garder la géométrie, on génère l'antenne par empilement textuel
    ' de formules de l'arbre d'historique (History List)
    Dim YFormula As String
    YFormula = "135.0 - feed_gap - (W_16/2) - 245.47" ' Position de l'élément 1

    For i = 1 To 16
        ' --- ALTERNANCE DES COUCHES ---
        If (i Mod 2 = 1) Then
            With Brick
                .Name "Element_" & CStr(i) & "_Top_Right"
                .Component "Antenna_Elements"
                .Material "PEC"
                .Xrange "0.0", "L_" & CStr(i) & "/2"
                .Yrange YFormula & " - (W_" & CStr(i) & "/2)", YFormula & " + (W_" & CStr(i) & "/2)"
                .Zrange "H_sub", "H_sub + 0.035"
                .Create
            End With
            With Brick
                .Name "Element_" & CStr(i) & "_Bottom_Left"
                .Component "Antenna_Elements"
                .Material "PEC"
                .Xrange "-L_" & CStr(i) & "/2", "0.0"
                .Yrange YFormula & " - (W_" & CStr(i) & "/2)", YFormula & " + (W_" & CStr(i) & "/2)"
                .Zrange "-0.035", "0.0"
                .Create
            End With
        Else
            With Brick
                .Name "Element_" & CStr(i) & "_Top_Left"
                .Component "Antenna_Elements"
                .Material "PEC"
                .Xrange "-L_" & CStr(i) & "/2", "0.0"
                .Yrange YFormula & " - (W_" & CStr(i) & "/2)", YFormula & " + (W_" & CStr(i) & "/2)"
                .Zrange "H_sub", "H_sub + 0.035"
                .Create
            End With
            With Brick
                .Name "Element_" & CStr(i) & "_Bottom_Right"
                .Component "Antenna_Elements"
                .Material "PEC"
                .Xrange "0.0", "L_" & CStr(i) & "/2"
                .Yrange YFormula & " - (W_" & CStr(i) & "/2)", YFormula & " + (W_" & CStr(i) & "/2)"
                .Zrange "-0.035", "0.0"
                .Create
            End With
        End If

        ' Ajoute l'espacement parametrique au texte de formule pour le prochain element
        If i < 16 Then
            YFormula = YFormula & " + R_" & CStr(i)
        End If
    Next i

    ' ----------------------------------------------------
    ' 5. DESSIN DES TRONCS DYNAMIQUES FIXÉS À Y = 135
    ' ----------------------------------------------------
    With Brick
        .Name "Boom_Top"
        .Component "Antenna_Elements"
        .Material "PEC"
        .Xrange "-w_boom/2", "w_boom/2"
        .Yrange "135.0 - feed_gap - (W_16/2) - 245.47 - (W_1/2)", "135.0"
        .Zrange "H_sub", "H_sub + 0.035"
        .Create
    End With

    With Brick
        .Name "Boom_Bottom"
        .Component "Antenna_Elements"
        .Material "PEC"
        .Xrange "-w_boom/2", "w_boom/2"
        .Yrange "135.0 - feed_gap - (W_16/2) - 245.47 - (W_1/2)", "135.0"
        .Zrange "-0.035", "0.0"
        .Create
    End With

End Sub
