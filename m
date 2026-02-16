Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50D0308F3A;
	Mon, 16 Feb 2026 13:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771249641; cv=none; b=LJwvR1cVuhPRqgYUYxg3drVLEuT48n/A5fCMn7OPsabEwbc044OfJeAimAKOUZ1QkaedQp15HMZOWPt9I8juTpO0UBHj6PsFh/L9L+24hzZ5CvCY8DtcNSnTk9m8GtwDCoIR8RX1CRrBvD7+WRNOnqFp2GtwHqClsTpIaRxiRJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771249641; c=relaxed/simple;
	bh=MX4U2lwddLcnGagKF1x6SNUUl/YON1AI4TDA+KqzJL0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZjI9EfVTZDLxklDXmm0JkFDFX7xrktktH6BCz3M9pJv7SFa9UDM5YVrPekz7ZskEzVR7mhr/fq7qObo7TXhrffWZn/AKHT00f8YdsWzro73baqOZTvlfSpGpud9X6HP+xMr/VFZ/YiLaeYfhhpwyrIKmklieF/N6zxR8ANuBXwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Vjc50z6i; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Vjc50z6i"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61GAXFok2106412;
	Mon, 16 Feb 2026 13:46:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=efwy30uit6j
	3O9jUp1qV5+eNwxyNO1rSRXY3FgHnYb4=; b=Vjc50z6iNSLfclxd5WEuLsLmIcT
	XBtta6NwxmMTAgawbwpWJwaWUFJ8ClBAlqkNXqe3PuiZ70OdCchWkw7h5lGYe7MC
	+7B/2XeUE6h0ob/wLvxtkwm73mai1xG7mtHI479gQB1dLU1BsLtaZxmdVCBvc1Zs
	Q4KMElOkVrI7YqFX7iAzmEpzW1QdrReV3FiLF3mBLwywTmoYG3jilbs/4gg1gv2u
	O1y++6YnEhvelzQcmKlnbLCf/8R1ivlfMTgLNXfA9N0shyMcKlnAj918cCdFh4Sb
	nO8QR6JCPn+u8VzJILexoKg8KQMvWZesiiGDWVNWiXb8xAXx95972io0iOA==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cb6bujyxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Feb 2026 13:46:57 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 61GDkutT009663;
	Mon, 16 Feb 2026 13:46:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4cc04njfs4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Feb 2026 13:46:56 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61GDkuqv009653;
	Mon, 16 Feb 2026 13:46:56 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 61GDkt7a009652
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Feb 2026 13:46:56 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id DCFB55A8; Mon, 16 Feb 2026 05:46:55 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Bean Huo <huobean@gmail.com>, Huan Tang <tanghuan@vivo.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        Liu Song <liu.song13@zte.com.cn>, Daniel Lee <chullee@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] scsi: ufs: core: Add a sysfs entry for ufshcd_state
Date: Mon, 16 Feb 2026 05:46:36 -0800
Message-Id: <20260216134636.3477154-3-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260216134636.3477154-1-can.guo@oss.qualcomm.com>
References: <20260216134636.3477154-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: c8ibYHT6uMNVr7lp6zvRuZ7mdc8gop3o
X-Proofpoint-ORIG-GUID: c8ibYHT6uMNVr7lp6zvRuZ7mdc8gop3o
X-Authority-Analysis: v=2.4 cv=M8dA6iws c=1 sm=1 tr=0 ts=69931fd1 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=EUspDBNiAAAA:8 a=NxQxUFsvoc-cg5by0coA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE2MDExNiBTYWx0ZWRfX6NbnhaXHajJ9
 +O3kk5AaaZERvv9O96wpQPmzCzUUzK7gRP11Noq9DvXbLSovNJF4eIRs2vgU4wMd4jKrYQlRWWf
 B6AQv2kP6XEqtk09FrHuoB4/gQTZkPVNKlR0tYvTCSPSU8dHSoS9OguWDW52zOiEQQ1+muN0zr5
 5VVthiQb2Moi4HrIXTTvLvmF+RcAQZsK/OVdngdF+llbjltG+hvF4H+ltrTL97bb2VqIBgLjnIR
 XWcEHgFArP3BsEqek05szP98gz2hD9N5l2ijeKUxd+PL4kCCi9ndt0I2PAdgJTqIg0lzsidI77a
 bQY017S500mW2LfcX80CHR0ZkX4bEUlVZdefvFaF7Ymk0Fj6DGvmowjOMFw1a3k75RmYbW9LZ6B
 gOrBUA5L6tGM8+sOWVqMmAQsmmHJUL2HI+JWu0+yJ9o45hcFX2S/B0rjE51MfTCgDlEtQOGlHtf
 lDHodb6hul38uXO2+dQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-16_04,2026-02-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 suspectscore=0 bulkscore=0 impostorscore=0
 clxscore=1011 phishscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602160116

