Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C0B15A8
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 01:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724288726; cv=none; b=AdWb2E+7a3XIm5c8oMwBiPl4FwNb9POmuZmRjy0Bw2L9j7IBOEXvUowQQR2JDnQw2vLfdkQ3I/3VZPJhPgGzReU1xwqZ0jWxuqAPFsK3tMQSh3DNgtDA5WARlSGq6Ox0xv2QSPpv1NEGZkyfR5RIDLfvJeL/EUROUDTounmtIzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724288726; c=relaxed/simple;
	bh=SW8a43227cpwCYxg0/mk/IReiiAQGOwJ9urYccX+mFY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=A9WRa2hcZD83nXQEtcAPEdnVQCf9L2gBNZJk2YRvfbixQKWjo931fdwyTUUtSqDLSwazbXv3Z95j44bfaZ5r/R0OSjFmNxXg3pTefuz0uiUoFmEbo8recxNN3ynMgxpv3iM/GvGkFy2r4TxT3rgZqoz1rHn2gjUROalyOJIZvAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=NWQefgBn; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="NWQefgBn"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47M12J1l030621;
	Thu, 22 Aug 2024 01:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+CEv+pAUegxPLmDjN9hxrYMyCLYk/NOhrFH0DX5eMQA=; b=NWQefgBn1PePhoOk
	NuhFNm4UepdDdDmYRmqOzx/67M0BOxUTEpw7/HJwPuV3vkfUMkpuGuJgmnfIPNI7
	5G13FvzPpHRJClTVX1yzByFS1hFiJwWxZwkJL1xj6PJaqi8C7T96w60sQD2fnjTr
	vMbfrR/E9khN+DfPK/dOte4Qsern7jUXa+JIsbBrwMaAbx1R+CXN6LpPtAzynYbZ
	jmBmpdVCIfwJp7v4rK88ZIw7sndJzN3a2f7ODwW0T0NCk2Q46kOOlfnteAmpfVoR
	RsbCn5Y3L96b5AAvQZ2U9AzXuyP+oHrX41P0pTIfBvC4W4Uar3tRCUTmkq2WCkJo
	ji20lw==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 414pdmeab9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Aug 2024 01:05:04 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47M151QL018762
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Aug 2024 01:05:01 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 21 Aug
 2024 18:05:01 -0700
Message-ID: <6fceba57-e1f6-e76b-94f3-1684c1fe6e98@quicinc.com>
Date: Wed, 21 Aug 2024 18:05:00 -0700
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
        "Andrew Halaney" <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
        Alim
 Akhtar <alim.akhtar@samsung.com>,
        Eric Biggers <ebiggers@google.com>, Minwoo
 Im <minwoo.im@samsung.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <41e5ed21-8ea6-3a4c-2f25-922458593f38@quicinc.com>
 <6e8df17b-320e-4bfc-a0be-c7918b0263d4@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <6e8df17b-320e-4bfc-a0be-c7918b0263d4@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: --J3ayibEbUVOXvDJ_sPQZMi08G2gM0C
X-Proofpoint-ORIG-GUID: --J3ayibEbUVOXvDJ_sPQZMi08G2gM0C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-21_17,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501 mlxscore=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2408220006

On 8/21/2024 5:14 PM, Bart Van Assche wrote:
> On 8/21/24 4:26 PM, Bao D. Nguyen wrote:
>> On 8/21/2024 11:29 AM, Bart Van Assche wrote:
>>> Accessing a host controller register after the host controller has
>>> entered the hibernation state may cause the host controller to exit the
>>> hibernation state. Hence rework the hibernation entry code such that it
>>> does not modify the interrupt enabled status. Bart,
>  >
>> I am not clear on the offending condition, particularly the term 
>> "hibernation" used in this context. In the function 
>> ufshcd_uic_pwr_ctrl() where you are making the change, the host 
>> controller is fully active at this point, right?
>> Please help me clarify the issue.
> 
> Hi Bao,
> 
> Isn't "hibernation" terminology that comes from the M-PHY standard?
> See also the DME_HIBERNATE_ENTER and DME_HIBERNATE_EXIT constants in
> the UFSHCI driver source code. Please let me know if you need more
> information.

I see. Thanks Bart.
If I understand correctly, the link is hibernated because we had a 
successful ufshcd_uic_hibern8_enter() earlier. Then the 
ufshcd_uic_pwr_ctrl() is invoked probably from a power mode change 
command? (a callstack would be helpful in this case).
Anyway, accessing the UFSHCI host controller registers space somehow 
affected the M-PHY link state? If my understanding is correct, it seems 
like a hardware issue that we are trying to work around?

Thanks, Bao
