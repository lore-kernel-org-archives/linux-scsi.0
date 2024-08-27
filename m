Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB3617BEA5
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 21:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724793483; cv=none; b=VgVniby3zCAD+tNrY/dmMVEiSkSLStbP6W0CtpxHl/Pkkycr5ZWB10ENHpQjYQ5DC2IXlpeZmiyAkTMtiqgZ0Sq5s9F+77CPJ9qIbwB0Ci3EnV6Bc+vj6tc+Rcvr/CqYUamtmNSq+b7uV24oo6VhThavI86oh86+WTUvPMe76Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724793483; c=relaxed/simple;
	bh=U/CY2dGdZCnLuHwko58ew2U0XXV4MPldshm1U2bxdbU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=o7aQXqDZK0vRlL1T2w2m473I7U7yFL9KQvbwJwrG7Fo9fb75/fxE0Tay39sN8jHNNjBRyrIdppaRJy/MBM5pbHJ6q6aSqfjcWNm6w5o2ev5BF/W0daomitVhuaz36yC48AoY4FuHhpNFmguu1sJXpyHy4pWxIIhNX1q4g09WMBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Mxv9vpgg; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Mxv9vpgg"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47RJlcKc005257;
	Tue, 27 Aug 2024 21:17:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IZM0LzwDcKPpZ5MNx8mTAxnyM45a0yG6R8aEXU1PDlQ=; b=Mxv9vpgglUFc4SDQ
	nfvhDvdqaYtHso/eLX6wcWNA+BZNwqy0fekf/7VSaOvZjj4vjfyBhAteXOWH8+y5
	C8qRpaqmjB4nN3SBlZvdD2CKwjQ/vjUd2ggDm7/7hUnUCaX3zi5kn8aJ/+kdgio2
	nWu9Vg3RaR5LHgx5W/R+x2aGxuLFM1zaoJX/icFqj0IlYfdAwQRTccGJTn3i/Zib
	DQw0O64OGlC9bymoMrR4Nwf7b89IjDyHYkvDd2o7E9ZTDYfd2ZJ4AO1jUiCdTgwj
	oK8avP5+BXLrfRuJoh+atheDdJ/PV8TSpz4SFAdg55igKMyc3atG/TIkLMB0zAwZ
	/XgE4Q==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4199yt27nd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Aug 2024 21:17:43 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47RLHgVA028850
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Aug 2024 21:17:42 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 27 Aug
 2024 14:17:42 -0700
Message-ID: <3a982573-3e0d-a644-e429-6b6aee829af8@quicinc.com>
Date: Tue, 27 Aug 2024 14:17:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
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
        "Andrew Halaney" <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
        Alim
 Akhtar <alim.akhtar@samsung.com>,
        Eric Biggers <ebiggers@google.com>, Minwoo
 Im <minwoo.im@samsung.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
 <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
 <1bc51b34-0d2f-59ec-f025-bcc68da74718@quicinc.com>
 <e974b034-62e8-4795-aa78-ee142fd14441@acm.org>
Content-Language: en-US
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <e974b034-62e8-4795-aa78-ee142fd14441@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: PJ__xCLz_YrcozzEjAAeZ5Gzclpc5aGt
X-Proofpoint-ORIG-GUID: PJ__xCLz_YrcozzEjAAeZ5Gzclpc5aGt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-27_10,2024-08-27_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 spamscore=0 impostorscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 mlxscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2408270157

On 8/23/2024 1:25 PM, Bart Van Assche wrote:

> If the UIC command completion interrupt could come late we would
> already have observed unhandled interrupt errors in device logs, isn't
> it?
> 
> Anyway, isn't this something that is easy to fix with something like the
> (untested) patch below?
> 
> 
> @@ -2559,8 +2557,7 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct 
> uic_command *uic_cmd,
>           return -EIO;
>       }
> 
> -    if (completion)
> -        init_completion(&uic_cmd->done);
> +    init_completion(&uic_cmd->done);

This change may not work, Bart.
In this path ufshcd_uic_pwr_ctrl()->__ufshcd_send_uic_cmd(), the 
proposal always has a init_completion(&uic_cmd->done). However, there is 
no ufshcd_wait_for_uic_cmd() in this path. The isr will call 
ufshcd_uic_cmd_compl()->complete(&hba->active_uic_cmd->done); to signal 
the completion, but you are missing the code that waits for the 
&hba->active_uic_cmd->done signal, so it may cause stability issues.

I am going to review another of your proposal in the mail with Peter and 
get back.

Thanks, Bao
