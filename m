From: vikas.chaudhary@qlogic.com
Subject: [PATCH 2/4] libiscsi: export function iscsi_switch_str_param
Date: Fri, 22 Mar 2013 07:41:30 -0400
Message-ID: <1363952492-16205-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1363952492-16205-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:41554 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753223Ab3CVMEN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Mar 2013 08:04:13 -0400
In-Reply-To: <1363952492-16205-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, poornima.vonti@qlogic.com, manish.rangankar@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/libiscsi.c |    3 ++-
 include/scsi/libiscsi.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 82c3fd4..d5e5c44 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3142,7 +3142,7 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_bind);
 
-static int iscsi_switch_str_param(char **param, char *new_val_buf)
+int iscsi_switch_str_param(char **param, char *new_val_buf)
 {
 	char *new_val;
 
@@ -3159,6 +3159,7 @@ static int iscsi_switch_str_param(char **param, char *new_val_buf)
 	*param = new_val;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(iscsi_switch_str_param);
 
 int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 		    enum iscsi_param param, char *buf, int buflen)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 6e33386..09c041e 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -427,6 +427,7 @@ extern void iscsi_complete_scsi_task(struct iscsi_task *task,
  */
 extern void iscsi_pool_free(struct iscsi_pool *);
 extern int iscsi_pool_init(struct iscsi_pool *, int, void ***, int);
+extern int iscsi_switch_str_param(char **, char *);
 
 /*
  * inline functions to deal with padding.
-- 
1.7.1

