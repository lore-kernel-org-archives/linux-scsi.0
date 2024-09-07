Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBA2156863
	for <linux-scsi@vger.kernel.org>; Sat,  7 Sep 2024 20:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725740854; cv=none; b=FmYfNdh19gY2xLcLMpHaO1jsByS0RoPFs8IJELKAXl8S/Q6jzDbLJ5MAja1jR0+5jjOBipNGnmjoVWp3qAhtulOkdMqcrP0gCHumFaErMj3m8w8KexSJGPI1pgwL0MMxDrw/KiV2sq2cTm2zj3DG0+SVgGy6TK6IFD6TmzfJN48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725740854; c=relaxed/simple;
	bh=0z12rQr8aOEhbv2ocuQ+qGvb9pu7p/hR0nESc/KdGi4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=eh9ARux5XQjnbubu+MRqtrtU/HI95eoE+/zDK1kvHzkK/mwzaSpqHBP72qixwyTJEUMIJ+NgMOZxsFg4V9J5HTnEz+UiFFxTj+4x0IFAiyEWfXmrdsrJD4YPThm1CvvQdpEvMB2Z9SOsLBDZIaDsiUP1NYXYSzkw/S+ABUtJAi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=oWEieebl; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="oWEieebl"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 487KKKY9028212;
	Sat, 7 Sep 2024 20:27:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tLMeh+awwH0FADuqhvKnueLa7ougHhwL8As1B7hWqQQ=; b=oWEieebl1R4yiwDD
	iwlRnHifhOkXvMNYkOLP81Smf9nIFqWlw2dcDH38X92/v6HSgD0nSH1jzb/BUYZM
	grRCsoi+zgec9AnboJuYcZ1Pu5HoiZVpEklqRKsNCMruwkRdS6DD9qxQ2TwskNWi
	zca8nMTSx2YytTgPhosPBiYWLpYxBTP+wz+kWLqG+D0nukfSKBFTtdn+618HDPeM
	XOd541BrGTL+7x2uTllDr8wZVo1sT0jeetDxbDQ+XQgKYR1JhRvqBKlU8k5EXBaP
	yhDAwmDcK+Hov8/yMVWByRrnN0z/E2FeULRkVk0P2CnEUhDrF7X/g/HeFLblqWxg
	HpscRA==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41gdsns3wr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 07 Sep 2024 20:27:21 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 487KRKir002311
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 7 Sep 2024 20:27:20 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sat, 7 Sep 2024
 13:27:20 -0700
Message-ID: <4a502b38-8085-f521-9be3-875ba5af92d0@quicinc.com>
Date: Sat, 7 Sep 2024 13:27:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 08/10] scsi: ufs: core: Move the MCQ scsi_add_host()
 call
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
References: <20240905220214.738506-1-bvanassche@acm.org>
 <20240905220214.738506-9-bvanassche@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240905220214.738506-9-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: bwtF_TGIqpS-yxuJDa7TtB4eu-oVqPiN
X-Proofpoint-GUID: bwtF_TGIqpS-yxuJDa7TtB4eu-oVqPiN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409070168

On 9/5/2024 3:01 PM, Bart Van Assche wrote:
> Whether or not MCQ is used, call scsi_add_host from ufshcd_add_scsi_host().
> For MCQ this patch swaps the order of the scsi_add_host() and
> ufshcd_post_device_init() calls. This patch also prepares for moving
> both scsi_add_host() calls into ufshcd_add_scsi_host().

This patch fixes the issue about scsi_add_host() being called twice 
introduced in patch #7. It also acknowledged the order swap I mentioned 
in patch #6.

> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 39 +++++++++++++++++++--------------------
>   1 file changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 014bc74390af..b46e9b526839 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10379,7 +10379,25 @@ static int ufshcd_add_scsi_host(struct ufs_hba *hba)
>   {
>   	int err;
>   
> -	if (!is_mcq_supported(hba)) {
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
> +		err = scsi_add_host(hba->host, hba->dev);
> +		if (err) {
> +			dev_err(hba->dev, "scsi_add_host failed\n");
> +			return err;
> +		}
> +		hba->scsi_host_added = true;
> +	} else {
>   		err = scsi_add_host(hba->host, hba->dev);
>   		if (err) {
>   			dev_err(hba->dev, "scsi_add_host failed\n");
> @@ -10623,25 +10641,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   	err = ufshcd_device_params_init(hba);
>   	if (err)
>   		goto out_disable;
> -	if (is_mcq_supported(hba)) {
> -		ufshcd_mcq_enable(hba);
> -		err = ufshcd_alloc_mcq(hba);
> -		if (!err) {
> -			ufshcd_config_mcq(hba);
> -		} else {
> -			/* Continue with SDB mode */
> -			ufshcd_mcq_disable(hba);
> -			use_mcq_mode = false;
> -			dev_err(hba->dev, "MCQ mode is disabled, err=%d\n",
> -				err);
> -		}
> -		err = scsi_add_host(host, hba->dev);
> -		if (err) {
> -			dev_err(hba->dev, "scsi_add_host failed\n");
> -			goto out_disable;
> -		}
> -		hba->scsi_host_added = true;
> -	}
>   
>   	err = ufshcd_post_device_init(hba);
>   	if (err)
> 

