// -----------------------------------------------------------------------------
// Tox[N]andGPU.as
// Tox[N]andGPU, a simple NandOS GPU handler
// Created by Marc "Toxicat" Guilmard
// -----------------------------------------------------------------------------

#include "unistd.h"
#include "fcntl.h"

class GPUHandler {
	private int _fd;
	private bool _open;
	
	GPUHandler() {
		_fd = -1;
		_open = false;
	}
	
	void Open() {
		if (!_open) {
			_fd = open("/dev/iq0", O_WRONLY);
			_open = true;
		}
	}
	
	void Close() {
		if (_open) {
			close(_fd);
			_open = false;
		}
	}
	
	/*
	** ==========
	** PowerOff functions
	** ==========
	*/
	
	void PowerOff() {
		if (!_open)
			return;
	
		vector<var> cmd = { Control_Device_Power, Device_PowerMode_Off };
		write(_fd, cmd);
		sleep(1);
	}
	
	void PowerOff(int display) {
		if (!_open)
			return;
	
		vector<var> cmd = { Control_Device_Power, Device_PowerMode_Off, display };
		write(_fd, cmd);
		sleep(1);
	}
	
	void PowerOff(vector<int> &displays) {
		if (!_open)
			return;
	
		for(uint i = 0; i < displays.size(); ++i) {
			PowerOff(displays[i]);
		}
		sleep(1);
	}
	
	/*
	** ==========
	** PowerOn functions
	** ==========
	*/
	
	void PowerOn(bool wait = true) {
		if (!_open)
			return;
	
		vector<var> cmd = { Control_Device_Power, Device_PowerMode_On };
		write(_fd, cmd);
	
		if (wait)
			sleep(1);
	}
	
	void PowerOn(int display, bool wait = true) {
		if (!_open)
			return;
	
		vector<var> cmd = { Control_Device_Power, Device_PowerMode_On, display };
		write(_fd, cmd);
	
		if (wait)
			sleep(1);
	}
	
	void PowerOn(vector<int> &displays, bool wait = true) {
		if (!_open)
			return;
	
		for(uint i = 0; i < displays.size(); ++i) {
			PowerOn(displays[i], false);
		}
	
		if (wait)
			sleep(1);
	}
	
	/*
	** ==========
	** SetDisplayMod functions
	** ==========
	*/
	
	void SetDisplayMod(int display, var mode) {
		if (!_open)
			return;
	
		vector<var> cmd = { Control_Video_DisplayMode, display, mode };
		write(_fd, cmd);
	}
	
	void SetDisplayMod(var mode) {
		if (!_open)
			return;
		
		for(uint i = 0; i <= 7; ++i) {
			SetDisplayMod(i, mode);
		}
	}
	
	void SetDisplayMod(vector<int> &displays, var mode) {
		if (!_open)
			return;
	
		for(uint i = 0; i < displays.size(); ++i) {
			SetDisplayMod(displays[i], mode);
		}
	}
	
	/*
	** ==========
	** ColorClear functions
	** ==========
	*/
	
	void ColorClear(int display, var color) {
		if (!_open)
			return;
	
		vector<var> cmd = { Control_Video_Clear, display, color };
		write(_fd, cmd);
	}
	
	void ColorClear(var color) {
		if (!_open)
			return;
	
		for(uint i = 0; i <= 7; ++i) {
			ColorClear(i, color);
		}
	}
	
	void ColorClear(vector<int> &displays, var color) {
		if (!_open)
			return;
	
		for(uint i = 0; i < displays.size(); ++i) {
			ColorClear(displays[i], color);
		}
	}
	
	/*
	** ==========
	** CharacterClear functions
	** ==========
	*/
	
	void CharacterClear(int display) {
		if (!_open)
			return;
	
		vector<var> cmd = { Control_Video_ClearCharacters, display };
		write(_fd, cmd);
	}
	
	void CharacterClear() {
		if (!_open)
			return;
		
		for(uint i = 0; i <= 7; ++i) {
			CharacterClear(i);
		}
	}
	
