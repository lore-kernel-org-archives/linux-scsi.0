Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AD7258CD9
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 22:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764801684; cv=none; b=A+pBQRiTOkXCiXRni62/XNZOf/S9BhWT+zq4zMqxCm8JnCOhoG0l2xfjRsLwJHI4pDugcxUsQadOFU6Ln/mqwLA4pXMJ8Y/vxceTELYVF/5Rs0Adm2KbgLYJ16Ygy+dEOd/TsMDhbWq9Wo0KlFN4h6GqAjRAq4xnGdT5ThZFVEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764801684; c=relaxed/simple;
	bh=i/djBuwJ5x46mSXkx2STKL87N4CQpWwCemFLarAbgcM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=lH6C/ph+5MG3Z/id/8o4tO5A0nPUiw+vZporgjO0R4FqnZSZ0PfORhRpLiXU8g6BQNI6QfehJ0ggROh3+YPM5cUuWPKW8ywZl3tcaXCmZQTipefWTdkLNvHsSnaip8fmFKNr9v16q5fNYQBDMnPkzjronelJUXGPt1ATmLTqrYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=fGvXRe4b; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="fGvXRe4b"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B3BReH31968464;
	Wed, 3 Dec 2025 22:41:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/nc4Kd8OHpYLPJe+eUb6LKqge/psEnl/OhRP3iZtT9Q=; b=fGvXRe4bMvvXcDNB
	EOizHdPqPV9TvX3Rxj/0EnO7ypeL5kyL968MkenfcXY+19qYsMyzV4EUzbsMRoQ4
	T99g2yWv2EC3J/EdJDPN7q47/YQV1CdKGKEtz8Es7H7hJIGJmFtmXcDqioKFAjjc
	DQ6I/nXWKCLSNeObQBeWEguWd6GD5rb15sDIJluMOIKvtKyhXJLddH6WDcGdiFUg
	fwv5kbNT60d72vAId/v5yhGneyesjRtTHKpOSC2vuk5OEKi4t+W/UYSiWf4zL7tm
	5WRetJJ/SsJ8Gsz/n8eXQIoPxqX5SDWXu+jIVuHWp1cdoX+y2R1n6bQhZw+1Kb4G
	aLv8aA==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4atmbthw96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Dec 2025 22:41:02 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 5B3Mf1Wk000517
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 3 Dec 2025 22:41:01 GMT
Received: from [10.216.3.38] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 3 Dec
 2025 14:40:59 -0800
Message-ID: <014c3e26-24ea-40e3-a876-bf0336231b18@quicinc.com>
Date: Thu, 4 Dec 2025 04:10:55 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Bart Van Assche <bvanassche@acm.org>, Roger Shimizu <rosh@debian.org>
CC: Manivannan Sadhasivam <mani@kernel.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>,
        "James E.J.
 Bottomley" <James.Bottomley@hansenpartnership.com>,
        Nitin Rawat
	<nitin.rawat@oss.qualcomm.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
 <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
 <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
 <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org>
 <nso6f36ozpad36yd3dlrqoujsxcvz4znvr6snqwgxihb3uxyya@gs6vuu76n6sx>
 <5c142a9d-7b41-422a-bbff-638fda1939dc@acm.org>
 <CAEQ9gEkz=Y1ksXL0wCumb7zbqXTREqJ6Vn29P-7FWS_e=iuuVQ@mail.gmail.com>
 <84b00b56-e775-43e6-a829-85e5da43508e@acm.org>
Content-Language: en-US
From: Nitin Rawat <quic_nitirawa@quicinc.com>
In-Reply-To: <84b00b56-e775-43e6-a829-85e5da43508e@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=KNBXzVFo c=1 sm=1 tr=0 ts=6930bc7e cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=N54-gffFAAAA:8 a=VwQbUJbxAAAA:8
 a=Ac4ghYw8HGii8tCyR4UA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: eILNo3eDpLIjIdQ8yYAcoGUkVwSN06by
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAzMDE4MCBTYWx0ZWRfXx1ALJoKAay6g
 /xfrnq6svWfiR+eCP1TM5ViMghQtWoLE6lPQfja2svT83nBWiSPpjg+FE50nQmuApDg2JAwjSfx
 25MQ1512hlbshOS1azyho4FE/OKRCcvV5AOUVMVnMszeRFvRcupUduGY7XpPbHNadgc9yH3CUys
 fLEOaJ/JbLYmn7gjt9zlfJa83V93eTMI8U1TgCKknMATNqADkU5aRql3sBQmGzfof/Bw/1UAueH
 YryUxQh1vFcmrwuO2wm4cwpDvbhGvguIIJUvgZ6Q3SdBdPP7AFk3tyU4g7sL4XkkCIrkp5arlfd
 hiSRIYmje6af1k37bRl34hgKMyeaqgezVTQG+8uUfgWZa1jFbXL0Exh2bG5Opp8MwC3DPeIk4KG
 WrVTCldEAnXHvqjITdS6GO3LqUXZyQ==
