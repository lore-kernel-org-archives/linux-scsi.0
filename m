Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4475C10E5;
	Fri, 22 Nov 2024 02:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732241443; cv=none; b=XV+mfN6qxmlHzVtc3wEmJC04+1DayMhSg77AKQo8eNQOWOMKxXnGiV3Ht0OJi9vpIb8VecrO6JzCsENxI/GsnMmdc6MhkXEl7QI9mc4QFZtBBgMOk3dM39RppHg/VELLoplJerkyquig3v16e3SmouIkfsgu0biqXnMSRzas27w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732241443; c=relaxed/simple;
	bh=no95gWltg85HbCbCbKOxRupqBtxssCeazKWENc2gOXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WUJ+JGbzZnCfOVGh3iLE0M8kF1CG6pREpVGSdi1/1xborEuk/s0i7LBZA2uuB8SRkzaG0nFXcUdxNBIjm0azBL9tl19MEdaAAICznq5A0J6lxNJ8sNBQ3nTIizS+h5y7kn6LCIskFD/uWE319kt1/Ubi4HMoWx3RE5IQb8fen2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=C3u0mf7a; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="C3u0mf7a"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ALMxcQO020148;
	Fri, 22 Nov 2024 02:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MRvPnpXSqC/BaFOieR8DGNJyOe0YGoOKBvBBD/6FCuM=; b=C3u0mf7aeV4MjGwB
	eti3vEhmIa6mKnSqNmJAK1sFiq/cQyDu7c9cSSbBqYf4nD06BqvTKyBXTfgb0Our
	gQFBP2c+bc5OphQ1dbYdT+1yfprSAHDbxtEvAGjXd8BXPUuDNXJse042nEBMG3Fy
	amEGz8fjEVhmYeaqTsTelFrOl8Ebg7WBzWcBelOTPVeodxLzfd0lXZiQ+mofoVe3
	uqr7/cKrhCIu6B3iWl88byXwsdqPCqEDoAEXxsA80pZNKwj5bs559erj4sltbpEO
	6DFQrNgd9sykqTp9oI3B55gd3wytZIn1jl5ZA5hmyOtj/IzDv2nnBPC/OOVP4iAv
	aMLFuA==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 431sv2kqbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 02:10:31 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 4AM2AU6c007009
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 02:10:30 GMT
Received: from [10.253.32.110] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 21 Nov
 2024 18:10:28 -0800
Message-ID: <401c94d5-1385-5da0-f9bd-cc84f45e7ece@quicinc.com>
Date: Fri, 22 Nov 2024 10:09:44 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] scsi: ufs: core: sysfs: Prevent div by zero
Content-Language: en-US
To: Gwendal Grignou <gwendal@chromium.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <daejun7.park@samsung.com>
CC: <linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>
References: <20241120062522.917157-1-gwendal@chromium.org>
From: Can Guo <quic_cang@quicinc.com>
In-Reply-To: <20241120062522.917157-1-gwendal@chromium.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: vC-pgLqyBQGSACYLN6sMWnlYIN3Zdk9v
X-Proofpoint-ORIG-GUID: vC-pgLqyBQGSACYLN6sMWnlYIN3Zdk9v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1011 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=846 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411220017


On 11/20/2024 2:25 PM, Gwendal Grignou wrote:
> Prevent a division by 0 when monitoring is not enabled.
>
> Fixes: 1d8613a23f3c ("scsi: ufs: core: Introduce HBA performance monitor sysfs nodes")
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> ---
>   drivers/ufs/core/ufs-sysfs.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index c95906443d5f9..3692b39b35e78 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -485,6 +485,9 @@ static ssize_t read_req_latency_avg_show(struct device *dev,
>   	struct ufs_hba *hba = dev_get_drvdata(dev);
>   	struct ufs_hba_monitor *m = &hba->monitor;
>   
> +	if (!m->nr_req[READ])
> +		return sysfs_emit(buf, "0\n");
> +
>   	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[READ]),
>   						 m->nr_req[READ]));
>   }
> @@ -552,6 +555,9 @@ static ssize_t write_req_latency_avg_show(struct device *dev,
>   	struct ufs_hba *hba = dev_get_drvdata(dev);
>   	struct ufs_hba_monitor *m = &hba->monitor;
>   
> +	if (!m->nr_req[WRITE])
> +		return sysfs_emit(buf, "0\n");
> +
>   	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[WRITE]),
>   						 m->nr_req[WRITE]));
>   }
Thanks for the fix!

Reviewed-by: Can Guo <quic_cang@quicinc.com>

