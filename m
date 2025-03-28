Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F9039ACC;
	Fri, 28 Mar 2025 20:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743193069; cv=none; b=kX7N2Gw9seO+ZrXHwX4iph9a2IwtrXnsStsL5xKkPaIkS+ihNK3awcGmKbshISYiMlDlTpwfVIl5jB/lt/DN+Vwqqhy85kCb5kv5+NRQChQwmga2RrD5agF4jrPvgojbHdtnAH4ww3PNzFMsNLPN77zfLvZPqRxTBuQ63hOv5HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743193069; c=relaxed/simple;
	bh=MqVWYq9XS7QtfWpX+vZ6G4Blv+2gHjDVRoYFerJunRU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Alhz3iWwRHD7KCN0gBaSfOpeNu0p8dntNFHlvd7GemTyGD0vL7AfXZ2JZiFjJ2YkVXt1ZPpwHdyygb4mTqRp0x+waEHwuebBucDhNlIijv1CS83SfteASHcpw9lGuYnQv5S94kYJ2vV3QU3cMmTgX0B/6vLrwmumPzgfsYLIWJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=UJmZhlih; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="UJmZhlih"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52SDYU4L011698;
	Fri, 28 Mar 2025 20:17:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=KNDbxc7eyTzbaRuAw1sgdRxe5UOPieXWPxKxPxjqLHY=; b=UJ
	mZhlih4092KU2CcZ1tROIKCl+yW0XaQA/FQLpEwzIZM8Z4aqnAF6zV/ZTevxn9td
	j3bzp33cLOzbLHA2Hxjj/0TlRYAdNVuwD03+5+JZEXov7f7umwZ8JerTRkRfJbea
	gyj8SZFR/dvv4eowRTdIoCKWAN26yKBDXetJyecyPh8z8oVBuW9TkyXXb1FsRwvB
	pT7b+VKiZQAdSWlgGwumbT8h7OoxkbTjQ+6LMG1TdMzea6n8tkZAglvlo9X+bl40
	ofIkILjm2ca6W7KjMJ6e24OLcaZMmhPDHEUdS7TzEjCujnf/4jsyGxa3vDCUyiGK
	Q7A6rbiEDijeDfmqRg2w==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45n0kqny6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Mar 2025 20:17:23 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 52SKHNbu003630
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Mar 2025 20:17:23 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Fri, 28 Mar 2025 13:17:22 -0700
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
Subject: [PATCH v2 1/1] scsi: ufs: core: Rename ufshcd_wb_presrv_usrspc_keep_vcc_on()
Date: Fri, 28 Mar 2025 13:17:11 -0700
Message-ID: <02ae5e133f6ebf23b54d943e6d1d9de2544eb80e.1743192926.git.quic_nguyenb@quicinc.com>
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
X-Proofpoint-ORIG-GUID: ALcpkPORBPoOGiUJNTZgnpQUo5b6QY_l
X-Authority-Analysis: v=2.4 cv=FrcF/3rq c=1 sm=1 tr=0 ts=67e703d3 cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=Vs1iUdzkB0EA:10 a=COk6AnOGAAAA:8 a=IMHNDf2ypZXSRH1sUZ0A:9 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: ALcpkPORBPoOGiUJNTZgnpQUo5b6QY_l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-28_10,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 clxscore=1015 suspectscore=0 malwarescore=0 adultscore=0 impostorscore=0
 mlxscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503280136

The ufshcd_wb_presrv_usrspc_keep_vcc_on() function has deviated
from its original implementation. The "_keep_vcc_on" part of the
function name is misleading. Rename the function to
ufshcd_wb_curr_buff_threshold_check() to improve the
readability. Also, updated the comments in the function.
There is no change to the functionality.

Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
---
Changes in v2:
Reverted to original implementation. Only changed the function
name. Updated the commit message (Avri's and Bart's comments).
---
 drivers/ufs/core/ufshcd.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4e1e214..310707f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6083,7 +6083,7 @@ int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable)
 	return ret;
 }
 
-static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
+static bool ufshcd_wb_curr_buff_threshold_check(struct ufs_hba *hba,
 						u32 avail_buf)
 {
 	u32 cur_buf;
@@ -6165,15 +6165,13 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
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
@@ -6188,7 +6186,7 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 	if (!hba->dev_info.b_presrv_uspc_en)
 		return avail_buf <= UFS_WB_BUF_REMAIN_PERCENT(10);
 
-	return ufshcd_wb_presrv_usrspc_keep_vcc_on(hba, avail_buf);
+	return ufshcd_wb_curr_buff_threshold_check(hba, avail_buf);
 }
 
 static void ufshcd_rpm_dev_flush_recheck_work(struct work_struct *work)
-- 
2.7.4

