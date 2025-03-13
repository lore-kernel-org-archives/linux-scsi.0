Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C851D63C0;
	Thu, 13 Mar 2025 21:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741900236; cv=none; b=Ydr+04Od1+tzkiiGKopKMhUV+O+3rsTTTHZC10YVUn7ZMMqyiutxlVFCYEIVCP0eQqObDXAsWG+x44btATPYmB+JSLxs1/LvZR8vtNa4NJvcrOVss+uRNC81/o2R4voDTepc3vbnDdvbrRm8EAwiRUjx2fA5kRSEC7K8zJkVZGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741900236; c=relaxed/simple;
	bh=ROM3SdFIzgvkI1IS6srM22blKUbcX+5wtdU4dr8hSI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=LqpMBvJGlxoeP1CLRGhkFWUvOiVNe0TIvpp/ni9O/2pt1DCGPlw6zWcNAHhZmQm6hYyNboYjNNxmCz7y4uTzTBKhQDculZPTLcEk9JWD28DZJ3W1jdaac/BpPWTEajsiNIl6vpMyDmFbzbBgeEtjSpKtaW3Tfjsx+2ikyL+EhC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=ReEIlaHG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="ReEIlaHG"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DAAW6n009842;
	Thu, 13 Mar 2025 21:09:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	A0iiiEsDajgMqBQFp2JjpICx9bPSEbZxDCtl8PcArW0=; b=ReEIlaHGHDlFxI3c
	GRteMTaOkqrj5u6hXJI1Reh9LOlmtfic1+tU+U790URJpGP4BoDZ8yKP2XlKN2tG
	cY3R5xOYJDdx2LIHSBHU1iqDyX5MAx2eUemErTOgPSPOsvVHwqE5NTFSDGvD4OE5
	pKgT6C/vbWpC8IhRhYSFMXJ2+6Ih/7qxEYHEtl+9vloUjH0tWM3xDfxTBcpBvGqA
	w08g53tJNB+V3c+cNBqY3/Ud8LJprJTb5NKBcywL3pmyZShZDrMWzQoBtact6aVi
	rGhpgup28pIPYm15AaUqt3l83gKnep+d36qMzn7Kb2gAylSgJ/n4sJOkB3IZWVbs
	18NP5w==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45au2rf5p3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 21:09:42 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 52DL9fOg009554
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 21:09:41 GMT
Received: from [10.46.162.103] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 13 Mar
 2025 14:09:40 -0700
Message-ID: <f45667a0-d629-a150-2b9f-db11f03a9833@quicinc.com>
Date: Thu, 13 Mar 2025 14:09:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v1 1/1] scsi: ufs: core: add device level exception
 support
Content-Language: en-US
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
CC: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <minwoo.im@samsung.com>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        Alim Akhtar
	<alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Bean Huo <beanhuo@micron.com>,
        "Ziqi
 Chen" <quic_ziqichen@quicinc.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Biggers <ebiggers@google.com>,
        open list <linux-kernel@vger.kernel.org>
References: <772730b9a036a33bebc27cb854576a012e76ca91.1741282081.git.quic_nguyenb@quicinc.com>
 <20250313172826.xzqkrx5rzuqpvz7j@thinkpad>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20250313172826.xzqkrx5rzuqpvz7j@thinkpad>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=D6NHKuRj c=1 sm=1 tr=0 ts=67d34996 cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=COk6AnOGAAAA:8 a=yC2W1mGafNBLVvU0_wwA:9 a=QEXdDO2ut3YA:10
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: V-EFZZvFL1VdnoHenuuF24dEpuL-G_5T
X-Proofpoint-ORIG-GUID: V-EFZZvFL1VdnoHenuuF24dEpuL-G_5T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_10,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503130163

On 3/13/2025 10:28 AM, Manivannan Sadhasivam wrote:
>> +
>> +What:		/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception
>> +What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception
>> +Date:		March 2025
>> +Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
>> +Description:
>> +		The device_lvl_exception is a counter indicating the number
>> +		of times the device level exceptions have occurred since the
>> +		last time this variable is reset. Read the device_lvl_exception_id
>> +		sysfs node to know more information about the exception.
>> +		The file is read only.
> 
> No. This attribute is RW and the write of 0 will reset the counter. Please
> change it here and also in commit message.
> 
> Also document the spec version requirement for these attributes.
> 
Thank you Mani. I will make corrections.

>> +
>> +What:		/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id
>> +What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception_id
>> +Date:		March 2025
>> +Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
>> +Description:
>> +		Reading the device_lvl_exception_id returns the device JEDEC
>> +		standard's qDeviceLevelExceptionID attribute. The definition of the
>> +		qDeviceLevelExceptionID is the ufs device vendor specific design.
>> +		Refer to the device manufacturer datasheet for more information
>> +		on the meaning of the qDeviceLevelExceptionID attribute value.
>> +		The file is read only.
>> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
>> index 90b5ab6..0248288a 100644
>> --- a/drivers/ufs/core/ufs-sysfs.c
>> +++ b/drivers/ufs/core/ufs-sysfs.c
>> @@ -466,6 +466,56 @@ static ssize_t critical_health_show(struct device *dev,
>>   	return sysfs_emit(buf, "%d\n", hba->critical_health_count);
>>   }
>>   
> 
> [...]
> 
>> +int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *exception_id)
>> +{
>> +	struct utp_upiu_query_response_v4_0 *upiu_resp;
>> +	struct ufs_query_req *request = NULL;
>> +	struct ufs_query_res *response = NULL;
>> +	int err;
>> +
>> +	if (hba->dev_info.wspecversion < 0x410)
>> +		return -EOPNOTSUPP;
>> +
>> +	ufshcd_hold(hba);
>> +	mutex_lock(&hba->dev_cmd.lock);
>> +
>> +	ufshcd_init_query(hba, &request, &response,
>> +			  UPIU_QUERY_OPCODE_READ_ATTR,
>> +			  QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID, 0, 0);
>> +
>> +	request->query_func = UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
>> +
>> +	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, QUERY_REQ_TIMEOUT);
>> +
>> +	if (err) {
>> +		dev_err(hba->dev, "%s: failed to read device level exception %d\n",
>> +			__func__, err);
>> +		goto out;
>> +	}
>> +
>> +	upiu_resp = (struct utp_upiu_query_response_v4_0 *)response;
>> +	*exception_id = get_unaligned_be64(&upiu_resp->value);
>> +
>> +out:
>> +	mutex_unlock(&hba->dev_cmd.lock);
>> +	ufshcd_release(hba);
>> +
>> +	return err;
>> +}
>> +EXPORT_SYMBOL_GPL(ufshcd_read_device_lvl_exception_id);
> 
> There is no need to export this function.
>
I will make the correction.

> - Mani
> 

