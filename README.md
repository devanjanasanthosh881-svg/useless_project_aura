Chaos-Cam 🎯
Basic Details
Team Name: useless_project_aura
Team Members
Team Lead: Bisharath K N P - Mar Athanasius College of Engineering, Kothamangalam

Member 2: Devanjana V S - Mar Athanasius College of Engineering, Kothamangalam

Project Description
Chaos-Cam is a Flutter-based mobile application disguised as a sleek "Pro Camera" that deliberately sabotages your photography with inverted gyroscope tilts, anti-autofocus reticles, severe image ruination, and live on-device LLM photo roasting.

The Problem (that doesn't exist)
In a world obsessed with pixel-perfect social media aesthetic standards, rule-of-thirds alignment, and hyper-stabilized camera sensors, everyday photography has become far too clean, predictable, and boringly symmetrical.

The Solution (that nobody asked for)
Chaos-Cam actively fights against photo perfection! It forces dynamic tilt angles with an inverted gyroscope engine, flashes blur on touch, crops off subject foreheads, saturates colors to radioactive levels, burns in a semi-transparent thumb overlay, and uses a local AI to roast your terrible shot in real time.

Technical Details
Technologies/Components Used
For Software:

Languages used: Dart

Frameworks used: Flutter (Android / Cross-platform)

Libraries used: image (low-level bitmap/pixel manipulation), sensors_plus (accelerometer motion tracking), http (local REST API integration), google_fonts (HUD styling)

Tools used: VS Code, Git/GitHub, Android Studio Emulator, Ollama CLI (llama3.2:1b)

Implementation
For Software:

Installation
PowerShell
# Clone the repository
git clone https://github.com/devanjanasanthosh881-svg/useless_project_aura.git
cd useless_project_aura

# Install Flutter packages
flutter pub get

# Pull local LLM model via Ollama (Ensure Ollama host environment is active)
$env:OLLAMA_HOST="0.0.0.0"
ollama serve
ollama pull llama3.2:1b
Run
PowerShell
# Launch on Android Emulator or connected physical device
flutter run
Project Documentation
For Software:

Screenshots (Add at least 3)
https://drive.google.com/file/d/1Gy2xuJojb6Tvba8S1m0J0OIHormJDuY2/view?usp=drivesdk
https://drive.google.com/file/d/15wDgy-3a4P_Z57COltugaF6cr-yNWbZ7/view?usp=drivesdk
https://drive.google.com/file/d/1NSndpURZb3FjNfuSANSQu10wl62qql0w/view?usp=drivesdk

Dark mode Pro Viewfinder featuring simulated live RGB histogram, anti-autofocus reticle, and anti-scene optimizer status pill.

Full-screen dramatic loader state locking screen interactions while dynamic sabotage prompts cycle.

Final ruined bitmap preview showing 19° burnt tilt, thumb overlay, decapitation crop, and live on-device Ollama LLM critique.

Diagrams
App architecture showing parallel execution of Dart Image Processing Engine and HTTP connection to local Ollama LLM endpoint (10.0.2.2:11434).

Project Demo
Video
https://drive.google.com/file/d/1Y3K89RZykpdYPJyOQ5Mi1g2hioVlqGuY/view?usp=drivesdk
Demonstrates live tilt sabotage, interactive tap-to-blur autofocus evasion, shutter image processing pipeline, and live local LLM response inside the emulator.


Team Contributions
Bisharath K N P: Developed Pro Mode UI screen (camera_screen.dart), Gyroscope Anti-Leveler (tilt_leveler.dart), Interactive Anti-Autofocus (pro_viewfinder.dart), and Local Ollama LLM service integration (llm_critic.dart).

Devanjana V S: Developed Dart Image Ruination Engine (chaos_engine.dart), Shutter State Machine overlay (chaos_loader.dart), and Result Modal dialog view (result_modal.dart), Integration of real-time camera.

Made with ❤️ at TinkerHub Useless Projects
