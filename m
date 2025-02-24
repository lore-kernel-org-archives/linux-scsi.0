Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDA4156F44;
	Mon, 24 Feb 2025 19:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740426241; cv=none; b=I0ozzgIut0Py4cLksuWd+QW1vekuolu/6emXkEkWH4fnKfjnJ4sz2TRLIr5ckXvOR627GLgeSq3Ku22cd0DraRh4v0KvgoEJZOz8aQy+iJdzaOJtHgU6lOJwxghMIpnFKfm0jMwmNQQwVOyda4WJUNO1OutnoBdh7ejQDN0P8qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740426241; c=relaxed/simple;
	bh=n4qmHe9hsQRu3gEdX75n88cgPPjh0NH1aTkazvBvyjQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PvtB/LSlLXk0l0xoCe+vnpo9yR+zuYBvvUe33tvdMA14nzr6Gf4hFw3y7hspsOoSAb2T4dNwET31F0i/htqbLF4Sa8OzX5e658VrCEq4jiWZn9dskREWgTpMhf8uhvWm1ykK5XCmfGlzHukT30tryJXFA1VGybC/K0KXl0y8wJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=BKBg9Xog; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="BKBg9Xog"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OHu1JC031793;
	Mon, 24 Feb 2025 19:43:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZK4In5afhvclfnRcJczHOHw4HBAuuJj+vd4Og+78rFY=; b=BKBg9Xogt4vLYeMy
	hJCSrBpdNofOPRIu1MQ317Upel0qSxtHzq8IVpMyN2k1kOBInMCzf9PnU5tZ+Vx/
	YEQTiSQJAI7XpJRDT4Ye+tQ2kr/IfoWOZ+v3K7zjTHr5dLX0fK40hrAjGk+hdiNo
	wWiLq0rR/m0z1COkCTHmaRqjDuMWn52KZK9NEWfYVPOqWH9aZMb08YQAK+wV8HJK
	u70JUKhLTgjNtFi8G0BpdpJcgB1kJolc6DsKvNmUAJ25eiBUeGUKzHOuEPANCDqP
	VNHpjicbbsCENAdMeJVcykgi5NrcowsXldfzaEuKmHeyjQqnwjHbJMz1+BJoIF2S
	su7cOw==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 44y49eehc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Feb 2025 19:43:30 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 51OJhTvd029118
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Feb 2025 19:43:29 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 24 Feb
 2025 11:43:28 -0800
Message-ID: <c8a87383-681d-c73c-b671-a03c2130374d@quicinc.com>
Date: Mon, 24 Feb 2025 11:43:27 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [RFC v1 1/1] scsi: ufs: core: Add device level exeption support
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        Avri Altman
	<Avri.Altman@sandisk.com>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
        "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>,
        "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>,
        "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Alim Akhtar
	<alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Keoseong Park
	<keosung.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>, Al Viro
	<viro@zeniv.linux.org.uk>,
        Gwendal Grignou <gwendal@chromium.org>,
        "Andrew
 Halaney" <ahalaney@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        open list
	<linux-kernel@vger.kernel.org>
References: <fdebf652abb4734d37f957062a2b4568754db374.1740016268.git.quic_nguyenb@quicinc.com>
 <PH7PR16MB61967197DC9C471F95536229E5C42@PH7PR16MB6196.namprd16.prod.outlook.com>
 <f4ad0222-d08b-4a57-8c8c-569fbe50f63a@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <f4ad0222-d08b-4a57-8c8c-569fbe50f63a@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: lW9HnPgUnxTCOG8vmU3FC60JiswXc0ge
X-Proofpoint-GUID: lW9HnPgUnxTCOG8vmU3FC60JiswXc0ge
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_09,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 adultscore=0 malwarescore=0 clxscore=1011 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2502240127

On 2/20/2025 10:29 AM, Bart Van Assche wrote:
> On 2/20/25 2:01 AM, Avri Altman wrote:
>>> @@ -419,6 +421,7 @@ enum {
>>>       MASK_EE_TOO_LOW_TEMP        = BIT(4),
>>>       MASK_EE_WRITEBOOSTER_EVENT    = BIT(5),
>>>       MASK_EE_PERFORMANCE_THROTTLING    = BIT(6),
>>> +    MASK_EE_DEV_LVL_EXCEPTION    = BIT(7),
>>>   };
>  >
>> I think you need to rebase your work - most probably for-next is best.
> 
> Hmm ... I think that Martin expects this kernel branch to be used as
> basis for SCSI kernel patches intended for the next merge window:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=staging
Thank you. I will move to this branch when I remove the RFC tag.

Thanks, Bao

