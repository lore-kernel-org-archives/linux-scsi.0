Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB142EB5C4;
	Wed,  1 Oct 2025 20:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352261; cv=none; b=HYJS/Id7syJqI8ArgLrkzObRrXvQnTsF08jrTkiVWJjZtb9bewkXrsMKtrk5sw+Jh67j4TtO2SxRFXLFpCvKx/m4lERd430Zs+zczMHKOi8Qq/gq/FU+UKTFGL4Wx2FXhhuoXrelKv03+viim58tLHovvhBGMMevMsLNnTr5Ie8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352261; c=relaxed/simple;
	bh=z2JUWWaSf7+UeCwjrkxD0mC2sSGn4f3g/3cyeA7LvTI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=X1yk7jJPvnQ88WgD3X9LM5c8EVy2hiaAz8mzTa1Qp5cRgzvxDZIETCsUZcw+XkuwzGNYTl9KImjhydpJFEZStSK2e//k/a9xksUHv339p4zOK81c9Hd0eXDQ6WCCi8+joxao8x7yPKKtYWizBxDffQTgtEJforIz2xjvxPXtuWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Y2/QSmcv; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Y2/QSmcv"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591Ic7qC005598;
	Wed, 1 Oct 2025 20:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=+45+pLhmRpnqwKQs2OmyisBAtmvmvvrbwhhu0F6U6d0=; b=Y2
	/QSmcvxMQgd2cIdrqb6axjOZNWWRRyQn+PTTGYoQ4qk6ZZhsYn0aXCn+fQtNzJyx
	6ep6MFPQuWMG6/rVoN4Yl3kVP+iYbcSGemrLTP2Tdxd5g1TjoHmVMVA8t5L0cfhk
	ZOVsgUz8S496W5ZnyddeR6BYqOsgIs2Fd7HTdEPAofMGqA+t+JE1ld00Gc/tyvTw
	wah0O1k+emxfdE9c9YP963iEaLOvZYrVDEYjSdr1RbXpzGNI5FXvXE6r0YHn/D1f
	Be14GwEuWsxsS+3gWdYUBDt2yFOO8NLUECXZsaiqyDxFSnovurRtFr4tX0aTzRdD
	pUbHIs+8ZaenPCHxNoEw==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49e851nvmw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 20:57:24 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 591KvOlC011137
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 1 Oct 2025 20:57:24 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.24; Wed, 1 Oct 2025 13:57:23 -0700
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <manivannan.sadhasivam@linaro.org>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
        "open list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-kernel@vger.kernel.org>,
        "moderated
 list:ARM/Mediatek SoC support:Keyword:mediatek"
	<linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-mediatek@lists.infradead.org>
Subject: [PATCH v1 0/2] *** Remove UFS_DEVICE_QUIRK_DELAY_AFTER_LPM quirk ***
Date: Wed, 1 Oct 2025 13:57:10 -0700
Message-ID: <cover.1759348507.git.quic_nguyenb@quicinc.com>
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
X-Authority-Analysis: v=2.4 cv=OJoqHCaB c=1 sm=1 tr=0 ts=68dd95b4 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=x6icFKpwvdMA:10 a=QiTLis0nzNNC8PZdpUgA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAzMiBTYWx0ZWRfX7uMPnhAKSqt7
 MhTQGmrdaJO/ZNPh7ZmuKJGl2PpMvWQdeod6H3jOwKBPua6WiY+FMzWS9JyOCqInOnx5HyWR9vq
 oaizxr5wz5Dr7hwV09nU1vCKiv+9OUNms5tEBRT4ZR3pz8wGNeTOYO5ThCE+vbY37QoXXRpcpNZ
 62RJPNT/RamQP7SSQQeU4uGSSkok6CIwdtqMFYpD+IYKZ1WLGiPjkoISxnrje1V33RbkxiMOmlh
 XojcgY91D0eOO71V02CGXaJ6hlbMqgc3BOMv+Gto/qE278pgj/gZGjNHvBVz93CiOulUTs+qjyd
 coFqmlYk9gm6QehJN0sg01ZFmEnfupgNJGR8s9uSxb7xG76bO4EEu06ntg7z+g+BkZDW+iG+mVr
 sAqjNe3gNRso+xKHOSySTLJNmpYoCg==
X-Proofpoint-ORIG-GUID: 9Qo_BlZEcpNsFWHqs7gVQBLDAM4axfq8
X-Proofpoint-GUID: 9Qo_BlZEcpNsFWHqs7gVQBLDAM4axfq8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_06,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270032

Multiple ufs device manufacturers request support for the
UFS_DEVICE_QUIRK_DELAY_AFTER_LPM quirk in the Qualcomm's platform driver.
After checking further with the major UFS manufacturers engineering teams
such as Samsung, Kioxia, SK Hynix and Micron, all the manufacturers require
this quirk. Since the quirk is needed by all the ufs device manufacturers,
remove the quirk in the ufs core driver and implement a universal delay
for all the ufs devices.

In addition to verifying with the public device's datasheets, the ufs
device manufacturer's engineering teams confirmed the required vcc
power-off time for the devices is a minimum of 1ms before vcc can be
powered on again. The existing 5ms delay implemented in the ufs core
driver seems too conservative, so reduce this time to 2ms to improve
the system resume latency.

Bao D. Nguyen (2):
  scsi: ufs: core: Remove UFS_DEVICE_QUIRK_DELAY_AFTER_LPM quirk
  scsi: ufs: core: Reduce the sleep before vcc can be powered on

 drivers/ufs/core/ufshcd.c       |  7 +++----
 drivers/ufs/host/ufs-mediatek.c | 11 ++++-------
 drivers/ufs/host/ufs-qcom.c     |  3 ---
 include/ufs/ufs_quirks.h        |  7 -------
 4 files changed, 7 insertions(+), 21 deletions(-)

-- 
2.7.4

