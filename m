From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 13/20] qla2xxx: Fallback enode-mac should not be a multicast address.
Date: Wed,  3 Jun 2009 09:55:24 -0700
Message-ID: <1244048131-56590-14-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381AbZFCQzm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:42 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index cb4d952..4649b2a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4406,7 +4406,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		nv->max_luns_per_target = __constant_cpu_to_le16(128);
 		nv->port_down_retry_count = __constant_cpu_to_le16(30);
 		nv->link_down_timeout = __constant_cpu_to_le16(30);
-		nv->enode_mac[0] = 0x01;
+		nv->enode_mac[0] = 0x00;
 		nv->enode_mac[1] = 0x02;
 		nv->enode_mac[2] = 0x03;
 		nv->enode_mac[3] = 0x04;
-- 
1.6.3.1.244.gf9275

