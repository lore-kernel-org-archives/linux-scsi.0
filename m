From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ipr: add message to error table
Date: Fri, 23 Jan 2009 09:17:37 -0800
Message-ID: <4979FBB1.8050103@linux.vnet.ibm.com>
References: <20090123165823.748742817@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39161 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbZAWRRj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2009 12:17:39 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n0NHG6Db031186
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2009 12:16:06 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0NHHcFm168316
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2009 12:17:38 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n0NHHclP007295
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2009 12:17:38 -0500
Received: from jwb.beaverton.ibm.com (wboyer.beaverton.ibm.com [9.47.17.47])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id n0NHHbSS007285
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2009 12:17:37 -0500
In-Reply-To: <20090123165823.748742817@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Adds a message to the error table for an error that wasn't previously handled.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/drivers/scsi/ipr.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ipr.c	2009-01-22 15:50:59.000000000 -0800
+++ linux-2.6/drivers/scsi/ipr.c	2009-01-23 08:55:23.000000000 -0800
@@ -354,6 +354,8 @@
 	"9076: Configuration error, missing remote IOA"},
 	{0x06679100, 0, IPR_DEFAULT_LOG_LEVEL,
 	"4050: Enclosure does not support a required multipath function"},
+	{0x06690000, 0, IPR_DEFAULT_LOG_LEVEL,
+	"4070: Logically bad written to device"},
 	{0x06690200, 0, IPR_DEFAULT_LOG_LEVEL,
 	"9041: Array protection temporarily suspended"},
 	{0x06698200, 0, IPR_DEFAULT_LOG_LEVEL,

