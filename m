Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1F2369967;
	Wed,  4 Mar 2026 13:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772632450; cv=none; b=BihRc2Eio4XSgVuwDN5TKbaTM7aElPehldwdpAdVVYuqAusoc4vmK5RabA43Gf6KWg4MJw60xWp+2U1U2nRe3YGg5wfIhiE3CnDv6x9PFVYJ01JkeKdn9mPv+RxZI+43a+F1+SMKvTLRmP6i7DIJ0HKGXEXQSMNMAcl83bajIuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772632450; c=relaxed/simple;
	bh=aZDjQzXjLCM3ky+djtvzdXv9R1WFRzycOW8WOOKmOTE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l3Mavj7pE+ZEekvfMrpTfYIWcoZzw3rNhvCVPM6I7suqFrQ14TfQVZxQfeITlDbmzsGoTE/GVWK4n3djKnQv0jCO0BwzHsORJsASRc4ydpybKzM2nE5JjVXmJGzqjBfnIBp34VnqJmxIEubb/N/dcCT7WfJzxIo0zq6V7+0+OWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BTH7BfAt; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BTH7BfAt"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624C0qlD2306277;
	Wed, 4 Mar 2026 13:53:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=/6sLYanh5Rc
	SU5g5POu/9B5+O4PpDSruG0y2miJrtp0=; b=BTH7BfAtxerWMaf9W3Sh+w1WJUV
	6NSmMllWzZNIZIRS0Fl+VBbFmOumcs8rzGLSOLsUb6y1PlzfxQ0Pp9CNzZLLv8et
	6T20gIluMx9dy5yNfRbJQ5ih14H8wA+xW75soHERpyPNXXv/HNalXiFpwFKpeeww
	sYpQTcMbpl5BizWqTCCiZgn58juNO7Hd71a7BcXT8K0omfg2Eo7volOlSp8AExPm
	TkYolkP1MNQKAUintyt5qTRK+Us0k4MuSXTGrHFTkRUd90O/alwmQFQaZnsQ0e1D
	lLas3gNYjnJUWegrdcKhRGfkHe7ygCGnhNSOmQM7cnD7n0odlNrzDtR+zAQ==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cpau8tb03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 13:53:45 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 624Driss005494;
	Wed, 4 Mar 2026 13:53:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4cp8uh03qa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 13:53:44 +0000
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 624DriC0005488;
	Wed, 4 Mar 2026 13:53:44 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 624DrhPV005487
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 13:53:44 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id C697D5A7; Wed,  4 Mar 2026 05:53:43 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 03/11] scsi: ufs: core: Add UFS_HS_G6 and UFS_HS_GEAR_MAX to enum ufs_hs_gear_tag
Date: Wed,  4 Mar 2026 05:53:05 -0800
Message-Id: <20260304135313.413688-4-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=AJS1/0o2 c=1 sm=1 tr=0 ts=69a83969 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8 a=eBzKeFCim48PKetIR0oA:9
X-Proofpoint-ORIG-GUID: iaWSxXmpYDSuHWGnYkp859xas5wfDXRT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDExMSBTYWx0ZWRfXxQjgK6oEWDDX
 F9uNcmBdA+cNWSwptbH4gWXs7AED/bXrbHMKMXYeMmtIAMIMhuUzJch1Y0hPiLGu1MyV47noYeh
 DZPItuF7ZnNXU7ibEWiyn4k4ozp/Xtlft4JkhRnCdj5t4SzYPkbyJPKpATG2BKG+yDHc8qElKUQ
 v20OxeWWsnImf88vionXRzo49FtL+z8vCIl+gZQ1DyHgJJQzFV/zB7RYg/iO8sBlcjukwElOeck
 fjx33Jdgi8tQ3F3CGafeWfRbD4kUnbFJra8rPK+/mkfsIUbOiYrvkItF3Ap3nTdRcCifLtMbFv9
 n5g+bHE124oxCb2B5WSs4GdNbu/L2k75hFkvsCKu9nRTLdffC6zaqEHd5v91FT48LqUH0pE4fFv
 mrENfxTGREJyQmMb3Z2PRVhR6wlvEIsAJUQDjr0ZEzIS8hFNjtEbyg3z7rz7cNGp+Tt0ZxRfesJ
 QMpCINSaDqWYyRlXdKA==
X-Proofpoint-GUID: iaWSxXmpYDSuHWGnYkp859xas5wfDXRT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_06,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 adultscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603040111

Add UFS_HS_G6 to enum ufs_hs_gear_tag. In addition, add UFS_HS_GEAR_MAX to
enum ufs_hs_gear_tag to facilitate iteration over valid High Speed Gears.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 include/ufs/unipro.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index 59de737490ca..eccb45d3b86c 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -233,7 +233,9 @@ enum ufs_hs_gear_tag {
 	UFS_HS_G2,		/* HS Gear 2 */
 	UFS_HS_G3,		/* HS Gear 3 */
 	UFS_HS_G4,		/* HS Gear 4 */
-	UFS_HS_G5		/* HS Gear 5 */
+	UFS_HS_G5,		/* HS Gear 5 */
+	UFS_HS_G6,		/* HS Gear 6 */
+	UFS_HS_GEAR_MAX,
 };
 
 enum ufs_lanes {
-- 
2.34.1

