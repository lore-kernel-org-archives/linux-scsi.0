Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C574442C;
	Fri, 12 Jul 2024 01:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720747263; cv=none; b=VIfM/tpCdvfh2W+Qv3LBV07OCpbeJXsqrxL2ez/DwMZ2kx8zPBAPXSuTeohtyb4hG7N07rY44ciQtykDoLAgCve0r/lmaW0T+J3jzeDVKk2nZhJhrIdjc2kZ2oSn1xl51V1lVbHf0BM4IlhVl+GBWxFU6MZ9l9uhkAMUdayPqzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720747263; c=relaxed/simple;
	bh=pleVz/gTSLLCk6BYxtN1q0cEv/wHYF7d+N6+qEpGXzM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=VdezSyGLBnfU0SWVe7hMpySKS4UO7cCjK5jG3lNDcOM7/JoqWhZPXlDfh45GfstzPG02CtlAtL4upwWx4uEJa8ANL4R3v1L256+Pyfgp+raiE2JJTm+Ye77A3Uh7ZhsjaNnPWWwNF1s8Xk8aa6cR9seOjWPcPuswJCSO2mNm1G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=MWphFQwP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="MWphFQwP"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46BDFUli009296;
	Fri, 12 Jul 2024 01:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cmiB/DREshNWORiGFpU8+EigwndlL2gj5Q7iB6GCnMQ=; b=MWphFQwPgnKL63eE
	LPRdLY/7SHc7pnc6avjX9p7u5JXCC2tUwlPArhsw6kRSXEhKzJc9RaEukTY1lNp9
	Hc8p0BAF7SYh7FQsxDMPVS1iT4t1WhVil23uDjHYVe3CvqYQlltMtjw/dq0mAkiI
	dzFe7pl63Yi1TGcF7IDa8k10cML5lv2CEMud6K9GBFlae+6PJuM/jk29q+2TmtfU
	cElVV/NmwT1FVGql773LXiaAj2XW2fQy6ha+cBJ/+TbmmPlhMeEycSthRScEmmKK
	UU4VJgbYOasu8liiiniJhZfL8qejMwjFnmUrcFYJ/S9UJ8+CPnKiF6Zx5wdTJOmy
	J5qp8g==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4091jdr2e5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jul 2024 01:20:32 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46C1KW5V001712
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jul 2024 01:20:32 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 11 Jul
 2024 18:20:31 -0700
Message-ID: <91d9bb0f-d9da-6303-c16a-f449b070a4e5@quicinc.com>
Date: Thu, 11 Jul 2024 18:20:31 -0700
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
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
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
 <6f6a2608-6f1e-60dd-0dcc-93fa3d61202e@quicinc.com>
Content-Language: en-US
In-Reply-To: <6f6a2608-6f1e-60dd-0dcc-93fa3d61202e@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 9xsaN98pJQNgqGyj6pCHRpe8fOBuCo6p
X-Proofpoint-ORIG-GUID: 9xsaN98pJQNgqGyj6pCHRpe8fOBuCo6p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-11_19,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2407120008

On 7/10/2024 10:46 PM, Bao D. Nguyen wrote:
> On 7/9/2024 11:10 AM, Bart Van Assche wrote:
>> On 7/8/24 11:06 PM, Bao D. Nguyen wrote:
>>> +static int uic_cmd_timeout_set(const char *val, const struct 
>>> kernel_param *kp)
>>> +{
>>> +    unsigned int n;
>>> +    int ret;
>>> +
>>> +    ret = kstrtou32(val, 0, &n);
>>> +    if (ret != 0 || n < UIC_CMD_TIMEOUT_DEFAULT || n > 
>>> UIC_CMD_TIMEOUT_MAX)
>>> +        return -EINVAL;
>>> +
>>> +    return param_set_int(val, kp);
>>> +}
>>
>> The above code converts 'val' twice to an integer: a first time by
>> calling kstrtou32() and a second time by calling param_set_int().
>> Please remove one of the two string-to-integer conversions, e.g. by
>> changing "param_set_int(val, kp)" into "uic_cmd_timeout = n" or
>> *(unsigned int *)kp->arg = n".
> Hi Bart,
> My understanding is that in the kstrtou32() function, the  the result of 
> the conversion is written to the third parameter only which is '&n' in 
> this case. 'val' does not get updated (and it cannot be updated because 
> of its 'const' type). Please correct me if I am wrong.
Hi Bart,
Maybe I misunderstood your comment. You probably was concerned about the 
execution time of param_set_int(val, kp) vs a single assignment 
instruction 'uic_cmd_timeout = n;', right? If that's the case, I'll 
update the patch.

Thanks, Bao

> 
> Thanks, Bao
> 
>>
>> Thanks,
>>
>> Bart.
> 

