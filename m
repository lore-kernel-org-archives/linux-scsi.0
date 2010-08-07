From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH] qla4xxx: fix compilation warning
Date: Sat, 7 Aug 2010 13:42:38 +0530
Message-ID: <1281168758-13751-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: sfr@canb.auug.org.au, James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, ravi.anand@qlogic.com, karen.higgins@qlogic.com, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Fix following warning:

drivers/scsi/qla4xxx/ql4_nx.c: In function 'qla4_8xxx_get_flash_info':
drivers/scsi/qla4xxx/ql4_nx.c:1952: warning: 'mid' may be used uninitialized in this function
drivers/scsi/qla4xxx/ql4_nx.c:1952: note: 'mid' was declared here
drivers/scsi/qla4xxx/ql4_nx.c:1952: warning: 'fid' may be used uninitialized in this function
drivers/scsi/qla4xxx/ql4_nx.c:1952: note: 'fid' was declared here

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/qla4xxx/ql4_nx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 1b85235..e031a73 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1953,7 +1953,8 @@ qla4_8xxx_get_fdt_info(struct scsi_qla_host *ha)
 	uint16_t cnt, chksum;
 	uint16_t *wptr;
 	struct qla_fdt_layout *fdt;
-	uint16_t mid, fid;
+	uint16_t mid = 0;
+	uint16_t fid = 0;
 	struct ql82xx_hw_data *hw = &ha->hw;
 
 	hw->flash_conf_off = FARX_ACCESS_FLASH_CONF;
-- 
1.7.0.5
