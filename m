Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FDE12C544;
	Mon,  1 Dec 2025 11:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764587242; cv=none; b=jjYYmVvQuJAVofUoS/Re1I+BGiol7DbdiNixuCi8dyDBftdEkjq/IDWMW4WN3O6/NeZ1m8v/5nqF7h7oA2u+cwvRNHFPXrLCp5i5F0m0o1YyfrQmUAORg3HImzbWOAKqY2XSM2190jgshqSZGJom05fxPISrMrcMT8gtYPFGLbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764587242; c=relaxed/simple;
	bh=vyIM4NVkw3NIwezHVqp5JvDRZ6N6LuFrYfCdj+FRDac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kp8mY6bFhO5oU6Gun2iYSbztYNvEd4Alvp8sarhjaowrEwXG4Bt+ujkIHrpgFYmXYGBWYpbEVAgK2SgCsJoG6BBoYCPHXJ1hfHmdnBWfHKwyz5XnFoTbUsFZ4384EZ5Aj/GLgDDMwrLtoP5eOLsTlFEzbOC/bAWnhKvnnYZMYtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I6dcxRy7; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I6dcxRy7"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B18mXle1594069;
	Mon, 1 Dec 2025 11:07:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=0cxLfuhaqlYpf2kqocGBbBNEsI+Xv
	dz4V4Vo3ta+kC0=; b=I6dcxRy7WDybxtOO0+U66XgMda54HZhvCmMkfMWf/v7iI
	FcyH/rFjl9ZHoZsM/YxE6lVgfWQxiq1c1spl+zSnouLcQegL/XbkWIH78nTUmBJu
	VCOEs/pwnr1RLmcG+POOWDcggGdYDcObG9aTRWA16S3eADxg8ZAlX4jUSUe2t0sk
	23V7t2cGX+/rzCqqJLUGS93Af9RFIFPEa2jekdcY5Rf29docmEX4GrXywHM3MOTC
	95zWrblTaT3Awz83VSZcmF7XId2Ul1KfpMey7j2wE9lHW1XBwzRc5k5wZGRbGy87
	mE1OmjfZ4g7P/Gu9Qsh06o52GL3gHTFq/0dJUQ/Pw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as7u7r8ch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 11:07:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B19ohHi028929;
	Mon, 1 Dec 2025 11:07:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq97vdw7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 11:07:18 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5B1B7HKm023609;
	Mon, 1 Dec 2025 11:07:17 GMT
Received: from gms-bm-13185-1.osdevelopmeniad.oraclevcn.com (gms-bm-13185-1.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.252.35])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aqq97vdvg-1;
	Mon, 01 Dec 2025 11:07:17 +0000
From: Gulam Mohamed <gulam.mohamed@oracle.com>
To: john.g.garry@oracle.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: gulam.mohamed@oracle.com
Subject: [PATCH V3 6.19/scsi-queue] scsi: target: core: Add emulation for REPORT_IDENTIFYING_INFORMATION
Date: Mon,  1 Dec 2025 11:07:16 +0000
Message-ID: <20251201110716.227588-1-gulam.mohamed@oracle.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512010089
X-Authority-Analysis: v=2.4 cv=Rfqdyltv c=1 sm=1 tr=0 ts=692d76e7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=aBE0p61DlpcDE2ZAjfQA:9
X-Proofpoint-GUID: guF1bgaCCGes8CX56q_UuzXSE_aLgxS1
X-Proofpoint-ORIG-GUID: guF1bgaCCGes8CX56q_UuzXSE_aLgxS1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAxMDA5MCBTYWx0ZWRfX1+NWcm3fffPN
 Cft5G9/oGuD06wV1vpV4xlJ1ozuchC0wXU2wcNQMrukZ5LQtnL11ZSC6WMD+fQdCo1pYpTHgMA3
 qS/PTQsMAmkfBbxx5OZMIgxubWG8X+XN2jy5dsKkQuyigBAVpQVkEaj9/qHo3s5yDQOhhfYwOu1
 cC6Qg0KCPhWID3GclM+pYEifcgQeJXs8RSWCUY4Ui4RSJegCZyJz4PzYg7dll7w6nnot+CTdM36
 U3/0Dz03Vo72IFF/e7ZabGFYkcF8p1+NdYTb/c55hOA26tGwaZwRyrUKtW8HUlv7xiPDF8RpFrc
 4ALbgQkRz/hlkVyTqWUM+4b41ciEtLd8r7OTKSuYGxzboH26hYpOLVCrx3PJeU0We7j+HsKAGgk
 eQyTMeP8yGcvkIwOhWaP1vd2HubWiw==

