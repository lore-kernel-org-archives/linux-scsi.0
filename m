From: "Paul" <paul@kbs.net.au>
Subject: adaptec aar1210 serial ata and 2.6.0
Date: Mon, 8 Dec 2003 18:48:14 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <074a01c3bd5f$a42fba80$7301a8c0@internal.kbs.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi All,

I am trying to get an adaptec 1210 serial ata raid controller working under
2.6.0. I've also tried 2.4.23
I've found a patch for 2.6.0 by Mark Haverkamp at
http://marc.theaimsgroup.com/?l=linux-scsi&m=10663501617378&w=2 and also a
patch (for 2.4.22) by someone else (not sure who) which just resulted in
lots of "lost interrupt" errors at bootup and it took around 30 minutes to
boot.

Below is a lcpci -vvv in case this helps in identifying this card

00:0d.0 RAID bus controller: CMD Technology Inc: Unknown device 0240 (rev
02) (prog-if 01)
Subsystem: Adaptec: Unknown device 0240
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
Latency: 32, cache line size 08
Interrupt: pin A routed to IRQ 11
Region 0: I/O ports at 9800 [size=8]
Region 1: I/O ports at 9400 [size=4]
Region 2: I/O ports at 9000 [size=8]
Region 3: I/O ports at 8800 [size=4]
Region 4: I/O ports at 8400 [size=16]
Region 5: Memory at eb800000 (32-bit, non-prefetchable) [size=512]
Expansion ROM at <unassigned> [disabled] [size=512K]
Capabilities: [60] Power Management version 2
Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 PME-Enable- DSel=0 DScale=2 PME-

Does anyone have a working patch for this card? It appears as a CMD card
according to the BIOS. I did manage to get it working in 2.4.23 with a
"Silicon Image" driver siimage.c however it had the same problems as
mentioned above, lots of "lost interrupt" and big pauses when attempting to
access the disks on the controller. Any help would be great.

Regards,

Paul Rivoli
paul@kbs.net.au
K B S   I N T E R N E T