X-Proofpoint-ORIG-GUID: eILNo3eDpLIjIdQ8yYAcoGUkVwSN06by
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-03_03,2025-12-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 suspectscore=0 adultscore=0 malwarescore=0
 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512030180



On 12/3/2025 11:16 AM, Bart Van Assche wrote:
> On 12/2/25 2:56 PM, Roger Shimizu wrote:
>> On Tue, Dec 2, 2025 at 8:03 AM Bart Van Assche <bvanassche@acm.org> 
>> wrote:
>>> Can you please help with the following:
>>> * Verify whether or not Martin's for-next branch boots fine on the
>>>     Qcom RB3Gen2 board (I expect this not to be the case). Martin's
>>>     Linux kernel git repository is available at
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git.
>>
>> No, same boot issue for mkp/for-next branch.
>>
>>> * If Martin's for-next branch boots fine, bisect linux-next.
>>> * If the boot hang is reproducible with Martin's for-next branch,
>>>     bisect that branch. After every bisection step, apply the patch
>>>     below to work around bisectability issues in this patch series.
>>>     If any part of that patch fails to apply, ignore the failures.
>>>     We already know that the boot hang does not occur with commit
>>>     1d0af94ffb5d ("scsi: ufs: core: Make the reserved slot a reserved
>>>     request"). There are only 35 UFS patches on Martin's for-next branch
>>>     past that commit:
>>>     $ git log 1d0af94ffb5d..mkp-scsi/for-next */ufs|grep -c ^commit
>>>     35
>>
>> First I want to clarify 1d0af94ffb5d ("scsi: ufs: core: Make the
>> reserved slot a reserved request")
>> has boot issue.
>> But applying for the debugging patch from your email, it boots fine.
>> So the bisecting start from here.
>>
>> Bisecting result is:
>> 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()") is
>> the first bad commit.
>>
>> And this commit can apply the debugging patch (below) without any 
>> conflict.
>> Hope it helps, and thank you!
> Thanks Roger for having taken the time to bisect this issue!
> Unfortunately this information is not sufficient to identify the root
> cause. This is what we can conclude from the information that has been
> shared so far:
> - The boot hang can't be caused by a ufshcd_get_dev_mgmt_cmd() hang
>    because that function specifies the flag BLK_MQ_REQ_NOWAIT. That flag
>    makes scsi_get_internal_cmd() return immediately if no reserved tag is
>    available. If scsi_get_internal_cmd() would fail, the caller would
>    emit a kernel warning. I haven't seen any kernel warnings in any of
>    the kernel logs that have been shared so far.
> - The boot hang can't be caused by a device management command timeout
>    because blk_execute_rq() is used for submitting device management
>    commands. blk_execute_rq() uses rq->timeout as timeout. Even if
>    rq->timeout wouldn't be set, the block layer would initialize that
>    timeout value. I haven't seen any data in any of the kernel logs that
>    indicates a device management request timeout.
> 
> Could anyone share the call traces produced by
> "echo w >/proc/sysrq-trigger" and also the output produced by
> "echo t >/proc/sysrq-trigge"" after having reproduced the boot hang?



Hi Bart,

With the fix shared by you , SDB mode on SM8750 works fine now but MCQ 
mode still have below error.


[    3.720396] ufshcd-qcom 1d84000.ufs: ufshcd_err_handler started; HBA 
state eh_non_fatal; powered 1; shutting down 0; saved_err = 0x4; 
saved_uic_err = 0x40; force_reset = 0
[    3.740078] Unable to handle kernel NULL pointer dereference at 
virtual address 0000000000000378
[    3.740084] Mem abort info:
[    3.740086]   ESR = 0x0000000096000006
[    3.740089]   EC = 0x25: DABT (current EL), IL = 32 bits
[    3.740092]   SET = 0, FnV = 0
[    3.740094]   EA = 0, S1PTW = 0
[    3.740096]   FSC = 0x06: level 2 translation fault
[    3.740099] Data abort info:
[    3.740100]   ISV = 0, ISS = 0x00000006, ISS2 = 0x00000000
[    3.740103]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    3.740105]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    3.740108] user pgtable: 4k pages, 48-bit VAs, pgdp=000000088f66d000
[    3.740111] [0000000000000378] pgd=080000088f66c403, 
p4d=080000088f66c403, pud=080000088f66b403, pmd=0000000000000000
[    3.740123] Internal error: Oops: 0000000096000006 [#1]  SMP

[    3.815406] CPU: 7 UID: 0 PID: 213 Comm: kworker/u32:2 Not tainted 
6.18.0-next-20251203-00001-gc131083d7359 #27 PREEMPT
[    3.918160] Hardware name: Qualcomm Technologies, Inc. SM8750 MTP (DT)
[    3.918163] Workqueue: ufs_eh_wq_0 ufshcd_err_handler
[    3.918171] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS 
BTYPE=--)
[    3.918176] pc : ufshcd_err_handler+0xac/0x9ec
[    3.918181] lr : ufshcd_err_handler+0x9c/0x9ec
[    3.918184] sp : ffff800081153d10
[    3.918186] x29: ffff800081153d50 x28: 0000000000000000 x27: 
ffff0008104508b0
[    3.918194] x26: 0000000000000000 x25: ffff000800968ac0 x24: 
ffff000801c76405
[    3.918200] x23: 0000000000000000 x22: ffff000800028000 x21: 
ffff000801c76400
[    3.918206] x20: ffffc34adec2e068 x19: ffff000810450b18 x18: 
0000000000000006
[    3.918212] x17: 0000000000000000 x16: 0000000000000000 x15: 
ffff80008115383f
[    3.918218] x14: 000000000000000e x13: 655f646368736675 x12: 
ffffc34adfee6c48
[    3.993771] x11: 0000000000000001 x10: ffff00080f7f4cc0 x9 : 
ffff0008013d6e00
[    4.001105] x8 : ffff000b7e150cc0 x7 : 0000000000000000 x6 : 
0000000000000002
[    4.008438] x5 : ffff000b7e146408 x4 : 0000000000000001 x3 : 
0000000000000000
[    4.015771] x2 : 0000000000000000 x1 : 0000000000000001 x0 : 
0000000000000378
[    4.023106] Call trace:
[    4.025629]  ufshcd_err_handler+0xac/0x9ec (P)
[    4.030207]  process_one_work+0x148/0x290
[    4.034336]  worker_thread+0x2c8/0x3e4
[    4.038192]  kthread+0x12c/0x204
[    4.041527]  ret_from_fork+0x10/0x20
[    4.045210] Code: f9402760 d503201f 910de000 52800021 (b821001f)
[    4.051474] ---[ end trace 0000000000000000 ]---
[    4.056981] scsi 0:0:0:49488: Well-known LUN    MICRON 
MT512GAYAX4U40   0100 PQ: 0 ANSI: 6


[    4.281093] devfreq 1d84000.ufs: dvfs failed with (-16) error
[    4.360921] devfreq 1d84000.ufs: dvfs failed with (-16) error
[    4.746782] devfreq 1d84000.ufs: dvfs failed with (-16) error
[    4.817093] devfreq 1d84000.ufs: dvfs failed with (-16) error
[    4.893131] devfreq 1d84000.ufs: dvfs failed with (-16) error
[    5.013146] devfreq 1d84000.ufs: dvfs failed with (-16) error
[    7.249155] devfreq 1d84000.ufs: dvfs failed with (-16) error
[    7.341071] devfreq 1d84000.ufs: dvfs failed with (-16) error


However, after switching to previous tag next-20251110 of linux-next, 
where this series of changes is not present, the issues is not seen.

Regards,
Nitin




> 
> Thanks,
> 
> Bart.
> 

