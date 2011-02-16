From: michaelc@cs.wisc.edu
Subject: [PATCH 08/17] cxgbi: enable TEXT PDU support
Date: Wed, 16 Feb 2011 15:04:32 -0600
Message-ID: <1297890281-9076-9-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab1BPVEg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:36 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4aUM021093
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:36 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tsv004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:35 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

cxgb3i and cxgb4i support TEXT PDU offloading, so set
the bits to enable it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |    2 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index e2362b9..69a6769 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -105,7 +105,7 @@ static struct iscsi_transport cxgb3i_iscsi_transport = {
 	/* owner and name should be set already */
 	.caps		= CAP_RECOVERY_L0 | CAP_MULTI_R2T | CAP_HDRDGST
 				| CAP_DATADGST | CAP_DIGEST_OFFLOAD |
-				CAP_PADDING_OFFLOAD,
+				CAP_PADDING_OFFLOAD | CAP_TEXT_NEGO,
 	.param_mask	= ISCSI_MAX_RECV_DLENGTH | ISCSI_MAX_XMIT_DLENGTH |
 				ISCSI_HDRDGST_EN | ISCSI_DATADGST_EN |
 				ISCSI_INITIAL_R2T_EN | ISCSI_MAX_R2T |
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 5b1f078..719aa71 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -106,7 +106,7 @@ static struct iscsi_transport cxgb4i_iscsi_transport = {
 	.name		= DRV_MODULE_NAME,
 	.caps		= CAP_RECOVERY_L0 | CAP_MULTI_R2T | CAP_HDRDGST |
 				CAP_DATADGST | CAP_DIGEST_OFFLOAD |
-				CAP_PADDING_OFFLOAD,
+				CAP_PADDING_OFFLOAD | CAP_TEXT_NEGO,
 	.param_mask	= ISCSI_MAX_RECV_DLENGTH | ISCSI_MAX_XMIT_DLENGTH |
 				ISCSI_HDRDGST_EN | ISCSI_DATADGST_EN |
 				ISCSI_INITIAL_R2T_EN | ISCSI_MAX_R2T |
-- 
1.7.2.3

