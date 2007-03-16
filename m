From: Horms <horms@verge.net.au>
Subject: [PATCH 1/2] fusion - removed unnecessary code in mptscsih_resume()
Date: Fri, 16 Mar 2007 16:05:22 +0900
Message-ID: <20070316070521.GB1081@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from koto.vergenet.net ([210.128.90.7]:45755 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbXCPH6m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Mar 2007 03:58:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org
Cc: Eric Moore <Eric.Moore@lsi.com>

It seems that most of the code in mptscsih_resume() doesn't
do anything. This patch removes that code.

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/drivers/message/fusion/mptscsih.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptscsih.c	2007-03-16 14:47:18.000000000 +0900
+++ linux-2.6/drivers/message/fusion/mptscsih.c	2007-03-16 14:48:53.000000000 +0900
@@ -1188,19 +1188,7 @@
 int
 mptscsih_resume(struct pci_dev *pdev)
 {
-	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
-	struct Scsi_Host 	*host = ioc->sh;
-	MPT_SCSI_HOST		*hd;
-
 	mpt_resume(pdev);
-
-	if(!host)
-		return 0;
-
-	hd = (MPT_SCSI_HOST *)host->hostdata;
-	if(!hd)
-		return 0;
-
 	return 0;
 }
 
