From: michaelc@cs.wisc.edu
Subject: [PATCH 6/7] iser: set tgt and lu reset timeout
Date: Wed, 11 Nov 2009 16:34:35 -0600
Message-ID: <1257978876-2742-7-git-send-email-michaelc@cs.wisc.edu>
References: <1257978876-2742-1-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-2-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-3-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-4-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-5-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-6-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759468AbZKKWel (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Nov 2009 17:34:41 -0500
In-Reply-To: <1257978876-2742-6-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

When iser enabled lu reset support it did not set the
bit to allow userspace to get/set the timeout. This
sets the tgt and lu reset timeout bits.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index add9188..5f7a6fc 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -625,6 +625,7 @@ static struct iscsi_transport iscsi_iser_transport = {
 				  ISCSI_USERNAME | ISCSI_PASSWORD |
 				  ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN |
 				  ISCSI_FAST_ABORT | ISCSI_ABORT_TMO |
+				  ISCSI_LU_RESET_TMO | ISCSI_TGT_RESET_TMO |
 				  ISCSI_PING_TMO | ISCSI_RECV_TMO |
 				  ISCSI_IFACE_NAME | ISCSI_INITIATOR_NAME,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
-- 
1.6.2.2

