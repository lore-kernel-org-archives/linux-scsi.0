From: Klaus Fuerstberger <netbox1@gmx.de>
Subject: DC390 Deadlock in DataIn
Date: Tue, 29 Oct 2002 21:32:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DBEF051.5050708@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <dc390@garloff.de>, linux-scsi@vger.kernel.org

Hi,

I use an Dawicontrol DC-2974 PCI Hostadapter.
Without any problems I am able to write a tar Backup to an attached 
HP-Streamer.
However, if I try to access the Tape with an "tar tvf /dev/st0" the 
SCSI-Bus hangs after short time with the following error message. I have 
to reset the SCSI-Bus with an "echo reset > /proc/scsi/tmscsim/0" as it 
is described in the README.tmscsim.

Any hints?
Thx Klaus


Oct 29 20:54:05 srv kernel: DC390: Illegal Operation detected (08d1cc10)!
Oct 29 20:54:05 srv kernel: DC390: SRB: Xferred 00000000, Remain 
00002800, State 00000100, Phase 01
Oct 29 20:54:05 srv kernel: DC390: AdpaterStatus: 00, SRB Status 00
Oct 29 20:54:05 srv kernel: DC390: Status of last IRQ (DMA/SC/Int/IRQ): 
08d1cc10
Oct 29 20:54:05 srv kernel: DC390: Register dump: SCSI block:
Oct 29 20:54:05 srv kernel: DC390: XferCnt  Cmd Stat IntS IRQS FFIS Ctl1 
Ctl2 Ctl3 Ctl4
Oct 29 20:54:05 srv kernel: DC390:  000000   90   11   cc   00   82   17 
   48   18   04
Oct 29 20:54:05 srv kernel: DC390: FIFO: 00 00
Oct 29 20:54:05 srv kernel: DC390: Register dump: DMA engine:
Oct 29 20:54:05 srv kernel: DC390: Cmd   STrCnt    SBusA    WrkBC 
WrkAC Stat SBusCtrl
Oct 29 20:54:05 srv kernel: DC390:  83 00002800 00090000 00000004 
000927fc   00 03184200
Oct 29 20:54:05 srv kernel: DC390: Register dump: PCI Status: 0200
Oct 29 20:54:05 srv kernel: DC390: In case of driver trouble read 
linux/drivers/scsi/README.tmscsim
Oct 29 20:54:05 srv kernel: DC390: Deadlock in DataIn_0: DMA aborted 
unfinished: 000004 bytes remain!!
Oct 29 20:54:05 srv kernel: DC390: DataIn_0: DMA State: 0
Oct 29 20:54:05 srv kernel: st0: Error 27010000 (sugg. bt 0x20, driver 
bt 0x7, host bt 0x1).
Oct 29 20:54:05 srv kernel: DC390: Illegal Operation detected (00d3cc10)!
Oct 29 20:54:05 srv kernel: DC390: SRB: Xferred 00000000, Remain 
00002800, State 00000100, Phase 01
Oct 29 20:54:05 srv kernel: DC390: AdpaterStatus: 00, SRB Status 00
Oct 29 20:54:05 srv kernel: DC390: Status of last IRQ (DMA/SC/Int/IRQ): 
00d3cc10
Oct 29 20:54:05 srv kernel: DC390: Register dump: SCSI block:
Oct 29 20:54:05 srv kernel: DC390: XferCnt  Cmd Stat IntS IRQS FFIS Ctl1 
Ctl2 Ctl3 Ctl4
Oct 29 20:54:05 srv kernel: DC390:  000000   90   13   cc   00   80   17 
   48   18   04
Oct 29 20:54:05 srv kernel: DC390: Register dump: DMA engine:
Oct 29 20:54:05 srv kernel: DC390: Cmd   STrCnt    SBusA    WrkBC 
WrkAC Stat SBusCtrl
Oct 29 20:54:05 srv kernel: DC390:  83 00002800 00090000 00000000 
00092800   08 031a4700
Oct 29 20:54:05 srv kernel: DC390: Register dump: PCI Status: 0200
Oct 29 20:54:05 srv kernel: DC390: In case of driver trouble read 
linux/drivers/scsi/README.tmscsim
Oct 29 20:54:05 srv kernel: DC390: Illegal Operation detected (08d3cc10)!
Oct 29 20:54:05 srv kernel: DC390: SRB: Xferred 00000000, Remain 
00002800, State 00000100, Phase 01
Oct 29 20:54:05 srv kernel: DC390: AdpaterStatus: 00, SRB Status 00
Oct 29 20:54:05 srv kernel: DC390: Status of last IRQ (DMA/SC/Int/IRQ): 
08d3cc10
Oct 29 20:54:05 srv kernel: DC390: Register dump: SCSI block:
Oct 29 20:54:05 srv kernel: DC390: XferCnt  Cmd Stat IntS IRQS FFIS Ctl1 
Ctl2 Ctl3 Ctl4
Oct 29 20:54:05 srv kernel: DC390:  000000   90   13   cc   00   80   17 
   48   18   04
