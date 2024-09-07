Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B7C1870
	for <linux-scsi@vger.kernel.org>; Sat,  7 Sep 2024 00:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725668710; cv=none; b=rxEpaiLcyWCYObKfSrWO87D3ya6ubgwO/uLLiZFmSjfeQObVu3ecyNMN5G9Z113TL1ujXHdYkUGif5ZQDnySH2asTg34BLN8NTq2cI6swesekmnrFacG5ZuWJvdWfujxmIR8R4ksv4CJBAt6ZM3rqALK0gUvRbNDS14NhU6GGSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725668710; c=relaxed/simple;
	bh=9Fj8F/dl/yiAi5zjxGF9VPH42Z5DZxcSWb35uUMYD2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=t1CnN/x13JPoPVDgVwUKQ/ayi6RVed4nvECYkiJy0Dr4B0hPoCqIE5Bxfk8DrVXNMsn4F9uPdFkTxVoETnmJmKcN5aan8mZw8xsNYbF6dcrTE4vLZgpNt34RJcWmqs64HHXIvswW2se6aO4CrI6KB6Wmfhl8eyHr1WF5nY+rywo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=kkXzZlMx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="kkXzZlMx"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4870LV2D027918;
	Sat, 7 Sep 2024 00:24:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UUzf/lpHsjU/ZcLKNFnGcrYt03N/KYi8k5qlunNc43U=; b=kkXzZlMxOORFK6QW
	tqmYT6zIGIk+1RGL0CWlPzYJlvUsmYx0DHBVoCWGDttTRhe4NUFbzlXgE9cuB7uc
	clo4HP2YDGDmd4bYQX6efvIjnKTkr0l+LxSpWuv21gB1UTrHXG3xXPlrjMhSmlWH
	9scTF2FCDPPHW8yJgWQ7m5ybjDDr4Oxd4MSBLhV5QxQlNxS/jZaeYr6JpTTNCEoe
	hMHG1mGv3Fy/Kbkf/etWuupT53KgHXqoKh2+FhNvVkatNoC9hrDBogxDeGERZJia
	BhwcWm3FV0ym09sOyw2j74hUqlDbx4INmW+meA/Yp22A+4yl+BbsDqTlovmb6Zix
	Lidx5Q==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41fhwu3p7r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 07 Sep 2024 00:24:57 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 4870OuZc017540
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 7 Sep 2024 00:24:56 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Fri, 6 Sep 2024
 17:24:56 -0700
Message-ID: <eeb12819-15d8-8469-4802-7433cb770fa6@quicinc.com>
Date: Fri, 6 Sep 2024 17:24:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 03/10] scsi: ufs: core: Introduce
 ufshcd_post_device_init()
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, Avri Altman <avri.altman@wdc.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang
	<peter.wang@mediatek.com>,
        Andrew Halaney <ahalaney@redhat.com>, Bean Huo
	<beanhuo@micron.com>
References: <20240905220214.738506-1-bvanassche@acm.org>
 <20240905220214.738506-4-bvanassche@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240905220214.738506-4-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: lIHU1G7P5yvimez7AE9fMNwCgadVNA0s
X-Proofpoint-GUID: lIHU1G7P5yvimez7AE9fMNwCgadVNA0s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=833 phishscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409070001

On 9/5/2024 3:01 PM, Bart Van Assche wrote:

> +	ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
> +	if (ret) {
> +		dev_err(hba->dev,

Nit picking. A line break here is not necessary. The original code fits 
the message fine.
> +			"%s: Failed setting power mode, err = %d\n",
> +			__func__, ret);
> +		return ret;
> +	}

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
