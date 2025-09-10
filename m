Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D18334711
	for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2025 18:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527517; cv=none; b=S2EWutfT0NsBBYs2Wb4694WM2QczSL7XLJDun9itVWv8ddlQBXUbqSFIjj4NrnADQeG3R3TzI/Xp6+OmgqcRnKAFX/gW0Lxq04aCskC/g4VX+oRKzrz0/YOH8pF9PXXGu60P4YRBeW7op70eaJ1Hqv1/4Barpm7K/18Cpk7xmxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527517; c=relaxed/simple;
	bh=Jg0S5VEWtuAnu6zpMay+12NAytGzw2iXk47sx69bLZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hSuoL2+p99Y/gRkMZbY6Li5zrLm8jHhqTL+tdTBs1vLWIK5n6q6nWQdCkndq47cRPHRBKYJHQ8qp5pHnEvB3Fh3XBq2xdPCkrjvEqXRUMFzjxUtoBChxCpsC7ZNbGHatzWGn8kyzPggBbiNJDfPQmVikWoghQrIYVxpWVjRYDQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=NVlHJX6j; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="NVlHJX6j"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AGFJ3f017772;
	Wed, 10 Sep 2025 18:03:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IOjrZohLUHONVcqr4tmRy4+M2MFkyS3x86H2M+A2GY8=; b=NVlHJX6jCNfj8Wgt
	EhfZzDSYvNbQmWaTa/bLnlKhZ02K7w4WbVDvhdu1bD5gHuBrQ+Iq/UpcOEkdBYYK
	iny81/hyftMQO9cUkA2DS+56lcwFSYDIvWLDXsRFdPYnqgth3RBm1K6N4X4gPZnM
	0gTzitFoyK6yMnbEbLwka//J7f0YDixj7TgAVi+8yDATxcW4shiFTNTxTeQWU9RM
	rs2JIa7UD/27pRoOnlxA+WQ+oBV2yA2xdw5puwuBXlXP+zHpUxykvvHB54RP86JH
	Xl3UnDUskS/4WnXVnJZ3prHRCUpodhw3Lr2SU6Ld6a20u793kmvOcsxME/V1CltD
	15n6qg==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 493cpb0b7u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:03:02 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 58AI31Mo001552
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:03:01 GMT
Received: from [10.216.11.191] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.24; Wed, 10 Sep
 2025 11:02:57 -0700
Message-ID: <04afb491-96e4-442e-8b46-796adb0bfb6f@quicinc.com>
Date: Wed, 10 Sep 2025 23:32:53 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Disable timestamp functionality if not
 supported
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Peter Wang
	<peter.wang@mediatek.com>,
        Avri Altman <avri.altman@sandisk.com>, Bean Huo
	<beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        "Adrian
 Hunter" <adrian.hunter@intel.com>,
        Manish Pandey <quic_mapa@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
References: <20250909190614.3531435-1-bvanassche@acm.org>
Content-Language: en-US
From: Nitin Rawat <quic_nitirawa@quicinc.com>
In-Reply-To: <20250909190614.3531435-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEwMDE1MCBTYWx0ZWRfX6e3PIhpODBjW
 OHoHfcRMx/zJ+4McrbAViNOUikdh4pidilhul5dACgn5llLCWR0x84jqdoqUB6m6/K6VrfMNHs7
 0+WtAnCfnVE5FTbfnae5m1o1F3qp7pB3zCb5gCc6qLnmt1Y5X+lRTf2kfHOKfW5ge/qMw5B7xVO
 H8WSjMXwcSGrABsK7WYrxGwWGyg+2oVxrUJ0nM9TBayNgaPOMFfR66YjP13UFdOLPuwDivE9jsh
 MuFGg5e0I+LThFsNeHX/ceGGPH1A9vsDjzpHxHUdq8f6BS+EuXUGU7+MM/40ew+BCbGEC2YUYoK
 Z/hjlG1QRM2wDPabFycNu+l820ZAiUivClLSbJ3IFhG+QmbXMUR4pjcfFqb6gGok2LJH0CqFp+o
 EfGVxx3B
X-Proofpoint-ORIG-GUID: 1f0Do93aCxFwf9b9bvqLJCGL7WA-U0-T
X-Proofpoint-GUID: 1f0Do93aCxFwf9b9bvqLJCGL7WA-U0-T
X-Authority-Analysis: v=2.4 cv=P4k6hjAu c=1 sm=1 tr=0 ts=68c1bd56 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=N54-gffFAAAA:8
 a=COk6AnOGAAAA:8 a=yZ0juUapM47ugal84-wA:9 a=QEXdDO2ut3YA:10
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 clxscore=1011 impostorscore=0 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 adultscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509100150



On 9/10/2025 12:36 AM, Bart Van Assche wrote:
> Some Kioxia UFS 4 devices do not support the qTimestamp attribute.
> Set the UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT for these devices such
> that no error messages appear in the kernel log about failures to set
> the qTimestamp attribute.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 6 +++++-
>   include/ufs/ufs_quirks.h  | 3 +++
>   2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ca6a0f8ccbea..5d0793d8b0e9 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -316,6 +316,9 @@ static const struct ufs_dev_quirk ufs_fixups[] = {
>   	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
>   	  .model = "THGLF2G9D8KBADG",
>   	  .quirk = UFS_DEVICE_QUIRK_PA_TACTIVATE },
> +	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
> +	  .model = "THGJFJT1E45BATP",
> +	  .quirk = UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT },
>   	{}
>   };
>   
> @@ -8777,7 +8780,8 @@ static void ufshcd_set_timestamp_attr(struct ufs_hba *hba)
>   	struct ufs_dev_info *dev_info = &hba->dev_info;
>   	struct utp_upiu_query_v4_0 *upiu_data;
>   
> -	if (dev_info->wspecversion < 0x400)
> +	if (dev_info->wspecversion < 0x400 ||
> +	    hba->dev_quirks & UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT)
>   		return;
>   
>   	ufshcd_dev_man_lock(hba);
> diff --git a/include/ufs/ufs_quirks.h b/include/ufs/ufs_quirks.h
> index f52de5ed1b3b..83563247c36c 100644
> --- a/include/ufs/ufs_quirks.h
> +++ b/include/ufs/ufs_quirks.h
> @@ -113,4 +113,7 @@ struct ufs_dev_quirk {
>    */
>   #define UFS_DEVICE_QUIRK_PA_HIBER8TIME          (1 << 12)
>   
> +/* Some UFS 4 devices do not support the qTimestamp attribute */
> +#define UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT	(1 << 13)
> +
>   #endif /* UFS_QUIRKS_H_ */
> 

Tested-by: Nitin Rawat <quic_nitirawa@quicinc.com> # on SM8650-QRD
Reviewed-by: Nitin Rawat <quic_nitirawa@quicinc.com>
