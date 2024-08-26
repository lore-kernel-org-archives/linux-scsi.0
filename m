Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEA04F215
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2024 06:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724654921; cv=none; b=jgZAoFtzFaoAQLd/Y8Mlu+duJ+ULD7bIQDlG0XAjMuICgqf0n+CQWiDIjvgW+v6F+8TekkJWON47fiF8wfVOtMCm7uM4tNvlILknS5c2MFLDPsnLN0sm4fLRgQ3ID5ub++eDhM6Htk0d91lt7UW1cSULd2yalGfKUbRLAln947Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724654921; c=relaxed/simple;
	bh=Vnzx9xl48Ole4+mKdz1/SYJ1W497+kIrgm3L5feFFCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HmPdRXtU/axuDOUdywh+ITGxzMc33Y5TArleOcTEoyzLiM1XDCNcml/9JCxvhKU8CEz5PSPBR4AZk/EFsAIQUKg/AdsyRXWz7IjWlfBzViMZK5MVA24U8cF4/3hHJO+o6hcJOlpFsMjALQ01IxAH6PKMQ4KPk/aPITLrm9ZUNUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=ZGocdVPB; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="ZGocdVPB"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47Q0fltP021104;
	Mon, 26 Aug 2024 06:48:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ujRHBzeN7p9cFhDjMlBVuYyTS0d4HihktfnjipdgTLQ=; b=ZGocdVPBVMqJOai0
	plX/r6sw+QpGXBdU/emv6x43RsJMSW+HNECU1cpLClz3ELGophD0jsIyLSW9ts+A
	KjMA5B48JYIsFrwyDEu5KEQ6xk1C2DhrQt2s9t3br+N6OgEBmMaiEEtoAI1h3SwK
	o3Lh+yiipGewGFvTvAVcuIbS/KkTGpC1asmWIMhmkepDh0JbAHNrJeCeObMa2lt2
	HAiimYokw0J2qrbNHKDYMMConnJKF5ZywNKiAVmiuy8LZmMzml9c+64Zunq2aoiy
	I3dyhMU4L2dst+NIxKltJuEIBZ83azBfMzweaTXYEUJnp0B4Wt6lwPvee6fSofv1
	j0oqSA==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 417973jqm9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Aug 2024 06:48:08 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47Q6m7Yd017747
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Aug 2024 06:48:07 GMT
Received: from [10.253.13.0] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sun, 25 Aug
 2024 23:48:04 -0700
Message-ID: <cb8eabd6-7652-4ed8-a281-7af55f2b00f2@quicinc.com>
Date: Mon, 26 Aug 2024 14:48:01 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re:
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bart Van Assche
	<bvanassche@acm.org>
CC: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang
	<peter.wang@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Andrew Halaney
	<ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
        Alim Akhtar
	<alim.akhtar@samsung.com>,
        Eric Biggers <ebiggers@google.com>, Minwoo Im
	<minwoo.im@samsung.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <3a455ddb-7dad-cb2c-7b80-ec355221fb0a@quicinc.com>
 <7d5c2cf5-24a3-4a1c-810f-f80ba367237e@acm.org>
 <20240823120104.siy54o6qja75lpwh@thinkpad>
 <5b3057e7-0d0f-4601-bf96-5d2111af2362@acm.org>
 <20240823145817.e24ka7mmbkn5purd@thinkpad>
 <c5699d57-cd51-4bff-95f4-372a00b2a3dd@acm.org>
 <20240823164822.fdkfswpyhlwnfgfl@thinkpad>
 <4b7d6a81-a0ac-4f1e-9744-6fc1ed4c6c43@acm.org>
 <20240824022929.sxnh7sjl2tb6pmbm@thinkpad>
 <861b64b8-d0cc-42b3-bf57-375f84f4fe85@acm.org>
 <20240824030314.rhsfdhralfpcdjgt@thinkpad>
Content-Language: en-US
From: Can Guo <quic_cang@quicinc.com>
In-Reply-To: <20240824030314.rhsfdhralfpcdjgt@thinkpad>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: FshG6yjfCvczPSBZUou-Qff3sAZHkRmi
X-Proofpoint-GUID: FshG6yjfCvczPSBZUou-Qff3sAZHkRmi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-26_03,2024-08-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 impostorscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2408260053

On 1/1/1970 8:00 AM, wrote:
> On Fri, Aug 23, 2024 at 07:48:50PM -0700, Bart Van Assche wrote:
>> On 8/23/24 7:29 PM, Manivannan Sadhasivam wrote:
>>> What if other vendors start adding the workaround in the core driver citing GKI
>>> requirement (provided it also removes some code as you justified)? Will it be
>>> acceptable? NO.
>> It's not up to you to define new rules for upstream kernel development.
> I'm not framing new rules, but just pointing out the common practice.
>
>> Anyone is allowed to publish patches that rework kernel code, whether
>> or not the purpose of such a patch is to work around a SoC bug.
>>
> Yes, at the same time if that code deviates from the norm, then anyone can
> complain. We are all working towards making the code better.
>
>> Additionally, it has already happened that one of your colleagues
>> submitted a workaround for a SoC bug to the UFS core driver.
>>  From the description of commit 0f52fcb99ea2 ("scsi: ufs: Try to save
>> power mode change and UIC cmd completion timeout"): "This is to deal
>> with the scenario in which completion has been raised but the one
>> waiting for the completion cannot be awaken in time due to kernel
>> scheduling problem." That description makes zero sense to me. My
>> conclusion from commit 0f52fcb99ea2 is that it is a workaround for a
>> bug in a UFS host controller, namely that a particular UFS host
>> controller not always generates a UIC completion interrupt when it
>> should.
>>
> 0f52fcb99ea2 was submitted in 2020 before I started contributing to UFS driver
> seriously. But the description of that commit never mentioned any issue with the
> controller. It vaguely mentions 'kernel scheduling problem' which I don't know
> how to interpret. If I were looking into the code at that time, I would've
> definitely asked for clarity during the review phase.

0f52fcb99ea2 is my commit, apologize for the confusion due to poor commit msg.
What we were trying to fix was not a SoC BUG. More background for this change:
from our customer side, we used to hit corner cases where the UIC command is
sent, UFS host controller generates the UIC command completion interrupt fine,
then UIC completion IRQ handler fires and calls the complete(), however the
completion timeout error still happens. In this case, UFS, UFS host and UFS
driver are the victims. And whatever could cause this scheduling problem should
be fixed properly by the right PoC, but we thought making UFS driver robust in
this spot would be good for all of the users who may face the similar issue,
hence the change.

Thanks,
Can Guo.

>
> But there is no need to take it as an example. I can only assert the fact that
> working around the controller defect in core code when we already have quirks
> for the same purpose defeats the purpose of quirks. And it will encourage other
> people to start changing the core code in the future thus bypassing the quirks.
>
> But I'm not a maintainer of this part of the code. So I cannot definitely stop
> you from getting this patch merged. I'll leave it up to Martin to decide.
>
> - Mani
>
