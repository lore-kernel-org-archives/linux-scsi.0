From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 03/18] bnx2fc: Enable bsg_request support for bnx2fc
Date: Thu, 4 Aug 2011 11:46:58 -0700
Message-ID: <1312483633-479-4-git-send-email-bprakash@broadcom.com>
References: <1312483633-479-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1331 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab1HDSr0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 14:47:26 -0400
In-Reply-To: <1312483633-479-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index a4770d9..9e2bf39 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2378,6 +2378,7 @@ static struct fc_function_template bnx2fc_transport_function = {
 	.vport_create = bnx2fc_vport_create,
 	.vport_delete = bnx2fc_vport_destroy,
 	.vport_disable = bnx2fc_vport_disable,
+	.bsg_request = fc_lport_bsg_request,
 };
 
 static struct fc_function_template bnx2fc_vport_xport_function = {
@@ -2411,6 +2412,7 @@ static struct fc_function_template bnx2fc_vport_xport_function = {
 	.get_fc_host_stats = fc_get_host_stats,
 	.issue_fc_host_lip = bnx2fc_fcoe_reset,
 	.terminate_rport_io = fc_rport_terminate_io,
+	.bsg_request = fc_lport_bsg_request,
 };
 
 /**
-- 
1.7.0.6


