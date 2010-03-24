From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH RESEND] mptscsih: Fix first line of kernel-doc for a few
 functions
Date: Wed, 24 Mar 2010 04:27:59 +0000
Message-ID: <1269404879.18314.276.camel@localhost>
References: <1266157055.10567.13.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55321 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061Ab0CXE2J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2010 00:28:09 -0400
In-Reply-To: <1266157055.10567.13.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Eric Moore <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org

The function name must be followed by a space, hypen, space, and a
short description.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/message/fusion/mptscsih.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 4a7d1af..53516ed 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2560,9 +2560,7 @@ mptscsih_getclear_scsi_lookup(MPT_ADAPTER *ioc, int i)
 }
 
 /**
- * mptscsih_set_scsi_lookup
- *
- * writes a scmd entry into the ScsiLookup[] array list
+ * mptscsih_set_scsi_lookup - write a scmd entry into the ScsiLookup[] array list
  *
  * @ioc: Pointer to MPT_ADAPTER structure
  * @i: index into the array
@@ -2725,7 +2723,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req,
 

 /**
- *	mptscsih_get_completion_code -
+ *	mptscsih_get_completion_code - get completion code from MPT request
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@req: Pointer to original MPT request frame
  *	@reply: Pointer to MPT reply frame (NULL if TurboReply)
-- 
1.6.6.2


