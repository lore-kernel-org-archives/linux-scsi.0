From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic7xxx/aic79xx: remove useless byte order macro cruft
Date: Sat, 11 Jun 2005 00:26:00 +0200
Message-ID: <20050610222600.GA8890@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:1716 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261289AbVFJW0C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 18:26:02 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm.h	2005-05-31 17:29:48.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm.h	2005-06-11 00:23:07.000000000 +0200
@@ -112,23 +112,6 @@
 #define ahd_le32toh(x)	le32_to_cpu(x)
 #define ahd_le64toh(x)	le64_to_cpu(x)
 
-#ifndef LITTLE_ENDIAN
-#define LITTLE_ENDIAN 1234
-#endif
-
-#ifndef BIG_ENDIAN
-#define BIG_ENDIAN 4321
-#endif
-
-#ifndef BYTE_ORDER
-#if defined(__BIG_ENDIAN)
-#define BYTE_ORDER BIG_ENDIAN
-#endif
-#if defined(__LITTLE_ENDIAN)
-#define BYTE_ORDER LITTLE_ENDIAN
-#endif
-#endif /* BYTE_ORDER */
-
 /************************* Configuration Data *********************************/
 extern uint32_t aic79xx_allow_memio;
 extern int aic79xx_detect_complete;
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-06-11 00:03:21.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-06-11 00:22:55.000000000 +0200
@@ -129,23 +129,6 @@
 #define ahc_le32toh(x)	le32_to_cpu(x)
 #define ahc_le64toh(x)	le64_to_cpu(x)
 
-#ifndef LITTLE_ENDIAN
-#define LITTLE_ENDIAN 1234
-#endif
-
-#ifndef BIG_ENDIAN
-#define BIG_ENDIAN 4321
-#endif
-
-#ifndef BYTE_ORDER
-#if defined(__BIG_ENDIAN)
-#define BYTE_ORDER BIG_ENDIAN
-#endif
-#if defined(__LITTLE_ENDIAN)
-#define BYTE_ORDER LITTLE_ENDIAN
-#endif
-#endif /* BYTE_ORDER */
-
 /************************* Configuration Data *********************************/
 extern u_int aic7xxx_no_probe;
 extern u_int aic7xxx_allow_memio;
