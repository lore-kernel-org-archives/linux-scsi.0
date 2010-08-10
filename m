From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ipr: Driver version 2.5.1
Date: Tue, 10 Aug 2010 09:13:00 -0700
Message-ID: <4C617A8C.9020005@linux.vnet.ibm.com>
References: <20100810160721.438853503@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55952 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326Ab0HJQNC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2010 12:13:02 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o7AFw2JE019178
	for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2010 11:58:02 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o7AGD29l022870
	for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2010 12:13:02 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o7AGD1MK017853
	for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2010 13:13:02 -0300
In-Reply-To: <20100810160721.438853503@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

Bump the driver version.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2010-08-10 09:02:48.000000000 -0700
+++ b/drivers/scsi/ipr.h	2010-08-10 09:04:35.000000000 -0700
@@ -37,8 +37,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.5.0"
-#define IPR_DRIVER_DATE "(February 11, 2010)"
+#define IPR_DRIVER_VERSION "2.5.1"
+#define IPR_DRIVER_DATE "(August 10, 2010)"

 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding

