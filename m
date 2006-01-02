From: James Bottomley <jejb@steeleye.com>
Subject: Re: [Bug 5808] aic7xxx - half speed/frequency
Date: Mon, 02 Jan 2006 10:28:29 -0600
Message-ID: <1136219309.3531.36.camel@mulgrave>
References: <200601020041.k020fes2021946@fire-2.osdl.org>
Reply-To: James.Bottomley@steeleye.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:55708 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750802AbWABQ3t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jan 2006 11:29:49 -0500
In-Reply-To: <200601020041.k020fes2021946@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: Zajsoft2@Zajsoft.NET, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2006-01-01 at 16:41 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> Most recent kernel where this bug did not occur: 2.6.12.6
> Distribution: Debian 3.1r1 - Sarge

Do you have the dmesg showing the domain validation commands for these, please?

And also could you tell me what's in

/sys/spi_transport/target<...>/min_period

Thanks,

James


> Hardware Environment: Dell PowerEdge 4200/300
> 
> Software Environment:
> ver_linux:
> Linux GW 2.6.13 #1 SMP Sun Jan 1 21:13:01 CET 2006 i686 GNU/Linux
> 
> Gnu C                  3.3.5
> Gnu make               3.80
> binutils               2.15
> util-linux             2.12p
> mount                  2.12p
> module-init-tools      3.2-pre1
> e2fsprogs              1.37
> jfsutils               1.1.7
> xfsprogs               2.6.20
> Linux C Library        2.3.2
> Dynamic linker (ldd)   2.3.2
> Procps                 3.2.1
> Net-tools              1.60
> Console-tools          0.2.3
> Sh-utils               5.2.1
> Modules Loaded
> 
> 
> proc/cpuinfo:
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 3
> model name      : Pentium II (Klamath)
> stepping        : 4
> cpu MHz         : 299.170
> cache size      : 512 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 2
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
> cmov mmx
> bogomips        : 599.32
> 
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 3
> model name      : Pentium II (Klamath)
> stepping        : 3
> cpu MHz         : 299.170
> cache size      : 512 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 2
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
> cmov mmx
> bogomips        : 598.36
> 
> 
> /proc/modules:
> 
> 
> /proc/ioports:
> 0000-001f : dma1
> 0020-0021 : pic1
> 0040-0043 : timer0
> 0050-0053 : timer1
> 0060-006f : keyboard
> 0070-0077 : rtc
> 0080-008f : dma page reg
> 00a0-00a1 : pic2
> 00c0-00df : dma2
> 00f0-00ff : fpu
> 0330-0333 : i2c-pca-isa
> 03c0-03df : vga+
> 0400-0407 : pnp 00:0f
> 040a-040c : pnp 00:0f
> 0410-043f : pnp 00:0f
> 0461-0462 : pnp 00:0f
> 0464-0465 : pnp 00:0f
> 0481-048b : pnp 00:0f
> 04c6-04c6 : pnp 00:0f
> 0c80-0c83 : Dell System PowerEdge 4200
> 0cf8-0cff : PCI conf1
> e000-efff : PCI Bus #01
>   e000-e0ff : 0000:01:0d.0
>     e000-e0ff : 8139too
>   e400-e4ff : 0000:01:0b.0
>   e800-e8ff : 0000:01:0a.0
> f4a0-f4bf : 0000:00:13.0
>   f4a0-f4bf : ne2k-pci
> f800-f8ff : 0000:00:14.0
> 
> 
> /proc/iomem:
> 00000000-0009fbff : System RAM
> 0009fc00-0009ffff : reserved
> 000a0000-000bffff : Video RAM area
> 000c0000-000c7fff : Video ROM
> 000c8000-000cc7ff : Adapter ROM
> 000f0000-000fffff : System ROM
> 00100000-0fffffff : System RAM
>   00100000-0049816c : Kernel code
>   0049816d-005b31c7 : Kernel data
> 10000000-100fffff : PCI Bus #01
>   10000000-1000ffff : 0000:01:0a.0
> 10100000-1010ffff : 0000:00:14.0
> 10110000-10113fff : 0000:00:13.0
> fc000000-fcffffff : 0000:00:14.0
> fde00000-fdffffff : PCI Bus #01
>   fdefe000-fdefefff : 0000:01:0a.0
>     fdefe000-fdefefff : aic7xxx
>   fdffe000-fdffefff : 0000:01:0b.0
>     fdffe000-fdffefff : aic7xxx
>   fdfff800-fdfff8ff : 0000:01:0d.0
>     fdfff800-fdfff8ff : 8139too
> fec00000-fec00fff : reserved
> fee00000-fee00fff : reserved
> fff80000-ffffffff : reserved
> 
> 
> lspci -vvv:
> 0000:00:00.0 Host bridge: Intel Corp. 440FX - 82441FX PMC [Natoma] (rev 02)
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort+ >SERR- <PERR-
>         Latency: 32
> 
> 0000:00:0d.0 PCI bridge: Digital Equipment Corporation DECchip 21152 (rev 02) 
> (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 255, Cache Line Size: 0x08 (32 bytes)
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=68
>         I/O behind bridge: 0000e000-0000efff
>         Memory behind bridge: fde00000-fdffffff
>         Prefetchable memory behind bridge: 0000000010000000-0000000010000000
>         BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
> 
> 0000:00:0f.0 Non-VGA unclassified device: Intel Corp. 82375EB/SB PCI to EISA 
> Bridge (rev 15)
>         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 248
> 
> 0000:00:13.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8029(AS)
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>         Interrupt: pin A routed to IRQ 10
>         Region 0: I/O ports at f4a0 [size=32]
>         Expansion ROM at 10110000 [disabled] [size=16K]
> 
> 0000:00:14.0 VGA compatible controller: ATI Technologies Inc 264VT [Mach64 VT] 
> (rev 40) (prog-if 00 [VGA])
>         Subsystem: ATI Technologies Inc Mach64VT Reference
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop+ ParErr- 
> Stepping+ SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>         Region 0: Memory at fc000000 (32-bit, prefetchable) [size=16M]
>         Region 1: I/O ports at f800 [size=256]
>         Expansion ROM at 10100000 [disabled] [size=64K]
> 
> 0000:01:0a.0 SCSI storage controller: Adaptec AIC-7880U
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64 (2000ns min, 2000ns max), Cache Line Size: 0x08 (32 bytes)
>         Interrupt: pin A routed to IRQ 15
>         Region 0: I/O ports at e800 [disabled] [size=256]
>         Region 1: Memory at fdefe000 (32-bit, non-prefetchable) [size=4K]
>         Expansion ROM at 10000000 [disabled] [size=64K]
> 
> 0000:01:0b.0 SCSI storage controller: Adaptec AIC-7860 (rev 01)
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64 (1000ns min, 1000ns max), Cache Line Size: 0x08 (32 bytes)
>         Interrupt: pin A routed to IRQ 15
>         Region 0: I/O ports at e400 [disabled] [size=256]
>         Region 1: Memory at fdffe000 (32-bit, non-prefetchable) [size=4K]
> 
> 0000:01:0d.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-
> 8139/8139C/8139C+ (rev 10)
>         Subsystem: Realtek Semiconductor Co., Ltd. RT8139
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64 (8000ns min, 16000ns max)
>         Interrupt: pin A routed to IRQ 9
>         Region 0: I/O ports at e000 [size=256]
>         Region 1: Memory at fdfff800 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-
> ,D1+,D2+,D3hot+,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 
> /proc/scsi/scsi:
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: SEAGATE  Model: ST34573LC        Rev: 5702
>   Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 01 Lun: 00
>   Vendor: SEAGATE  Model: ST19171W         Rev: 2219
>   Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 02 Lun: 00
>   Vendor: SEAGATE  Model: ST19171W         Rev: 2219
>   Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 03 Lun: 00
>   Vendor: SEAGATE  Model: ST19171W         Rev: 2224
>   Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 04 Lun: 00
>   Vendor: SEAGATE  Model: ST39173LC        Rev: 5702
>   Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 05 Lun: 00
>   Vendor: SEAGATE  Model: ST19171W         Rev: 2224
>   Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 06 Lun: 00
>   Vendor: DELL     Model: 6UW BACKPLANE    Rev: 7
>   Type:   Processor                        ANSI SCSI revision: 02
> Host: scsi1 Channel: 00 Id: 05 Lun: 00
>   Vendor: NEC      Model: CD-ROM DRIVE:464 Rev: 1.05
>   Type:   CD-ROM
> 
> 
> /proc/scsi/aic7xxx/0:
> Adaptec AIC7xxx driver version: 6.2.36
> Adaptec aic7880 Ultra SCSI adapter
> aic7880: Ultra Wide Channel A, SCSI Id=7, 16/253 SCBs
> Allocated SCBs: 36, SG List Length: 128
> 
> Serial EEPROM:
> 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338
> 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338
> 0x18b6 0x005e 0x2807 0x0010 0xff00 0xffff 0xffff 0xffff
> 0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x00ff 0x74a1
> 
> Target 0 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Goal: 20.000MB/s transfers (10.000MHz, offset 8, 16bit)
>         Curr: 20.000MB/s transfers (10.000MHz, offset 8, 16bit)
>         Channel A Target 0 Lun 0 Settings
>                 Commands Queued 1283
>                 Commands Active 0
>                 Command Openings 32
>                 Max Tagged Openings 32
>                 Device Queue Frozen Count 0
> Target 1 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Goal: 20.000MB/s transfers (10.000MHz, offset 8, 16bit)
>         Curr: 20.000MB/s transfers (10.000MHz, offset 8, 16bit)
>         Channel A Target 1 Lun 0 Settings
>                 Commands Queued 46
>                 Commands Active 0
>                 Command Openings 32
>                 Max Tagged Openings 32
>                 Device Queue Frozen Count 0
> Target 2 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Goal: 20.000MB/s transfers (10.000MHz, offset 8, 16bit)
>         Curr: 20.000MB/s transfers (10.000MHz, offset 8, 16bit)
>         Channel A Target 2 Lun 0 Settings
>                 Commands Queued 37
>                 Commands Active 0
>                 Command Openings 32
>                 Max Tagged Openings 32
>                 Device Queue Frozen Count 0
> Target 3 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Goal: 20.000MB/s transfers (10.000MHz, offset 8, 16bit)
>         Curr: 20.000MB/s transfers (10.000MHz, offset 8, 16bit)
>         Channel A Target 3 Lun 0 Settings
>                 Commands Queued 36
>                 Commands Active 0
>                 Command Openings 32
>                 Max Tagged Openings 32
>                 Device Queue Frozen Count 0
> Target 4 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Goal: 20.000MB/s transfers (10.000MHz, offset 8, 16bit)
>         Curr: 20.000MB/s transfers (10.000MHz, offset 8, 16bit)
>         Channel A Target 4 Lun 0 Settings
>                 Commands Queued 36
>                 Commands Active 0
>                 Command Openings 32
>                 Max Tagged Openings 32
>                 Device Queue Frozen Count 0
> Target 5 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Goal: 20.000MB/s transfers (10.000MHz, offset 8, 16bit)
>         Curr: 20.000MB/s transfers (10.000MHz, offset 8, 16bit)
>         Channel A Target 5 Lun 0 Settings
>                 Commands Queued 45
>                 Commands Active 0
>                 Command Openings 32
>                 Max Tagged Openings 32
>                 Device Queue Frozen Count 0
> Target 6 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Goal: 3.300MB/s transfers
>         Curr: 3.300MB/s transfers
>         Channel A Target 6 Lun 0 Settings
>                 Commands Queued 6
>                 Commands Active 0
>                 Command Openings 1
>                 Max Tagged Openings 0
>                 Device Queue Frozen Count 0
> Target 7 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 8 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 9 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 10 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 11 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 12 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 13 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 14 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 15 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> 
> 
> /proc/scsi/aic7xxx/1:
> Adaptec AIC7xxx driver version: 6.2.36
> Adaptec aic7860 Ultra SCSI adapter
> aic7860: Ultra Single Channel A, SCSI Id=7, 3/253 SCBs
> Allocated SCBs: 4, SG List Length: 128
> 
> Serial EEPROM:
> 0x0318 0x0318 0x0318 0x0318 0x0318 0x0318 0x0318 0x0318
> 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338
> 0x18b5 0x005e 0x2807 0x5008 0xff00 0xffff 0xffff 0xffff
> 0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x00ff 0xc398
> 
> Target 0 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
> Target 1 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
> Target 2 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
> Target 3 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
> Target 4 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
> Target 5 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
>         Goal: 10.000MB/s transfers (10.000MHz, offset 15)
>         Curr: 10.000MB/s transfers (10.000MHz, offset 15)
>         Channel A Target 5 Lun 0 Settings
>                 Commands Queued 16
>                 Commands Active 0
>                 Command Openings 1
>                 Max Tagged Openings 0
>                 Device Queue Frozen Count 0
> Target 6 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
> Target 7 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
> 
> 
> /proc/scsi/aic7xxx/0 - from kernel 2.6.12.6:
> 
> Adaptec AIC7xxx driver version: 6.2.36
> Adaptec aic7880 Ultra SCSI adapter
> aic7880: Ultra Wide Channel A, SCSI Id=7, 16/253 SCBs
> Allocated SCBs: 8, SG List Length: 128
> 
> Serial EEPROM:
> 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338
> 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338
> 0x18b6 0x005e 0x2807 0x0010 0xff00 0xffff 0xffff 0xffff
> 0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x00ff 0x74a1
> 
> Target 0 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Goal: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
>         Curr: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
>         Channel A Target 0 Lun 0 Settings
>                 Commands Queued 1459
>                 Commands Active 0
>                 Command Openings 32
>                 Max Tagged Openings 32
>                 Device Queue Frozen Count 0
> Target 1 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Goal: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
>         Curr: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
>         Channel A Target 1 Lun 0 Settings
>                 Commands Queued 48
>                 Commands Active 0
>                 Command Openings 32
>                 Max Tagged Openings 32
>                 Device Queue Frozen Count 0
> Target 2 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Goal: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
>         Curr: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
>         Channel A Target 2 Lun 0 Settings
>                 Commands Queued 38
>                 Commands Active 0
>                 Command Openings 32
>                 Max Tagged Openings 32
>                 Device Queue Frozen Count 0
> Target 3 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Goal: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
>         Curr: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
>         Channel A Target 3 Lun 0 Settings
>                 Commands Queued 37
>                 Commands Active 0
>                 Command Openings 32
>                 Max Tagged Openings 32
>                 Device Queue Frozen Count 0
> Target 4 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Goal: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
>         Curr: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
>         Channel A Target 4 Lun 0 Settings
>                 Commands Queued 37
>                 Commands Active 0
>                 Command Openings 32
>                 Max Tagged Openings 32
>                 Device Queue Frozen Count 0
> Target 5 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Goal: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
>         Curr: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
>         Channel A Target 5 Lun 0 Settings
>                 Commands Queued 47
>                 Commands Active 0
>                 Command Openings 32
>                 Max Tagged Openings 32
>                 Device Queue Frozen Count 0
> Target 6 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Goal: 3.300MB/s transfers
>         Curr: 3.300MB/s transfers
>         Channel A Target 6 Lun 0 Settings
>                 Commands Queued 6
>                 Commands Active 0
>                 Command Openings 1
>                 Max Tagged Openings 0
>                 Device Queue Frozen Count 0
> Target 7 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 8 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 9 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 10 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 11 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 12 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 13 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 14 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> Target 15 Negotiation Settings
>         User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
> 
> 
> /proc/scsi/aic7xxx/1 - from kernel 2.6.12.6:
> Adaptec AIC7xxx driver version: 6.2.36
> Adaptec aic7860 Ultra SCSI adapter
> aic7860: Ultra Single Channel A, SCSI Id=7, 3/253 SCBs
> Allocated SCBs: 4, SG List Length: 128
> 
> Serial EEPROM:
> 0x0318 0x0318 0x0318 0x0318 0x0318 0x0318 0x0318 0x0318
> 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338 0x0338
> 0x18b5 0x005e 0x2807 0x5008 0xff00 0xffff 0xffff 0xffff
> 0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x00ff 0xc398
> 
> Target 0 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
> Target 1 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
> Target 2 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
> Target 3 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
> Target 4 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
> Target 5 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
>         Goal: 20.000MB/s transfers (20.000MHz, offset 15)
>         Curr: 20.000MB/s transfers (20.000MHz, offset 15)
>         Channel A Target 5 Lun 0 Settings
>                 Commands Queued 16
>                 Commands Active 0
>                 Command Openings 1
>                 Max Tagged Openings 0
>                 Device Queue Frozen Count 0
> Target 6 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
> Target 7 Negotiation Settings
>         User: 20.000MB/s transfers (20.000MHz, offset 127)
> 
> Problem Description:
> If use kernel 2.6.13 or newer, all SCSI discs/cdrom work only on half 
> speed/frequency.
> 
> Steps to reproduce:
> Only boot... cat /proc/scsi/aic7xxx/0