Add the emulation for REPORT_IDENTIFYING_INFORMATION command using the
configfs file pd_text_id_info in target core module. The configfs file is
created in /sys/kernel/config/target/core/<backend type>/
<backing_store_name>/wwn/. The user can set the peripheral device text
identification string to the file pd_text_id_info. An emulation function
"spc_emulate_report_id_info()" is defined in target_core_spc.c which
returns the device text id whenever the user requests the same.

The details of the REPORT_IDENTIFYING_INFORMATION command is mentioned
in the section 6.32 of spc4r37 specification document of SCSI Primary
Commands.

Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
---
Changes in V3:
        1. Used sysfs_emit() in target_wwn_pd_text_id_info_show()
           instead of sprintf()
        2. Not initializing the "stripped" variable as per suggestion in
           the function target_wwn_pd_text_id_info_store()
        3. Reduced the variable to 2 for holding lengths in the function
           spc_fill_pd_text_id_info()
        4. Using the macro for the header length
---
 drivers/target/target_core_configfs.c | 50 ++++++++++++++++
 drivers/target/target_core_spc.c      | 86 +++++++++++++++++++++++++++
 include/target/target_core_base.h     |  4 ++
 3 files changed, 140 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 77da1fc82b8d..ebeba9519e3a 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1741,6 +1741,54 @@ static ssize_t target_wwn_vpd_protocol_identifier_show(struct config_item *item,
 	return len;
 }
 
+static ssize_t target_wwn_pd_text_id_info_show(struct config_item *item,
+		char *page)
+{
+	return sysfs_emit(page, "%s\n", &to_t10_wwn(item)->pd_text_id_info[0]);
+}
+
+static ssize_t target_wwn_pd_text_id_info_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct t10_wwn *t10_wwn = to_t10_wwn(item);
+	struct se_device *dev = t10_wwn->t10_dev;
+
+	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
+	unsigned char buf[PD_TEXT_ID_INFO_LEN + 2];
+	char *stripped;
+
+	/*
+	 * Check to see if any active exports exist.  If they do exist, fail
+	 * here as changing this information on the fly (underneath the
+	 * initiator side OS dependent multipath code) could cause negative
+	 * effects.
+	 */
+	if (dev->export_count) {
+		pr_err("Unable to set the peripheral device text id info while active %d exports exist\n",
+			dev->export_count);
+		return -EINVAL;
+	}
+
+	if (strscpy(buf, page, sizeof(buf)) < 0)
+		return -EOVERFLOW;
+
+	/* Strip any newline added from userspace. */
+	stripped = strstrip(buf);
+	if (strlen(stripped) >= PD_TEXT_ID_INFO_LEN) {
+		pr_err("Emulated peripheral device text id info exceeds PD_TEXT_ID_INFO_LEN: " __stringify(PD_TEXT_ID_INFO_LEN "\n"));
+		return -EOVERFLOW;
+	}
+
+	BUILD_BUG_ON(sizeof(dev->t10_wwn.pd_text_id_info) != PD_TEXT_ID_INFO_LEN);
+	strscpy(dev->t10_wwn.pd_text_id_info, stripped,
+	       sizeof(dev->t10_wwn.pd_text_id_info));
+
+	pr_debug("Target_Core_ConfigFS: Set emulated peripheral dev text id info:"
+		  " %s\n", dev->t10_wwn.pd_text_id_info);
+
+	return count;
+}
+
 /*
  * Generic wrapper for dumping VPD identifiers by association.
  */
