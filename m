From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [PATCH 2.4.12.5 2/2] include/linux: enclose idr.h in #ifndef
Date: Tue, 16 Aug 2005 17:56:02 -0400
Message-ID: <430260F2.9000100@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:17597 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750986AbVHPV4O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2005 17:56:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Dave Jones <davej@redhat.com>, Jeff Garzik <jgarzik@pobox.com>, Jim Houston <jim.houston@ccur.com>

Hi,

This patch encloses the idr.h header file in
#ifndef __IDR_H__ macro.

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

--- linux-2.6.12.5/include/linux/idr.h.old	2005-08-16 17:20:15.000000000 -0400
+++ linux-2.6.12.5/include/linux/idr.h	2005-08-16 17:21:11.000000000 -0400
@@ -8,6 +8,10 @@
  * Small id to pointer translation service avoiding fixed sized
  * tables.
  */
+
+#ifndef __IDR_H__
+#define __IDR_H__
+
 #include <linux/types.h>
 #include <linux/bitops.h>
 
@@ -76,3 +80,5 @@
 int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
 void idr_remove(struct idr *idp, int id);
 void idr_init(struct idr *idp);
+
+#endif /* __IDR_H__ */
