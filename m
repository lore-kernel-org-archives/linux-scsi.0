From: Martin Michlmayr <tbm@cyrius.com>
Subject: [PATCH] osd_protocol.h: Add missing #include
Date: Wed, 11 Nov 2009 15:14:30 +0000
Message-ID: <20091111151430.GA3515@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:44675 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940AbZKKPOe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2009 10:14:34 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

include/scsi/osd_protocol.h uses ALIGN() without an #include
<linux/kernel.h>, leading to:
| include/scsi/osd_protocol.h:362: error: implicit declaration of function 'ALIGN'

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Acked-by: Boaz Harrosh <bharrosh@panasas.com>

--- a/include/scsi/osd_protocol.h	2009-10-31 09:19:28.000000000 +0000
+++ b/include/scsi/osd_protocol.h	2009-10-31 09:27:42.000000000 +0000
@@ -17,6 +17,7 @@
 #define __OSD_PROTOCOL_H__
 
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
 

-- 
Martin Michlmayr
http://www.cyrius.com/
