Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D465D150981;
	Tue, 19 Nov 2024 06:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731996738; cv=none; b=Q6thAsBv5IVz6AEmV6zkZfVh5nhCkWp+o6g+xX052Kdh1oLgfOD2+F2BD1wJ+eDhV2zADvtqWcuOj7jP/Mys7HC118cacpFIxO/SYS7FtICQURv9U7Mi9YszZq9JUCoDxRByN2c643OHCY1iVRGLCsNhoGOBvGGcbtoiJEsgCB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731996738; c=relaxed/simple;
	bh=WU71AvLVwpj+83UBdTdsQIQ5kLcwJwB3U1bCNR2uns0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Yq0u/teYnAJNmHcbOo9nsCRtuWYgJMbkr6Y/849MDDD0T4+qXhwlvTLq54UZ5MA2IUT/MxYBorwtFUYmzlKw+alOkgiLGWOoeKrPE74KAbfZElesmeb5Our+krMs3gDAmR9t6eQ8CQWjOnC4UEJ/7OpdjLFHB1Un2KhxKAIHwY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Huz0hV8w; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Huz0hV8w"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AIGHJx2028646;
	Tue, 19 Nov 2024 06:11:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xvYVmZOoIIjRRxYgM7b2v+AV5vLL9ebGAIWkoSYIx9c=; b=Huz0hV8wcQSO2lKM
	urToKNwrYOKRJpbKbc+aFfw3iwdrSZAW4F0NiqG3gZBOR02AYPR+T2qY+75uvM4e
	o6gEmEvDpCN2QvDXv2lqiEP6KlSyfjIUm128slAK0tjBtUJNL0Ou47bz/hnd1+5S
	uOWEo9n8z3X/20qyAYNEUNPEQgVp1Xs8nmvCRDyvcTnTdu2EfKsOUBqXDqitIdVf
	u50GTvoXgET/rnktSu4LpCREfXKeq5jGQCEB/VD4FTsLa+thOg6zZo+V1FOdGI+H
	imFKWpq7bnMSBwmCa3JAwPH6oORN4KRsg+/gFcJIyTNSBv6IWU7lCJ88nGhdA7W1
	SUdAzA==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4308y6skyh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 06:11:48 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 4AJ6Bm24018051
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 06:11:48 GMT
Received: from [10.239.155.136] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 18 Nov
 2024 22:11:43 -0800
Message-ID: <7d269ee6-0b85-4f9f-93fb-08bd07b6195c@quicinc.com>
Date: Tue, 19 Nov 2024 14:11:13 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for UFS
 BSG
To: Avri Altman <Avri.Altman@wdc.com>,
        "quic_asutoshd@quicinc.com"
	<quic_asutoshd@quicinc.com>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "mani@kernel.org"
	<mani@kernel.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "junwoo80.lee@samsung.com" <junwoo80.lee@samsung.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
        "quic_rampraka@quicinc.com" <quic_rampraka@quicinc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Alim Akhtar
	<alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
        Peter Wang <peter.wang@mediatek.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Andrew Halaney
	<ahalaney@redhat.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        open list
	<linux-kernel@vger.kernel.org>
References: <20241113111409.935032-1-quic_ziqichen@quicinc.com>
 <DM6PR04MB65753A23120240123B090585FC202@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Ziqi Chen <quic_ziqichen@quicinc.com>
In-Reply-To: <DM6PR04MB65753A23120240123B090585FC202@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: sUD-njPsl_ZBwtf_gwT0OZCuO-4MfY2B
X-Proofpoint-GUID: sUD-njPsl_ZBwtf_gwT0OZCuO-4MfY2B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=659
 phishscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411190045



On 11/19/2024 2:02 PM, Avri Altman wrote:
>> User layer applications can send UIC GET/SET commands via the BSG
>> framework, and if the user layer application sends a UIC SET command to the
>> PA_PWRMODE attribute, a power mode change shall be initiated in UniPro
>> and two interrupts shall be triggered if the power mode is successfully
>> changed, i.e., UIC Command Completion interrupt and UIC Power Mode
>> interrupt.
>>
>> The current UFS BSG code calls ufshcd_send_uic_cmd() directly, with which
>> the second interrupt, i.e., UIC Power Mode interrupt, shall be treated as
>> unhandled interrupt. In addition, after the UIC command is completed, user
>> layer application has to poll UniPro and/or M-PHY state machine to confirm
>> the power mode change is finished.
>>
>> Add a new wrapper function ufshcd_send_bsg_uic_cmd() and call it from
>> ufs_bsg_request() so that if a UIC SET command is targeting the
>> PA_PWRMODE attribute it can be redirected to ufshcd_uic_pwr_ctrl().
>>
> 
> Fixes tag?
Thank Avri， will update new version to add Fixes tag.

>> Signed-off-by: Can Guo <quic_cang@quicinc.com>
>> Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
> With that fixed:
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> 
>> ---
>> V1 -> V2: Rebased on Linux 6.13
