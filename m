Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AE224025F;
	Mon, 13 Jan 2025 18:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736793185; cv=none; b=O6feuMbLCAD6BMgxT0jRp1DcRFksajydwaEAf49DmxLhIxMTpC0Nil61eP613Kdp0xI7eCJzMpswmPNGEcvTQcPAiiXx/nYBDdDhPR/5iPXaLcKCsvVuWJkof8p7pOmGrmhQ55A3wX2+3XVQarbrMfrDS6aGWdyVTjNeATcWwtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736793185; c=relaxed/simple;
	bh=21fLidw53ojjN6zpuTtPCwTEbbqcmGogU6ieugMHJNQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bY19/kHjvFFm2SNFkI17ao9ApCvp+oK1xv4H8j6UBggQroz3e9DSOiuReowcYRtReLwmPd6nElYJnJ4HVzIu9y90E1XQPQAQxYmkCLWAtqjOm0QuecXqqMubjfXCJxtWi3P/O1aNzXMJBjGdv4Ad5zaQKunMywj7flbxS/K5hKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=QoHiOcBl; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="QoHiOcBl"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50DCsb8j001497;
	Mon, 13 Jan 2025 18:32:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=Y5YOAJ/JeD4pnofa3cuaSRIqBLD/9xsyiZ9wVPVgYwg=; b=Qo
	HiOcBl+baX2rZk2toQ8eL6fz3YhY9+DDJslqUgFZZ6hADlD2JG5iZF7T6c6E6YiQ
	R5Oi4/HsPW6SHawfZyNelm2U6TwUreTB5gcfUAI4+7FRJ56xuyXR3JnGiPV7GhlX
	RR1s6rsVYMZua8p17JP698rmGcymP/lO+sKkMmS9DfdKhahAv3na4sHjMG5qopxS
	kzq7tHC7afQuCgfbXiap/eUq49vDbHtLD6U+JetkR8EPZN9XpcRbMl6VDEHuBO8a
	UgP8DRlRYPweYF0j1f+fXTJwG56Qk9KEl9Dj2/54rQhznt93jKxSh7umd8kUJdgL
	kympfQLqUO4x5l8u9wRg==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 44538jgt6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 18:32:33 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 50DIWWAK020112
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 18:32:32 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Mon, 13 Jan 2025 10:32:32 -0800
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
Subject: [PATCH v2 1/1] scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit Definitions
Date: Mon, 13 Jan 2025 10:32:07 -0800
Message-ID: <69992b3e3e3434a5c7643be5a64de48be892ca46.1736793068.git.quic_nguyenb@quicinc.com>
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
X-Proofpoint-ORIG-GUID: fSY7ZQTqWuieRlJapXuf7L5w-XQYfCs7
X-Proofpoint-GUID: fSY7ZQTqWuieRlJapXuf7L5w-XQYfCs7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=687 clxscore=1015 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501130149

According to the UFS Device Specification, the dExtendedUFSFeaturesSupport
defines the support for TOO_HIGH_TEMPERATURE as bit[4] and the
TOO_LOW_TEMPERATURE as bit[5]. Correct the code to match with
the UFS device specification definition.

Fixes: e88e2d322 ("scsi: ufs: core: Probe for temperature notification support")
Cc: stable@vger.kernel.org
Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Reviewed-by: Avri Altman <Avri.Altman@wdc.com>
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

