From: Alexander Nyberg <alexn@dsv.su.se>
Subject: Old broken drivers
Date: Thu, 02 Dec 2004 13:31:48 +0100
Message-ID: <1101990708.713.15.camel@boxen>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailfe02.swip.net ([212.247.154.33]:36786 "EHLO
	mailfe02.swip.net") by vger.kernel.org with ESMTP id S261584AbULBMdH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Dec 2004 07:33:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andmike@us.ibm.com, mikenc@us.ibm.com, hch@infradead.org

Hi

The following drivers have been broken since at least 2.5.53:
drivers/net/fc/iph5526.c
drivers/scsi/pci2000.c
drivers/scsi/pci2220i.c

Furthermore they have a coding style which doesn't look like the rest of
the kernel.

I'm suggesting a removal of them in the 2.6 series and if anyone wishes
to add them back fine. If noone has anything against this I will send
patches to remove them.


The relevant bug reports:
http://bugme.osdl.org/show_bug.cgi?id=201

http://bugme.osdl.org/show_bug.cgi?id=213

http://bugme.osdl.org/show_bug.cgi?id=215

