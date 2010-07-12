From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 06/20] be2iscsi: Fix for return type of mgmt_epfw_cleanup
Date: Mon, 12 Jul 2010 23:22:12 +0530
Message-ID: <20100712175201.GA11489@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:31717 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755852Ab0GLRwI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2010 13:52:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

        The return type for mgmt_epfw_cleanup is int and
 this patch fixes it

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 8552ee5..3ad3b59 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3294,7 +3294,7 @@ static void hwi_purge_eq(struct beiscsi_hba *phba)
 
 static void beiscsi_clean_port(struct beiscsi_hba *phba)
 {
-	unsigned char mgmt_status;
+	int  mgmt_status;
 
 	mgmt_status = mgmt_epfw_cleanup(phba, CMD_CONNECTION_CHUTE_0);
 	if (mgmt_status)
-- 
1.6.5.2

