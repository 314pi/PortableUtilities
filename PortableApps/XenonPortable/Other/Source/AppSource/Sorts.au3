;=============================================================================
;
; Function Name:	_Sort_Cocktail()
;
; Description:		Performs a cocktail sort on the given array.
;
; Syntax:			_Sort_Cocktail(ByRef $aValues, Const $bSkipFirst = False)
;
; Parameter(s):		$aValues = Array of values to be sorted.
;					$bSkipFirst = (Optional) Skip the first element of the array if it not part of the values to be sorted.
;
; Requirement(s):	External:   = None.
;					Internal:   = None.
;
; Return Value(s):	On Success: = Returns True and the array will be sorted.
;					On Failure: = Sets @Error and returns False.
;					@ERROR:     = 0 = No error.
;                                1 = The first parameter is not actually an array.
;                                2 = The first parameter is an array, but has more than one dimension.
;								 3 = The second paramenter is not boolean.
;
; Author(s):		"Nutster" David Nuttall <danuttall at rocketmail dot com>
;
; Notes:			- If the array stores the number of elements in element 0, set the second parameter to True.
;				   	- All the values in the array should be the same internal type.  Inconsistant
;					conversion from string to numerics can occur, causing unexpected orderings.
;					- The cocktail sort is based on a bubble sort, but sorts in one direction and then the
;					other on each pass.  This tends to move heavy and light elements into their positions
; 					faster than a straight bubble sort.  The name comes from shaking a cocktail back and forth
;					during its preparation.
;
; Example(s):
;   Local $aNums[100], $I, $sMsg
;
;   For $I = 0 To 99
;      $aNums[$I] = Random(1, 1000, True)
;   Next
;   _Sort_Cocktail($aNums)
;   $sMsg = $aNums[0]
;   For $I = 1 To 99
;      $sMsg &= ", " & $aNums[$I]
;   Next
;   MsgBox(48, "Sort Test", $sMsg)
;
;=============================================================================
Func _Sort_Cocktail(ByRef $aValues, Const $bSkipFirst = False)
	If Not IsArray($aValues) Then ;Make sure that it is an array
		SetError(1)
		Return False
	ElseIf UBound($aValues, 0) <> 1 Then ;Make sure that it is single dimensioned
		SetError(2)
		Return False
	ElseIf Not IsBool($bSkipFirst) Then
		SetError(3)
		Return False
	EndIf
	; Passed all those tests
	; Actual Cocktail sort
	Local $I
	Local $nStart = 0, $nLow, $nHigh = UBound($aValues) - 1, $nLastSwap

	If $bSkipFirst Then $nStart = 1
	$nLow = $nStart
	
	Do
		$nLastSwap = -1
		For $I = $nLow To $nHigh - 1
			If $aValues[$I] > $aValues[$I + 1] Then
				Swap($aValues[$I], $aValues[$I + 1])
				$nLastSwap = $I
			EndIf
		Next
		If $nLastSwap > 0 Then
			$nHigh = $nLastSwap
			$nLastSwap = -1
			For $I = $nHigh - 1 To $nLow Step - 1
				If $aValues[$I] > $aValues[$I + 1] Then
					Swap($aValues[$I], $aValues[$I + 1])
					$nLastSwap = $I
				EndIf
			Next
			$nLow = $nLastSwap
		EndIf
	Until $nLastSwap < 0
	Return True
EndFunc   ;==>_Sort_Cocktail

Func Swap(ByRef $vA, ByRef $vB)
	Local $T = $vA
	$vA = $vB
	$vB = $T
EndFunc   ;==>Swap