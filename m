Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C95418732E
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 05:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726206445; cv=none; b=MeorcB28+ozjKEL0DP+tbb0txg5TwuIIfNBF5eZEjR8ihE1Pvqz6+jXMWEuRRRt7ERXoSmLfoE2Ls6WaY9qjpg94phzLqz2+g85zG5Zqcw4+QOiJ25ZyffFlfrrOT9vDhC8+DoOB6Hj+vT1+judQQDGUfRvVxqYRtaTsDDmJ7y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726206445; c=relaxed/simple;
	bh=jVAZvBXOHajYihL/6MSCBrOb18AcA3Hh4fK8LBu0Iqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qesOoUL+nkI7khgHUVzQILNbTZ+NmG4QwCbHJXnYUwW3i6UHxG75IkYZRVS67MaIRoQq/cpcL9bUm77hvY1XrcWJUeGGBFbMlqLCyE7GOxJDEgGmNUUoZrDe0LwHzVTdcvtmCNbz6wSmjALarxxpriDQ0S/BFq9CQECCFI0mPSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=fO7vlNTT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="fO7vlNTT"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMCLCb031584;
	Fri, 13 Sep 2024 05:47:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	NOHJvs/Ps3/2ufV3VAtxlydiqSGHgrwgtzQriD8zRkU=; b=fO7vlNTTHMV57kVe
	nM7UFxVY2KTTVrCAP/ECiIktMaH/DtGcxHAcKdcpauIYkcT14IxYn2cI2NzMI2E8
	lJtgyWOwQijMnQhmxxSpnMCToYsHMzOUwlfsxEnzeeh4moLr3E/zMaZl4d89nQVd
	xUjHlkwUELvQVCIMfudJ6OcpjsRwmmmiXv+PCj1ggjRMIn/hQgvh7atF+XkiS/rZ
	zXhSeR4rEYLKKlT150PDISy1ENvGSnW7qGePsP7GmjK8T6eSsDx9K6skKCNMNib0
	qtQnURGvXBsuIeSu/gf8zQOr9nnfQ7FagaWDwrd+9Mou5B/Nz3qgQYHf35u87hBu
	kz3jBA==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41gy5a7r2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 05:47:10 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 48D5l9Ps014191
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 05:47:09 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 12 Sep
 2024 22:47:09 -0700
Message-ID: <bc1155d5-2d25-6573-e99c-341677879a9d@quicinc.com>
Date: Thu, 12 Sep 2024 22:47:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 07/10] scsi: ufs: core: Expand the
 ufshcd_device_init(hba, true) call
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Andrew Halaney <ahalaney@redhat.com>, Bean
 Huo <beanhuo@micron.com>
References: <20240910215139.3352387-1-bvanassche@acm.org>
 <20240910215139.3352387-8-bvanassche@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240910215139.3352387-8-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 7ibqTko4whALSshtl7RZ6zb4D4Ij6mdR
X-Proofpoint-ORIG-GUID: 7ibqTko4whALSshtl7RZ6zb4D4Ij6mdR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409130040

On 9/10/2024 2:50 PM, Bart Van Assche wrote:
> Expand the ufshcd_device_init(hba, true) call and remove all code that
> depends on init_dev_params == false. This change prepares for combining
> the two scsi_add_host() calls.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 55 ++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index a3c5493ccc8f..efa9c177a80f 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10608,7 +10608,60 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   
>   	/* Initialize hba, detect and initialize UFS device */
>   	hba->device_init_start = ktime_get();
> -	err = ufshcd_device_init(hba, /*init_dev_params=*/true);
> +
> +	hba->ufshcd_state = UFSHCD_STATE_RESET;
> +
> +	err = ufshcd_link_startup(hba);
> +	if (err)
> +		goto out_disable;
> +
> +	if (hba->quirks & UFSHCD_QUIRK_SKIP_PH_CONFIGURATION)
> +		goto initialized;
> +
> +	/* Debug counters initialization */
> +	ufshcd_clear_dbg_ufs_stats(hba);
> +
> +	/* UniPro link is active now */
> +	ufshcd_set_link_active(hba);
> +
> +	/* Verify device initialization by sending NOP OUT UPIU */
> +	err = ufshcd_verify_dev_init(hba);
> +	if (err)
> +		goto out_disable;
> +
> +	/* Initiate UFS initialization, and waiting until completion */
> +	err = ufshcd_complete_dev_init(hba);
> +	if (err)
> +		goto out_disable;
> +
> +	err = ufshcd_device_params_init(hba);
> +	if (err)
> +		goto out_disable;
> +
> +	if (is_mcq_supported(hba)) {
> +		ufshcd_mcq_enable(hba);
> +		err = ufshcd_alloc_mcq(hba);
> +		if (!err) {
> +			ufshcd_config_mcq(hba);
> +		} else {
> +			/* Continue with SDB mode */
> +			ufshcd_mcq_disable(hba);
> +			use_mcq_mode = false;
> +			dev_err(hba->dev, "MCQ mode is disabled, err=%d\n",
> +				err);
> +		}
> +		err = scsi_add_host(host, hba->dev);
> +		if (err) {
> +			dev_err(hba->dev, "scsi_add_host failed\n");
> +			goto out_disable;
> +		}
> +		hba->scsi_host_added = true;
> +	}
> +
> +	err = ufshcd_post_device_init(hba);
> +
> +initialized:
> +	ufshcd_process_device_init_result(hba, hba->device_init_start, err);

I have similar comment as in previous patch #6. This patch probably 
changed the print. In the original code, it prints the time spent in 
probe_hba(), but here it prints some part of the time spent in 
ufshcd_init(). There will be some trace prints during init, but the data 
it prints would have inconsistent meaning.

>   	if (err)
>   		goto out_disable;
>   
> 

