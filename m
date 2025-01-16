Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D8E1A08BC;
	Thu, 16 Jan 2025 09:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737018775; cv=none; b=A0u81JHVKCpRM5pneK0Kv4w76f+iJFvFJ10KeM3qNaTovxKj5AQ9ccfkF5ZeesWla9zvDC8XI6gI8LIB0uxbUxBkyAa/vDipgHMXDarqNbG/tO9XNDGiYrQXOmzr0eInQoAn8Zok0vW9xdybdD+WIVXspllh5mvOJuiMiGKE5i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737018775; c=relaxed/simple;
	bh=B0S1DPadhbWXnAv5eOUDHaqfyu2OtUbC1f0CVRFfQc4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Plt4f8pHP6fQAc0x08T1IVDwM3mOf3GLYPF5giyd1eBkPCnQg3Ez6PIomAywpY9DobP7his0/ujzHasCH+vzA4VIen7+a0OrZT0j8RBrVyAl9F0jZps4KGLHshgnEivy2gM7Dro1YXYQcilyo2aycu0N1lzblu+n25bNhvuRiuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=XRpCB4Xw; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="XRpCB4Xw"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50G85sXY006715;
	Thu, 16 Jan 2025 09:12:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=XZKRXPVX5N9iqSWVwXzEEYuU/tXxflI/n2D
	0/vLeP2c=; b=XRpCB4XwF2FKp8U+TRNXwFTLKp3CizqMGX5Ya+b+1jILNE8XOhs
	NAilmr4KwPEml8NrfCa7bZVZw4f324Aeiw+n9/wUyqNsjNxAkBr16qxTYmRA/ZHr
	rwju5t4pMTOpPoOgpU5TeNNA1PbMzujmWnQxMl8lgJcluOUngame+siS64pllcCu
	hNxoT/hbgF80/KVsqIS1XoiRRRnMHrQaTKvj6MI4S2Qq6akqWMjWqJAXi0nS8/h5
	Mg0kNKNHwHO6QkTM7Vlr/sFcHA2n1gnsvTE35qi9buOnP35uainYC8OrLBBfbFEV
	H/gEsBaQhtwkhqgyXVqu4d5YvXAOEncvBQA==
Received: from aptaippmta02.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com [103.229.16.4])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 446xa4r5jm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:12:30 +0000 (GMT)
Received: from pps.filterd (APTAIPPMTA02.qualcomm.com [127.0.0.1])
	by APTAIPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 50G9CShs032018;
	Thu, 16 Jan 2025 09:12:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APTAIPPMTA02.qualcomm.com (PPS) with ESMTPS id 4442bf51r2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:12:28 +0000
Received: from APTAIPPMTA02.qualcomm.com (APTAIPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50G9CRhE032013;
	Thu, 16 Jan 2025 09:12:27 GMT
Received: from cbsp-sh-gv.ap.qualcomm.com (CBSP-SH-gv.ap.qualcomm.com [10.231.249.68])
	by APTAIPPMTA02.qualcomm.com (PPS) with ESMTPS id 50G9CRU0032012
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:12:27 +0000
Received: by cbsp-sh-gv.ap.qualcomm.com (Postfix, from userid 393357)
	id 45FEA40BF9; Thu, 16 Jan 2025 17:12:26 +0800 (CST)
From: Ziqi Chen <quic_ziqichen@quicinc.com>
To: quic_cang@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com, quic_ziqichen@quicinc.com,
        quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
        quic_rampraka@quicinc.com
Cc: linux-scsi@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org (open list:ARM/Mediatek SoC support:Keyword:mediatek),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek)
Subject: [PATCH 0/8] Support Multi-frequency scale for UFS
Date: Thu, 16 Jan 2025 17:11:41 +0800
Message-Id: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
X-Mailer: git-send-email 2.34.1
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
X-Proofpoint-ORIG-GUID: zSS8U_aKh72K2o3eJEkCUbuXW__bBe_x
X-Proofpoint-GUID: zSS8U_aKh72K2o3eJEkCUbuXW__bBe_x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_03,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=788 clxscore=1015
 priorityscore=1501 impostorscore=0 malwarescore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501160067

With OPP V2 enabled, devfreq can scale clocks amongst multiple frequency
plans. However, the gear speed is only toggled between min and max during
clock scaling. Enable multi-level gear scaling by mapping clock frequencies
to gear speeds, so that when devfreq scales clock frequencies we can put
the UFS link at the appropraite gear speeds accordingly.

This series has been tested on below platforms -
SM8650 + UFS3.1
SM8750 + UFS4.0


Can Guo (6):
  scsi: ufs: core: Pass target_freq to clk_scale_notify() vops
  scsi: ufs: qcom: Pass target_freq to clk scale pre and post change
  scsi: ufs: core: Add a vops to map clock frequency to gear speed
  scsi: ufs: qcom: Implement the freq_to_gear_speed() vops
  scsi: ufs: core: Enable multi-level gear scaling
  scsi: ufs: core: Toggle Write Booster during clock scaling base on
    gear speed

Ziqi Chen (2):
  scsi: ufs: core: Check if scaling up is required when disable clkscale
  ARM: dts: msm: Use Operation Points V2 for UFS on SM8650

 arch/arm64/boot/dts/qcom/sm8650.dtsi | 51 ++++++++++++++++----
 drivers/ufs/core/ufshcd-priv.h       | 17 +++++--
 drivers/ufs/core/ufshcd.c            | 71 +++++++++++++++++++++-------
 drivers/ufs/host/ufs-mediatek.c      |  1 +
 drivers/ufs/host/ufs-qcom.c          | 60 ++++++++++++++++++-----
 include/ufs/ufshcd.h                 |  8 +++-
 6 files changed, 166 insertions(+), 42 deletions(-)

-- 
2.34.1

