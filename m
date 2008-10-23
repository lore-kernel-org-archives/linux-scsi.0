From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: remove severly outdated comment in scsi_dispatch_cmd
Date: Thu, 23 Oct 2008 20:01:26 +0200
Message-ID: <20081023180126.GA24914@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:40179 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbYJWSB3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2008 14:01:29 -0400
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m9NI1QIF024944
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2008 20:01:26 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m9NI1QPr024942
	for linux-scsi@vger.kernel.org; Thu, 23 Oct 2008 20:01:26 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/scsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi.c	2008-10-11 09:53:20.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi.c	2008-10-11 09:53:41.000000000 +0200
@@ -651,10 +651,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	unsigned long timeout;
 	int rtn = 0;
 
-	/*
-	 * We will use a queued command if possible, otherwise we will
-	 * emulate the queuing and calling of completion function ourselves.
-	 */
 	atomic_inc(&cmd->device->iorequest_cnt);
 
 	/* check if the device is still usable */
