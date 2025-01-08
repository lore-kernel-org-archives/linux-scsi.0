Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D156A19EEBF;
	Wed,  8 Jan 2025 23:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736380562; cv=none; b=WNgHjZVYMOgLPLjWkcVpkXt6Aup+RvQKhVYnPJC81xb62bDlgU8APR3mYI9JAmwxZIJGncCFw+oFuEG6DFbFGKgjrKoA9irDk7HrklgBiFkkh99m+z3mt3ISo0ssRe9S0E1y45Gdl6mfd9okQG/CTWSAi9/mTG9tnRaA9yGKIoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736380562; c=relaxed/simple;
	bh=n7afv02qo6u96L9j3FA8Sql6Koxsq/HF9WBO1Eb1EEE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tEtx8iU7I4PiF0vuOrQMO/poB/NHdW54YR4tBT5fyWa2LvSK8IXzDbdVDha1HxUN/fa9qriPWz15VHixOyxEyfmIrcjPzKzmwv6kbptZMaQCiEqTlMiY3hWbAY0IylVBmowM2w+vv54Pd9ZSK/0vCtIEo/BK9GS8WVH3hWqJC6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=mOaMCNMm; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="mOaMCNMm"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508HN8uM016072;
	Wed, 8 Jan 2025 23:55:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=fsTFgKBXT0ESfb+2y174dP1Hdu/HPOCLZf/c+ERCUYQ=; b=mO
	aMCNMmwGH9r5qeAq0ivmdR3M/5SBCefGTNjwHMi2mHd+8bZ0CYL+x0rFyUsJtdPa
	um+pTWSjbf6MbJ+Kajo8oFJ1p250dssdJMjQBK/MyhW4itngBJzvl97XBR9rbB27
	9iR5sYYsnZL4I4qBfq6k+QR9oWyRq+F5dBOt2cAbIfAQu/ZiUbJo6A9GIBtxkDuu
	TqG/SBhDby3kD+rn50SjXnBPalOmz3I2OXa/UEGGJ+2PAlLlNNfT04r67c7BXSRA
	m55pJ8xKMvx9+3XlHCEDaABg9DwIiY13smlE9n6ji3V6mm9Y4rZfWPB7dF1My7lB
	D2kKD64yE6MKE5fElHYA==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 441wq50tqt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 23:55:23 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 508NtMnZ012997
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 8 Jan 2025 23:55:22 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Wed, 8 Jan 2025 15:55:22 -0800
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <bvanassche@acm.org>, <avri.altman@wdc.com>,
        <peter.wang@mediatek.com>, <manivannan.sadhasivam@linaro.org>,
        <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>,
        "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>, Daejun Park
	<daejun7.park@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>,
        open list
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1 1/1] scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit Definitions
Date: Wed, 8 Jan 2025 15:55:09 -0800
Message-ID: <5df3cb168d367719ae5c378029a90f6337d00e79.1736380252.git.quic_nguyenb@quicinc.com>
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
X-Proofpoint-GUID: DpzO4G3lh-2-OApubJg4Hf9YhwOBQP4z
X-Proofpoint-ORIG-GUID: DpzO4G3lh-2-OApubJg4Hf9YhwOBQP4z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1011 malwarescore=0 mlxlogscore=768 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501080196

According to the UFS Device Specification, the bUFSFeaturesSupport
defines the support for TOO_HIGH_TEMPERATURE as bit[4] and the
TOO_LOW_TEMPERATURE as bit[5]. Correct the code to match with
the UFS device specification definition.

Fixes: e88e2d322 ("scsi: ufs: core: Probe for temperature notification support")
Cc: stable@vger.kernel.org
Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
---
 include/ufs/ufs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index e594abe..f0c6111 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -386,8 +386,8 @@ enum {
 
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
-	UFS_DEV_LOW_TEMP_NOTIF		= BIT(4),
-	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(5),
+	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(4),
+	UFS_DEV_LOW_TEMP_NOTIF		= BIT(5),
 	UFS_DEV_EXT_TEMP_NOTIF		= BIT(6),
 	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
-- 
2.7.4

