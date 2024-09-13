Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455B7623
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 07:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726211378; cv=none; b=PhCIJLsYY8hUqlrzMf0Xt9IktiUqfKE9a672mokN652K9SywBbUV0pEi1odHL9DwGJDY48APpoxw+IyB7HerTUMRLOPXZHZ7H3c8oWA48DetRlQ/B8RXTNhR4iFq9ZUyg5FH+xPxj4Ipqhoip34VoI6YRDkPlpXXExXut7sDW+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726211378; c=relaxed/simple;
	bh=l16491mh6y48mHBSfwMCaLZihe8mIEoNVQ+VDjpH4+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Tt5ohQ0gAjhKlzqauD9HD1Zh6fL3WaaDLPaypatZjnqLLqZTMbZoG9d/l5YeqjUvUi5P8+z9owKIjW5OCQQiSSLCsSeo0PQJMsDfzrUlFZ0uU9c+SddMkddyGWTWGa2uyWoFJcuCrKbA28Cf/8pspnOjOQs8Y67eSnhE71poIfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=DrUhtFxL; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="DrUhtFxL"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBOAx018841;
	Fri, 13 Sep 2024 07:08:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gq18mXrcY6WGpRqt+xf2cMeSa9kKDCHrbOnwh9l/GvQ=; b=DrUhtFxLhu2n71nB
	lZe0cClWUseuRCAYUABN+vALPgkdxgs2QjwD6t+pE1+7wmDoRvGj3djBxt8X9ibz
	zWStn8fTTtEetrvyeElOAVINm4kxuTfhgYFjMhWrW/TMi3QanBnk718YknYnHcI6
	hbzpgDcx2c4els3vlTjGybP5MLXBuqMWHdWFXH45MVrlDGvWFlx9GlC4/KPr4CPe
	ih3+N8julIHZSexBsEARMRVpOg+IXqDirBLLbpOJ8CzwAB84IeYmbTybNcof9oQE
	3J/kHZ36FYzHA0MbxLzk0hsGW2nJ1trtq6MM2xCkV5UZAeVfjOQN99HxhTjMtilb
	Of0bgw==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41j6gn437h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 07:08:52 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 48D78pGC007988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 07:08:51 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Fri, 13 Sep
 2024 00:08:51 -0700
Message-ID: <9ceb9b6a-3e65-3c64-9a6c-f0a74475296b@quicinc.com>
Date: Fri, 13 Sep 2024 00:08:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 1/4] scsi: ufs: core: Improve the struct ufs_hba
 documentation
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, Peter Wang <peter.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
        Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Eric Biggers <ebiggers@google.com>, Avri Altman <avri.altman@wdc.com>,
        "Minwoo Im" <minwoo.im@samsung.com>,
        Maramaina Naresh
	<quic_mnaresh@quicinc.com>
References: <20240912223019.3510966-1-bvanassche@acm.org>
 <20240912223019.3510966-2-bvanassche@acm.org>
Content-Language: en-US
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240912223019.3510966-2-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: Of1EY005dNGFT0EUumoW2Ishlyx1XlRq
X-Proofpoint-GUID: Of1EY005dNGFT0EUumoW2Ishlyx1XlRq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 clxscore=1011 phishscore=0 mlxlogscore=883 lowpriorityscore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409130049

On 9/12/2024 3:30 PM, Bart Van Assche wrote:
> Make the role of the structure members related to UIC command processing
> more clear.
> 
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>

