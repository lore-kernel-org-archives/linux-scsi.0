Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B21F8462;
	Thu, 27 Mar 2025 06:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743057555; cv=none; b=lv9ugIy0Bs3Vjb+Iyn5UdlEVK6LbEkqkdRCwU2EKKyh8m8hF00ER1nfCyCIKqTaB3OKjX1GdUVHj2HfUyvhUpaVuRLQtR63iptzw0wYc1so6A3XCc2GPkW2gstgweDNQG1h1qGYw8aOWqfMcIl8pJ49Y1jxPtP90IjImLkPZC6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743057555; c=relaxed/simple;
	bh=69OQaw6iHmI2FOTiSUfyqaKpDYawQwEdgTz/BtuItFU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UnZPAROWqzGNBXG/i7VlnLRxasl6/7kxaad6NP6JCMPMLXiP7PWUQ/mgrhqo1sJF5Pzq8x65vcbvAOX3VN+hevlhlEBUkb2fPkV1gjxiyvnsrfF+FvOOhTZpgQx+9gGxV4migcbZYFUMAgcB9Sx45axbld1/w3nxZEVzyO/+BTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=eVJ6fsiX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="eVJ6fsiX"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52R5jFRM010171;
	Thu, 27 Mar 2025 06:38:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=tRR6RWBz3+WGQMy2m7+wW7R5uDZSyow8ksYYa8vdJaQ=; b=eV
	J6fsiXOnomcW3hw75M/J5q8GjBNwaWT8/sx1kkGnY6+14ElO/Q10Ag2xX4/XL1hQ
	gh41WB3R1SfdM+W16tZkz27U7cK8vdvVw6Pl9AFwWXIRq/3KOjErmsVUW0EcY7wi
	b8WgnoxnS77b4zD8wdH7nRRgZB/IX6FP9WlHn34BsIXkOJZaJdJ4PtESSTmFMHmx
	Bfn6BnTyTAT89VOawZWJ5h/JEqIyFGD3GLF70/e7qjDNlpfifLcNwUaMRZW0rLit
	LZ1IPzObZGfIYUvMLR62JJtsGZCabqqm9LEZaZNtkS874fkkiOKRzqn3uh6tmek1
	poi4X5H5JW0PNt0KcVOw==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45kmcyfjt6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Mar 2025 06:38:20 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 52R6cJ8i024019
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Mar 2025 06:38:19 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Wed, 26 Mar 2025 23:38:19 -0700
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <bvanassche@acm.org>, <avri.altman@wdc.com>,
        <peter.wang@mediatek.com>, <manivannan.sadhasivam@linaro.org>,
        <minwoo.im@samsung.com>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        open list
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1 1/1] scsi: ufs: core: Removed ufshcd_wb_presrv_usrspc_keep_vcc_on()
Date: Wed, 26 Mar 2025 23:38:07 -0700
Message-ID: <9ff613809e88496b5802a2d45984d2a8dddf92dd.1743057420.git.quic_nguyenb@quicinc.com>
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
X-Authority-Analysis: v=2.4 cv=EZ3IQOmC c=1 sm=1 tr=0 ts=67e4f25c cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=Vs1iUdzkB0EA:10 a=COk6AnOGAAAA:8 a=T9f8hDbICis96D9fBvkA:9 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: 5mkk4etoXAyKzCA9xz83EFD-BI6GJuOV
X-Proofpoint-GUID: 5mkk4etoXAyKzCA9xz83EFD-BI6GJuOV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-26_09,2025-03-26_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 phishscore=0
 adultscore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503270041

Merge the ufshcd_wb_presrv_usrspc_keep_vcc_on() function
into ufshcd_wb_need_flush(). The "_keep_vcc_on" part of the
function name is misleading. The function definition may be
deviated from its original intention. This is a small function
only invoked by the ufshcd_wb_need_flush(). To improve the
readability, remove this function and merge its content
into its caller. There is no change to the functionality.

Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
---
 drivers/ufs/core/ufshcd.c | 53 +++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4e1e214..b9272b1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6083,32 +6083,6 @@ int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable)
 	return ret;
 }
 
-static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
-						u32 avail_buf)
-{
-	u32 cur_buf;
-	int ret;
-	u8 index;
-
-	index = ufshcd_wb_get_query_index(hba);
-	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
-					      QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE,
-					      index, 0, &cur_buf);
-	if (ret) {
-		dev_err(hba->dev, "%s: dCurWriteBoosterBufferSize read failed %d\n",
-			__func__, ret);
-		return false;
-	}
-
-	if (!cur_buf) {
-		dev_info(hba->dev, "dCurWBBuf: %d WB disabled until free-space is available\n",
-			 cur_buf);
-		return false;
-	}
-	/* Let it continue to flush when available buffer exceeds threshold */
-	return avail_buf < hba->vps->wb_flush_threshold;
-}
-
 static void ufshcd_wb_force_disable(struct ufs_hba *hba)
 {
 	if (ufshcd_is_wb_buf_flush_allowed(hba))
@@ -6152,9 +6126,9 @@ static bool ufshcd_is_wb_buf_lifetime_available(struct ufs_hba *hba)
 
 static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 {
-	int ret;
-	u32 avail_buf;
+	u32 avail_buf, cur_buf;
 	u8 index;
+	int ret;
 
 	if (!ufshcd_is_wb_allowed(hba))
 		return false;
@@ -6165,15 +6139,13 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 	}
 
 	/*
-	 * The ufs device needs the vcc to be ON to flush.
 	 * With user-space reduction enabled, it's enough to enable flush
 	 * by checking only the available buffer. The threshold
 	 * defined here is > 90% full.
 	 * With user-space preserved enabled, the current-buffer
 	 * should be checked too because the wb buffer size can reduce
 	 * when disk tends to be full. This info is provided by current
-	 * buffer (dCurrentWriteBoosterBufferSize). There's no point in
-	 * keeping vcc on when current buffer is empty.
+	 * buffer (dCurrentWriteBoosterBufferSize).
 	 */
 	index = ufshcd_wb_get_query_index(hba);
 	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
@@ -6188,7 +6160,24 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 	if (!hba->dev_info.b_presrv_uspc_en)
 		return avail_buf <= UFS_WB_BUF_REMAIN_PERCENT(10);
 
-	return ufshcd_wb_presrv_usrspc_keep_vcc_on(hba, avail_buf);
+	index = ufshcd_wb_get_query_index(hba);
+	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+				      QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE,
+				      index, 0, &cur_buf);
+	if (ret) {
+		dev_err(hba->dev, "%s: dCurWriteBoosterBufferSize read failed %d\n",
+			__func__, ret);
+		return false;
+	}
+
+	if (!cur_buf) {
+		dev_info(hba->dev, "dCurWBBuf: %d WB disabled until free-space is available\n",
+			 cur_buf);
+		return false;
+	}
+
+	/* Let it continue to flush when available buffer exceeds threshold */
+	return avail_buf < hba->vps->wb_flush_threshold;
 }
 
 static void ufshcd_rpm_dev_flush_recheck_work(struct work_struct *work)
-- 
2.7.4

