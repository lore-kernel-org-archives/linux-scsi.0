From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 6/6 2.6.29-rc] cxgb3i -- update the driver version to 1.0.1
Date: Fri, 13 Feb 2009 21:39:09 -0800
Message-ID: <200902140539.n1E5d9WI014359@localhost.localdomain>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


[PATCH v2 6/6 2.6.29-rc] cxgb3i - update the driver version to 1.0.1

From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Bump the driver version up to 1.0.1.

Signed-off-by: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---

 drivers/scsi/cxgb3i/cxgb3i_init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_init.c b/drivers/scsi/cxgb3i/cxgb3i_init.c
index 091ecb4..1ce9f24 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_init.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_init.c
@@ -12,8 +12,8 @@
 #include "cxgb3i.h"
 
 #define DRV_MODULE_NAME         "cxgb3i"
-#define DRV_MODULE_VERSION	"1.0.0"
-#define DRV_MODULE_RELDATE	"Jun. 1, 2008"
+#define DRV_MODULE_VERSION	"1.0.1"
+#define DRV_MODULE_RELDATE	"Jan. 2009"
 
 static char version[] =
 	"Chelsio S3xx iSCSI Driver " DRV_MODULE_NAME
