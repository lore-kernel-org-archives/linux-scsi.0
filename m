Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91C628F5;
	Thu, 20 Feb 2025 01:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740016358; cv=none; b=YRZ1WiJcrTiiKv9VWjqWxho+Dqg5CaFUxBfLT6cMaqTFRF4eygL/8d79K4u6DS9cwb1yg5WYaC5IVj7Ahvg9a1XYehaG7TVV5fLYi43cod0wzb5U1N3lXpXjMYzCwVM4mitN98tb2eeO3NGMUuw85N2uJMynYSLoYG6gyYmahF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740016358; c=relaxed/simple;
	bh=kQKg4kEwXQcrFwZbBBYKy9vYYC4vu6OAvKUT1g4BbTM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nVZ2Mp3GXN962DBYNdJRKv4No5JbljLvTfLVnU9PjU5fDNquXM9Xqq8VndlQYIv/x9GjFCjxfn3lSzfVOkbtG5IOf7V0VcDpxJSN3sWgULz5QORanrO+3F030oJpr8KAtLbu7ncboesQ8DPyG5asL/bcoxegu/I4VuCL0HC+Wm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=A+W1tCis; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="A+W1tCis"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51JHE5dk008310;
	Thu, 20 Feb 2025 01:52:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=vtPIMOsmsjzBirTenSlEEAwJIMh/ceYD4Uk1CQou7sY=; b=A+
	W1tCisnGlzTgKLdv2XH+gLH0cHaeBZbMszAlsu+wHJSE1Aei8A+3wh8/SnUGLJ7E
	uV35ZVfGlVmXYdTN52nAATSwqrhZH3S0M9zMKaxXndShhlbX9W0Ka4vwTjqX4UGU
	UjkFjQ3qplvu/68qHB3VqbP2VS0wHjAmv6dBNZUfQgytF7HaewiZ/dvsx2B+BcJP
	YlnvQIlfF9auJw1mqYZKGy2Ab3xB9+rEFo1tJPHtuEbTGj+YthSfPUjeiiEhF0uS
	XTSa0va3M6zCxU64/PB+pa5EUsApli4lmc9d9jVln3SqZ3hYghgyPP6+FgvzW1s0
	e7i1NmpCRVFZB6f12B6g==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 44vyy3ch11-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Feb 2025 01:52:06 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 51K1q5Ew007775
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Feb 2025 01:52:05 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Wed, 19 Feb 2025 17:52:05 -0800
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <manivannan.sadhasivam@linaro.org>, <minwoo.im@samsung.com>,
        <adrian.hunter@intel.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Keoseong Park
	<keosung.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>, Al Viro
	<viro@zeniv.linux.org.uk>,
        Gwendal Grignou <gwendal@chromium.org>,
        "Andrew
 Halaney" <ahalaney@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        open list
	<linux-kernel@vger.kernel.org>
Subject: [RFC v1 1/1] scsi: ufs: core: Add device level exeption support
Date: Wed, 19 Feb 2025 17:51:40 -0800
Message-ID: <fdebf652abb4734d37f957062a2b4568754db374.1740016268.git.quic_nguyenb@quicinc.com>
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
X-Proofpoint-ORIG-GUID: 95DXzFG_F01gqfhEU1uM2bNbp5Khkg-g
X-Proofpoint-GUID: 95DXzFG_F01gqfhEU1uM2bNbp5Khkg-g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-19_11,2025-02-19_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1011
 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2502200011

The device JEDEC standard version 4.1 adds support for the device
level exception events. In order to provide the user space access to
the device level exception information, we propose exposing 2 new
sysfs nodes namely
/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception
/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id
The device_lvl_exception sysfs node would report the number of
device level exceptions that have occurred between the
device_lvl_exception_id reads.
The device_lvl_exception_id sysfs node would report the last read of the
exception ID which is the JEDEC standard qDeviceLevelExceptionID attribute.
The user space would query the sysfs nodes to get more information about
the device level exception. Alternatively, we can change the implementation
to notify the user space of the exception.

Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 21 +++++++++
 drivers/ufs/core/ufs-sysfs.c               | 23 ++++++++++
 drivers/ufs/core/ufshcd.c                  | 69 ++++++++++++++++++++++++++++++
 include/uapi/scsi/scsi_bsg_ufs.h           |  8 ++++
 include/ufs/ufs.h                          |  5 ++-
 include/ufs/ufshcd.h                       |  7 +++
 6 files changed, 132 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 5fa6655..e480115 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1559,3 +1559,24 @@ Description:
 		Symbol - HCMID. This file shows the UFSHCD manufacturer id.
 		The Manufacturer ID is defined by JEDEC in JEDEC-JEP106.
 		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception
+What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception
+Date:		February 2025
+Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
+Description:
+		Indicates the number times the device level exceptions have occurred
+		since the last device reset. Read the device_lvl_exception_id to know
+		more information about the exception id.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id
+What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception_id
+Date:		February 2025
+Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
+Description:
+		This is the device JEDEC standard qDeviceLevelExceptionID attribute.
+		The definition of the qDeviceLevelExceptionID is the ufs device vendor specific.
+		Refer to the device manufacturer datasheet for more information
+		on the meaning of the qDeviceLevelExceptionID attribute value.
+		The file is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 3438269..fd74ae0 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -458,6 +458,25 @@ static ssize_t pm_qos_enable_store(struct device *dev,
 	return count;
 }
 
