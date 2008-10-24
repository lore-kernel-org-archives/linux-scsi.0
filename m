From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Subject: [Re: Linux 2.6.28-rc1] scsi 4:0:0:0: timing out command, waited 22s
Date: Fri, 24 Oct 2008 19:57:03 +0200
Message-ID: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

During boot I have this message:

ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x60a0 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60a8 irq 15
ata5.00: ATAPI: MATSHITADVD-RAM UJ-840S, 1.11, max MWDMA2
ata5.00: configured for MWDMA2
ata6: port disabled. ignoring.
scsi 4:0:0:0: timing out command, waited 22s
scsi 4:0:0:0: timing out command, waited 22s
scsi 4:0:0:0: timing out command, waited 22s
scsi 4:0:0:0: timing out command, waited 22s
scsi 4:0:0:0: timing out command, waited 22s
scsi 4:0:0:0: timing out command, waited 22s
	ata5: WARNING: synchronous SCSI scan failed without making any progress,
                  switching to async

DVD drive doesn't work. Under 2.6.27 (stable and -rc) works OK.

Dmesg ang config:
http://unixy.pl/maciek/download/kernel/2.6.28-rc1/

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
