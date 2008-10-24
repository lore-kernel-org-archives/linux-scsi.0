From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Re: Linux 2.6.28-rc1] scsi 4:0:0:0: timing out command, waited 22s
Date: Fri, 24 Oct 2008 20:05:25 +0200
Message-ID: <200810242005.26328.rjw@sisk.pl>
References: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757847AbYJXSBT@vger.kernel.org>
In-Reply-To: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Friday, 24 of October 2008, Maciej Rutecki wrote:
> During boot I have this message:
> 
> ata_piix 0000:00:1f.1: version 2.12
> ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> ata_piix 0000:00:1f.1: setting latency timer to 64
> scsi4 : ata_piix
> scsi5 : ata_piix
> ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x60a0 irq 14
> ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60a8 irq 15
> ata5.00: ATAPI: MATSHITADVD-RAM UJ-840S, 1.11, max MWDMA2
> ata5.00: configured for MWDMA2
> ata6: port disabled. ignoring.
> scsi 4:0:0:0: timing out command, waited 22s
> scsi 4:0:0:0: timing out command, waited 22s
> scsi 4:0:0:0: timing out command, waited 22s
> scsi 4:0:0:0: timing out command, waited 22s
> scsi 4:0:0:0: timing out command, waited 22s
> scsi 4:0:0:0: timing out command, waited 22s
> 	ata5: WARNING: synchronous SCSI scan failed without making any progress,
>                   switching to async
> 
> DVD drive doesn't work. Under 2.6.27 (stable and -rc) works OK.
> 
> Dmesg ang config:
> http://unixy.pl/maciek/download/kernel/2.6.28-rc1/

Fixed in the Linus' tree:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e013e13bf605b9e6b702adffbe2853cfc60e7806

Thanks,
Rafael
