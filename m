Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F822C21E8;
	Mon, 13 Oct 2025 19:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760384342; cv=none; b=cKO6eIu14xvaIQD+mRzvsOOQaz4lSrXniihXlleU/egZc4/xzPLG8+tkxB7mvV7c5g1dgcpgoy7EjQ1PSF9L+P+mZGBCe9R1BO92BYGsIlLeRxNJOtXRzKOameF4d4oRfrsgeeGYtTBr2EDIHjsiu6CeIbqJT4fJqarcWekZOyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760384342; c=relaxed/simple;
	bh=Fm93mPt8FzNaS2HaMTo/CMPwKmey2XtxYKmR5Nulu5A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r43s3YR8LxEfaEPpRrvCRKDGJa603aMwoQv4aROKi4deEkC5kFtJiXlgnooWwehblYJ47SckwKSwbXpt1ZchkcokuPJ2+B/2pz31ixUFo3zgE1sjU7iqISLDasYXCCB8ugZjEf07L12micX8ENuFJxwkTWVWcjbIqlQBh2jgkAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Ph5RhtFo; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Ph5RhtFo"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59DHD7sm018935;
	Mon, 13 Oct 2025 19:38:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=KpDcrDX5iKA+etXRtyLWzkYD
	OsF6AA7RbKVi9Vwts9g=; b=Ph5RhtFoUKu05KPnuyv+R+UzkhOh6XMPdZpmCwU5
	d2gJ/WE5tk/i7BraOsZoNUl67WLPL81tYn5N59ZEiMG/4vN6xW2pC2prjmUkgbbn
	Aqv+9InwqQ9pZ+Zs1EXo6ZIIMSHq1NkpT88vDSENWr1OjK+VbSsOAel5qUKZtS6H
	P9G+LdVK7olKl7qkKqOp8Hja5/I8NaGVTmX7TyJ8to2AS22oS55YxcebKKio37o0
	5iV7R5LTpT01YDv+3BCphZGbhmB3VtRfpNRz1+zcO4yHE3YR3aWzh49BedJCNAl4
	JI/8wgNVzbXp25kMRuOgbvsjlhSYwcHhTmYL6UZ0/l0u5Q==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49qferww5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Oct 2025 19:38:35 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 59DJcY7X015398
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Oct 2025 19:38:34 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.24; Mon, 13 Oct 2025 12:38:34 -0700
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
Subject: [PATCH v3 2/2] scsi: ufs: core: Replace hard coded vcc-off delay with a variable
Date: Mon, 13 Oct 2025 12:38:16 -0700
Message-ID: <72fa649406a0bf02271575b7d58f22c968aa5d7e.1760383740.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1760383740.git.quic_nguyenb@quicinc.com>
References: <cover.1760383740.git.quic_nguyenb@quicinc.com>
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
X-Authority-Analysis: v=2.4 cv=R64O2NRX c=1 sm=1 tr=0 ts=68ed553b cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=x6icFKpwvdMA:10 a=COk6AnOGAAAA:8 a=N54-gffFAAAA:8
 a=BYDoPV6jByX-8JW-AE8A:9 a=TjNXssC_j7lpFel5tvFf:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: mQtgdzw4f32xssi-MnlSDsomM05gFI2y
X-Proofpoint-ORIG-GUID: mQtgdzw4f32xssi-MnlSDsomM05gFI2y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxOCBTYWx0ZWRfX4l1VyFoTZ7iY
 mfzmix0WVoJ09WNnzh4BCUphcMnMMGOu/JICQ1b30ZZ/o7Y7xWV0gaSj1c6KojrI8TWj2Qg5fg6
 icj0Wt3PX2POO2zHB49hA/MgfWvxpUoZdNhjynIEgqL+kNQmHbSSaYMiUir9Laoyxyw1NrCElvU
 9pkdkt00v+yTNM78F1afQADMssT79+wfEMO8zJyA045hLE4UBpfDkUHjNUH0eLKAUH848qFDxCH
 xYmWCDINIQVFz12DXKPkyhgk4npIOGhyk0VE7FaEU0FLTuEYlgPKkIGRg3x5B+t/Sx6w5MDJp9V
 yb2QHes10ADc+5ENsk67/x1Bdrdd1oaZxpX8uWzo5j5bG2bPFUaexoBreTQpiRhXrTliGBrY7+u
 bGMlk143+MA/nGwYZTfX3q/u6mCP5g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110018

After the ufs device vcc is powered off, all the ufs device
manufacturers require a minimum of 1ms of power-off time before
vcc can be powered on again. This requirement has been verified
with all the ufs device manufacturer's datasheets.

Replace the hard coded 5ms delay with a variable with a default
setting of 2ms to improve the system resume latency. The platform
drivers can override this setting as needed.

Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 10 +++++++++-
 include/ufs/ufshcd.h      |  2 ++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e8842dc..8d4cdd5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9741,7 +9741,8 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
 	 * All UFS devices require delay after VCC power rail is turned-off.
 	 */
 	if (vcc_off && hba->vreg_info.vcc && !hba->vreg_info.vcc->always_on)
-		usleep_range(5000, 5100);
+		usleep_range(hba->vcc_off_delay_us,
+			     hba->vcc_off_delay_us + 100);
 }
 
 #ifdef CONFIG_PM
@@ -10665,6 +10666,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 						UFS_SLEEP_PWR_MODE,
 						UIC_LINK_HIBERN8_STATE);
 
+	/*
+	 * Most ufs devices require 1ms delay after vcc is powered off before
+	 * it can be powered on again. Set the default to 2ms. The platform
+	 * drivers can override this setting as needed.
+	 */
+	hba->vcc_off_delay_us = 2000;
+
 	init_completion(&hba->dev_cmd.complete);
 
 	err = ufshcd_hba_init(hba);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 1d39437..4be32e3 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1140,6 +1140,8 @@ struct ufs_hba {
 	int critical_health_count;
 	atomic_t dev_lvl_exception_count;
 	u64 dev_lvl_exception_id;
+
+	u32 vcc_off_delay_us;
 };
 
 /**
-- 
2.7.4

