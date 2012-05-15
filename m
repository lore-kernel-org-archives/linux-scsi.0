From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 11/22] qla2xxx: Display proper supported speeds for 16G FC adapters.
Date: Tue, 15 May 2012 14:34:18 -0400
Message-ID: <1337106869-14191-12-git-send-email-chad.dupuis@qlogic.com>
References: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:36924 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S966422Ab2EOS5Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2012 14:57:25 -0400
In-Reply-To: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 6464518..f8d7692 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1956,6 +1956,9 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
 
 	if (IS_CNA_CAPABLE(ha))
 		speed = FC_PORTSPEED_10GBIT;
+	else if (IS_QLA2031(ha))
+		speed = FC_PORTSPEED_16GBIT | FC_PORTSPEED_8GBIT |
+		    FC_PORTSPEED_4GBIT;
 	else if (IS_QLA25XX(ha))
 		speed = FC_PORTSPEED_8GBIT | FC_PORTSPEED_4GBIT |
 		    FC_PORTSPEED_2GBIT | FC_PORTSPEED_1GBIT;
-- 
1.7.7

