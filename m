Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2924527A129;
	Mon, 13 Oct 2025 19:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760384336; cv=none; b=sbeev4/ARGeZFdiTjBqWgDtu/sNKWyVSTY8bc1BsS044P3eURSj0Awxg7b4lMEeT5X88mOChM1i+k6ppvKaCGCPHNSUvTgPh/KSG71WiEiekaKjv5pcH1SqGE9Jye4KMB1fWdlsPGT+n2ZyiHnxOw+yWGzGrT1Zqlu5uv9Y45hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760384336; c=relaxed/simple;
	bh=xaj10ml0crM+zFfAZQ59QLWmX7QiLLall0r9mElsHDU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Of1VVFsRgwW4euaeqNn6c3yqu8dtU00iepWTtfwakyyH+KoxHPvwNQInRfsjI2WDEWrmSHZDfZQyRI9XJZE4EcKsqVq9Rb7Fc1KyAHMbHfWaXu+a1MiB/2MM9xe1hD5XPFdfQhRDjzFGVAScSOGEeRA6XufU41K8gEf8jvwpC+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=fwyEyJG5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="fwyEyJG5"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59DHDo4Q003848;
	Mon, 13 Oct 2025 19:38:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	qcppdkim1; bh=3DR+Y9YeijrAcC09e3k/rjlsd6433fk4E6uM23VjGwI=; b=fw
	yEyJG54PuJfi53ZzL9CLPGrjBt0CD76KYBqQW8fLEnzK2WdqfxKrhJKaEL2/0uxh
	CZLIN2nXwsHmIQ93iA+AILHgq52o3gF6Rq5+gMKtTwSy7wxayUkCrS5DXZEtetGC
	Hm+sJerb7YmJhkaKyUSK1wLybJIjnbKrySqA2rpbb9pVsXWVyzAbM8VfYu2bJS6q
	1icRqm7jYQ9Z5oXlCIQBfagCQxssBlIPrkkV9gKKKjQFA9eZwkBcGJ5i8EiTbB+f
	UMGsAaP6HGCpB8VehriDebbtKCy6B2Sz/MYzbAhXokeF2ZOukXZ6zoIOCCZ0a+rE
	+9xc/FrSjEZgRvDHIeqQ==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49qfbhwwd5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Oct 2025 19:38:27 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 59DJcQPZ005298
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Oct 2025 19:38:26 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.24; Mon, 13 Oct 2025 12:38:25 -0700
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
Subject: [PATCH v3 0/2] *** Remove UFS_DEVICE_QUIRK_DELAY_AFTER_LPM quirk ***
Date: Mon, 13 Oct 2025 12:38:14 -0700
Message-ID: <cover.1760383740.git.quic_nguyenb@quicinc.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxOCBTYWx0ZWRfX1ra6uHgtO8ZF
 EUrwbHxIRfytshlSygmzeDQ/EoY1Q9yMmHxyFPhauo0EQ5NV4E/9kupUzBYp6OAcz4R4cFgSusY
 +1OQTK5+SDWHKDYLmdf/yzKKVTflfrEsIsPeUBrVArmiP1VU7RGOmXHbrGg6NM1VdTXcLAsrDQc
 /5Us5ParoPd3FQH/F+5AzXawngJEbVPmLRIYJzIJdJ20R5DJJa1g1KbczZHGim67Qfa8HK2oUF7
 U8uCI6KO62kOqUXzCzr1bC/R1rNe/wG3inQEFJYsa0CEREU6QlRz8E2F/h6dkcnI2KarrAboJWj
 r/0CC4J+rj7cJzFQVWS52+p6wGxtkj9KQHRrPdg25PoMhnm+3fxcUn5a5OOWgKPxfsauEkK+8kM
 b+/F0AleoVis8XW+vkA80/0jMHr9yw==
X-Proofpoint-ORIG-GUID: YDACFd5mVpx-cI07geh5FyAw2yu0OTWR
X-Authority-Analysis: v=2.4 cv=bodBxUai c=1 sm=1 tr=0 ts=68ed5533 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=x6icFKpwvdMA:10 a=EGZWyozpdK3AfW_iKrYA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: YDACFd5mVpx-cI07geh5FyAw2yu0OTWR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110018

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
variable default to 2ms setting to improve the system resume latency.
The platform drivers can override this setting as needed.

v2 -> v3:
        - Rename sleep_post_vcc_off to vcc_off_delay_us and change the
          default setting for this variable from 5ms to 2ms (Peter's comment).

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

