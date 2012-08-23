From: <kgudipat@brocade.com>
Subject: [PATCH 04/10] bfa: Add new hardware model info to sysfs model description routine.
Date: Wed, 22 Aug 2012 19:51:35 -0700
Message-ID: <1345690295-21148-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:43466 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757235Ab2HWCwJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 22:52:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Added new hardware model Brocade-1867 information to
	  sysfs model description routine.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad_attr.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 91a2044..72f5dc3 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -824,6 +824,13 @@ bfad_im_model_desc_show(struct device *dev, struct device_attribute *attr,
 		else if (nports == 2 && !bfa_ioc_is_cna(&bfad->bfa.ioc))
 			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
 				"Brocade 16Gbps PCIe dual port FC HBA");
+	} else if (!strcmp(model, "Brocade-1867")) {
+		if (nports == 1 && !bfa_ioc_is_cna(&bfad->bfa.ioc))
+			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+				"Brocade 16Gbps PCIe single port FC HBA for IBM");
+		else if (nports == 2 && !bfa_ioc_is_cna(&bfad->bfa.ioc))
+			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+				"Brocade 16Gbps PCIe dual port FC HBA for IBM");
 	} else
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
 			"Invalid Model");
-- 
1.7.3.rc1

