From: Ali Akcaagac <aliakc@web.de>
Subject: [PATCH]: 2.6.0-test2-bk1 SCSI dc395x compile problem
Date: Fri, 01 Aug 2003 15:01:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059742864.30594.10.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-DQjPovcJR9f0fhkwC4wx"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp02.web.de ([217.72.192.151]:25123 "EHLO smtp.web.de")
	by vger.kernel.org with ESMTP id S270753AbTHANBE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2003 09:01:04 -0400
Received: from [80.130.17.164] (helo=p508211A4.dip.t-dialin.net)
	by smtp.web.de with esmtp (WEB.DE 4.99 #433)
	id 19iZWp-0002fd-00
	for linux-scsi@vger.kernel.org; Fri, 01 Aug 2003 15:01:04 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-DQjPovcJR9f0fhkwC4wx
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello,

I'm besides 2 others one of the Maintainers of the SCSI DC395x SCSI
driver and I found a little 1 char problem during the merge from the AC
tree to the official BK tree which causes a compile issue.

Here is a little fix for the 2.6.0-test2-bk1 that allows compiling
correctly. I would be thankful if this patch can be included in an
upcoming bk2 or test3 release.

--=-DQjPovcJR9f0fhkwC4wx
Content-Disposition: attachment; filename=dc395x.c.patch
Content-Type: text/x-patch; name=dc395x.c.patch; charset=iso-8859-15
Content-Transfer-Encoding: 7bit

--- linux-2.6.0-test2-bk1/drivers/scsi/dc395x.c.bak	2003-08-01 14:32:05.000000000 +0200
+++ linux-2.6.0-test2-bk1/drivers/scsi/dc395x.c	2003-08-01 14:46:26.247629416 +0200
@@ -5890,7 +5890,7 @@
 	pci_set_drvdata(dev, scsi_host);
 
 	/* get the scsi mid level to scan for new devices on the bus */
-	scsi_add_host(scsi_host, &pdev->dev);	/* XXX handle failure */
+	scsi_add_host(scsi_host, &dev->dev);	/* XXX handle failure */
 	scsi_scan_host(scsi_host);
 
 	return 0;

--=-DQjPovcJR9f0fhkwC4wx--

