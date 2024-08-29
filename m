Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5D218FC7E;
	Thu, 29 Aug 2024 12:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724933676; cv=none; b=R5VTpBdmXM48kp2Hv8TJNKYktbvl0J+yy1ksjwOBYe4l/FyyWqo/0EFjsnLXpVr70pAeJtSav3IujUvAVyUxdETLGEqurF/xnlK3OkASrZ01b4SgWRFH0y76RKLqNB3riZ+85Srp7eUXn6J0hkizCS6vAmCiOctZwhO2019R1cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724933676; c=relaxed/simple;
	bh=jPa/Do411f1dm8Duft5PmzkJ1D4bPLdqlEzRXwXvOsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=rLAzMoIZxVTJINC9DltzQq4OdKnHcObqwsUsqH1X7/qV+Vj3VdUdvNRu6/RQimVdQl2Dxxd8ixyWDJ37WuJavKkTmhy8Mk3WYhY97rOfkhmzdpOBX9k+s9XVzrcnlHco5EiNWRgy1mVo0S/IiOTLTmU0KJsxdOBTJjxONvITCTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=g7hms1aU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="g7hms1aU"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47T8HlB7031817;
	Thu, 29 Aug 2024 12:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZCs/XIqluJ8ropdFPNCiOktm7PkEOs5nD4/Lq5NEpUs=; b=g7hms1aUTGijl+B9
	jU5bpMLSsNiQk9eTgirTE6XnoW3q7VHYgTFiV3HSWPFyjWkiUXuAd5Qb++QxtSMn
	jHZsdXnAULM61ZK9uP2cWfTDHN9jTUYnwk8+Y8zjeWeeyo46IBk/NgUBnYq0m2nf
	Nh4fKBYyyLuifUtKjXunoo6hlHwSRQxO2r6nY5kLA4wHSAa6NNqe1rIaQlg4rkRY
	CWrH52y8EnumHS0Kd6gvAZ7LyJ/ZqFcOnTOqNB1iVe35ASQ1AH9hsYfk4yMylucR
	4aEadWKhDCjR3DMFqp4GeWfC9CM4qxA4MD7Qym+ZFrlz1HgEo4PJHYrm5onxpLXO
	tj2fHg==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 419puw576s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Aug 2024 12:14:28 +0000 (GMT)
Received: from nasanex01c.na.qualcomm.com (nasanex01c.na.qualcomm.com [10.45.79.139])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47TCERn7025457
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Aug 2024 12:14:27 GMT
Received: from [10.217.217.229] (10.80.80.8) by nasanex01c.na.qualcomm.com
 (10.45.79.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 29 Aug
 2024 05:14:24 -0700
Message-ID: <f0b62279-b4b6-4cb3-a808-fcd170a384eb@quicinc.com>
Date: Thu, 29 Aug 2024 17:44:21 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] scsi: ufs: qcom: update MODE_MAX cfg_bw value
Content-Language: en-US
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <quic_nitirawa@quicinc.com>, <quic_bhaskarv@quicinc.com>,
        <quic_narepall@quicinc.com>, <quic_rampraka@quicinc.com>,
        <quic_cang@quicinc.com>, <quic_nguyenb@quicinc.com>
References: <20240828132526.25719-1-quic_mapa@quicinc.com>
 <20240828133132.zqozjegmbnwa7byb@thinkpad>
From: MANISH PANDEY <quic_mapa@quicinc.com>
In-Reply-To: <20240828133132.zqozjegmbnwa7byb@thinkpad>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01c.na.qualcomm.com (10.45.79.139)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: SSifZb7m3C43k-OdoAHsZE-SaccaD8rG
X-Proofpoint-GUID: SSifZb7m3C43k-OdoAHsZE-SaccaD8rG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 spamscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2408290086


On 8/28/2024 7:01 PM, Manivannan Sadhasivam wrote:
> On Wed, Aug 28, 2024 at 06:55:26PM +0530, Manish Pandey wrote:
>> The cfg_bw value for max mode was incorrect for the Qualcomm SoC.
> 
> What do you mean by 'incorrect'? I extracted the value from downstream DTs. So
> it cannot be incorrect.
> 
> If you want to update it, please clearly provide the reason.

Hi Mani,

 From the snip from commit message
"The bandwidth values defined in ufs_qcom_bw_table struct are taken from
Qcom downstream vendor devicetree source and are calculated as per the
UFS3.1 Spec."

we have UFS 4.x devices, and ufs_qcom_bw_table is already updated with 
Gear 5 support (8db8f6ce556a - "scsi: ufs: qcom: Add missing 
interconnect bandwidth values for Gear 5"). So the max cfg_bw is not 
updated.

Also for UFS 3.x devices,
[MODE_HS_RB][UFS_HS_G3][UFS_LANE_2] = { 1492582,        204800 },
[MODE_HS_RB][UFS_HS_G4][UFS_LANE_2] = { 2915200,        409600 },
[MODE_MAX][0][0]                    = { 7643136,        307200 },

Please have a look for current max mode value(307200), it is even less 
than UFS_HS_G4 (409600). So it should be updated.


> And if this patch is addressing an issue, then a Fixes tag should be present. If
> you want to get it backported (if it is a critical fix), then stable list should
> be CCed.
> 
> - Mani
> 
My bad.. will update the patch.
also yes, we need it to be backported, i should cc add stable list.
Thanks for guidance.

>> Update it to the correct value for cfg_bw max mode.
>>
>> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
>> ---
>>   drivers/ufs/host/ufs-qcom.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index c87fdc849c62..ecdfff2456e3 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -93,7 +93,7 @@ static const struct __ufs_qcom_bw_table {
>>   	[MODE_HS_RB][UFS_HS_G3][UFS_LANE_2] = { 1492582,	204800 },
>>   	[MODE_HS_RB][UFS_HS_G4][UFS_LANE_2] = { 2915200,	409600 },
>>   	[MODE_HS_RB][UFS_HS_G5][UFS_LANE_2] = { 5836800,	819200 },
>> -	[MODE_MAX][0][0]		    = { 7643136,	307200 },
>> +	[MODE_MAX][0][0]		    = { 7643136,	819200 },
>>   };
>>   
>>   static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);
>> -- 
>> 2.17.1
>>
> 
