From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH v2 09/11] qla2xxx: Enable T10-DIF for ISP27XX
Date: Wed, 27 Jan 2016 12:03:36 -0500
Message-ID: <1453914218-380-10-git-send-email-himanshu.madhani@qlogic.com>
References: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:7270 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933780AbcA0RqB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 12:46:01 -0500
In-Reply-To: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d94a236..fa017e9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2217,6 +2217,7 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
 		ha->device_type |= DT_IIDMA;
+		ha->device_type |= DT_T10_PI;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2271:
@@ -2224,6 +2225,7 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
 		ha->device_type |= DT_IIDMA;
+		ha->device_type |= DT_T10_PI;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2261:
@@ -2231,6 +2233,7 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->device_type |= DT_ZIO_SUPPORTED;
 		ha->device_type |= DT_FWI2;
 		ha->device_type |= DT_IIDMA;
+		ha->device_type |= DT_T10_PI;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	}
-- 
1.7.7

