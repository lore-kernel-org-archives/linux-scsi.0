From: Narsimhulu Musini <nmusini@cisco.com>
Subject: [PATCH 1/1] snic: Fixing duplicate cache names
Date: Thu, 25 Jun 2015 03:34:50 -0700
Message-ID: <1435228490-3996-1-git-send-email-nmusini@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-5.cisco.com ([173.37.142.92]:50900 "EHLO
	alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbbFYKkl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2015 06:40:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Narsimhulu Musini <nmusini@cisco.com>

This patch fixes duplicate cache names.

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
---
 drivers/scsi/snic/snic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index b2b87ce..47ed593 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -919,7 +919,7 @@ snic_global_data_init(void)
 	snic_glob->req_cache[SNIC_REQ_CACHE_MAX_SGL] = cachep;
 
 	len = sizeof(struct snic_host_req);
-	cachep = kmem_cache_create("snic_req_maxsgl", len, SNIC_SG_DESC_ALIGN,
+	cachep = kmem_cache_create("snic_tm_req", len, SNIC_SG_DESC_ALIGN,
 				   SLAB_HWCACHE_ALIGN, NULL);
 	if (!cachep) {
 		SNIC_ERR("Failed to create snic tm req slab\n");
-- 
1.8.5.4