@@ -1797,6 +1845,7 @@ CONFIGFS_ATTR_RO(target_wwn_, vpd_protocol_identifier);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_logical_unit);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_target_port);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_scsi_target_device);
+CONFIGFS_ATTR(target_wwn_, pd_text_id_info);
 
 static struct configfs_attribute *target_core_dev_wwn_attrs[] = {
 	&target_wwn_attr_vendor_id,
@@ -1808,6 +1857,7 @@ static struct configfs_attribute *target_core_dev_wwn_attrs[] = {
 	&target_wwn_attr_vpd_assoc_logical_unit,
 	&target_wwn_attr_vpd_assoc_target_port,
 	&target_wwn_attr_vpd_assoc_scsi_target_device,
+	&target_wwn_attr_pd_text_id_info,
 	NULL,
 };
 
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index fe2b888bcb43..888d043176a7 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -25,6 +25,8 @@
 #include "target_core_ua.h"
 #include "target_core_xcopy.h"
 
+#define PD_TEXT_ID_INFO_HDR_LEN	4
+
 static void spc_fill_alua_data(struct se_lun *lun, unsigned char *buf)
 {
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
@@ -1999,6 +2001,18 @@ static const struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
 	.enabled = spc_rsoc_enabled,
 };
 
+static struct target_opcode_descriptor tcm_opcode_report_identifying_information = {
+	.support = SCSI_SUPPORT_FULL,
+	.serv_action_valid = 1,
+	.opcode = MAINTENANCE_IN,
+	.service_action = MI_REPORT_IDENTIFYING_INFORMATION,
+	.cdb_size = 12,
+	.usage_bits = {MAINTENANCE_IN, MI_REPORT_IDENTIFYING_INFORMATION,
+		       0x00, 0x00,
+		       0x00, 0x00, 0xff, 0xff,
+		       0xff, 0xff, 0xff, SCSI_CONTROL_MASK},
+};
+
 static bool tcm_is_set_tpg_enabled(const struct target_opcode_descriptor *descr,
 				   struct se_cmd *cmd)
 {
@@ -2086,6 +2100,7 @@ static const struct target_opcode_descriptor *tcm_supported_opcodes[] = {
 	&tcm_opcode_report_target_pgs,
 	&tcm_opcode_report_supp_opcodes,
 	&tcm_opcode_set_tpg,
+	&tcm_opcode_report_identifying_information,
 };
 
 static int
@@ -2303,6 +2318,72 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
 	return ret;
 }
 
+static sense_reason_t
+spc_fill_pd_text_id_info(struct se_cmd *cmd, u8 *cdb)
+{
+	struct se_device *dev = cmd->se_dev;
+	unsigned char *buf;
+	unsigned char *rbuf;
+	u32 buf_len;
+	u16 data_len;
+
+	buf_len = get_unaligned_be32(&cdb[6]);
+	if (buf_len < PD_TEXT_ID_INFO_HDR_LEN)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	data_len = strlen(dev->t10_wwn.pd_text_id_info);
+	if (data_len > 0)
+		/* trailing null */
+		data_len += 1;
+
+	data_len = data_len + PD_TEXT_ID_INFO_HDR_LEN;
+
+	if (data_len < buf_len)
+		buf_len = data_len;
+
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf) {
+		pr_err("Unable to allocate response buffer for IDENTITY INFO\n");
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
+	scnprintf(&buf[PD_TEXT_ID_INFO_HDR_LEN], buf_len - PD_TEXT_ID_INFO_HDR_LEN, "%s",
+		 dev->t10_wwn.pd_text_id_info);
+
+	put_unaligned_be16(data_len, &buf[2]);
+
+	rbuf = transport_kmap_data_sg(cmd);
+	if (!rbuf) {
+		pr_err("transport_kmap_data_sg() failed in spc_fill_pd_text_id_info\n");
+		kfree(buf);
+		return TCM_OUT_OF_RESOURCES;
+	}
+
+	memcpy(rbuf, buf, buf_len);
+	transport_kunmap_data_sg(cmd);
+	kfree(buf);
+
+	target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, buf_len);
+	return TCM_NO_SENSE;
+}
+
+static sense_reason_t
+spc_emulate_report_id_info(struct se_cmd *cmd)
+{
+	u8 *cdb = cmd->t_task_cdb;
+	sense_reason_t rc;
+
+	switch ((cdb[10] >> 1)) {
+	case 2:
+		rc = spc_fill_pd_text_id_info(cmd, cdb);
+		break;
+	default:
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	return rc;
+}
+
 sense_reason_t
 spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 {
@@ -2442,6 +2523,11 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 			    MI_REPORT_SUPPORTED_OPERATION_CODES)
 				cmd->execute_cmd =
 					spc_emulate_report_supp_op_codes;
+			if ((cdb[1] & 0x1f) ==
+			    MI_REPORT_IDENTIFYING_INFORMATION) {
+				cmd->execute_cmd =
+					spc_emulate_report_id_info;
+			}
 			*size = get_unaligned_be32(&cdb[6]);
 		} else {
 			/*
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 7016d93fa383..b62d5fcce950 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -108,6 +108,9 @@
 #define SE_MODE_PAGE_BUF			512
 #define SE_SENSE_BUF				96
 
+/* Peripheral Device Text Identification Information */
+#define PD_TEXT_ID_INFO_LEN			256
+
 enum target_submit_type {
 	/* Use the fabric driver's default submission type */
 	TARGET_FABRIC_DEFAULT_SUBMIT,
@@ -348,6 +351,7 @@ struct t10_wwn {
 	struct se_device *t10_dev;
 	struct config_group t10_wwn_group;
 	struct list_head t10_vpd_list;
+	char pd_text_id_info[PD_TEXT_ID_INFO_LEN];
 };
 
 struct t10_pr_registration {
-- 
2.47.3

