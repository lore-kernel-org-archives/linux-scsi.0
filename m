Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8860226E70B;
	Thu,  9 Oct 2025 20:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760040985; cv=none; b=IgmSLHiJ3a0VQ9uajjXzyACFyl7yQSApKweC/wtTXApm9tfy9wxdFTrauBLY/WT8qT76fug/pbd8X6q+wDaijg6cY7XYieTBI1YR/QzfaQu/diex9s2csIduDnZjHr6uEG8DJ7XlOCHJx3L1CLoA1EwztdANhCNzZjPfYg2pN/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760040985; c=relaxed/simple;
	bh=8h0yu2pV7uQOX+9yJMn/3FbXWLNjoFlGlRNrtc9pOcM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SsVG+8pUlecUE7bVX4ludHf08e/ZL+vO88bQPraTb04wTSdAM/5csY/WQAqjFRiyPjubhO+OyVp5Hme68ExqCb30JM41LPZ645Kk6rKrqBO/Jl1Iq/xYmaVapmx7ti1wGebJn1665EajcFXGfOqUBP+6WnTdfOFR7staoR+f7X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=pKsHcFtd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="pKsHcFtd"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 599EIOxQ014054;
	Thu, 9 Oct 2025 20:11:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=f0Z6sFSRwksfBZQlXTFw+3+zEZbAZaUN0TuayQVteiY=; b=pK
	sHcFtdOQwL6pntzVrA7Ht/NcAaQKasWUMYPGN6q93J1GRd+H56fugCwfQXnMiiuP
	8wOM3WE0CrIPIEjX1SGLVj+zoHU9pch2t9uHfAsnpk3ZGbSz6qRuzzNQb3DS1Tgo
	omVMaNy+tfAXvXYFbAgIr5oT3xOwIzRSpmPTPbmJLDP0mbu6t2sjMwQmtZVu2+tb
	lNNqSHKw8xz/xn/UC+YitxUkYtiXQxVbemPgKpSLDLG4AnuJSVs5Jw9Odc3G+Vxh
	kkBC2HIccb1Wh3kz/nkacv4uuBR/wz/ib0Idp/jUQeLvrZc3ftzd46FDXdFV2DXI
	enGSU8R5/e9P5kxZYmrQ==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49nv4km70r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 20:11:10 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 599KBATN002953
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 9 Oct 2025 20:11:10 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.24; Thu, 9 Oct 2025 13:11:09 -0700
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <adrian.hunter@intel.com>, <martin.petersen@oracle.com>
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
Subject: [PATCH v2 0/2] *** Remove UFS_DEVICE_QUIRK_DELAY_AFTER_LPM quirk ***
Date: Thu, 9 Oct 2025 13:10:57 -0700
Message-ID: <cover.1760039554.git.quic_nguyenb@quicinc.com>
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
X-Authority-Analysis: v=2.4 cv=dojWylg4 c=1 sm=1 tr=0 ts=68e816de cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=x6icFKpwvdMA:10 a=EGZWyozpdK3AfW_iKrYA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: X1k8RkBjTGYHt1tHE3U4UbrVs3m654S0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX+E5yWUxx6HgG
 7HPLgXeR1x7Gp5xOWCjS2dQ8qG0LRB3a1alhNiSqs6qQhBT7Wq5J3xI2TE4IK5vBs6oJ5nI7tmM
 gSHRhGn7DBlUZWNvWqzvydon+Fy8IkLEvHOvng1vd3Z0O4713/NM6hvxyu9d7dQRZa88hbd1OIO
 tB5NfR3mtEHo7gCS/r1le9g1fXSEoBwHjDXZjeoNjhYxJvwTDoph01vQuXkEM7pwHLA/LiGSFSZ
 eYNtfgvJZVZcIo8ttv57IiZJxdjaD3zAVymkkT2XJQQiSnhPK+Qe69H4FRLbuq+Am2WKQbBi4vj
 HM7/wCid0ug05+pMC1OjYCFjQSLxETC8O2DqyaUZc3nck4USx1OGxJ+aLcG99W9A+Tu+3gXiFQE
 1VPfPHjoksvFCRifkRHeuI8gYmC43A==
X-Proofpoint-ORIG-GUID: X1k8RkBjTGYHt1tHE3U4UbrVs3m654S0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121

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
driver seems too conservative, so replace the hard coded 5ms delay with a
variable default to 5ms setting and allow the platform drivers
to override this setting as needed to improve the system resume latency.

v1 -> v2:
	- Added a check for vcc's always_on to skip the delay if the vcc
	  is an always-on regulator (Peter's comment)
	- Added a sleep_post_vcc_off variable to allow platform drivers to
	  override the default core driver's setting as needed (Bart and Peter's comments)

Bao D. Nguyen (2):
  scsi: ufs: core: Remove UFS_DEVICE_QUIRK_DELAY_AFTER_LPM quirk
  scsi: ufs: core: Replace hard coded vcc-off delay with a variable

 drivers/ufs/core/ufshcd.c       | 15 +++++++++++----
 drivers/ufs/host/ufs-mediatek.c | 11 ++++-------
 drivers/ufs/host/ufs-qcom.c     |  3 ---
 include/ufs/ufs_quirks.h        |  7 -------
 include/ufs/ufshcd.h            |  2 ++
 5 files changed, 17 insertions(+), 21 deletions(-)

-- 
2.7.4

