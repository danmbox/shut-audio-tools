SHUT AUDIO TOOLS
Lightweight tools for playing, practicing and recording music on Linux

Home page: http://danmbox.github.com/shut-audio-tools/
Author: Dan A. Muresan (danmbox at gmail dot com)


1. DESCRIPTION:

Shut Audio Tools are lightweight tools for playing, practicing and
recording music on Linux. They support Jack, Pulse Audio and ALSA.
They run in a text terminal, or in GUI mode. Currently included are:

* ShutLP, a gapless loop player with a count-in metronome. It helps
you practice along with a recorded loop. For session management, it's
LASH-aware.

* Shut Record, a recording front end with workflow management for
naming / recording / redoing.  It can use jack_capture, arecord and
other back-ends. Set up a background loop with shutlp, record with
shutrecord, view with mhwaveedit and retry until happy.

* spliceaudio, an audio splicing / loop-creation utility using sox

* Shut Audio Control (shut-actl), a GUI for managing Pulse Audio,
Jack and their interactions


2. DEPENDENCIES:

* mandatory: sox, mplayer; perl, python; Jack, Pulse Audio or ALSA

* build dependencies: GNU make, perl, python, help2man

* recommended: TkInter and Python-Imaging (for GUIs)

* recommended: jack_capture (for recording)

* recommended: an audio editor such as mhwaveedit

3. INSTALLING:

Whatever the setup, all executables MUST be installed in the path,
because they call one another by name.

# installs in /usr/local:
make install

# installs elsewhere:
make prefix=/opt/shutat install
PATH="$PATH:"/opt/shutat

# Debian / Ubuntu:
make xdebian
cd ../shut-audio-tools-*/
debuild -i -b -us -uc
dpkg -i ../shut-audio-tools*.deb

# for packagers:
make DESTDIR=build/ prefix=/usr install
cd build; tar cvzf ../shut-audio-tools.tar.gz .


4. RUNNING

In a desktop environment (Gnome, KDE, LXDE etc.), ShutLP is a handler
for audio files, and Shut Record is a handler for folders -- so you
can run them via the "Open With..." dialog (or equivalents).

Or just start the tools from the command line. See the man pages for
command-line arguments.


5. COPYRIGHT:

Copyright 2010-2011 Dan A. Muresan

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
