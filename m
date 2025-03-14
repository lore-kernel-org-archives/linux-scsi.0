Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3FA1B0F2C;
	Fri, 14 Mar 2025 22:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741993005; cv=none; b=pj8u5EE8+OGMGVJjQ7zs/kw09m2kEkVxBQ5oI6Zm/bwKn0wnwSBOye9wgtnSZn2ZjsezS1x5co/8Qgjm6/jAZlMewTJC+AsN4Tvr8m9waE4DjyfujoQNq5iTwEvCbs88DHVXdhjo8FiCOHdgNNR5OmBBizaNWIPDkliy27ItOf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741993005; c=relaxed/simple;
	bh=yobYeXPNJzzA242YULtizcqAabCbunqZZYgZnG/j7w8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Lux80f+gk2pwM3HomEgS52vDrEyo2z2JA1ZmzZmVRscwKcLUg2eN3ra4CqkR5DK6xQlxf4ZSRqLpyYf71LQTWeqcKKbtmF3nH4ktCf0LV0zAwdTmVEBRrQvYl/eFWhmIOUhiDVi2+SN7VjEyh4l/fTMfNmVpzaoXd+/fQhSeNQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=B/QuWg6y; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="B/QuWg6y"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52EDuDKW026118;
	Fri, 14 Mar 2025 22:56:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=n4RpS//6//g+YIfB3oJgxS9ygN/0j3W2K98cHRvT6oE=; b=B/
	QuWg6y9L9OJLc7jRXOy+iE86QLNE68CSxNJSEZ3pPzHmbmZdMFPY5+K0fcXpt222
	Q/snlAZwh4Hib74dIAiaFOTGi7dfbm+jy+RmIpLtKa1Q3nY1bMAqF/2Za/1pDZvZ
	6Sy9fErq37yDoK7K777uFvZEyj3iRkTRzIGMGJfR4WlBzJ75GKtB80qzYrkjCuZ3
	I8ZByOvIAKyZB/EQ8+Bny5O1lyinjj/xQZ93TbOEcJJ0sbBQOLVMdmFmiuK6l9Z0
	KX87+dHxvVA221DQgozyNljjHyGdPppOiTIYLFclXaYxAd7T/SgCSspSGH0kLVNC
	/rZ+ZYh8y9vOYH3pdTdQ==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45cnscsc21-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Mar 2025 22:56:14 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 52EMuDAQ023567
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Mar 2025 22:56:13 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Fri, 14 Mar 2025 15:56:13 -0700
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <manivannan.sadhasivam@linaro.org>, <minwoo.im@samsung.com>,
        <adrian.hunter@intel.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Bean Huo <beanhuo@micron.com>,
        "Ziqi
 Chen" <quic_ziqichen@quicinc.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Biggers <ebiggers@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/1] scsi: ufs: core: add device level exception support
Date: Fri, 14 Mar 2025 15:55:33 -0700
Message-ID: <df2a1843d1dbfd0d3fef87b9730089969b6f00bd.1741992586.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=Qbxmvtbv c=1 sm=1 tr=0 ts=67d4b40e cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=Vs1iUdzkB0EA:10 a=COk6AnOGAAAA:8 a=sSBHTfuD2D8JQwrNuTcA:9 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: Iy2QyfJGoEzXbpD_wYJQqObtrNI3SLPz
X-Proofpoint-GUID: Iy2QyfJGoEzXbpD_wYJQqObtrNI3SLPz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-14_09,2025-03-14_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 impostorscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503140176

The ufs device JEDEC specification version 4.1 adds support for the
device level exception events. To support this new device level
exception feature, expose two new sysfs nodes below to provide
the user space access to the device level exception information.
/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_count
/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id

The device_lvl_exception_count sysfs node reports the number of
device level exceptions that have occurred since the last time
this variable is reset. Writing a value of 0 will reset it.
The device_lvl_exception_id reports the exception ID which is the
qDeviceLevelExceptionID attribute of the device JEDEC specifications
version 4.1 and later. The user space application can query these
sysfs nodes to get more information about the device level exception.

Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
---
Changes in v2:
1. Addressed Mani's comments:
   - Update the documentation of dev_lvl_exception_count to read/write.
   - Rephrase the description of the Documentation and commit text.
   - Remove the export of ufshcd_read_device_lvl_exception_id().
2. Addressed Bart's comments:
   - Rename dev_lvl_exception sysfs node to dev_lvl_exception_count.
   - Update the documentation of the sysfs nodes.
   - Skip comment about sysfs_notify() being used in interrupt
     context because Avri already addressed it.
