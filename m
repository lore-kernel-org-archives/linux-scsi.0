Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A212D54656
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jan 2024 14:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705675904; cv=none; b=ZAbT9gDnVChiXHeQqTJN7zrJqIQQWYvJJMB9YjxIBaaAdn7fbXQmltc1mQSjk6PPY6BG+k395wzjmC2e+o+YC96rik/Dt0LDoMAXnDI4S2YxPgvE4bPRRbyuKs/+w0bOhLBdLz8TpqIQXXwioTO2JzFsNqXrTdu6jgbMp249dCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705675904; c=relaxed/simple;
	bh=7bFNOn9FumAjAOI4ipewa5/5tZ/pSVcxOkDa8iBdCts=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZY8MEc6D1lzVfqMa44VjThrw1SK14tF8eDC5N61PaCmOviPDnEldulb7ZCYTcxqbPmmUN5tSp/t14dYMYofZ6K5Fb/vlZOffF0CTHYeMmNou5B8RXvrAdj1QOZ3pq20eK/F0KujX4B/4CEyWprARwL+MvbBDbbyjitBEHcJSxXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=jNrrI++I; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="jNrrI++I"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 40JEHk5x024386;
	Fri, 19 Jan 2024 14:51:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	qcppdkim1; bh=X7dh1uuLcHXLAsPKwH58aMzLln2WuSCnZhGBM6tQxGk=; b=jN
	rrI++I1wA1ZmQQTswXeLAcQcdcfgbRYAf/mel/nckW71/r4Nysbqp3/5YXr67xul
	fPbgz6wJ2+oOA6c4JsPWj9DqZ64g5upKQvcHt6R4gEh9J+6nXQiISIY4GICJjizW
	KB6FJXNCOXAKxRddwJhuk5Ho/JXy8GhD4P/JdP5t7EjGNWQdadam971cPLrnGMSK
	o6T9ObwO6ZzAmpl+OGa+g8Wdb65VU0ctqIvfW3q45U4kD9OBwBpeBNL+qtHwkzho
	Ak2JaZ66Yei9eRSfZDzRST52i2mgIiOUlN0kQNjG2nNeC+yInBZXkspI7PaDIAMJ
	aiBUhhcMDDFWBLEvUCZg==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3vqmgd8txj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Jan 2024 14:51:29 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 40JEpPpw031845
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Jan 2024 14:51:28 GMT
Received: from [10.218.7.247] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Fri, 19 Jan
 2024 06:51:24 -0800
Message-ID: <8dcad0ce-326e-430a-823f-fda0681af4a6@quicinc.com>
Date: Fri, 19 Jan 2024 20:21:19 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 0/2] Add CPU latency QoS support for ufs driver
Content-Language: en-US
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Stanley Jhu <chu.stanley@gmail.com>, <linux-scsi@vger.kernel.org>,
        Peter Wang <peter.wang@mediatek.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        <quic_narepall@quicinc.com>
References: <20231219123706.6463-1-quic_mnaresh@quicinc.com>
From: Nitin Rawat <quic_nitirawa@quicinc.com>
In-Reply-To: <20231219123706.6463-1-quic_mnaresh@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: BhXN1qMTO_pFflmhkoTFB8jp5NI89mJ3
X-Proofpoint-GUID: BhXN1qMTO_pFflmhkoTFB8jp5NI89mJ3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-19_08,2024-01-19_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 phishscore=0 clxscore=1011 priorityscore=1501 mlxscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 mlxlogscore=666 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2401190081

Hi Martin,

This patch series add CPU latency QoS support for UFS driver. This 
improves random io
performance by ~15% for UFS. Can you please consider this patch series 
for the next merge window.

Thank you,
Nitin

On 12/19/2023 6:07 PM, Maramaina Naresh wrote:
> Add CPU latency QoS support for ufs driver. This improves random io
> performance by 15% for ufs.
>
> tiotest benchmark tool io performance results on sm8550 platform:
>
> 1. Without PM QoS support
> 	Type (Speed in)    | Average of 18 iterations
> 	Random Read(IPOS)  | 37101.3
> 	Random Write(IPOS) | 41065.13
>
> 2. With PM QoS support
> 	Type (Speed in)    | Average of 18 iterations
> 	Random Read(IPOS)  | 42943.4
> 	Random Write(IPOS) | 46784.9
> (Improvement with PM QoS = ~15%).
>
> This patch is based on below patch by Stanley Chu [1].
> Moving the PM QoS code to ufshcd.c and making it generic.
>
> [1] https://lore.kernel.org/r/20220623035052.18802-8-stanley.chu@mediatek.com
>
> Changes from v5:
> - Addressed bvanassche comment to use kstrtobool instead kstrtou32
> - Addressed bvanassche comment to add sys attribute into an existing group
>
> Changes from v4:
> - Addressed angelogioacchino's comment to update commit text
> - Addressed angelogioacchino's comment to code alignment
>
> Changes from v3:
> - Removed UFSHCD_CAP_PM_QOS capability flag from patch#2
>
> Changes from v2:
> - Addressed bvanassche and mani comments
> - Provided sysfs interface to enable/disable PM QoS feature
>
> Changes from v1:
> - Addressed bvanassche comments to have the code in core ufshcd
> - Design is changed from per-device PM QoS to CPU latency QoS based support
> - Reverted existing PM QoS feature from MEDIATEK UFS driver
> - Added PM QoS capability for both QCOM and MEDIATEK SoCs
>
> Maramaina Naresh (2):
>    ufs: core: Add CPU latency QoS support for ufs driver
>    ufs: ufs-mediatek: Migrate to UFSHCD generic CPU latency PM QoS
>      support
>
>   drivers/ufs/core/ufs-sysfs.c    | 49 ++++++++++++++++++++++++++++++++
>   drivers/ufs/core/ufshcd.c       | 50 +++++++++++++++++++++++++++++++++
>   drivers/ufs/host/ufs-mediatek.c | 17 -----------
>   drivers/ufs/host/ufs-mediatek.h |  3 --
>   include/ufs/ufshcd.h            |  6 ++++
>   5 files changed, 105 insertions(+), 20 deletions(-)
>
