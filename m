From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 9/9] osd_protocol.h: Add missing #include
Date: Mon, 16 Nov 2009 20:49:25 +0200
Message-ID: <1258397365-356-1-git-send-email-bharrosh@panasas.com>
References: <4B019BEC.3080909@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:35512 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753551AbZKPSww (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2009 13:52:52 -0500
In-Reply-To: <4B019BEC.3080909@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>
Cc: Martin Michlmayr <tbm@cyrius.com>

From: Martin Michlmayr <tbm@cyrius.com>

include/scsi/osd_protocol.h uses ALIGN() without an #include
<linux/kernel.h>, leading to:
| include/scsi/osd_protocol.h:362: error: implicit declaration of function 'ALIGN'

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 include/scsi/osd_protocol.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
index 2cc8e8b..6856612 100644
--- a/include/scsi/osd_protocol.h
+++ b/include/scsi/osd_protocol.h
@@ -17,6 +17,7 @@
 #define __OSD_PROTOCOL_H__
 
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
 
-- 
1.6.5.2

