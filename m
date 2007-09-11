From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [patchset 0/24] Lots of the Accessors patches and !use_sg cleanup
Date: Tue, 11 Sep 2007 23:23:09 +0300
Message-ID: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:23259 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752254AbXIKU1M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 16:27:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew

Here are more accessors patches. I have tried
to find Maintainers of drivers but please help me if
I missed any.

After this there are 3 drivers left (I think)
- gdth.c, pluto.c, seagate.c
These I'll send only next week in a set of their own.
{Please tell me I can kill pluto and seagate.}

Some of the drivers that are not here were already posted by Tomo.
Some of the drivers here were posted before but these are better
versions of them.

[USB] - Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
	Matthew Dharm <mdharm-usb@one-eyed-alien.net>
0001- 	drivers/usb/storage/transport.c drivers/usb/storage/transport.h
0002- 	drivers/usb/storage/protocol.c
0003- 	drivers/usb/storage/shuttle_usbat.c
0004- 	drivers/usb/storage/freecom.c drivers/usb/storage/sddr09.c
0005 	drivers/usb/storage/isd200.c

[NCR5380 family] - ?
0006 	drivers/scsi/NCR5380.c drivers/scsi/atari_NCR5380.c
	drivers/scsi/sun3_NCR5380.c

[esp family] - Maciej W. Rozycki <macro@linux-mips.org>
0020 	drivers/scsi/NCR53C9x.c drivers/scsi/NCR53C9x.h
	drivers/scsi/dec_esp.c drivers/scsi/oktagon_esp.c
	drivers/scsi/sun3x_esp.c

[ARM] - Russell King <rmk@arm.linux.org.uk>
0007 	drivers/scsi/arm/acornscsi.c drivers/scsi/arm/scsi.h

[other drivers]
0008 	drivers/scsi/pcmcia/nsp_cs.c - YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
0009 	drivers/ata/libata-scsi.c - Jeff Garzik <jeff@garzik.org>
0010 	drivers/scsi/eata_pio.c - Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> ?
0011 	drivers/scsi/a2091.c - ?
0012 	drivers/scsi/a3000.c - ? 
0013 	drivers/scsi/aha1542.c - ? 
0014 	drivers/scsi/atp870u.c - ? 
0015 	drivers/scsi/fd_mcs.c - ? 
0016 	drivers/scsi/imm.c - ? 
0017 	drivers/scsi/in2000.c - ? 
0018 	drivers/scsi/ppa.c - ? 
0019 	drivers/scsi/wd33c93.c - ? 
0021 	drivers/scsi/qlogicpti.c - David S. Miller <davem@davemloft.net>, Mark Fortescue <mark@mtfhpc.demon.co.uk>
0024 	drivers/scsi/ide-scsi.c - Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

[remove psi240i.c driver] - ?
0022 	drivers/scsi/Kconfig drivers/scsi/Makefile   
	delete drivers/scsi/psi240i.c
	delete drivers/scsi/psi240i.h
	delete drivers/scsi/psi_chip.h

[fixes]
0023 	drivers/scsi/wd7000.c - ? 