---
 Documentation/ABI/testing/sysfs-driver-ufs | 27 ++++++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 54 +++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h             |  1 +
 drivers/ufs/core/ufshcd.c                  | 60 ++++++++++++++++++++++++++++++
 include/uapi/scsi/scsi_bsg_ufs.h           |  9 +++++
 include/ufs/ufs.h                          |  5 ++-
 include/ufs/ufshcd.h                       |  5 +++
 7 files changed, 160 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index ae01912..6a6c35a 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1604,3 +1604,30 @@ Description:
 		prevent the UFS from frequently performing clock gating/ungating.
 
 		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_count
+What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception_count
+Date:		March 2025
+Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
+Description:
+		This attribute is applicable to ufs devices compliant to the JEDEC
+		specifications version 4.1 or later. The device_lvl_exception_count
+		is a counter indicating the number of times the device level exceptions
+		have occurred since the last time this variable is reset.
+		Writing a 0 value to this attribute will reset the device_lvl_exception_count.
+		If the device_lvl_exception_count reads a positive value, the user
+		application should read the device_lvl_exception_id attribute to know more
+		information about the exception.
+		This attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id
+What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception_id
+Date:		March 2025
+Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
+Description:
+		Reading the device_lvl_exception_id returns the qDeviceLevelExceptionID
+		attribute of the ufs device JEDEC specification version 4.1. The definition
+		of the qDeviceLevelExceptionID is the ufs device vendor specific implementation.
+		Refer to the device manufacturer datasheet for more information
+		on the meaning of the qDeviceLevelExceptionID attribute value.
+		The attribute is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 90b5ab6..2ad3197 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -466,6 +466,56 @@ static ssize_t critical_health_show(struct device *dev,
 	return sysfs_emit(buf, "%d\n", hba->critical_health_count);
 }
 
+static ssize_t device_lvl_exception_count_show(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	if (hba->dev_info.wspecversion < 0x410)
+		return -EOPNOTSUPP;
+
+	return sysfs_emit(buf, "%u\n", hba->dev_lvl_exception_count);
+}
+
+static ssize_t device_lvl_exception_count_store(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned int value;
+
+	if (kstrtouint(buf, 0, &value))
+		return -EINVAL;
+
+	/* the only supported usecase is to reset the dev_lvl_exception_count */
+	if (value)
+		return -EINVAL;
+
+	hba->dev_lvl_exception_count = 0;
+
+	return count;
+}
+
+static ssize_t device_lvl_exception_id_show(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u64 exception_id;
+	int err;
+
+	ufshcd_rpm_get_sync(hba);
+	err = ufshcd_read_device_lvl_exception_id(hba, &exception_id);
+	ufshcd_rpm_put_sync(hba);
+
+	if (err)
+		return err;
+
+	hba->dev_lvl_exception_id = exception_id;
+	return sysfs_emit(buf, "%llu\n", exception_id);
+}
+
 static DEVICE_ATTR_RW(rpm_lvl);
 static DEVICE_ATTR_RO(rpm_target_dev_state);
 static DEVICE_ATTR_RO(rpm_target_link_state);
@@ -479,6 +529,8 @@ static DEVICE_ATTR_RW(wb_flush_threshold);
 static DEVICE_ATTR_RW(rtc_update_ms);
 static DEVICE_ATTR_RW(pm_qos_enable);
 static DEVICE_ATTR_RO(critical_health);
+static DEVICE_ATTR_RW(device_lvl_exception_count);
+static DEVICE_ATTR_RO(device_lvl_exception_id);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -494,6 +546,8 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
 	&dev_attr_critical_health.attr,
+	&dev_attr_device_lvl_exception_count.attr,
+	&dev_attr_device_lvl_exception_id.attr,
 	NULL
 };
 
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 10b4a19..d0a2c96 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -94,6 +94,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     enum query_opcode desc_op);
 
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
+int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *exception_id);
 
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4e1e214..3300845 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6013,6 +6013,43 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 				__func__, err);
 }
 
+int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *exception_id)
+{
+	struct utp_upiu_query_response_v4_0 *upiu_resp;
+	struct ufs_query_req *request = NULL;
+	struct ufs_query_res *response = NULL;
+	int err;
+
+	if (hba->dev_info.wspecversion < 0x410)
+		return -EOPNOTSUPP;
+
+	ufshcd_hold(hba);
+	mutex_lock(&hba->dev_cmd.lock);
+
+	ufshcd_init_query(hba, &request, &response,
+			  UPIU_QUERY_OPCODE_READ_ATTR,
+			  QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID, 0, 0);
+
+	request->query_func = UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
+
+	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, QUERY_REQ_TIMEOUT);
+
+	if (err) {
+		dev_err(hba->dev, "%s: failed to read device level exception %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	upiu_resp = (struct utp_upiu_query_response_v4_0 *)response;
+	*exception_id = get_unaligned_be64(&upiu_resp->value);
+
+out:
+	mutex_unlock(&hba->dev_cmd.lock);
+	ufshcd_release(hba);
+
+	return err;
+}
+
 static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn idn)
 {
 	u8 index;
@@ -6240,6 +6277,11 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 		sysfs_notify(&hba->dev->kobj, NULL, "critical_health");
 	}
 
