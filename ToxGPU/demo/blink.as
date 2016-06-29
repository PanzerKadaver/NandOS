int main(uint argc, vector<var> &in argv) {
	
	GPUHandler myGPU;
	
	myGPU.Open();
	myGPU.PowerOff();
	
	myGPU.SetDisplayMod(Display_Mode_Text);
	myGPU.CharacterClear();
	
	myGPU.PowerOn(1);	
	myGPU.ColorBlink(1, Display_TextBackground_Black, Display_TextBackground_LightBlue, 250000, 3);
	
	vector<int> navigationPanels = {2, 3, 4};
	myGPU.PowerOn(navigationPanels);
	myGPU.ColorBlink(navigationPanels, Display_TextBackground_Black, Display_TextBackground_LightBlue, 250000, 3);
	
	myGPU.PowerOn(7);
	myGPU.ColorBlink(7, Display_TextBackground_Black, Display_TextBackground_LightBlue, 250000, 3);
	
	vector<int> cargoPanels = {5, 6};
	myGPU.PowerOn(cargoPanels);
	myGPU.ColorBlink(cargoPanels, Display_TextBackground_Black, Display_TextBackground_LightBlue, 250000, 3);
	
	myGPU.Close();
	return 0;
}