Oct 29 20:54:05 srv kernel: DC390: Register dump: DMA engine:
Oct 29 20:54:05 srv kernel: DC390: Cmd   STrCnt    SBusA    WrkBC 
WrkAC Stat SBusCtrl
Oct 29 20:54:05 srv kernel: DC390:  83 00002800 00090000 00000000 
00092800   08 031a4700
Oct 29 20:54:05 srv kernel: DC390: Register dump: PCI Status: 0200
Oct 29 20:54:05 srv kernel: DC390: In case of driver trouble read 
linux/drivers/scsi/README.tmscsim
Oct 29 20:54:05 srv kernel: DC390: Illegal Operation detected (08d1c410)!
Oct 29 20:54:05 srv kernel: DC390: SRB: Xferred 00000000, Remain 
00002800, State 00000100, Phase 01
Oct 29 20:54:05 srv kernel: DC390: AdpaterStatus: 00, SRB Status 00
Oct 29 20:54:05 srv kernel: DC390: Status of last IRQ (DMA/SC/Int/IRQ): 
08d1c410
Oct 29 20:54:05 srv kernel: DC390: Register dump: SCSI block:
Oct 29 20:54:05 srv kernel: DC390: XferCnt  Cmd Stat IntS IRQS FFIS Ctl1 
Ctl2 Ctl3 Ctl4
Oct 29 20:54:05 srv kernel: DC390:  000000   90   11   c4   00   89   17 
   48   18   04
Oct 29 20:54:05 srv kernel: DC390: FIFO: 8c 62 18 c4 00 04 63 18 c6
Oct 29 20:54:05 srv kernel: DC390: Register dump: DMA engine:
Oct 29 20:54:05 srv kernel: DC390: Cmd   STrCnt    SBusA    WrkBC 
WrkAC Stat SBusCtrl
Oct 29 20:54:05 srv kernel: DC390:  83 00002800 00090000 00000014 
000927ec   00 03184231
Oct 29 20:54:05 srv kernel: DC390: Register dump: PCI Status: 0200
Oct 29 20:54:05 srv kernel: DC390: In case of driver trouble read 
linux/drivers/scsi/README.tmscsim
Oct 29 20:54:05 srv kernel: DC390: Deadlock in DataIn_0: DMA aborted 
unfinished: 000014 bytes remain!!
Oct 29 20:54:05 srv kernel: DC390: DataIn_0: DMA State: 0


# uname -a
Linux srv 2.4.19 #1 Tue Oct 29 18:19:20 CET 2002 i686 Intel(R) 
Pentium(R) 4 CPU 1.70GHz GenuineIntel GNU/Linux

# lsmod
st 25712   1
tmscsim 29120   1

# lspci -vv
02:02.0 SCSI storage controller: Advanced Micro Devices [AMD] 53c974 
[PCscsi] (rev 10)
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr+ Stepping+ SERR+ FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 70 (1000ns min, 10000ns max)
         Interrupt: pin A routed to IRQ 10
         Region 0: I/O ports at dc00 [size=128]
         Expansion ROM at ff9f0000 [disabled] [size=64K]

# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 03 Lun: 00
   Vendor: HP       Model: C1537A           Rev: L005
   Type:   Sequential-Access                ANSI SCSI revision: 02

# cat /proc/scsi/tmscsim/0
Tekram DC390/AM53C974 PCI SCSI Host Adapter, Driver Version 2.0f 2000-12-20
SCSI Host Nr 0, AM53C974 Adapter Nr 0
IOPortBase 0xdc00, IRQ 10
MaxID 7, MaxLUN 8, AdapterID 7, SelTimeout 250 ms, DelayReset 1 s
TagMaxNum 16, Status 0x00, ACBFlag 0x00, GlitchEater 24 ns
Statistics: Cmnds 3437, Cmnds not sent directly 1, Out of SRB conds 0
             Lost arbitrations 0, Sel. connected 0, Connected: No
Nr of attached devices: 1, Nr of DCBs: 1
Map of attached LUNs: 00 00 00 01 00 00 00 00
Idx ID LUN Prty Sync DsCn SndS TagQ NegoPeriod SyncSpeed SyncOffs MaxCmd
00  03  00  Yes  Yes  Yes  Yes  No    100 ns    10.0 M      15      01
Commands in Queues: Query: 0:

