Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB96F20328;
	Tue, 27 Aug 2024 23:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724800489; cv=none; b=tJnEX4/ucS32SD4BM6YRe6a6eUA6Wx1r8twlb5qTOmHsCWvz+429776Uisozg7VqBRuuD1NUTlozk85BNCNTUwyWRyKuAS9AxM37KpjrMkF2+YCsCGbSlyfTrvUzIrRouReFqVx8oXKHynz3OmcJdVA43/9ZVTCtTgseq9Lt30c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724800489; c=relaxed/simple;
	bh=UWBjnG4XfM+5qMMM7Xy4uYDZNDy57ECVqZwYsqtaa7k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NLOenPR14R+xKiR96ZOLkxbEEZAG4l8Vx8OdNV0mJDsh2PWgJYLPQYNAE46mSm/Cpbjru/AIXKbCBTheAa++GSN4nykBcvl/RAXw2brEBA+x3jpfg/F9B5dpWe2ELWqzwTeC8EaOCvs+KN5/fgthYAztTqCee44IWCRVyxvRaf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=KYeqVrfT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="KYeqVrfT"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47RLelH6009010;
	Tue, 27 Aug 2024 23:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=ndf8QZtW+qgyKz/FJGZ875Az4Ew53Z7g48j1N4SkQlo=; b=KY
	eqVrfTK5rDUyYmbWGD0Qmma8Bb8HvGFX71uXe0wjLrpKkLKGPBtgDtr/lnH11WPy
	Dw6EwuwWzQOu2Yv7aTMxvBTTRbOhaCYCoNzMqICllTpYI10EuFRCj5S+uNdq8kJv
	O8XqzkXnHYhgycKMdpM1JenmMCE3XrZDWlKsiortUZbfybzTKcJcHkzs9HoZ8GHD
	3DpgV5XEKjfQQzG3dnKA4N9HKGqSxi8hN8OUBc7TYNruc4W0MfCYJRS7wkc/pDXH
	tOsUkys/A3uSgrZmT/7Z5sSWE4pKs14jX362p7Qf+hYoYAYRSkkfXT+5unA+gcAy
	vprQ2vFbn06ZDO0X1QFQ==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 419px5g4dk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Aug 2024 23:14:31 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47RNEUsJ014459
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Aug 2024 23:14:30 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Tue, 27 Aug 2024 16:14:30 -0700
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <manivannan.sadhasivam@linaro.org>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, ChanWoo Lee
	<cw9316.lee@samsung.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        "open
 list" <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 1/1] scsi: ufs: core: Remove ufshcd_urgent_bkops()
Date: Tue, 27 Aug 2024 16:14:13 -0700
Message-ID: <0c7f2c8d68408e39c28e3e81addce09cc0ee3969.1724800328.git.quic_nguyenb@quicinc.com>
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
X-Proofpoint-ORIG-GUID: tWbLZ-uLWet3gnzv3ywxUEq5ilTOlphc
X-Proofpoint-GUID: tWbLZ-uLWet3gnzv3ywxUEq5ilTOlphc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-27_10,2024-08-27_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 adultscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2408270170

The ufshcd_urgent_bkops() is a wrapper function.
It only calls the ufshcd_bkops_ctrl(). Remove it to
simplify the ufs core driver. Replace any references
to ufshcd_urgent_bkops() with ufshcd_bkops_ctrl().

In addition, remove the second parameter in the
ufshcd_bkops_ctrl() because the information can be
retrieved from the first parameter.

Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
---
 drivers/ufs/core/ufshcd.c | 32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 21429ee..a52c95b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5895,12 +5895,11 @@ static inline int ufshcd_get_bkops_status(struct ufs_hba *hba, u32 *status)
 /**
  * ufshcd_bkops_ctrl - control the auto bkops based on current bkops status
  * @hba: per-adapter instance
- * @status: bkops_status value
  *
  * Read the bkops_status from the UFS device and Enable fBackgroundOpsEn
  * flag in the device to permit background operations if the device
- * bkops_status is greater than or equal to "status" argument passed to
- * this function, disable otherwise.
+ * bkops_status is greater than or equal to the "hba->urgent_bkops_lvl",
+ * disable otherwise.
  *
  * Return: 0 for success, non-zero in case of failure.
  *
@@ -5908,11 +5907,11 @@ static inline int ufshcd_get_bkops_status(struct ufs_hba *hba, u32 *status)
  * to know whether auto bkops is enabled or disabled after this function
  * returns control to it.
  */
-static int ufshcd_bkops_ctrl(struct ufs_hba *hba,
-			     enum bkops_status status)
+static int ufshcd_bkops_ctrl(struct ufs_hba *hba)
 {
-	int err;
+	enum bkops_status status = hba->urgent_bkops_lvl;
 	u32 curr_status = 0;
+	int err;
 
 	err = ufshcd_get_bkops_status(hba, &curr_status);
 	if (err) {
@@ -5934,23 +5933,6 @@ static int ufshcd_bkops_ctrl(struct ufs_hba *hba,
 	return err;
 }
 
-/**
- * ufshcd_urgent_bkops - handle urgent bkops exception event
- * @hba: per-adapter instance
- *
- * Enable fBackgroundOpsEn flag in the device to permit background
- * operations.
- *
- * If BKOPs is enabled, this function returns 0, 1 if the bkops in not enabled
- * and negative error value for any other failure.
- *
- * Return: 0 upon success; < 0 upon failure.
- */
-static int ufshcd_urgent_bkops(struct ufs_hba *hba)
-{
-	return ufshcd_bkops_ctrl(hba, hba->urgent_bkops_lvl);
-}
-
 static inline int ufshcd_get_ee_status(struct ufs_hba *hba, u32 *status)
 {
 	return ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
@@ -9801,7 +9783,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			 * allow background operations if bkops status shows
 			 * that performance might be impacted.
 			 */
-			ret = ufshcd_urgent_bkops(hba);
+			ret = ufshcd_bkops_ctrl(hba);
 			if (ret) {
 				/*
 				 * If return err in suspend flow, IO will hang.
@@ -9990,7 +9972,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		 * If BKOPs operations are urgently needed at this moment then
 		 * keep auto-bkops enabled or else disable it.
 		 */
-		ufshcd_urgent_bkops(hba);
+		ufshcd_bkops_ctrl(hba);
 
 	if (hba->ee_usr_mask)
 		ufshcd_write_ee_control(hba);
-- 
2.7.4

