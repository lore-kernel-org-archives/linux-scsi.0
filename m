From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] dmx3191d: Coding style police
Date: Fri, 22 Jun 2007 14:24:56 +0100
Message-ID: <20070622142456.0dff942f@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34828 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751134AbXFVNTI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2007 09:19:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com


Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc4-mm2/drivers/scsi/dmx3191d.c linux-2.6.22-rc4-mm2/drivers/scsi/dmx3191d.c
--- linux.vanilla-2.6.22-rc4-mm2/drivers/scsi/dmx3191d.c	2007-06-07 14:24:28.000000000 +0100
+++ linux-2.6.22-rc4-mm2/drivers/scsi/dmx3191d.c	2007-06-14 13:48:18.000000000 +0100
@@ -113,13 +113,13 @@
 	scsi_scan_host(shost);
 	return 0;
 
- out_free_irq:
+out_free_irq:
 	free_irq(shost->irq, shost);
- out_release_region:
+out_release_region:
 	release_region(io, DMX3191D_REGION_LEN);
- out_disable_device:
+out_disable_device:
 	pci_disable_device(pdev);
- out:
+out:
 	return error;
 }
 
