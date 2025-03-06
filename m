Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD061C7017;
	Thu,  6 Mar 2025 13:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741266330; cv=none; b=uEKA53Vsus7rYKY4ceNhgR8XZWTd1tEaKEo8Qpo1ZbBzLrGOp/NGStIy54amacZmc46C1pkHS5GPuDfU2U818zghXSm+o5Evhn3UOkjwtMSvdkIZqCdTNw9fEYQkoJjyPi5tn5F3zUnFuZ2S398wvHmPkpASv3xllWyS6Qp0i/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741266330; c=relaxed/simple;
	bh=oit9iCVAzl6xEfiY9pN3rkfZVdyzGi35uF91jaISyAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=KjCVXXo6TgU5sjd9FmWMwFQdyT+76JrnK7Yp3EAedPLPq7qbiDB3XEdcSFshtmjJ/EnviemyfULZuZdutW05IK1ra3GAzvQSTvaT/NWK3W8C2bWnj1nXpoSP4bh6XPzQzSuEHMCVYl7ZVSVAT9xi2RKSETmmVW4fMRnyZLFF9LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=S2JvZ7Zx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="S2JvZ7Zx"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 526B3jOd032047;
	Thu, 6 Mar 2025 13:05:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WBCgeeBjBpJkcmcOMtnpiqIKOmDFRnl5pP0rLltg67E=; b=S2JvZ7ZxxqDLZZpq
	QTSuaFoOrZ1CPMnvcTXrPl3TvRIXcN3hnVsCOjxn163+g0d2X2QZ3sWzE66+0lX7
	Cx5aVVovS96ZTkKKIll4DqJd/jWixDNSpaMH1qXgiLeH2+nORzlK3msphISKdju3
	Jd5Sf2RtcOK4lYXRaXSh91pup9t1aO5xjN5FXSSsAsvqkqQDUWJ4GRfhGQDjUgwM
	r63+WeNdbENT+RaF56Wqy2p+WWk8bJ3RKgRaLxstK1ONC04m7yXcdnW5xtB+1d4u
	6TO+SV9IaVnyMF0bvRaPpWuovLViMEkbF98b/U5PyJ6igTIAmTZAsefXmX1Y1de7
	Y+3GMQ==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 457aghgcp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Mar 2025 13:05:12 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 526D5BeQ020402
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 6 Mar 2025 13:05:12 GMT
Received: from [10.253.35.155] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 6 Mar 2025
 05:05:08 -0800
Message-ID: <c3f0d284-07d8-42a2-85d0-f4023b9b6bbc@quicinc.com>
Date: Thu, 6 Mar 2025 21:04:41 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: bsg: Add hibern8 enter/exit to
 ufshcd_send_bsg_uic_cmd
To: Bean Huo <huobean@gmail.com>,
        Arthur Simchaev
	<arthur.simchaev@sandisk.com>,
        <martin.petersen@oracle.com>, <quic_mapa@quicinc.com>
CC: <avri.altman@sandisk.com>, <Avi.Shchislowski@sandisk.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bvanassche@acm.org>
References: <20250304114652.210395-1-arthur.simchaev@sandisk.com>
 <bd2e01d8b33413655a4215221c910eaf2cdf6461.camel@gmail.com>
Content-Language: en-US
From: Can Guo <quic_cang@quicinc.com>
In-Reply-To: <bd2e01d8b33413655a4215221c910eaf2cdf6461.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: IA1v9K4Lx4Uzjc5inQvHoUOa9fUoyOUO
X-Authority-Analysis: v=2.4 cv=R5D5GcRX c=1 sm=1 tr=0 ts=67c99d88 cx=c_pps a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=askNAfbZAAAA:8
 a=InJrZTXqAAAA:8 a=0k5qN4xF1ULUk8dre8gA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=7Vq0anFIkUTOnIa2TtOZ:22 a=WwJ7OKCui7YMbFU4sWpb:22
X-Proofpoint-GUID: IA1v9K4Lx4Uzjc5inQvHoUOa9fUoyOUO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-06_05,2025-03-06_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 priorityscore=1501 clxscore=1011
 spamscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2503060099

Hi Arthur,

On 3/6/2025 8:50 PM, Bean Huo wrote:
> Arthur,
>
> At present, we lack a user-space tool to initiate eye monitor
> measurements. Additionally, opening a channel for users in user land to
> send MP commands seems unsafe.
>
>
> Kind regards,
> Bean
>
> On Tue, 2025-03-04 at 13:46 +0200, Arthur Simchaev wrote:
>> Eye monitor measurement functionality was added to the M-PHY v5
>> specification. The measurement of the eye monitor signal for the UFS
>> device begins when the link enters the hibernate state.
>> Hence, allow user-layer applications the capability to send the
>> hibern8
>> enter command through the BSG framework. For completion, allow the
>> sibling functionality of hibern8 exit as well.
>>
>> Signed-off-by: Arthur Simchaev <arthur.simchaev@sandisk.com>
>> ---
>>   drivers/ufs/core/ufshcd.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 4e1e214fc5a2..546ab557a77c 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -4366,6 +4366,16 @@ int ufshcd_send_bsg_uic_cmd(struct ufs_hba
>> *hba, struct uic_command *uic_cmd)
>>                  goto out;
>>          }
>>   
>> +       if (uic_cmd->command == UIC_CMD_DME_HIBER_ENTER) {
>> +               ret = ufshcd_uic_hibern8_enter(hba);
>> +               goto out;
>> +       }
>> +
>> +       if (uic_cmd->command == UIC_CMD_DME_HIBER_EXIT) {
>> +               ret = ufshcd_uic_hibern8_exit(hba);
>> +               goto out;
>> +       }
>> +
>>          mutex_lock(&hba->uic_cmd_mutex);
>>          ufshcd_add_delay_before_dme_cmd(hba);
>>   
>> --
>> 2.34.1
I can understand that you want to use hibern8 enter&exit to trigger a 
RCT to kick start the EOM,
however there is a better/simpler way to do so: you can trigger a power 
mode change to the
same power mode (e.g., from HS-G5 to HS-G5) to trigger a RCT (without 
invoking hibern8 enter&exit)
from user layer by dme_set(PA_PWRMODE).

FYI, we have open-sourced Qcom's EOM tool in GitHub and validated the 
EOM function on most
UFS4.x devices from UFS vendors, you can find the code for your reference:
https://github.com/quic/ufs-tools/blob/main/ufs-cli/ufs_eom.c#L266

The recent change from Ziqi Chen is to serve the power mode change 
purpose I mentioned above:
https://lore.kernel.org/all/20241212144248.990103107@linuxfoudation.org/

Hope above info can help you.

Thanks,
Can Guo.
