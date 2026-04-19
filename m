Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40085478D;
	Sun, 19 Apr 2026 13:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776606847; cv=none; b=PXRMdcjbJ6NrihfT5n4TKu6AiI0nYAW6dhs7iA1GmqAI+L/Izm0gJLHfwnNAwXg8gWOh4pJsIBS8fv+UHIZ9tnm7yJBNnRTknMWDhjlz3rauRKZSWQdQi3gcxudmNztkco6gG30ImwjqBm4bh5tn+HPOts6eUnjQ+g+16h20bVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776606847; c=relaxed/simple;
	bh=cr07GTwRdA0Lih4Ede9YM6+EYWV0yO4qhLjWqJK1exg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l0U7kInyniEgq9zhnualM1f3sf/2ylBWhw0Xz5BuRR6JUWuOAuIW0NEoLqa3FrMqMcO7kX2L89oICn+yiGCpOZ2/PClXdYTqI/HM8UYhd6w9AIBTHja86nXHlVx3pQcDiAfJ2IQQDowOqsrOAATB3sGnJijXN+hCurm+z8W23kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dsdP8rIm; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dsdP8rIm"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63J3fGkR3289478;
	Sun, 19 Apr 2026 13:53:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=L8uLgXB72Ql
	xeE4sx3AsF1vgF0s5c2jIIQqL99bJy1Q=; b=dsdP8rImadpWIK9mLB5S9ImIkOz
	xJ0UDSGoCVY3Hk6ktnQoTWgRXgwJtIwDpY9sDQY+ZFBAVZV7KlIdlWlQJF/BP/3K
	/SbTZjBEEj8ggbCENPp0QBEujwyiKkyI/qJ+J6LqNucjDXcGtc3089IMB9IPTw5k
	XxFVkFHCMTdf8JyRPMcGYP9YSzIGUnmCKLO2VJwb0G2izrU+cnwGolelw9VeOrFv
	qY394AsQa1MwdV1rjkNivxoKZPyy8qNS8OAZ31pwVB0Ov5KrdKZv21X8rTxkAb9F
	yGF+wVMeR7iMXaRlF1r+0NRVMmPMzxvIsbiqphKiaj4DHScUygl4Jrfkmbw==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dm2b72kar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 19 Apr 2026 13:53:35 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 63JDmkUH025022;
	Sun, 19 Apr 2026 13:53:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 4dm31hj41b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 19 Apr 2026 13:53:34 +0000 (GMT)
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 63JDmkG9025010;
	Sun, 19 Apr 2026 13:53:33 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 63JDrXpI031959
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 19 Apr 2026 13:53:33 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 61341607; Sun, 19 Apr 2026 06:53:33 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniel Lee <chullee@google.com>,
        Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        Huan Tang <tanghuan@vivo.com>, Liu Song <liu.song13@zte.com.cn>,
        Bean Huo <huobean@gmail.com>,
        vamshi gajjela <vamshigajjela@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] scsi: ufs: core: Introduce function ufshcd_query_attr_qword()
Date: Sun, 19 Apr 2026 06:52:28 -0700
Message-Id: <20260419135229.1036926-2-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260419135229.1036926-1-can.guo@oss.qualcomm.com>
References: <20260419135229.1036926-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Authority-Analysis: v=2.4 cv=KZridwYD c=1 sm=1 tr=0 ts=69e4de5f cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8 a=NbVfUCxmoLbEYo6_3H4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE5MDE0OCBTYWx0ZWRfX8v38yTixI1DO
 zltsYPCRdt78m5zW+/a9HzAj9AbHbYd1zGJuSVuc2Dwp+kzbVDUxnfSL7o5aZbzjXs72f300BbV
 Nz9dSv2FlC4XeqAVMhjykvfrqwt4xOTB5dCZB5o0Dfz3SqlPYvg/q0y/lvahdT4xR8m/BTfO1Yb
 3ev7VdeWw8dYT4kOnRe5CsUjcACHqKpHWkHb1XII5gijxaoYfw82PqVB3HAnxsBOuEAwPu/q9ov
 UwUzh+ytCJ9Jyg8elIUaKtNiRcyww0Phxgaf4JfCanOPPTfYMje1ej0Im44Vz9pR055M5hfp/eV
 YRA+h3x9JEu56cinCzEuWqBSMEDOLJGJDHdBtDIT+c48mFsN1VJ7599Ms6k75NX0GXFDPMXLr1k
 IhYcngPa77x7E/XmgENe20atfM+dJu4bzCfVwiTK6rI9+1ZI0TwmfzPzNJhYImE+pzGfQIJiQz/
 DXyYQnWfjoVQhIKEQmg==
X-Proofpoint-GUID: 5GIQTTXVDTnj8c1XzW-7KMWhet-d7ylS
X-Proofpoint-ORIG-GUID: 5GIQTTXVDTnj8c1XzW-7KMWhet-d7ylS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-19_04,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 clxscore=1011 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604190148

