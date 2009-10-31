From: Martin Michlmayr <tbm@cyrius.com>
Subject: [PATCH] Add missing #include for include/scsi/osd_protocol.h
Date: Sat, 31 Oct 2009 09:33:37 +0000
Message-ID: <20091031093337.GA3339@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:60010 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbZJaJ6h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Oct 2009 05:58:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

include/scsi/osd_protocol.h is missing an #include, leading to:
| include/scsi/osd_protocol.h:277: error: implicit declaration of function '__constant_cpu_to_be16'
| include/scsi/osd_protocol.h:362: error: implicit declaration of function 'ALIGN'

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>

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
