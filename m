From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 28/42] qla2xxx: Clear loop_id for ports that are marked lost during fabric scanning.
Date: Fri, 11 Apr 2014 16:54:33 -0400
Message-ID: <1397249687-32666-29-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:32799 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754930AbaDKVcD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:03 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3260ec5..2d97d7c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3407,7 +3407,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 					    fcport->d_id.b.domain,
 					    fcport->d_id.b.area,
 					    fcport->d_id.b.al_pa);
-					fcport->loop_id = FC_NO_LOOP_ID;
+					qla2x00_clear_loop_id(fcport);
 				}
 			}
 		}
-- 
1.7.7

