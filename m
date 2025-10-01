Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356812D640E;
	Wed,  1 Oct 2025 20:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352273; cv=none; b=JiL80BShl3hApUxnQLs+xGp7/vu6HlR2POMzQLLxkTM2WqIba107T9rHaKoCz0E+nwqKmntGhtTfBWNOcAGWrOQd1VBER8CaVNoIUvXPN/CE6atilOK9brLPVP+BTTyDg1M6ForqIpEp2Qfxse7M5kEpygQzaerDlP/DMOjvxcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352273; c=relaxed/simple;
	bh=P8hair+fuzt56qeYEnp63E7vxLzGRG2x777VAwTBkz0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b5CbmAZ6ylb81LyN9FjG3eXU+jrRWA5AFbD4D1iagGoRXWhBm2yC5hdFp21+qK1cOX+Cu3TFlCPXLVQIcTlibibnk1ORVB7FqRhXrFBv3ehTRx6JYntT0aEhqxVOvbbbq0uNzOePsapDECUWOC4QNamQEqjlQS3CdTj9GSqf0W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=HryEawAo; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="HryEawAo"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591IcLr1018108;
	Wed, 1 Oct 2025 20:57:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=oibsE6NM5w1dxwqg8dLlyolj
	/JuJKLMLNXCReaj5CZ4=; b=HryEawAo/EVELxaPhKefqIkt92k/u2LROF2nB1hT
	mwyGSYiLQxTHjpALtgY4YjYDR9ZPwxzzKBQuGH4vQtLAwhZLaUmcHfxDI9CALps3
	JAR5629n8IclJMwE4RVCipwQXitWD/5ARtRR7uvPCEAxZxzADCBChjEaGLmliGi9
	/EanC0Qh7TknINc+pgS0A2hExMTcTKBGWCygnRSA7XKHc2nxDz2qnZXJrmkrnuYG
	o5thksFET/hEiJsriZdm28dTZnNP74bQWcRLDx7V6MaZE0xwAgRuExrRznw4nGGi
	nlb9hMxouLPhdfYjH9Ldn+5XNalUUoace8rR/Vnig1XMqQ==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49fyrf7d4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 20:57:36 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 591KvZNS015457
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 1 Oct 2025 20:57:35 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.24; Wed, 1 Oct 2025 13:57:34 -0700
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <manivannan.sadhasivam@linaro.org>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Bean Huo <beanhuo@micron.com>,
        "open
 list" <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 2/2] scsi: ufs: core: Reduce the sleep before vcc can be powered on
Date: Wed, 1 Oct 2025 13:57:12 -0700
Message-ID: <b9467720ccabbabd6d3d230a21f9ffb24721f1ed.1759348507.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1759348507.git.quic_nguyenb@quicinc.com>
References: <cover.1759348507.git.quic_nguyenb@quicinc.com>
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
X-Proofpoint-ORIG-GUID: vdXJmS_Os-n4Rrg6PwmfaqcJjiWcuZxm
X-Proofpoint-GUID: vdXJmS_Os-n4Rrg6PwmfaqcJjiWcuZxm
X-Authority-Analysis: v=2.4 cv=etzSD4pX c=1 sm=1 tr=0 ts=68dd95c0 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=x6icFKpwvdMA:10 a=COk6AnOGAAAA:8 a=qFsjF2YTUMbPFVu7nBkA:9
 a=TjNXssC_j7lpFel5tvFf:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI5MDE3NSBTYWx0ZWRfX3rv+OK6mhmHS
 RMTLcveiMslcLwXj+etVCFbSe/QdvHwdDn9J5gSy5tVhVPlhJcHm8O+tpqWntIvvxJ/Uwd0VEDa
 mjFRjbVQ0dUdjlupSXFNZW3UnIQlFcVXqf+6noSqd91Ik/+P5YDVHnoHahhyo8f03iC1hyYYrME
 vWybIawaeI+9urDbpA2cnmDMJLqti+Yt7GnO1Illvhiof10NOUEp2AhTfPEXw8MhuTCzLgy4v/Y
 UYt/0QwjSkazeS/UF48PD/TrWjCEeSMpuD1ZB/D7Er46b7fGdeAzvye62NqY2p7ZMyKvWEsRzeH
 UoKwfOuOMpRtd3j0SiPHUz7r0Q8NLLMksO3S4gLlvk7mZEO8I97e4Sem8yKTBxsIFbq4/uPPLRP
 d7sLXADV9PpvVqfHoRzYUPIw3TC28A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_06,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1011 suspectscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509290175

After the ufs device vcc is powered off, all the ufs device
manufacturers require a minimum of 1ms of power-off time before
vcc can be powered on again. This requirement has been verified
with all the ufs device manufacturer's datasheets.
Improve the system resume latency by reducing the required power-off
time from 5ms to 2ms. The chosen 2ms should include enough
additional buffer time without being wasteful.

Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 45e509b..83bd731 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9741,7 +9741,7 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
 	 * All UFS devices require delay after VCC power rail is turned-off.
 	 */
 	if (vcc_off && hba->vreg_info.vcc)
-		usleep_range(5000, 5100);
+		usleep_range(2000, 2100);
 }
 
 #ifdef CONFIG_PM
-- 
2.7.4

