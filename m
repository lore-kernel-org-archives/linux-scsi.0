Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B26C26159E;
	Thu,  9 Oct 2025 20:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760040698; cv=none; b=nSn+AXDAN1UIn9JGsGcSeADjDHTFJRdhzUvBJfr7cSy52iE73KE1ZtzIw6I8LKgilP4ctuKcaHiuSWvy9VKY5K8JSchtiwA6GLMBXGg10B564BkyWr47Ffn6Nss8mPqujx7DpDou2w6i1XGmz+B6exb7z7glfmSqIl9LVkcTLjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760040698; c=relaxed/simple;
	bh=hpM/ogVqdHozQMjR5/y/Jhr+AaojI4C95c9N+Z7I41s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pL7it9C+boRu7rJsulXKUstk6DeasGy1CShiHsiiJVZEmD3Pybx7OlHhCpVHpKODyGIsBpOzb66ZhNVTMzotKA2Ehn8NR2akD8CQp3u8jjc0lvet7hHHTopGQD0UI6aMDq91KNwKlrJwJE4eSXBzKUxgf6U2tCs0qrLc03/Xu4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=DU7T643a; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="DU7T643a"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 599ELcF4012475;
	Thu, 9 Oct 2025 20:11:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=YnTfQeXJbp7KmtxXRP1QEF8y
	LUMvyRpjuX1yUd2RGEk=; b=DU7T643a4/C4NaOyZDp6ivw8RgpOP3a1sgjRlyIG
	cYmm40hkvGbcKr4ef8ZecurG8giLNT3N8K5HRGDZrDEB4rh6LtSb4v5xwhJjYVSp
	mk4Kq6vmv1aXrhmbverdiv/bB0+jmdaUtNcN9TkvOOzVRx0jQB0h3ibXIioEKus3
	+M7gbYqrwhaUDiU//J9DE5H9iu1Fv9MHY6p257HHM7VyHkxUrGybddMB02UkI9vz
	mMWqIEfwA+HhtuGp9zj1FOECC0A6dYUjB9S6upDioqrH6S88sBs81r2JQ9DTvovI
	Oyr0a9qdBVQnmUefTQHaumd2R/5UFngyrEVs60Kn87fPyA==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49nv4km711-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 20:11:19 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 599KBJl8003070
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 9 Oct 2025 20:11:19 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.24; Thu, 9 Oct 2025 13:11:18 -0700
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <adrian.hunter@intel.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Bean Huo <beanhuo@micron.com>,
        "Neil
 Armstrong" <neil.armstrong@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/2] scsi: ufs: core: Replace hard coded vcc-off delay with a variable
Date: Thu, 9 Oct 2025 13:10:59 -0700
Message-ID: <7df97c5bf49d7e53435725062bcff2ccd77a6959.1760039554.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1760039554.git.quic_nguyenb@quicinc.com>
References: <cover.1760039554.git.quic_nguyenb@quicinc.com>
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
X-Authority-Analysis: v=2.4 cv=dojWylg4 c=1 sm=1 tr=0 ts=68e816e7 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=x6icFKpwvdMA:10 a=COk6AnOGAAAA:8 a=BYDoPV6jByX-8JW-AE8A:9
 a=TjNXssC_j7lpFel5tvFf:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: s7GE2pDgRNKfdBajkgZdRUCQfjtwFNQR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX/7O4oVBqqp/Y
 C21+nQcJ4V3G8IeqyJujZuQ8+42zsd+OaAFWAqfY01eIUSNiTEvYTkGMfgAW3RKlvYerCK1gcU5
 JwSx5CvTc28uxSlucRljD0Hx8+pq6s8Txk4bAPJ9UBNzUYgZ4T+zMnGoJ0e/5YgY9AGPR9re/vV
 jYTjVa16WNSPLI2jk+q1cFhiaATy/k8xIewPeXLMkPrdXclQm6+TbZkAqAY+LUWISi5GidtRVak
 fmYNt7KlBEsluPRzqLWxjGMsBdROFT8ck/DLtDmOobGjUpjtjaKjqhDiPmSu7OiGVG39voqHv8i
 Y8IMf4tJh+OY1QQPz4kvGcwChdh2TvpJpxUdsXqT8AXh6EMDuabcsBfAF+CGyf9/Gpx0S+gf1Mp
 e+jXqXBeVA5I17EF2b5PuzvLeeH8Jg==
X-Proofpoint-ORIG-GUID: s7GE2pDgRNKfdBajkgZdRUCQfjtwFNQR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121

After the ufs device vcc is powered off, all the ufs device
manufacturers require a minimum of 1ms of power-off time before
vcc can be powered on again. This requirement has been verified
with all the ufs device manufacturer's datasheets.

Replace the hard coded 5ms delay with a variable using a default
setting of 5ms. This allows the platform drivers to override this
setting to improve the system resume latency by reducing the sleep
time as needed.

Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
---
 drivers/ufs/core/ufshcd.c | 10 +++++++++-
 include/ufs/ufshcd.h      |  2 ++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e8842dc..593c9d0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9741,7 +9741,8 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
 	 * All UFS devices require delay after VCC power rail is turned-off.
 	 */
 	if (vcc_off && hba->vreg_info.vcc && !hba->vreg_info.vcc->always_on)
-		usleep_range(5000, 5100);
+		usleep_range(hba->sleep_post_vcc_off,
+			     hba->sleep_post_vcc_off + 100);
 }
 
 #ifdef CONFIG_PM
@@ -10665,6 +10666,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 						UFS_SLEEP_PWR_MODE,
 						UIC_LINK_HIBERN8_STATE);
 
+	/*
+	 * Most ufs devices require 1ms delay after vcc is powered off before
+	 * it can be powered on again. Set the default to 5ms. The platform
+	 * drivers can override this setting as needed.
+	 */
+	hba->sleep_post_vcc_off = 5000;
+
 	init_completion(&hba->dev_cmd.complete);
 
 	err = ufshcd_hba_init(hba);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 1d39437..ad49979 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1140,6 +1140,8 @@ struct ufs_hba {
 	int critical_health_count;
 	atomic_t dev_lvl_exception_count;
 	u64 dev_lvl_exception_id;
+
+	u32 sleep_post_vcc_off;
 };
 
 /**
-- 
2.7.4

