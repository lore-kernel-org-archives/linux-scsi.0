From: "James H. Cloos Jr." <cloos@jhcloos.com>
Subject: Re: libata driver update posted
Date: 19 Jul 2003 22:27:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3ispyx79n.fsf@lugabout.jhcloos.org>
References: <3F19A651.2080503@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ore.jhcloos.com ([64.240.156.239]:16901 "EHLO ore.jhcloos.com")
	by vger.kernel.org with ESMTP id S270596AbTGTCMH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jul 2003 22:12:07 -0400
In-Reply-To: <3F19A651.2080503@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

I gave this (pulled into linus' bk current) a try on my laptop.

It has this pata chip:

00:00.0 Host bridge: Intel Corp. 82815 815 Chipset Host Bridge and Memory Controller Hub (rev 04)
00:1f.1 IDE interface: Intel Corp. 82801BAM IDE U100 (rev 03)

aka

00:00.0 Class 0600: 8086:1130 (rev 04)
        Flags: bus master, fast devsel, latency 0
        Memory at e8000000 (32-bit, prefetchable) [size=64M]
00:1f.1 Class 0101: 8086:244a (rev 03)
        Subsystem: 8086:4541
        Flags: bus master, medium devsel, latency 0
        I/O ports at bfa0 [size=16]

I left out the regualt ide support and added:

CONFIG_SCSI_ATA=y
CONFIG_SCSI_ATA_PATA=y
CONFIG_SCSI_ATA_ATAPI=y
CONFIG_SCSI_ATA_PIIX=y

The laptop has its fixed drive at hda, its fixed cd/dvd at hdb and
its media bay drive (whatever may be installed) at hdc.

root=/dev/sda3 failed to find the root fs.

I don't have anything here to plug into the serial port, so I cannot
record the boot messages.  

Is my controller among the supported PIIX/ICH PATA chipsets?

-JimC

