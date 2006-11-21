From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 3/3] aacraid: Driver version update
Date: Tue, 21 Nov 2006 10:40:50 -0800
Message-ID: <1164134450.18765.39.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:27532 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1031294AbWKUSky (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 13:40:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn:

Version patch, update to reflect a rough estimate of the Adaptec build
(2423) that coincides with the sources on kernel.org.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---

Applies to the scsi-misc-2.6 tree


--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2006-11-21 10:16:03.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2006-11-21 10:16:48.000000000 -0800
@@ -11,8 +11,8 @@
  *----------------------------------------------------------------------------*/
 
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 2409
-# define AAC_DRIVER_BRANCH "-mh2"
+# define AAC_DRIVER_BUILD 2423
+# define AAC_DRIVER_BRANCH "-mh3"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
 

-- 
Mark Haverkamp <markh@osdl.org>