+	if (status & hba->ee_drv_mask & MASK_EE_DEV_LVL_EXCEPTION) {
+		hba->dev_lvl_exception_count++;
+		sysfs_notify(&hba->dev->kobj, NULL, "device_lvl_exception_count");
+	}
+
 	ufs_debugfs_exception_event(hba, status);
 }
 
@@ -8139,6 +8181,22 @@ static void ufshcd_temp_notif_probe(struct ufs_hba *hba, const u8 *desc_buf)
 	}
 }
 
+static void ufshcd_device_lvl_exception_probe(struct ufs_hba *hba, u8 *desc_buf)
+{
+	u32 ext_ufs_feature;
+
+	if (hba->dev_info.wspecversion < 0x410)
+		return;
+
+	ext_ufs_feature = get_unaligned_be32(desc_buf +
+				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
+	if (!(ext_ufs_feature & UFS_DEV_LVL_EXCEPTION_SUP))
+		return;
+
+	hba->dev_lvl_exception_count = 0;
+	ufshcd_enable_ee(hba, MASK_EE_DEV_LVL_EXCEPTION);
+}
+
 static void ufshcd_set_rtt(struct ufs_hba *hba)
 {
 	struct ufs_dev_info *dev_info = &hba->dev_info;
@@ -8339,6 +8397,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	ufs_init_rtc(hba, desc_buf);
 
+	ufshcd_device_lvl_exception_probe(hba, desc_buf);
+
 	/*
 	 * ufshcd_read_string_desc returns size of the string
 	 * reset the error value
diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
index 8c29e49..8b61dff 100644
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -143,6 +143,15 @@ struct utp_upiu_query_v4_0 {
 	__be32 reserved;
 };
 
+struct utp_upiu_query_response_v4_0 {
+	__u8 opcode;
+	__u8 idn;
+	__u8 index;
+	__u8 selector;
+	__be64 value;
+	__be32 reserved;
+} __attribute__((__packed__));
+
 /**
  * struct utp_upiu_cmd - Command UPIU structure
  * @exp_data_transfer_len: Data Transfer Length DW-3
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 8a24ed5..1c47136 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -180,7 +180,8 @@ enum attr_idn {
 	QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE       = 0x1D,
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    = 0x1E,
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        = 0x1F,
-	QUERY_ATTR_IDN_TIMESTAMP		= 0x30
+	QUERY_ATTR_IDN_TIMESTAMP		= 0x30,
+	QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID     = 0x34,
 };
 
 /* Descriptor idn for Query requests */
@@ -390,6 +391,7 @@ enum {
 	UFS_DEV_EXT_TEMP_NOTIF		= BIT(6),
 	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
+	UFS_DEV_LVL_EXCEPTION_SUP       = BIT(12),
 };
 #define UFS_DEV_HPB_SUPPORT_VERSION		0x310
 
@@ -419,6 +421,7 @@ enum {
 	MASK_EE_TOO_LOW_TEMP		= BIT(4),
 	MASK_EE_WRITEBOOSTER_EVENT	= BIT(5),
 	MASK_EE_PERFORMANCE_THROTTLING	= BIT(6),
+	MASK_EE_DEV_LVL_EXCEPTION       = BIT(7),
 	MASK_EE_HEALTH_CRITICAL		= BIT(9),
 };
 #define MASK_EE_URGENT_TEMP (MASK_EE_TOO_HIGH_TEMP | MASK_EE_TOO_LOW_TEMP)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index e3909cc..ad90a43 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -968,6 +968,9 @@ enum ufshcd_mcq_opr {
  * @pm_qos_req: PM QoS request handle
  * @pm_qos_enabled: flag to check if pm qos is enabled
  * @critical_health_count: count of critical health exceptions
+ * @dev_lvl_exception_count: count of device level exceptions since last reset
+ * @dev_lvl_exception_id: vendor specific information about the
+ * device level exception event.
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -1138,6 +1141,8 @@ struct ufs_hba {
 	bool pm_qos_enabled;
 
 	int critical_health_count;
+	u32 dev_lvl_exception_count;
+	u64 dev_lvl_exception_id;
 };
 
 /**
-- 
2.7.4

