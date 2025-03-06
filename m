Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC84E2192F1;
	Thu,  6 Mar 2025 17:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741282356; cv=none; b=szsgcA7xYGHcKRFDeJINg9M9gFLYuje/nPgNcfvKqaOWQbqBySUsr3YWZY6z6ZyazVREp4eW651cwuSKyhgYz2Z96P3FeoPJ2rUi43YtYRRmJIn4LxcY2c68YWKjlxjI2NY9kfL3w1codGSJDuRUWZ2xc9bTBh4/fingDNUu0GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741282356; c=relaxed/simple;
	bh=A7zLjVG6YZ+2TI9o/IVTJYRiZhxZvh0qIPkvFCcsucU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=azV12gUMVU0gFUt14lxbJjhvxJKC9x4Ll9LJ5nvFTQQDPNd/TQ/3FUuyhk+2/fVbtKCeZ7y+v9GYXuvucTd17mqKUeB7UaFqj2zR1IidoMdmcVgWRNoYOPAmxC4YpxJsQNEQuBPcPpDC4hSdeM8rOAWIzRZIaXbGjqbjsd7EFEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=E/erdLU/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="E/erdLU/"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 526Awxlm006820;
	Thu, 6 Mar 2025 17:32:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=wqN+oUEBZy4in/4xutVX3dcLn914vASacUX78rTNBqg=; b=E/
	erdLU/+bSA7eHCNVsWzZqa0MyhkjtHXJjTn/tg25fYvTibfWSMooJoWAfta/JuUY
	rXH1PMT+hH1UOmJze959qRrJPTslufwTHFcTZ+mTo2L9jLhMylgrlqI5H0+ujqnD
	xBK3gf0P68sk0dp3KcWdSJ/iKxi1PlK1ay2T0wmPrVZapBUUjRMB5X47mFZ7ii2I
	HBSEaM76Gz2bbUOzlO/IwaAsXfhMno/fd4++J+q2gWW4V7+PPfyiKkREoAz9VEKi
	UrTaV/qtU3/sIBW9FSPsAkadK1X8otEr0lg5E9YgPhGyfHCB02CU+zulEDDnB1Cp
	aDFNo/eoFbpZzK37aBBw==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4571sdamyv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Mar 2025 17:32:00 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 526HVx1P008543
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 6 Mar 2025 17:31:59 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 6 Mar 2025 09:31:58 -0800
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
Subject: [PATCH v1 1/1] scsi: ufs: core: add device level exception support
Date: Thu, 6 Mar 2025 09:31:06 -0800
Message-ID: <772730b9a036a33bebc27cb854576a012e76ca91.1741282081.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: Tke_d13tCRwaIUEVI2lss-VEKQttIhYV
X-Authority-Analysis: v=2.4 cv=W6PCVQWk c=1 sm=1 tr=0 ts=67c9dc10 cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=Vs1iUdzkB0EA:10 a=COk6AnOGAAAA:8 a=D3a0u0wl9lu6AOdgJ4EA:9 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: Tke_d13tCRwaIUEVI2lss-VEKQttIhYV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-06_06,2025-03-06_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2503060133

The device JEDEC standard version 4.1 adds support for the device
level exception events. To support this new device level exception
feature, expose two new sysfs nodes below to provide
the user space access to the device level exception information.
/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception
/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id

The device_lvl_exception sysfs node reports the number of
device level exceptions that have occurred since the last time
this variable is reset.
The device_lvl_exception_id sysfs node reports the exception ID
which is the JEDEC standard qDeviceLevelExceptionID attribute.
The user space application can query these sysfs nodes to get more
information about the device level exception.

Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 23 +++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 54 ++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h             |  1 +
 drivers/ufs/core/ufshcd.c                  | 61 ++++++++++++++++++++++++++++++
 include/uapi/scsi/scsi_bsg_ufs.h           |  9 +++++
 include/ufs/ufs.h                          |  5 ++-
 include/ufs/ufshcd.h                       |  5 +++
 7 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index ae01912..5cf3f43 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1604,3 +1604,26 @@ Description:
 		prevent the UFS from frequently performing clock gating/ungating.
 
 		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception
+What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception
+Date:		March 2025
+Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
+Description:
+		The device_lvl_exception is a counter indicating the number
+		of times the device level exceptions have occurred since the
+		last time this variable is reset. Read the device_lvl_exception_id
+		sysfs node to know more information about the exception.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id
+What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception_id
+Date:		March 2025
+Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
+Description:
+		Reading the device_lvl_exception_id returns the device JEDEC
+		standard's qDeviceLevelExceptionID attribute. The definition of the
+		qDeviceLevelExceptionID is the ufs device vendor specific design.
+		Refer to the device manufacturer datasheet for more information
+		on the meaning of the qDeviceLevelExceptionID attribute value.
+		The file is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 90b5ab6..0248288a 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -466,6 +466,56 @@ static ssize_t critical_health_show(struct device *dev,
 	return sysfs_emit(buf, "%d\n", hba->critical_health_count);
 }
 
+static ssize_t device_lvl_exception_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	if (hba->dev_info.wspecversion < 0x410)
+		return -EOPNOTSUPP;
+
+	return sysfs_emit(buf, "%u\n", hba->dev_lvl_exception_count);
+}
+
+static ssize_t device_lvl_exception_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
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
+static DEVICE_ATTR_RW(device_lvl_exception);
+static DEVICE_ATTR_RO(device_lvl_exception_id);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -494,6 +546,8 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
 	&dev_attr_critical_health.attr,
+	&dev_attr_device_lvl_exception.attr,
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
index 4e1e214..01b2f95 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6013,6 +6013,44 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
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
+EXPORT_SYMBOL_GPL(ufshcd_read_device_lvl_exception_id);
+
 static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn idn)
 {
 	u8 index;
@@ -6240,6 +6278,11 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 		sysfs_notify(&hba->dev->kobj, NULL, "critical_health");
 	}
 
+	if (status & hba->ee_drv_mask & MASK_EE_DEV_LVL_EXCEPTION) {
+		hba->dev_lvl_exception_count++;
+		sysfs_notify(&hba->dev->kobj, NULL, "device_lvl_exception");
+	}
+
 	ufs_debugfs_exception_event(hba, status);
 }
 
@@ -8139,6 +8182,22 @@ static void ufshcd_temp_notif_probe(struct ufs_hba *hba, const u8 *desc_buf)
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
@@ -8339,6 +8398,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
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