Introduce a new generic function ufshcd_query_attr_qword() to handle
quad-word (64-bit) UFS attribute operations. This consolidates the
handling of 64-bit attributes which was previously scattered across
multiple specialized functions.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-sysfs.c   |  30 ++++++--
 drivers/ufs/core/ufshcd-priv.h |   3 +-
 drivers/ufs/core/ufshcd.c      | 126 +++++++++++++++++----------------
 3 files changed, 94 insertions(+), 65 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 99af3c73f1af..61052df2915c 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -594,8 +594,13 @@ static ssize_t device_lvl_exception_id_show(struct device *dev,
 	u64 exception_id;
 	int err;
 
+	if (hba->dev_info.wspecversion < 0x410)
+		return -EOPNOTSUPP;
+
 	ufshcd_rpm_get_sync(hba);
-	err = ufshcd_read_device_lvl_exception_id(hba, &exception_id);
+	err = ufshcd_query_attr_qword(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+				      QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID,
+				      0, 0, &exception_id);
 	ufshcd_rpm_put_sync(hba);
 
 	if (err)
@@ -1670,6 +1675,12 @@ static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
 		idn <= QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
 }
 
+static inline bool ufshcd_is_qword_attrs(enum attr_idn idn)
+{
+	return idn == QUERY_ATTR_IDN_TIMESTAMP ||
+	       idn == QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID;
+}
+
 static int wb_read_resize_attrs(struct ufs_hba *hba,
 			enum attr_idn idn, u32 *attr_val)
 {
@@ -1736,6 +1747,7 @@ static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
 {									\
 	struct ufs_hba *hba = dev_get_drvdata(dev);			\
+	u64 qword_value;							\
 	u32 value;							\
 	int ret;							\
 	u8 index = 0;							\
@@ -1748,14 +1760,24 @@ static ssize_t _name##_show(struct device *dev,				\
 	if (ufshcd_is_wb_attrs(QUERY_ATTR_IDN##_uname))			\
 		index = ufshcd_wb_get_query_index(hba);			\
 	ufshcd_rpm_get_sync(hba);					\
-	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,	\
-		QUERY_ATTR_IDN##_uname, index, 0, &value);		\
+	if (ufshcd_is_qword_attrs(QUERY_ATTR_IDN##_uname))		\
+		ret = ufshcd_query_attr_qword(hba,			\
+			UPIU_QUERY_OPCODE_READ_ATTR,			\
+			QUERY_ATTR_IDN##_uname,				\
+			index, 0, &qword_value);				\
+	else								\
+		ret = ufshcd_query_attr(hba,				\
+			UPIU_QUERY_OPCODE_READ_ATTR,			\
+			QUERY_ATTR_IDN##_uname, index, 0, &value);	\
 	ufshcd_rpm_put_sync(hba);					\
 	if (ret) {							\
 		ret = -EINVAL;						\
 		goto out;						\
 	}								\
-	ret = sysfs_emit(buf, "0x%08X\n", value);			\
+	if (ufshcd_is_qword_attrs(QUERY_ATTR_IDN##_uname))               \
+		ret = sysfs_emit(buf, "0x%016llX\n", qword_value);		\
+	else								\
+		ret = sysfs_emit(buf, "0x%08X\n", value);		\
 out:									\
 	up(&hba->host_sem);						\
 	return ret;							\
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 0a72148cb053..ed1adeb22ec6 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -60,6 +60,8 @@ int ufshcd_query_attr_retry(struct ufs_hba *hba, enum query_opcode opcode,
 			    u32 *attr_val);
 int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val);
+int ufshcd_query_attr_qword(struct ufs_hba *hba, enum query_opcode opcode,
+			    enum attr_idn idn, u8 index, u8 sel, u64 *attr_val);
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, u8 index, bool *flag_res);
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
@@ -106,7 +108,6 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     enum query_opcode desc_op);
 
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
-int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *exception_id);
 
 int ufshcd_uic_tx_eqtr(struct ufs_hba *hba, int gear);
 void ufshcd_apply_valid_tx_eq_settings(struct ufs_hba *hba);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4805e40ed4d7..e5e22adcbbc3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3611,6 +3611,67 @@ int ufshcd_query_attr_retry(struct ufs_hba *hba,
 	return ret;
 }
 
+/**
+ * ufshcd_query_attr_qword - API function of sending query requests for quad-word attributes
+ * @hba: per-adapter instance
+ * @opcode: attribute opcode
+ * @idn: attribute idn to access
+ * @index: index field
+ * @sel: selector field
+ * @attr_val: the attribute value after the query request completes
+ *
+ * Return: 0 for success, non-zero in case of failure.
+ */
+int ufshcd_query_attr_qword(struct ufs_hba *hba, enum query_opcode opcode,
+			    enum attr_idn idn, u8 index, u8 sel, u64 *attr_val)
+{
+	struct utp_upiu_query_v4_0 *upiu_req;
+	struct utp_upiu_query_v4_0 *upiu_resp;
+	struct ufs_query_req *request = NULL;
+	struct ufs_query_res *response = NULL;
+	int err;
+
+	if (!attr_val) {
+		dev_err(hba->dev, "%s: attribute value required for opcode 0x%x\n",
+			__func__, opcode);
+		return -EINVAL;
+	}
+
+	ufshcd_dev_man_lock(hba);
+
+	ufshcd_init_query(hba, &request, &response, opcode, idn, index, sel);
+
+	switch (opcode) {
+	case UPIU_QUERY_OPCODE_WRITE_ATTR:
+		request->query_func = UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST;
+		upiu_req = (struct utp_upiu_query_v4_0 *)&request->upiu_req;
+		put_unaligned_be64(*attr_val, &upiu_req->osf3);
+		break;
+	case UPIU_QUERY_OPCODE_READ_ATTR:
+		request->query_func = UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
+		break;
+	default:
+		dev_err(hba->dev, "%s: Expected query attr opcode but got = 0x%.2x\n",
+			__func__, opcode);
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
+	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, dev_cmd_timeout);
+	if (err) {
+		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, index %d, selector %d, err = %d\n",
+			__func__, opcode, idn, index, sel, err);
+		goto out_unlock;
+	}
+
+	upiu_resp = (struct utp_upiu_query_v4_0 *)response;
+	*attr_val = get_unaligned_be64(&upiu_resp->osf3);
+
+out_unlock:
+	ufshcd_dev_man_unlock(hba);
+	return err;
+}
+
 /*
  * Return: 0 upon success; > 0 in case the UFS device reported an OCS error;
  * < 0 if another error occurred.
@@ -6224,46 +6285,6 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 				__func__, err);
 }
 
-/*
- * Return: 0 upon success; > 0 in case the UFS device reported an OCS error;
- * < 0 if another error occurred.
- */
-int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *exception_id)
-{
-	struct utp_upiu_query_v4_0 *upiu_resp;
-	struct ufs_query_req *request = NULL;
-	struct ufs_query_res *response = NULL;
-	int err;
-
-	if (hba->dev_info.wspecversion < 0x410)
-		return -EOPNOTSUPP;
-
-	ufshcd_hold(hba);
-	mutex_lock(&hba->dev_cmd.lock);
-
-	ufshcd_init_query(hba, &request, &response,
-			  UPIU_QUERY_OPCODE_READ_ATTR,
-			  QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID, 0, 0);
-
-	request->query_func = UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
-
-	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, dev_cmd_timeout);
-
-	if (err) {
-		dev_err(hba->dev, "%s: failed to read device level exception %d\n",
-			__func__, err);
-		goto out;
-	}
-
-	upiu_resp = (struct utp_upiu_query_v4_0 *)response;
-	*exception_id = get_unaligned_be64(&upiu_resp->osf3);
-out:
-	mutex_unlock(&hba->dev_cmd.lock);
-	ufshcd_release(hba);
-
-	return err;
-}
-
 static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn idn)
 {
 	u8 index;
@@ -9113,35 +9134,20 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
 
 static void ufshcd_set_timestamp_attr(struct ufs_hba *hba)
 {
-	int err;
-	struct ufs_query_req *request = NULL;
-	struct ufs_query_res *response = NULL;
 	struct ufs_dev_info *dev_info = &hba->dev_info;
-	struct utp_upiu_query_v4_0 *upiu_data;
+	u64 ts_ns;
+	int err;
 
 	if (dev_info->wspecversion < 0x400 ||
 	    hba->dev_quirks & UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT)
 		return;
 
-	ufshcd_dev_man_lock(hba);
-
-	ufshcd_init_query(hba, &request, &response,
-			  UPIU_QUERY_OPCODE_WRITE_ATTR,
-			  QUERY_ATTR_IDN_TIMESTAMP, 0, 0);
-
-	request->query_func = UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST;
-
-	upiu_data = (struct utp_upiu_query_v4_0 *)&request->upiu_req;
-
-	put_unaligned_be64(ktime_get_real_ns(), &upiu_data->osf3);
-
-	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, dev_cmd_timeout);
-
+	ts_ns = ktime_get_real_ns();
+	err = ufshcd_query_attr_qword(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				      QUERY_ATTR_IDN_TIMESTAMP, 0, 0, &ts_ns);
 	if (err)
 		dev_err(hba->dev, "%s: failed to set timestamp %d\n",
 			__func__, err);
-
-	ufshcd_dev_man_unlock(hba);
 }
 
 /**
-- 
2.34.1

