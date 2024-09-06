Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E12158A30
	for <linux-scsi@vger.kernel.org>; Fri,  6 Sep 2024 23:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725667163; cv=none; b=L6HaJi7uO2Z/3ja+U+YiEDFpMDJrt0DJrO2+4So+ofnsubS0IzkEBMkEidisYvwO8lHVMxMg2WTmCTZ//z1dmVXEpDo7iPhwdTb020czNgDKn6Ub+JLfq3cQmx3I3utQYp+e4pqZt5ZmxU3RkdIpExs6VUpqBVKlKz8xOz+XjDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725667163; c=relaxed/simple;
	bh=4pJufKJL486PwQ8MZgxR+Mt/AOToIuGRDjHhWdgQTTc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=n0IVvZVEEKflKcbK6F8ilhoPTkZ7nWYJrFzd+sS+7PHD3DPue575pEuT3CCbhNs9WzT0sz9PaaSG5sF/jtNSIPE8SEaDsgGEh1LJty0OkLshBng3aEoIjk4ZDGh/jQhpRRLwIjEM9yoSEfSSO9iovu28Bn0m57Q/nbMvzeAzqsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=jBj1USgf; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="jBj1USgf"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486JNm6o032142;
	Fri, 6 Sep 2024 23:59:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eruT7CjQxx+U6i8J33wExK77yvZ5B0RPgaIBnM6bIbY=; b=jBj1USgfbdM6M8k+
	T5htN7jBj26oCTrX6b/VA84eUFRVWV1P5kOjedqeVkl3SeRvPVAWY9Fv3a2vobPk
	qSCt78LZjTWfRwp33J+LLSv/u0Bn5ho7OLdeULSDaMkEFXxWpJg+ixRbYqc/a5IS
	8PO1lMSP2NrXutRqPCiC1JSEbIMF9mOqQRt/yGXZPgLf2EohF+MRI9Pg9XePx/aD
	rT1tiLat4tRvMlEfWKssMghDRB0oUqeWv8jTkDmueK0FtgsH96KhXLuRuCJP3YDS
	pBBW5kggNRTftddxYc8y2ZQtqtklM1k8XhW7juVzqo/mvOD4Rv+9kfZZg/Ys+IUp
	yMNBkg==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41g7ur8dax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Sep 2024 23:59:06 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 486Nx53S013871
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 6 Sep 2024 23:59:05 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Fri, 6 Sep 2024
 16:59:04 -0700
Message-ID: <1add8a06-74fa-4d31-4f23-30fce2209d5b@quicinc.com>
Date: Fri, 6 Sep 2024 16:59:04 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 02/10] scsi: ufs: core: Introduce
 ufshcd_activate_link()
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, Avri Altman <avri.altman@wdc.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bean Huo
	<beanhuo@micron.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Peter Wang
	<peter.wang@mediatek.com>,
        Andrew Halaney <ahalaney@redhat.com>
References: <20240905220214.738506-1-bvanassche@acm.org>
 <20240905220214.738506-3-bvanassche@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240905220214.738506-3-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: teCNTexXyvE_HRs8pc61jhwHUPK6TsGo
X-Proofpoint-ORIG-GUID: teCNTexXyvE_HRs8pc61jhwHUPK6TsGo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_08,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 malwarescore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2408220000 definitions=main-2409060178

On 9/5/2024 3:01 PM, Bart Van Assche wrote:
> Prepare for introducing a second caller by moving the code for
> activating the link between UFS controller and device into a new
> function. No functionality has been changed.
> 
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ecf6da2efed1..4cfa8dd5500a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8709,10 +8709,9 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
>   		 hba->nutrs);
>   }
>   
> -static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
> +static int ufshcd_activate_link(struct ufs_hba *hba)
>   {
>   	int ret;
> -	struct Scsi_Host *host = hba->host;
>   
>   	hba->ufshcd_state = UFSHCD_STATE_RESET;
>   
> @@ -8729,6 +8728,18 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>   	/* UniPro link is active now */
>   	ufshcd_set_link_active(hba);
>   
> +	return 0;
> +}
> +
> +static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
> +{
> +	struct Scsi_Host *host = hba->host;
> +	int ret;
> +
> +	ret = ufshcd_activate_link(hba);
> +	if (ret)
> +		return ret;

Hi Bart,
There may be a problem in this patch.
In the original code, if UFSHCD_QUIRK_SKIP_PH_CONFIGURATION is set, 
ufshcd_device_init() would exit early. However, in this patch, if 
UFSHCD_QUIRK_SKIP_PH_CONFIGURATION is set, the new function 
ufshcd_activate_link() would return 0 which would cause the 
ufshcd_device_init() to continue further down. As a result, the 
ufshcd_device_init() would fail to handle the 
UFSHCD_QUIRK_SKIP_PH_CONFIGURATION flag as its original intention, right?

Thanks, Bao

> +
>   	/* Reconfigure MCQ upon reset */
>   	if (hba->mcq_enabled && !init_dev_params) {
>   		ufshcd_config_mcq(hba);
> 

