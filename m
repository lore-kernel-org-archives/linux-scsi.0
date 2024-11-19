Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D991AA1E3;
	Tue, 19 Nov 2024 08:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732006378; cv=none; b=a309I1+TAXOMiIH4Zs00DLGTT3IsWs791NiuSdFN4ugqlOEjNwmwZI+BsXLu/tQ7u8G75Duyh/uWLulRWqdsa4UBXSyuc+U33gtyEpnm2nT6EYQqIS92zDvxSgTbIYvsQp8dMVsk7p53hB6ytNup4Y/C+fWX2q1km5bD/FGTB1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732006378; c=relaxed/simple;
	bh=f1YOiiMABFHOzZDVuOESLyzocQBXaZ2MX3CikrW+07Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=VtR6F0esKtUefDbwJ7lr0wVHegllMC1e+n4gHC6DqbGdobzY6+ManFyaFxVJiF8+6Kl36vlfvCjDP/sRWDE6hm7aGLYMV/bytn090gphjh11nkr2P6RaVTxHbKj8AikI4Pf4uy7WkTd25D+yPC/9HkKarIDWGgkJ/FZYN39la24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Q0/yxc5s; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Q0/yxc5s"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJ7XlkL030145;
	Tue, 19 Nov 2024 08:52:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZBJ/c+hKm/UDgiMMFoDCX9YfhZzdwI2Bvc/bPb89la0=; b=Q0/yxc5sOwhEuUOr
	sIOf8kilHqSBBcBgFu9QBPylKqKUOqtpAg/YfKRHAUUXsZanhlPrTC8gvHvj/yql
	62Btry3C9Xjbg/EsKb+tHHyk0fJW6GsPKsqeK8QpEAiNiP9E9D2NQ/F4s1L43gHl
	Q4p0HHGP0fORWeKdVJCN/QZI/zaJfZswQT8HNesx/SXQC4Q3zvmA5RAG6od44C0C
	DUPIsEyDchHDj5o4GmfLs59pS9094ZOygB7bW/mzIWiRgvzpV+gsnHFXudv9qA/+
	BNg2sBmfk/FWbHYQ0vKe52IAd6pivVwEL1KFC3C1sqQU6Wsfsu2gfiZLOs5BrdKt
	lotMPg==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4308y6a00x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 08:52:28 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 4AJ8qSF8010132
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 08:52:28 GMT
Received: from [10.239.155.136] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 19 Nov
 2024 00:52:23 -0800
Message-ID: <eb9fd0fd-6701-478c-a697-9453d97d604e@quicinc.com>
Date: Tue, 19 Nov 2024 16:52:21 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for UFS
 BSG
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "quic_rampraka@quicinc.com" <quic_rampraka@quicinc.com>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
        "beanhuo@micron.com"
	<beanhuo@micron.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "quic_asutoshd@quicinc.com"
	<quic_asutoshd@quicinc.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>,
        "junwoo80.lee@samsung.com"
	<junwoo80.lee@samsung.com>,
        "mani@kernel.org" <mani@kernel.org>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dlemoal@kernel.org" <dlemoal@kernel.org>,
        "ahalaney@redhat.com"
	<ahalaney@redhat.com>,
        "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
        "hare@suse.de" <hare@suse.de>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>,
        "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>,
        "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
References: <20241113111409.935032-1-quic_ziqichen@quicinc.com>
 <d3461ef552047db3e18cf3d222163ee685e13d9f.camel@mediatek.com>
Content-Language: en-US
From: Ziqi Chen <quic_ziqichen@quicinc.com>
In-Reply-To: <d3461ef552047db3e18cf3d222163ee685e13d9f.camel@mediatek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: kkrOzmUT-fury1R0nEHOG36jkH1veegm
X-Proofpoint-GUID: kkrOzmUT-fury1R0nEHOG36jkH1veegm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 adultscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411190063

Hi Peter,

Thank you for your comment. We also recognize that the H8 Enter/Exit has 
the same issue. In fact, we have tried to add the H8 command before. 
Unfortunately, the situation with Hibern8 is complex, there are a lot of 
status checks, and some vendors have their own sequence that is 
implemented in their vendor driver by Vops. Simply including the H8 
command here would cause other issues since the vendor sequence for H8 
enter/exit is required. If we add the full sequence here, the code will 
be bloated. We haven’t come up with a good solution for the Hibern8 
situation yet. However, whether we include the H8 command or not, the 
above issue is present as well (directly call ufshcd_send_uic_cmd() via 
BSG framework).
Right now, we have tested the PA_PWRMODE case and confirmed that it 
works, so we want to quickly resolve the PA_PWRMODE issue to unblock our 
customers’ urgent cases first. As for the Hibern8 situation, we have 
plan to fix it but we want to fix it afterward, in a separated change. 
If you have any good suggestions, we can discuss separately.

BRs,
Ziqi

On 11/19/2024 2:40 PM, Peter Wang (王信友) wrote:
> On Wed, 2024-11-13 at 19:14 +0800, Ziqi Chen wrote:
> 
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index e338867bc96c..c01f4b0c1b4f 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -4319,6 +4319,42 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba
>> *hba, struct uic_command *cmd)
>>          return ret;
>>   }
>>
>> +/**
>> + * ufshcd_send_bsg_uic_cmd - Send UIC commands requested via BSG
>> layer and retrieve the result
>> + * @hba: per adapter instance
>> + * @uic_cmd: UIC command
>> + *
>> + * Return: 0 only if success.
>> + */
>> +int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command
>> *uic_cmd)
>> +{
>> +       int ret;
>> +
>> +       if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
>> +               return 0;
>> +
>> +       ufshcd_hold(hba);
>> +
>> +       if (uic_cmd->argument1 == UIC_ARG_MIB(PA_PWRMODE) &&
>> +           uic_cmd->command == UIC_CMD_DME_SET) {
>>
> 
> Hi Ziqi,
> 
> Should we also check if uic_cmd->command == UIC_CMD_DME_HIBER_ENTER
> or UIC_CMD_DME_HIBER_EXIT?
> 
> Thanks
> Peter
> 
> 
> 
>> +               ret = ufshcd_uic_pwr_ctrl(hba, uic_cmd);
>> +               goto out;
>> +       }
>> +
>> +       mutex_lock(&hba->uic_cmd_mutex);
>> +       ufshcd_add_delay_before_dme_cmd(hba);
>> +
>> +       ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
>> +       if (!ret)
>> +               ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
>> +
>> +       mutex_unlock(&hba->uic_cmd_mutex);
>> +
>> +out:
>> +       ufshcd_release(hba);
>> +       return ret;
>> +}
>> +
>>   /**
>>    * ufshcd_uic_change_pwr_mode - Perform the UIC power mode chage
>>    *                             using DME_SET primitives.
>> --
>> 2.34.1
>>
