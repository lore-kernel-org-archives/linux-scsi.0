Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D421FDD;
	Mon, 21 Oct 2024 00:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729470405; cv=none; b=MfVn6EwosBlZ2cjWODUTkT5p2m4MPe4EDkq968vPwIt/KNb7C+O8kpCsEeOwwh5Q+VcjO40+U0/E9wSKYZXa591IVgWOyDJQPOiXkDMUOrL3hBbXlrisrSEdmDwLpA+yp6rVzg0xTOReTfOYY+TAwjm6KejDeA3/ggGhiodTrA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729470405; c=relaxed/simple;
	bh=YnnxuuCfNu4P8m+6Ygxevm2LbIGYcL5A0C/bjDwuUyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=F4JfKkL+KnKKy7aSSYgpTL8xbCL9qobk4BL3oSd01pJ6zbbdfajbU11krsz3d4amFcWCSFAAk/My0me18nrjRGtRtmi1p8ThqvH/Zt6YfZRxzhAaQL70eMQX7eA6mAlpyrS/4dVRliHCOcZ21kD++zh2qyhpmweqVGbkWG38gQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=EMBhqF0d; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="EMBhqF0d"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49KNgclc010476;
	Mon, 21 Oct 2024 00:26:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	r1bxPaN/ll6s1s/ED37SgN/1iaUXiyBIFDtqTWYVPRQ=; b=EMBhqF0d7AVCipoy
	li5t2NK/ygvQLJgMBDijzTnoRSJrnoxY/EwE+DiETVeA3F0liv8OgPEo99/TC6FR
	dgAEVpioeOlrPshRRLnaPiBDWNq7IJGlNrID+E5YW3eMfk+yKyDzA1x0Wr+mF1sH
	f5xwawfSp1hvDkJDtyjJhWbEphOGGI+XTOHIANsZG6eafNN0lRbsR2VqS3TXhH/c
	Zrph3GGVuimzJGPnG+qFM4WDPyDAP3+xn9ZpV+9tqkqLn1dypOPyFuQWdANhxUCI
	wqpPQNmt/JkZYPFYmgtV49uaOmCa9WR6eqx7XRVpZEkJEy9DjDLbVW9N/Hpcoc6d
	m+Ug0g==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 42c6w1jrgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 00:26:25 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 49L0QPQ0012217
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 00:26:25 GMT
Received: from [10.48.241.209] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sun, 20 Oct
 2024 17:26:24 -0700
Message-ID: <0c0bb52b-06a2-4f55-845f-014acd299b78@quicinc.com>
Date: Sun, 20 Oct 2024 17:26:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: elx: efct: Prevent potential integer overflow in
 efct_efclib_config()
To: Gax-c <zichenxie0106@gmail.com>, <james.smart@broadcom.com>,
        <ram.vegesna@broadcom.com>, <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <fthain@linux-m68k.org>,
        <dwagner@suse.de>, <hare@suse.de>
CC: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <zzjas98@gmail.com>, <chenyuan0y@gmail.com>
References: <20241019211637.5533-1-zichenxie0106@gmail.com>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Content-Language: en-US
In-Reply-To: <20241019211637.5533-1-zichenxie0106@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: ocaIyC4IwIJm1qfSmdFP_hwbpLAuSYZs
X-Proofpoint-ORIG-GUID: ocaIyC4IwIJm1qfSmdFP_hwbpLAuSYZs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 clxscore=1011 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410210002

On 10/19/2024 2:16 PM, Gax-c wrote:
> From: Zichen Xie <zichenxie0106@gmail.com>
> 
> This was found by a static analyzer.
> There may be a potential integer overflow issue in
> efct_efclib_config(). efc->max_xfer_size is defined
> as "efc->max_xfer_size" while sli->sge_supported_length

I think you wanted to say: as "u64" while...

> and sli_get_max_sgl(&efct->hw.sli) are all "u32".
> The result of the calculation will be limited to
> "u32" without correct casting.
> We recommend adding an extra cast to prevent
> potential integer overflow.

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes
Describe your changes in imperative mood, e.g. “make xyzzy do frotz” instead
of “[This patch] makes xyzzy do frotz” or “[I] changed xyzzy to do frotz”, as
if you are giving orders to the codebase to change its behaviour.

So suggest something like:
Cast an operand to u64 to prevent potential u32 overflow.


> 
> Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
> Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
> ---
>  drivers/scsi/elx/efct/efct_driver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
> index 55d2301bfd7d..7fe180037c2d 100644
> --- a/drivers/scsi/elx/efct/efct_driver.c
> +++ b/drivers/scsi/elx/efct/efct_driver.c
> @@ -109,7 +109,7 @@ efct_efclib_config(struct efct *efct, struct libefc_function_template *tt)
>  	efc->log_level = EFC_LOG_LIB;
>  
>  	sli = &efct->hw.sli;
> -	efc->max_xfer_size = sli->sge_supported_length *
> +	efc->max_xfer_size = (u64)sli->sge_supported_length *
>  			     sli_get_max_sgl(&efct->hw.sli);
>  	efc->sli = sli;
>  	efc->fcfi = efct->hw.fcf_indicator;