Add a sysfs entry for ufshcd_state, such that userspace can check and
track the state transitions of hba.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  9 +++++++++
 drivers/ufs/core/ufs-sysfs.c               | 18 ++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  |  2 ++
 3 files changed, 29 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 665819308b40..339bb1befc9c 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1778,3 +1778,12 @@ Description:
 		notification from UFSHCI UECDME.
 
 		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/ufshcd_state
+What:		/sys/bus/platform/devices/*.ufs/ufshcd_state
+Date:		February 2026
+Contact:	Can Guo <can.guo@oss.qualcomm.com>
+Description:
+		This attribute shows the state of ufshcd.
+
+		The attribute is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 99af3c73f1af..10804ec6e252 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -97,6 +97,14 @@ static const char * const ufs_hid_states[] = {
 	[DEFRAG_NOT_REQUIRED]	= "defrag_not_required",
 };
 
+static const char * const ufshcd_states[] = {
+	[UFSHCD_STATE_RESET]			= "reset",
+	[UFSHCD_STATE_OPERATIONAL]		= "operational",
+	[UFSHCD_STATE_EH_SCHEDULED_NON_FATAL]	= "eh_scheduled_non_fatal",
+	[UFSHCD_STATE_EH_SCHEDULED_FATAL]	= "eh_scheduled_fatal",
+	[UFSHCD_STATE_ERROR]			= "error",
+};
+
 static const char *ufs_hid_state_to_string(enum ufs_hid_state state)
 {
 	if (state < NUM_UFS_HID_STATES)
@@ -633,6 +641,14 @@ static ssize_t dme_qos_notification_store(struct device *dev,
 	return count;
 }
 
+static ssize_t ufshcd_state_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%s\n", ufshcd_states[hba->ufshcd_state]);
+}
+
 static DEVICE_ATTR_RW(rpm_lvl);
 static DEVICE_ATTR_RO(rpm_target_dev_state);
 static DEVICE_ATTR_RO(rpm_target_link_state);
@@ -650,6 +666,7 @@ static DEVICE_ATTR_RO(critical_health);
 static DEVICE_ATTR_RW(device_lvl_exception_count);
 static DEVICE_ATTR_RO(device_lvl_exception_id);
 static DEVICE_ATTR_RW(dme_qos_notification);
+static DEVICE_ATTR_RO(ufshcd_state);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -669,6 +686,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_device_lvl_exception_count.attr,
 	&dev_attr_device_lvl_exception_id.attr,
 	&dev_attr_dme_qos_notification.attr,
+	&dev_attr_ufshcd_state.attr,
 	NULL
 };
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e0e70da35c2a..735e59052fbd 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7918,6 +7918,8 @@ static void ufshcd_process_probe_result(struct ufs_hba *hba,
 		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	sysfs_notify(&hba->dev->kobj, NULL, "ufshcd_state");
+
 	trace_ufshcd_init(hba, ret,
 			  ktime_to_us(ktime_sub(ktime_get(), probe_start)),
 			  hba->curr_dev_pwr_mode, hba->uic_link_state);
-- 
2.34.1

