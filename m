Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385451C3D;
	Thu, 11 Jul 2024 05:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720676836; cv=none; b=b6olYO83OnK/eTVjA0xGwyEP8/LL18scuD7v/PtryrnXcb+77qYMk3DpjF81ucnvG9HbxBQhoSC7mZC2OvUc9JjhoSQxVXlCjm3bO0GJlJPy/osZ3oWS8E48IJNJPbMvAmyxjnDrCTGk4Vh2VNOIXSOz/i3gGjQwIXi6G6pu3KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720676836; c=relaxed/simple;
	bh=KV5IXxru9pilF4dOOLYpt1RzDfKhSLtpig38iU5SKYk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=JbzK/4C6ds2OAbI7tdEgWONnQOX7bViU8vhNA9C3IRfGGUgZnfOSf73fgidE95UgKgCGRh6ixFNxxQVMEuCF90pDjXlyxKrLXHwBREARocxt+Jr017a1Q6pmV9H4BzyC9di7lzDtfDJ4fiYPia6dBz1grwPYvmk/5MnDJxtFcUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=II6EcZ5G; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="II6EcZ5G"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46B4mkfM014592;
	Thu, 11 Jul 2024 05:47:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	D2mb8mAgWdsLluzPI3epDbMKGaelwMrlZ3WFZaUSHQY=; b=II6EcZ5Gi1ha4kRB
	YvybFzFH9uqi2BmkNEKjL1lXBmxWiNq57/HcZw++aZ7GqxvOKoR/utmmTI80t3sd
	m1UpN/WaRQiqd4mabh6TCLhSQht/jN3486JBLVR8FrFv1LIr/uRu20Ljqpd+wea5
	Sy24k8js4A0zLZrRzM34aAAjJvhCEaw5ZHjuu6OqtnYuBcmVAxxzbd8+bPaIRGqm
	5WCdTNOSqSSKQ99olOsZidgl5P5BiYnKqdtDl8BCo+5UPznqGQOVzYLB8CbPB18j
	41uzG8wjLiKO4kdgC8URiotEAJsaupK2FaOe5OHaoq8bHtQkXFhCp5NC8Eyp/xzd
	qSQQWQ==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 409kdtk5u2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 05:47:00 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46B5kwp7023762
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 05:46:58 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 10 Jul
 2024 22:46:58 -0700
Message-ID: <6f6a2608-6f1e-60dd-0dcc-93fa3d61202e@quicinc.com>
Date: Wed, 10 Jul 2024 22:46:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 1/1] scsi: ufs: core: Support Updating UIC Command
 Timeout
To: Bart Van Assche <bvanassche@acm.org>, <quic_cang@quicinc.com>,
        <quic_nitirawa@quicinc.com>, <avri.altman@wdc.com>,
        <peter.wang@mediatek.com>, <manivannan.sadhasivam@linaro.org>,
        <minwoo.im@samsung.com>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        open list
	<linux-kernel@vger.kernel.org>
References: <cover.1720503791.git.quic_nguyenb@quicinc.com>
 <6513429b6d3b10829263bf33ace5c5128f106e59.1720503791.git.quic_nguyenb@quicinc.com>
 <a89910ad-da5b-42c2-8a0f-9f4908fa2c1a@acm.org>
Content-Language: en-US
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <a89910ad-da5b-42c2-8a0f-9f4908fa2c1a@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 39rtRuUgvIp4coAdsiixNe33AyD2U0Z5
X-Proofpoint-GUID: 39rtRuUgvIp4coAdsiixNe33AyD2U0Z5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-11_02,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407110038

On 7/9/2024 11:10 AM, Bart Van Assche wrote:
> On 7/8/24 11:06 PM, Bao D. Nguyen wrote:
>> +static int uic_cmd_timeout_set(const char *val, const struct 
>> kernel_param *kp)
>> +{
>> +    unsigned int n;
>> +    int ret;
>> +
>> +    ret = kstrtou32(val, 0, &n);
>> +    if (ret != 0 || n < UIC_CMD_TIMEOUT_DEFAULT || n > 
>> UIC_CMD_TIMEOUT_MAX)
>> +        return -EINVAL;
>> +
>> +    return param_set_int(val, kp);
>> +}
> 
> The above code converts 'val' twice to an integer: a first time by
> calling kstrtou32() and a second time by calling param_set_int().
> Please remove one of the two string-to-integer conversions, e.g. by
> changing "param_set_int(val, kp)" into "uic_cmd_timeout = n" or
> *(unsigned int *)kp->arg = n".
Hi Bart,
My understanding is that in the kstrtou32() function, the  the result of 
the conversion is written to the third parameter only which is '&n' in 
this case. 'val' does not get updated (and it cannot be updated because 
of its 'const' type). Please correct me if I am wrong.

Thanks, Bao

> 
> Thanks,
> 
> Bart.

