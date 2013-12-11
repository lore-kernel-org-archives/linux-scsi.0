From: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/3] BNX2FC: Updated version to 2.4.2
Date: Wed, 11 Dec 2013 15:30:23 -0800
Message-ID: <1386804623-22376-3-git-send-email-eddie.wai@broadcom.com>
References: <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: fcoe-devel <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Old version: 2.4.1
New version: 2.4.2

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 2e984e3..6a97665 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -64,7 +64,7 @@
 #include "bnx2fc_constants.h"
 
 #define BNX2FC_NAME		"bnx2fc"
-#define BNX2FC_VERSION		"2.4.1"
+#define BNX2FC_VERSION		"2.4.2"
 
 #define PFX			"bnx2fc: "
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 4cabd3e..6287f6a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -22,7 +22,7 @@ DEFINE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
 
 #define DRV_MODULE_NAME		"bnx2fc"
 #define DRV_MODULE_VERSION	BNX2FC_VERSION
-#define DRV_MODULE_RELDATE	"Sep 17, 2013"
+#define DRV_MODULE_RELDATE	"Dec 11, 2013"
 
 
 static char version[] =
-- 
1.7.1
