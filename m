Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623D8282FA
	for <linux-scsi@vger.kernel.org>; Sat,  7 Sep 2024 20:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725740135; cv=none; b=tyfBw3K0HwjS9so7+HWtO9LBDurPxaqnf5tdwltJphnzNovU1ImgLIxBtl2itvdyEnNj2gPrNuh7nnkkCrgFvCr6UqMqy3GWK1POCSSj0nxJxIEM+TthK2scqLNiyC4fkZpSU575faXhQ5YOtQkutIQIeGjHtG+Rw1jnAykztpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725740135; c=relaxed/simple;
	bh=1+jrJznT0jvgqRtv1iUGJ8RbeqnOdhy6OKa4zu+kOx0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WGa1SZdqGpeOWC+XzLwIHx8F9nRe2v7GiWHMDngZrNykIBbVJty9HqAuWshY5E1tjw4nFT44YQ91ZKb3yczvvmFAUAQag7TcgwH5ZmorVHkAru7d4SE8570VY35WhukoiApMW+YCLBS/zRkvHqR+qXvEbcD2wewllZLEnzwJeuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=d9wQL12/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="d9wQL12/"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 487KF2kL032460;
	Sat, 7 Sep 2024 20:15:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	lFHhvm52VZ0KNS2C04J4ONiH5P/JAT9JOt+weO4Y23Q=; b=d9wQL12//5Nshtzy
	qgRvK77PnCHor3+JyQNqYsvhT5HjFk/S77iPwBUjPKf5ZzWQgOSpdmeNomliLEtK
	kMaHMujAdfgEXi3DFIG3P2vf958jyx6y7vMTZhv9Gj1av8LIHjaX4Z+mQR50uiXk
	dHP7wWX8YPOqffmCYaDvHSv/OD4H5opABYPG0P0D4dx2D95lqPtuy3JyPk1LFIq7
	xqv/rmrq7fUQ1Xso6z8kujVTuXEcffxJwZXomQ1/M7NNZ2dqQLS6EYT0+4OQHik3
	8ON/k6EWYHryVXRRrMd7KMUWGeJInSvIZMbQsfZkn4SzqdLlQKYu6sS04oE11QOf
	1KYSzA==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41gfkcrxmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 07 Sep 2024 20:15:19 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 487KFIpE016443
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 7 Sep 2024 20:15:18 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sat, 7 Sep 2024
 13:15:18 -0700
Message-ID: <e67d8cf8-674b-cb29-0caa-8e209bc1fc46@quicinc.com>
Date: Sat, 7 Sep 2024 13:15:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 07/10] scsi: ufs: core: Expand the
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
References: <20240905220214.738506-1-bvanassche@acm.org>
 <20240905220214.738506-8-bvanassche@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240905220214.738506-8-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: iurXAsxWv22jjlZ3O79QDO6jUjjdT4Ay
X-Proofpoint-GUID: iurXAsxWv22jjlZ3O79QDO6jUjjdT4Ay
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409070167

On 9/5/2024 3:01 PM, Bart Van Assche wrote:
> Expand the ufshcd_device_init(hba, true) call and remove all code that
> depends on init_dev_params == false. This change prepares for combining
> the two scsi_add_host() calls.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 43 ++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 843566720afa..014bc74390af 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10602,7 +10602,48 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   	 */
>   	ufshcd_set_ufs_dev_active(hba);
>   
> -	err = ufshcd_device_init(hba, /*init_dev_params=*/true);
> +	err = ufshcd_activate_link(hba);
> +	if (err)
> +		goto out_disable;
> +
> +	/* Verify device initialization by sending NOP OUT UPIU. */
> +	err = ufshcd_verify_dev_init(hba);
> +	if (err)
> +		goto out_disable;
> +
> +	/* Initiate UFS initialization and waiting for completion. */
> +	err = ufshcd_complete_dev_init(hba);
> +	if (err)
> +		goto out_disable;
> +
> +	/*
> +	 * Initialize UFS device parameters used by driver, these
> +	 * parameters are associated with UFS descriptors.
> +	 */
> +	err = ufshcd_device_params_init(hba);
> +	if (err)
> +		goto out_disable;
> +	if (is_mcq_supported(hba)) {
> +		ufshcd_mcq_enable(hba);
> +		err = ufshcd_alloc_mcq(hba);
> +		if (!err) {
> +			ufshcd_config_mcq(hba);
> +		} else {
> +			/* Continue with SDB mode */
> +			ufshcd_mcq_disable(hba);
> +			use_mcq_mode = false;

If ufshcd_alloc_mcq() fails here, sdb mode is used. The scsi_add_host() 
is also called for sdb mode. Later on, when the ufshcd_add_scsi_host() 
function is called, we will call scsi_add_host() again for sdb mode. 
Therefore, scsi_add_host() would be called twice.

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
>   	if (err)
>   		goto out_disable;
>   
> 

