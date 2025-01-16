Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94941D934B;
	Thu, 16 Jan 2025 09:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737018813; cv=none; b=gYRalB9sEHMU6LV43D04UOsd8pXHgji0jj8JosZ+BCThbuom0m6feSIm6hTA+iW4RlG+hBY9z/AW10Yjevi76JCFZvA74vKEJyOXxTyR3BbMs5723gfgagaJ2WD0mM5F7xwLoN2IghdQ4LrLzMBjqiBhxwKnyvLplf8fkCPnOTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737018813; c=relaxed/simple;
	bh=xR8xAsc0Yh8ZCeX0OsTJyZ2cqtKxMSgFTLw2jaIiJVI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PhKb8awrD7v+8oFT8E0bwYn2x1M804GU/3KFa95g8B+26JrryoURtoS3ioHcnMldlFO4xPVinXr3Bz4r9dLbKtrDQSGYs6fGqxwWtr/heLMfLSVDIdYu7yNwzb5F9UN89gsEQoB8i4FttsFQ5lg9q75+WIwF/hj7cRKrOijh+ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=KP2EyBBP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="KP2EyBBP"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50G62dHn015712;
	Thu, 16 Jan 2025 09:13:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=6EEEPWbmhB1
	Cr5+dZsPPJkal8hjqFsBNJkUF6BlN25U=; b=KP2EyBBPPI9vJdKSpAF+ciMfUQC
	bJZy1BIeaLL/QQ3jBzoYKe5pcvUFKotviRfYijRm0WCm6w/exCer4tUoDln3CO4u
	v9Ldrv7bF6s37wP6KxfUn2I2LDv7QkZ6Ahq857FtFzNZKuEInUCyYWtDKalhqBHv
	nuZbmFac3YcbMBcIyUQpOG/41/9k7ms76pvZxpcjCy+PSYIo0NbnPhE2Q59QhFZv
	u2Ig7wSVsZg/DmFUjSWzJdcBGlWovUPqybSUe3l2vlY30qtJp2c6y6vOMnJpzjTm
	CCNG10W76IwoLrYOpOPWkA6d3giJC+CShogyY3vd4X+xuYtXVBzYbSbyWvA==
Received: from aptaippmta02.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com [103.229.16.4])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 446vge8f5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:13:06 +0000 (GMT)
Received: from pps.filterd (APTAIPPMTA02.qualcomm.com [127.0.0.1])
	by APTAIPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 50G9Ci04032498;
	Thu, 16 Jan 2025 09:13:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APTAIPPMTA02.qualcomm.com (PPS) with ESMTPS id 4442bf51tv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:13:04 +0000
Received: from APTAIPPMTA02.qualcomm.com (APTAIPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50G9D3l1032617;
	Thu, 16 Jan 2025 09:13:04 GMT
Received: from cbsp-sh-gv.ap.qualcomm.com (CBSP-SH-gv.ap.qualcomm.com [10.231.249.68])
	by APTAIPPMTA02.qualcomm.com (PPS) with ESMTPS id 50G9D3XW032615
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:13:03 +0000
Received: by cbsp-sh-gv.ap.qualcomm.com (Postfix, from userid 393357)
	id 9BABE40BF9; Thu, 16 Jan 2025 17:13:02 +0800 (CST)
From: Ziqi Chen <quic_ziqichen@quicinc.com>
To: quic_cang@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com, quic_ziqichen@quicinc.com,
        quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
        quic_rampraka@quicinc.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 6/8] scsi: ufs: core: Check if scaling up is required when disable clkscale
Date: Thu, 16 Jan 2025 17:11:47 +0800
Message-Id: <20250116091150.1167739-7-quic_ziqichen@quicinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
References: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
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
X-Proofpoint-ORIG-GUID: -v7OLBlPnmIIQ_Lq3j-1qj5-1Fbhr559
X-Proofpoint-GUID: -v7OLBlPnmIIQ_Lq3j-1qj5-1Fbhr559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_03,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=997 spamscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501160067

When disabling clkscale via the clkscale_enable sysfs entry, UFS driver
shall perform scaling up once regardless. Check if scaling up is required
or not first to avoid repetitive work.

Co-developed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
---
 drivers/ufs/core/ufshcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 839bc23aeda0..721bf9d1a356 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1772,6 +1772,10 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 	freq = clki->max_freq;
 
 	ufshcd_suspend_clkscaling(hba);
+
+	if (!ufshcd_is_devfreq_scaling_required(hba, freq, true))
+		goto out_rel;
+
 	err = ufshcd_devfreq_scale(hba, freq, true);
 	if (err)
 		dev_err(hba->dev, "%s: failed to scale clocks up %d\n",
-- 
2.34.1

