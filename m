From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5/5] mptscsih: Fix first line of kernel-doc for a few
 functions
Date: Sun, 14 Feb 2010 14:21:11 +0000
Message-ID: <1266157271.10567.17.camel@localhost>
References: <1266157055.10567.13.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1266157055.10567.13.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

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
