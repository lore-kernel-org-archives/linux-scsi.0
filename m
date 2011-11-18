From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 11/18] qla2xxx: Corrected the display of firmware dump availability for ISP82xx.
Date: Fri, 18 Nov 2011 09:03:15 -0800
Message-ID: <1321635802-16491-12-git-send-email-chad.dupuis@qlogic.com>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:27394
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758089Ab1KRRQa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:16:30 -0500
In-Reply-To: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index ea62b71..e57837e 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3655,10 +3655,10 @@ qla82xx_check_md_needed(scsi_qla_host_t *vha)
 				qla82xx_md_free(vha);
 				/* ALlocate MiniDump resources */
 				qla82xx_md_prep(vha);
-			} else
-				ql_log(ql_log_info, vha, 0xb02e,
-				    "Firmware dump available to retrieve\n");
-		}
+			}
+		} else
+			ql_log(ql_log_info, vha, 0xb02e,
+			    "Firmware dump available to retrieve\n");
 	}
 	return rval;
 }
-- 
1.6.0.2


