From: Hanna Linder <hannal@us.ibm.com>
Subject: more aic7xxx boot failure
Date: Thu, 24 Oct 2002 15:25:19 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <8800000.1035498319@w-hlinder>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Hanna Linder <hannal@us.ibm.com>, tmolina@cox.net, haveblue@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


>                                2.5 Kernel Problem Reports as of 22 Oct
>    Status                 Discussion  Problem Title
> 
>    open                   04 Oct 2002 AIC7XXX boot failure
>    1. http://marc.theaimsgroup.com/?l=linux-kernel&m=103356254615324&w=2
> 


This may be a different problem but it is related to the aic7xxx
driver. My system is a 2-way PIII 500MHz 2.5GB RAM box. It boots
if I remove the aic7xxx driver. This is on 2.5.44 btw. Works fine
on 2.4.x.

Here is the output from lspci -v -v:


00:06.0 SCSI storage controller: Adaptec AHA-2940U/UW / AHA-39xx / AIC-7895 (rev 04)
	Subsystem: Adaptec AHA-2940U/2940UW Dual AHA-394xAU/AUW/AUWD AIC-7895B
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 80 (2000ns min, 2000ns max)
	Interrupt: pin A routed to IRQ 15
	Region 0: I/O ports at 2200 [disabled] [size=256]
	Region 1: Memory at febfe000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at <unassigned> [disabled] [size=64K]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:06.1 SCSI storage controller: Adaptec AHA-2940U/UW / AHA-39xx / AIC-7895 (rev 04)
	Subsystem: Adaptec AHA-2940U/2940UW Dual AHA-394xAU/AUW/AUWD AIC-7895B
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 80 (2000ns min, 2000ns max)
	Interrupt: pin B routed to IRQ 10
	Region 0: I/O ports at 2300 [disabled] [size=256]
	Region 1: Memory at febfd000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
