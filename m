From: Tejun Heo <teheo@novell.com>
Subject: Re: Maybe Sorry for that but where should i write .)
Date: Wed, 02 Jan 2008 16:14:26 +0900
Message-ID: <477B39D2.6030201@novell.com>
References: <4775A7D8.6000001@trollprod.org> <477786B8.9040000@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <477786B8.9040000@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: thanatos <thanatos@trollprod.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> On Sat, Dec 29 2007 at 3:50 +0200, thanatos <thanatos@trollprod.org> wrote:
>> I got a sata controller  ignitio
>>
>>  00:11.0 SATA controller: Initio Corporation INI-1623 PCI SATA-II 
>> Controller (rev 02) (prog-if 00 [Vendor specific])
>>         Subsystem: Initio Corporation INI-1623 PCI SATA-II Controller
>>         Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 11
>>         I/O ports at dc00 [size=256]
>>         I/O ports at d800 [size=256]
>>         I/O ports at d400 [size=256]
>>         I/O ports at d000 [size=256]
>>         I/O ports at cc00 [size=256]
>>         Memory at cffff000 (32-bit, non-prefetchable) [size=4K]
>>         Expansion ROM at cff80000 [disabled] [size=256K]
>>         Capabilities: [dc] Power Management version 2
>>
>>
>> and an "no yet usable" 320 hdd, cause of lba48
>>
>> ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> ata3.00: HPA unlocked: 625142448 -> 625142448, native 18446744072354982576
>> ata3.00: ATA-8: SAMSUNG HD321KJ, CP100-12, max UDMA7
>> ata3.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 0/32)
>> ata3.00: ERROR: This driver doesn't support LBA48 yet and may cause
>>                 data corruption on such devices.  Disabling.
>> ata3.00: disabled
>>
>> i'm still on kernel 2.6.22. i had look on changelog 2.6.23 and even 
>> 2.6.24 nothing for that, is theyre a roadmap ?
>>
>> so if i could help in any way testing patch. i'm theyre
> 
> cc: the linux-scsi mailing list.
> 
> Personally I have nothing to do with this driver, I only sent a fix
> for a patch in 2.6.23

Actually, the correct mailing list is linux-ide.  Alan Cox began working
on the driver.  Cc'ing both.

Thanks.

-- 
tejun
