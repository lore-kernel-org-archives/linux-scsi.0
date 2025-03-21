Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175C9D2FB;
	Fri, 21 Mar 2025 03:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742527166; cv=none; b=N46SwuXL8hKnsjEB8schlh0rc3djCDgd0gqJ9xxFWhRh7gQm+oL7xbYclZketrYHYan3AEorSDdI6NL4UHMPRyrommO2hby/Ab6NvepNr9G1vbCen2y9hXQj8pEo9KioIs5eAqu62+DbdBYFdnuGdjZDDSpFdBVKM6+ef87d3nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742527166; c=relaxed/simple;
	bh=xGZpu9TJJwOnz1Dm4/OKGk7M5pSLpdldFGalONatX/s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Vtg4HNNv/hmwQQY/5rYcXoMF100r0RGtcR24hqLj6K4A0bOK4cplcrQHXgDUZFwY1Zk2z8sTR/Qa/yPN9xItqMfhhqJjtByQb/M+/aGxuXcrgDHprZJLZM14W1hJXROEhZ2wSwma4vDXL4oLwlnRq/dxFPBlv4BxOMwT/nH2zWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=CYHilm/T; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="CYHilm/T"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52L1WSH7018730;
	Fri, 21 Mar 2025 03:18:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=3nc6yhk/CsXLFnqiEj1iFT7NX0oUCv0eMr8OhvrO/q8=; b=CY
	Hilm/T2k2y+JJf+XCsOFZ5EL2NTj9KBuguB4gHTUTlrjJVu0rl95rxGDl13WtD/C
	rH0w+3wLVn/Czs1mKE/wRjtU40CWExmtZk/QnmNklQ3AatOHJs8Xw6QkceTd6E8o
	4+qP6ZdoKy/7uoj5Nx5V85yc4pjx/lAFkcjAf2U5eCcVI0ieLMS5MvBB+gVAaP1I
	BU56D3PGhgj0/LPoAvgL0lpzUF7LNFergIkgNH2Qc95xDK3ETCY/ufTMPkjGZeXB
	wFBS8MqihthQ2NMHf4kZPAhfUdOSoEJyqe1xI8+BAJlhfUVsbl/w+SMgRJdVGdKG
	fETQD46/ID1wB1Md287A==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45g09f58mq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Mar 2025 03:18:49 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 52L3ImA4008961
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Mar 2025 03:18:48 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 20 Mar 2025 20:18:48 -0700
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <manivannan.sadhasivam@linaro.org>, <minwoo.im@samsung.com>,
        <adrian.hunter@intel.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Matthias Brugger
	<matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
        Bean Huo <beanhuo@micron.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Ziqi Chen
	<quic_ziqichen@quicinc.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Gwendal
 Grignou" <gwendal@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        open
 list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>,
        "moderated
 list:ARM/Mediatek SoC support:Keyword:mediatek"
	<linux-mediatek@lists.infradead.org>
Subject: [PATCH v4 1/1] scsi: ufs: core: add device level exception support
Date: Thu, 20 Mar 2025 20:18:24 -0700
Message-ID: <4370b3a3b5a5675bb3e75aaa48a273674c159339.1742526978.git.quic_nguyenb@quicinc.com>
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
X-Authority-Analysis: v=2.4 cv=BvKdwZX5 c=1 sm=1 tr=0 ts=67dcda99 cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=Vs1iUdzkB0EA:10 a=COk6AnOGAAAA:8 a=mpaa-ttXAAAA:8 a=sSBHTfuD2D8JQwrNuTcA:9
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: DFDNGSI7xF7mXuzfQICK25jYbQYEhbtB
X-Proofpoint-GUID: DFDNGSI7xF7mXuzfQICK25jYbQYEhbtB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-21_01,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503210022

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
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
---
Changes in v4:
1. Changed the hba->dev_lvl_exception_count to atomic_t type. Removed
the spinlock() around hba->dev_lvl_exception_count accesses
(Peter's and Bart's comments).

Changes in v3:
1. Add protection for hba->dev_lvl_exception_count accesses in different
contexts (Bart's comment).

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
index 90b5ab6..634cf16 100644
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
+	return sysfs_emit(buf, "%u\n", atomic_read(&hba->dev_lvl_exception_count));
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
+	atomic_set(&hba->dev_lvl_exception_count, 0);
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
index 4e1e214..86ef716 100644
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
+		atomic_inc(&hba->dev_lvl_exception_count);
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
+	atomic_set(&hba->dev_lvl_exception_count, 0);
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
index e3909cc..5888463 100644
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
+	atomic_t dev_lvl_exception_count;
+	u64 dev_lvl_exception_id;
 };
 
 /**
-- 
2.7.4