+static ssize_t device_lvl_exception_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%u\n", hba->dev_lvl_exception_count);
+}
+
+static ssize_t device_lvl_exception_id_show(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	hba->dev_lvl_exception_count = 0;
+	return sysfs_emit(buf, "%llu\n", hba->dev_lvl_exception_id);
+}
+
 static DEVICE_ATTR_RW(rpm_lvl);
 static DEVICE_ATTR_RO(rpm_target_dev_state);
 static DEVICE_ATTR_RO(rpm_target_link_state);
@@ -470,6 +489,8 @@ static DEVICE_ATTR_RW(enable_wb_buf_flush);
 static DEVICE_ATTR_RW(wb_flush_threshold);
 static DEVICE_ATTR_RW(rtc_update_ms);
 static DEVICE_ATTR_RW(pm_qos_enable);
+static DEVICE_ATTR_RO(device_lvl_exception);
+static DEVICE_ATTR_RO(device_lvl_exception_id);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -484,6 +505,8 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_wb_flush_threshold.attr,
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
+	&dev_attr_device_lvl_exception.attr,
+	&dev_attr_device_lvl_exception_id.attr,
 	NULL
 };
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index cd404ad..4467777 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5994,6 +5994,54 @@ static void ufshcd_temp_exception_event_handler(struct ufs_hba *hba, u16 status)
 	 */
 }
 
+static int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba,
+					       u64 *exception_id)
+{
+	struct ufs_query_req *request = NULL;
+	struct ufs_query_res *response = NULL;
+	struct utp_upiu_query_response_v4_0 *upiu_resp;
+	int err;
+
+	ufshcd_hold(hba);
+
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
+	*exception_id = be64_to_cpu(upiu_resp->value);
+out:
+	mutex_unlock(&hba->dev_cmd.lock);
+	ufshcd_release(hba);
+
+	return err;
+}
+
+static void ufshcd_device_lvl_exception_event_handler(struct ufs_hba *hba)
+{
+	u64 *exception_id;
+	int err;
+
+	hba->dev_lvl_exception_count++;
+	exception_id = &hba->dev_lvl_exception_id;
+	err = ufshcd_read_device_lvl_exception_id(hba, exception_id);
+	if (err)
+		dev_err(hba->dev, "%s: read dev lvl exception id err=%d\n",
+			__func__, err);
+}
+
 static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn idn)
 {
 	u8 index;
@@ -6216,6 +6264,9 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
 		ufshcd_temp_exception_event_handler(hba, status);
 
+	if (status & hba->ee_drv_mask & MASK_EE_DEV_LVL_EXCEPTION)
+		ufshcd_device_lvl_exception_event_handler(hba);
+
 	ufs_debugfs_exception_event(hba, status);
 }
 
@@ -8115,6 +8166,22 @@ static void ufshcd_temp_notif_probe(struct ufs_hba *hba, const u8 *desc_buf)
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
@@ -8310,6 +8377,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	ufs_init_rtc(hba, desc_buf);
 
+	ufshcd_device_lvl_exception_probe(hba, desc_buf);
+
 	/*
 	 * ufshcd_read_string_desc returns size of the string
 	 * reset the error value
diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
index 8c29e49..7a4e2f9 100644
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -143,6 +143,14 @@ struct utp_upiu_query_v4_0 {
 	__be32 reserved;
 };
 
+struct utp_upiu_query_response_v4_0 {
+	__u8 opcode;
+	__u8 idn;
+	__u8 index;
+	__u8 selector;
+	__be64 value;
+};
+
 /**
  * struct utp_upiu_cmd - Command UPIU structure
  * @exp_data_transfer_len: Data Transfer Length DW-3
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 89672ad..f2303e9 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -180,7 +180,8 @@ enum attr_idn {
 	QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE       = 0x1D,
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    = 0x1E,
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        = 0x1F,
-	QUERY_ATTR_IDN_TIMESTAMP		= 0x30
+	QUERY_ATTR_IDN_TIMESTAMP		= 0x30,
+	QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID     = 0x34
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
+	MASK_EE_DEV_LVL_EXCEPTION	= BIT(7),
 };
 #define MASK_EE_URGENT_TEMP (MASK_EE_TOO_HIGH_TEMP | MASK_EE_TOO_LOW_TEMP)
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 650ff23..d9e8fdd 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -962,6 +962,10 @@ enum ufshcd_mcq_opr {
  * @ufs_rtc_update_work: A work for UFS RTC periodic update
  * @pm_qos_req: PM QoS request handle
  * @pm_qos_enabled: flag to check if pm qos is enabled
+ * @dev_lvl_exception_count: Number of device level exception events
+ * between device level exception id reads.
+ * @dev_lvl_exception_id: vendor specific information about the
+ * device level exception event.
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -1130,6 +1134,9 @@ struct ufs_hba {
 	struct delayed_work ufs_rtc_update_work;
 	struct pm_qos_request pm_qos_req;
 	bool pm_qos_enabled;
+
+	u32 dev_lvl_exception_count;
+	u64 dev_lvl_exception_id;
 };
 
 /**
-- 
2.7.4

