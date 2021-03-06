"
SqueakWin32x86Config is an Abstract base class that provides common information for my subclasses.
I am not meant to be built.

I configure a VM according to my name's form: [Operating System] [WordSize] [Processor Language][VM MemoryManager][BuildType]Conf


SqueakWin32x86Builder 
	configureABuildFor: #ONE OF MY SUBCLASSES NAME HERE withBuildType: #build;
	enableMessageTracking: true;
	generateByTemplate.


HelpBrowser openOn: CMakeVMMakerSqueakDeveloperHelp

"
Class {
	#name : #SqueakWin32x86Config,
	#superclass : #SqueakWindowsConfig,
	#category : #'CMakeVMMakerSqueak-Win32x86'
}

{ #category : #'as yet unclassified' }
SqueakWin32x86Config class >> licenseTemplate [
	^'Squeak  {1} license information
==============================

About Squeak
-----------


Squeak is a modern, open source, full-featured implementation of the powerful Smalltalk programming language and environment. Squeak is highly-portable, running on almost any platform you could name and you can really truly write once run anywhere.  Squeak is the vehicle for a wide range of projects from multimedia applications and educational platforms to commercial web application development. Read on and join in!

http://www.squeak.org


LIcense

Note: The current release of Squeak is a combination of source code originating from it''s origins at Apple which Apple agreed to license under the Apache license and more recent contributions licensed under the MIT license. The vast majority of the code is under the MIT license.
MIT License

Copyright (c) The individual, corporate, and institutional contributors who have collectively contributed elements to this software ("The Squeak Community"), 1996-2010 All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
Portions of Squeak are covered by the following license:
Apache License, Version 2.0

Copyright (c) Xerox Corp. 1981, 1982 All rights reserved. Copyright (c) Apple Computer, Inc. 1985-1996 All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


About Cog
---------

Cog is a virtual machine designed for Smalltalk and other similar dynamic languages.  Cog builds on the
Squeak virtual machine adding a stack-to-register-mapping just-in-time compiler, aggressive in-line message
cacheing and effective optimization of Smalltalk’s first-class activation records.  Cog is the virtual machine
underlying Teleplace''s Croquet-based enterprise virtual collaboration spaces software, the fastest virtual
machine for Squeak, and for Gilad Bracha''s Newspeak modular language inspired by Beta and Smalltalk.  
Like the original Squeak VM, Cog is implemented and developed in Smalltalk, and translated into a lower-level
language to produce the production VM.  Being a Smalltalk program it is a delight to develop.  Cog is
available under the MIT open source license and is unencumbered for commercial deployment.

Cog''s performance relative to the existing Squeak interpreter varies, depending on the benchmark chosen.
As of early-2011, the Cog JIT uses strong inline cacheing techniques and stack-to-register mapping that
results in a register-based calling convention for low-arity methods.  Due to the complexity of the Squeak
object representation it has a limited set of primitives implemented in machine code that, for example,
exclude object allocation.  Performance of the early-2011 JIT for the nbody, binarytrees and chameneos
redux benchmarks from the computer language shootout is in the range of 4 to 6 times faster than the
interpreter.
'
]

{ #category : #'as yet unclassified' }
SqueakWin32x86Config class >> pluginsTemplate [
	^'Squeak {1} ships with the following plugins already built:
		
Internal: 
=========
{2}

External: 
=========
{3}

'
]

{ #category : #cmake }
SqueakWin32x86Config >> availableBuildTypes [
	 ^SqueakCMakeVMMakerAbstractBuilder  default  allBuildTypes
"	subclasses should use

  ^super availableBuildTypes copyWithoutAll: #( #assertWithHeartbeatTimer #debugWithHeartbeatTimer debugMultiThreadedFFI.....etc))   "
	

]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateAsynchFilePlugin:  aMaker [ 
	aMaker templates 
		addLast:((CMakeListAppend new) list:'sources' elements: (OrderedCollection with: '${pluginPlatform}/sqWin32AsyncFilePrims.c'))
	




]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateCroquetPlugin:  aMaker [ 
	super configureByTemplateCroquetPlugin:  aMaker.
	aMaker templates 
		addLast:((CMakeListAppend new) list:'sources' elements: (OrderedCollection with: '${pluginPlatform}/sqWin32CroquetPlugin.c'))




]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateDropPlugin:  aMaker [ 
	aMaker templates 
		addLast:((CMakeListAppend new) list:'sources' elements: (OrderedCollection with: '${pluginPlatform}/sqWin32Drop.c')).




]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateFT2Plugin: aMaker [
	| lib |
	self flag:'tty'. "is internalFT2 still not supported?"
	aMaker isExternal ifFalse: [self error: 'building internal FT2Plugin is not supported yet' ]. 	
	self flag:'tty'. "I haven't been down the addThirdpartyLibrary rabbit hole yet"
	lib := self addThirdpartyLibrary: 'freetype2'.
	aMaker templates   	"link plugin with freetype lib"
		addLast:((CMakeListAppend new) list:'LINKLIBS' elements: (OrderedCollection with:  (lib targetForLinking)));
		addLast: ((CMakeIncludeDirectories new) dirs: (OrderedCollection with: lib includeDir)).
]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateFilePlugin: aMaker [ 

	super configureByTemplateFilePlugin: aMaker.
	aMaker templates 
		addLast:((CMakeListAppend new) list:'sources' elements: (OrderedCollection with: '${pluginPlatform}/sqWin32FilePrims.c'))
	


]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateHostWindowPlugin:    aMaker [ 
	aMaker templates 
		addLast:((CMakeListAppend new) list:'sources' elements: (OrderedCollection with: '${pluginPlatform}/sqWin32HostWindowPlugin.c'))




]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateJoystickTabletPlugin:  aMaker [ 

	aMaker templates 
		addLast:((CMakeListAppend new) list:'sources' elements: (OrderedCollection with: '${pluginPlatform}/sqWin32Joystick.c'))
	


]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateLocalePlugin: aMaker [ 
	aMaker templates 
		addLast:((CMakeListAppend new) list:'sources' elements: (OrderedCollection with: '${pluginPlatform}/sqWin32Locale.c'))
	




]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateMIDIPlugin:  aMaker [ 
	aMaker templates 
		addLast:((CMakeListAppend new) list:'sources' elements: (OrderedCollection with: '${pluginPlatform}/sqWin32MIDI.c'))



]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateMpeg3Plugin:  aMaker [ 

	super configureByTemplateMpeg3Plugin:  aMaker.
	aMaker templates 
		addLast:((CMakeAddDefinitions new) definitions: (OrderedCollection with:  '-DNOPTHREADS'));
		addLast:((CMakeListAppend new) list:'sources' elements: (OrderedCollection with: '${pluginPlatform}/sqOpenFile.c'))	

]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateSecurityPlugin: aMaker [ 
	aMaker templates 
		addLast:((CMakeListAppend new) list:'sources' elements: (OrderedCollection with: '${pluginPlatform}/sqWin32Security.c'))	




]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateSerialPlugin:  aMaker [ 
	aMaker templates 
		addLast:((CMakeListAppend new) list:'sources' elements: (OrderedCollection with: '${pluginPlatform}/sqWin32SerialPort.c'))	




]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateSocketPlugin:  aMaker [ 
	aMaker templates 
		addLast:((CMakeListAppend new) list:'sources' elements: (OrderedCollection with: '${pluginPlatform}/sqWin32NewNet.c'))	




]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateSoundPlugin: aMaker [ 
	aMaker templates 
		addLast:((CMakeListAppend new) list:'sources' elements: (OrderedCollection with: '${pluginPlatform}/sqWin32Sound.c'))
	

]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateSqueakSSLPlugin: aMaker [
	| lib |
	self flag:'tty'. "expect transposing mistakes here. see pharo CPlatformConfig configureSSLPlugin for originial code"
	aMaker templates 
		addLast:((CMakeListAppend new) list:'sources' elements: (OrderedCollection with: '${pluginPlatform}/sqUnixOpenSSL.c')).
	lib := self addThirdpartyLibrary: 'openssl'.  "is this order important? probably not."
	aMaker templates 
		addLast: ((CMakeIncludeDirectories new) dirs: (OrderedCollection with: lib includeDir));
		addLast:((CMakeLinkDirectories new) directories: (OrderedCollection with: '${outputDir}'));
		addLast:((CMakeListAppend new) list:'LINKLIBS' elements: (OrderedCollection with: 'libeay32.dll' with: 'ssleay32.dll'));
		addLast:((CMakeListAppend new) 
					list: self moduleName , '_dependencies'
					 elements: (OrderedCollection with: lib buildTarget)).



]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateUUIDPlugin: aMaker [ 
	aMaker templates 
		addLast:((CMakeListAppend new) list:'sources' elements: (OrderedCollection with: '${pluginPlatform}/sqWin32UUID.c'))	



]

{ #category : #'plugin extra rules' }
SqueakWin32x86Config >> configureByTemplateWin32OSProcessPlugin: aMaker [ 
	aMaker templates 
		addLast: ((CMakeIncludeDirectories new) 
				dirs: (OrderedCollection 
						with:'${crossDir}/plugins/FilePlugin' 
						with: '${crossDir}/plugins/SocketPlugin'))

]

{ #category : #cmake }
SqueakWin32x86Config >> configureForNoBuildType [
		generateBuild:=generateBuildAssert:=generateBuildAssertITimerHeartbeat:=generateBuildDebug:=generateBuildDebugITimerHeartbeat:= generateBuildDebugMultiThreaded:= generateBuildIHeartbeatTimer:= generateBuildMultiThreaded:= generateBuildMultiThreadedAssert:= generateBuildMultiThreadedDebug:=false.
]

{ #category : #'cmake buildType redirects' }
SqueakWin32x86Config >> coreSourcesBuild [
	"files to include from src/vm dir"
	
	^ #(
		'cogit.c'
		'gcc3x-cointerp.c'
		)
]

{ #category : #'cmake buildType redirects' }
SqueakWin32x86Config >> coreSourcesBuildMultiThreaded [
	"files to include from src/vm dir"
	^ #(
		'cogit.c'
		'cointerpmt.c'
		)
]

{ #category : #plugins }
SqueakWin32x86Config >> defaultExternalPlugins [
	"expertly cut-n-pasted from Cog/cygwinbuild/plugins.ext"
	^#(
		BochsIA32Plugin 
		SqueakFFIPrims 
		Win32OSProcessPlugin
	)
]

{ #category : #plugins }
SqueakWin32x86Config >> defaultInternalPlugins [
	"expertly cut-n-pasted from Cog/cygwinbuild/plugins.int"
	^#(
		ADPCMCodecPlugin 
		AsynchFilePlugin 
		B3DAcceleratorPlugin 
		B2DPlugin 
		BitBltPlugin 
		BMPReadWriterPlugin 
		CroquetPlugin 
		ZipPlugin 
		DropPlugin 
		DSAPrims 
		FFTPlugin 
		FilePlugin 
		FloatArrayPlugin 
		FloatMathPlugin 
		HostWindowPlugin 
		IA32ABI 
		JoystickTabletPlugin 
		JPEGReaderPlugin 
		JPEGReadWriter2Plugin 
		Klatt 
		LargeIntegers 
		LocalePlugin 
		Matrix2x3Plugin 
		MIDIPlugin 
		MiscPrimitivePlugin 
		Mpeg3Plugin 
		RePlugin 
		SecurityPlugin 
		SerialPlugin 
		SocketPlugin 
		SoundCodecPrims 
		SoundGenerationPlugin 
		SoundPlugin 
		StarSqueakPlugin 
		SurfacePlugin 
		UUIDPlugin
	)
]

{ #category : #cmake }
SqueakWin32x86Config >> dirBuildPlatform [
	"the directory for the platform. example: build.linux32x86"
	^self dirWin32x86
]

{ #category : #cmake }
SqueakWin32x86Config >> excludeFromBuild [
	^true

]

{ #category : #cmake }
SqueakWin32x86Config >> executableName [
	"AbstractBaseClass configurations are not meant to be executable"
	^ self vmIShouldNotBeHereExecutableName
]

{ #category : #'thirdparty libs' }
SqueakWin32x86Config >> externalLibraries [
	
	^ #( 
		ddraw dinput opengl32 wsock32 comdlg32 ole32 winmm
		version wininet user32 gdi32 psapi kernel32 crtdll dsound secur32
	).
]

{ #category : #'cmake buildType redirects' }
SqueakWin32x86Config >> externalPluginsBuild [
	^ externalPlugins ifNil: [ externalPlugins := self defaultExternalPlugins ]
]

{ #category : #'cmake buildType redirects' }
SqueakWin32x86Config >> extraPluginSettingsBuild: aMaker [
	self subclassResponsibility.
"
	aMaker isExternal 
		ifTrue:[aMaker templates addLast:((CMakeSet new) variable:'LIBRARY_OUTPUT_PATH' value:'${outputDir}')].
	
"
]

{ #category : #'cmake buildType redirects' }
SqueakWin32x86Config >> internalPluginsBuild [
	^ internalPlugins ifNil: [ internalPlugins := self defaultInternalPlugins ]
]
