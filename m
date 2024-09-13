Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBD41D52B
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 07:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726212712; cv=none; b=nPRz8f/RMDvJWKF5nWo4agyIRTqPFJ4k6R024gsRETU6LeSa9kNc8DotVvNYgKyrG+6a5LdHjeJHXyDv2D3KdzDkkPf4N7jk/jLboBvCIeiquyF2H8MfONUS9ybGe2GBowzFr4cZN87iacKgkAucn2rgftiNWygmxfqzbXwmxa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726212712; c=relaxed/simple;
	bh=fwdDPoZCQiOZH5VSqRkc2lGCdZmeqNU4eph4E0VeVdY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dTXWPQcrYTO9vjYPBafUnRAa79BBcg7qR9LHSFcoo4OMeT+L9WNYlCvdQHwan1eDTJCU0aMc91ezVWAmTdnR2T1H/yDEdwxUshg69CjMZ0H6TGC6kSpPAb7ktfKvZiwHHD1RwclSeiekv/frVsDnVpCsTmmmIkdSXty0auzQyd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=g7pKgIdT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="g7pKgIdT"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMCQub006841;
	Fri, 13 Sep 2024 07:31:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	K+8taXHTvSApVb4kKi4rlzNqSWhgFZ5ArbjXdnVleuI=; b=g7pKgIdT0qlE7pWo
	lOgnMsaUTOI0sY11xjtv9u1twZdZ4IGBN/zcRIVTbVvHbxirgF5oHo4vRCIHbHbu
	4TE0M+EmF8pVLZtVXRKPXEmLY7AZ61y9LY1mfMy6UZ+CiZnWq7Yrpprg1bx8TdoF
	tySurj6ELewHVzGZX5edYt+XB48ljAJVmiMxqSuq0z/mWzfY1pwwIVJc2SiDHe4f
	gOwwMIDS2mrgJdS46caCP2wDbxYRieOMLAMNoO0Fpm4AWhmG+vOyvcSR2/2zqYTY
	dVv1dftEbBIAnEzUSb15FxiPYVgfsSlzdNaWXcFOqpE+1a3U7sw9jgZgEh13Hq6v
	9JGV6A==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41kvma3gfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 07:31:39 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 48D7VcMG024672
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 07:31:38 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Fri, 13 Sep
 2024 00:31:38 -0700
Message-ID: <c4ce91f3-6724-03eb-ed72-0215c8992e0c@quicinc.com>
Date: Fri, 13 Sep 2024 00:31:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 3/4] scsi: ufs: core: Make ufshcd_uic_cmd_compl()
 easier to analyze
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Peter Wang
	<peter.wang@mediatek.com>,
        Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>,
        Avri Altman <avri.altman@wdc.com>,
        Andrew
 Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
References: <20240912223019.3510966-1-bvanassche@acm.org>
 <20240912223019.3510966-4-bvanassche@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240912223019.3510966-4-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: eqjCusayQZc3_E86PC-K3GmYTR4jbbaB
X-Proofpoint-GUID: eqjCusayQZc3_E86PC-K3GmYTR4jbbaB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=727 bulkscore=0 priorityscore=1501 adultscore=0
 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409130052

On 9/12/2024 3:30 PM, Bart Van Assche wrote:
> In ufshcd_uic_cmd_compl(), there is code that dereferences 'cmd' with
> and without checking the 'cmd' pointer. This confuses static source code
> analyzers like Coverity and sparse. Since none of the code in
> ufshcd_uic_cmd_compl() can do anything useful if 'cmd' is NULL, move the
> 'cmd' test near the start of this function.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>


>   	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
>   		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);

Hi Bart, while you are at it, there are extra parenthesis here too.

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
