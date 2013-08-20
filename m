From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/9] scsi: Add CDB definition for COMPARE_AND_WRITE
Date: Tue, 20 Aug 2013 20:07:52 +0000
Message-ID: <1377029280-19144-2-git-send-email-nab@daterainc.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 include/scsi/scsi.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 4b87d99..6268062 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -144,6 +144,7 @@ enum scsi_timeouts {
 #define ACCESS_CONTROL_IN     0x86
 #define ACCESS_CONTROL_OUT    0x87
 #define READ_16               0x88
+#define COMPARE_AND_WRITE     0x89
 #define WRITE_16              0x8a
 #define READ_ATTRIBUTE        0x8c
 #define WRITE_ATTRIBUTE	      0x8d
-- 
1.7.10.4
