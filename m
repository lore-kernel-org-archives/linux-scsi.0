From: michaelc@cs.wisc.edu
Subject: [PATCH 05/17] be2iscsi:Fix typo function name mismatch
Date: Tue, 20 Mar 2012 20:47:56 -0500
Message-ID: <1332294488-13684-6-git-send-email-michaelc@cs.wisc.edu>
References: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030355Ab2CUBsc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 21:48:32 -0400
In-Reply-To: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Minh Tran <MinhDuc.Tran@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

Signed-off-by: Minh Tran <MinhDuc.Tran@Emulex.Com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 33c8f09..2bb681e 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -221,7 +221,7 @@ int beiscsi_ep_get_param(struct iscsi_endpoint *ep,
 	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
 	int len = 0;
 
-	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_get_param, param= %d\n", param);
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_ep_get_param, param= %d\n", param);
 
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
-- 
1.7.7.6