	void CharacterClear(vector<int> &displays) {
		if (!_open)
			return;
		
		for(uint i = 0; i < displays.size(); ++i) {
			CharacterClear(displays[i]);
		}
	}
	
	/*
	** ==========
	** AppendText functions
	** ==========
	*/
	
	void AppendText(int display, string text, var foregroundColor = Display_TextForeground_Default, var backgroundColor = Display_TextBackground_Default, var textAttribute = Display_TextAttribute_Normal, bool newLine = false) {
		if (!_open)
			return;
	
		vector<var> cmd = { Control_Video_AppendCharacters, display, text, foregroundColor, backgroundColor, textAttribute };
		write(_fd, cmd);
	
		if (newLine) {
			NewLine(display);
		}
	}
	
	void AppendText(string text, var foregroundColor = Display_TextForeground_Default, var backgroundColor = Display_TextBackground_Default, var textAttribute = Display_TextAttribute_Normal, bool newLine = false) {
		if (!_open)
			return;
	
		for(uint i = 0; i <= 7; ++i) {
			AppendText(i, text, foregroundColor, backgroundColor, textAttribute, false);
		}
		
		if (newLine) {
			NewLine();
		}
	}
	
	void AppendText(vector<int> &displays, string text, var foregroundColor = Display_TextForeground_Default, var backgroundColor = Display_TextBackground_Default, var textAttribute = Display_TextAttribute_Normal, bool newLine = false) {
		if (!_open)
			return;
	
		for(uint i = 0; i < displays.size(); ++i) {
			AppendText(displays[i], text, foregroundColor, backgroundColor, textAttribute, false);
		}
		
		if (newLine)
			NewLine(displays);
	}
	
	/*
	** ==========
	** NewLine functions
	** ==========
	*/
	
	void NewLine(int display) {
		if (!_open)
			return;
	
		vector<var> cmd = { Control_Video_Newline, display };
		write(_fd, cmd);
	}
	
	void NewLine() {
		if (!_open)
			return;
	
		for(uint i = 0; i <= 7; ++i) {
			NewLine(i);
		}
	}
	
	void NewLine(vector<int> &displays) {
		if (!_open)
			return;
	
		for(uint i = 0; i < displays.size(); ++i) {
			NewLine(displays[i]);
		}
	}
	
	/*
	** ==========
	** AnimationFunction functions
	** ==========
	*/
	
	void ColorBlink(int display, var baseColor, var blinkColor, int delay, uint nb) {
		if (!_open)
			return;
		
		ColorClear(display, baseColor);
		usleep(delay);
		ColorClear(display, blinkColor);
		usleep(delay);
		ColorClear(display, baseColor);
		
		if (--nb > 0)
			ColorBlink(display, baseColor, blinkColor, delay, nb);
	}
	
	void ColorBlink(var baseColor, var blinkColor, int delay, uint nb) {		
		if (!_open)
			return;
		
		for(uint i = 0; i <= 7; ++i) {
			ColorClear(i, baseColor);
		}
		
		usleep(delay);
		
		for(uint i = 0; i <= 7; ++i) {
			ColorClear(i, blinkColor);
		}
		
		usleep(delay);
		
		for(uint i = 0; i <= 7; ++i) {
			ColorClear(i, baseColor);
		}
		
		if (--nb > 0)
			ColorBlink(baseColor, blinkColor, delay, nb);
	}
	
	void ColorBlink(vector<int> &displays, var baseColor, var blinkColor, int delay, uint nb) {
		if (!_open)
			return;
		
		for(uint i = 0; i < displays.size(); ++i) {
			ColorClear(displays[i], baseColor);
		}
		
		usleep(delay);
		
		for(uint i = 0; i < displays.size(); ++i) {
			ColorClear(displays[i], blinkColor);
		}
		
		usleep(delay);
		
		for(uint i = 0; i < displays.size(); ++i) {
			ColorClear(displays[i], baseColor);
		}
		
		if (--nb > 0)
			ColorBlink(displays, baseColor, blinkColor, delay, nb);
	}
}
