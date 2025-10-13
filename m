Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198DD19CCF5;
	Mon, 13 Oct 2025 19:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760384121; cv=none; b=CFGCoYIxApOnQqLPwwiNDW1EyWZ0X0pCvgCvznFMPMj9COPps9bL6PMPQ0o0HHyT5hjJ7j+TfgB4iTPXvxzWHZUCT681VlCx956/vIKtQAv/dxdsJ125WUvpMQEGtA5W9pFru0j53sZptD8Xlcu1EyE4cbP9siABnGFIn0U9sVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760384121; c=relaxed/simple;
	bh=sQIduPUC7SxeYOpYsiAgGAdZOovV+vri64psOQGIVJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=acmuHPYDiz6soCs9gZFba8+aOX7BTz3EIj911ZBnwzn3uoaiTRz/FhStg1Hlkm4w9tVYaherUbY8eLlV+WWSb2/+4/wMKJ+64mzAhKpgUZ63gF4icovOuScpdnuq0qd7MCqHuBNhpMzJ7V/O6L6yADXG6GpFh6ZFLzw0lLu45ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=HjFDhXYf; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="HjFDhXYf"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59DHELk7001153;
	Mon, 13 Oct 2025 19:34:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KKsg14wEQrXU/IsT8gZxTWTpSrodlzmQgWynL/QqwyM=; b=HjFDhXYfHUr+q7px
	tqD0/Zz7c3vytFA+XYl4T3kT8sPLAtSkJKwIeBYt8h0+uR4Et4Bh4NDM4OtNUBOI
	pvwtZ8YSLDCaglq1Si3eTVAlX0y2UnUtuSALqk6gLpwiEbmiHoeZIWFdLWvCzZ4o
	+8txGm3krd1plw72zFuoRDX+fNOWQiPiWtJZyX486jPa4kq51kRe2V/mfPB4f1sI
	LrGKxnjHyPZPQMLOdbnXBJlbK9zxloxIGYDgT0EZ0wiljR6RB+2gbD9+fiBuCp9p
	VyDjyP+Z64Sx3LUDXhkjmLVahujgTZOk3AX713nICX1v2MkfWrW48jWbPgHpKfEK
	225xCQ==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49qgdfwsur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Oct 2025 19:34:54 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 59DJYrZa031395
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Oct 2025 19:34:53 GMT
Received: from [10.46.162.103] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.24; Mon, 13 Oct
 2025 12:34:53 -0700
Message-ID: <ea706279-3c74-bd0e-453a-d635ca0c82d9@quicinc.com>
Date: Mon, 13 Oct 2025 12:34:53 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Replace hard coded vcc-off delay
 with a variable
Content-Language: en-US
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>,
        "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>,
        "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>,
        "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "ebiggers@kernel.org"
	<ebiggers@kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <cover.1760039554.git.quic_nguyenb@quicinc.com>
 <7df97c5bf49d7e53435725062bcff2ccd77a6959.1760039554.git.quic_nguyenb@quicinc.com>
 <714110b991f9ced2c8d496afc767d8666ad8332a.camel@mediatek.com>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <714110b991f9ced2c8d496afc767d8666ad8332a.camel@mediatek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAyNSBTYWx0ZWRfX8M0SfaSPVfNy
 pFRjCmoZaqFqF0QamdgFyfuJZY5rOEA1G0Qf10asNA4i4z05VroxarTYT6yY9e9dxl3HOMi3GEr
 y8eioXsLwkqPMcq3VtLPOlQ5MQoyvpJejqf3wmlIBMMhN/b5DfjmeqnavaE6Ma1bys7w/oKyXKg
 xDhPDFt5vCCWCkCkGzchVCHB+ESyerqfAdjEybwzpeb8LWfIdwvUNRO8Z55wHVJsZA5mfF5Mlwf
 iyvoNaRK3mz51A3JJnrSXt/WHshtwPze9XyTNwmQ/0j59JrmtgWVY6Fo6nNZjoeHk3txIjZxnPt
 SWVrKiWDodMFiqr0WQ6rorSIo+kLob7e2+OtAQU1RbM857aVMTAscpdSypIFTz71nvsuidNOffl
 Gr28laXYTbP/LMb55rCNHhhlqbZVEQ==
X-Proofpoint-GUID: 5nkJazC-KaO8Y-nYTpnbh5YxtszqiNEe
X-Proofpoint-ORIG-GUID: 5nkJazC-KaO8Y-nYTpnbh5YxtszqiNEe
X-Authority-Analysis: v=2.4 cv=J4ynLQnS c=1 sm=1 tr=0 ts=68ed545e cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10
 a=GC0PD7z2HCKrETsP624A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 bulkscore=0 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510110025

On 10/12/2025 8:58 PM, Peter Wang (王信友) wrote:
> On Thu, 2025-10-09 at 13:10 -0700, Bao D. Nguyen wrote:
>>
>> +       /*
>> +        * Most ufs devices require 1ms delay after vcc is powered
>> off before
>> +        * it can be powered on again. Set the default to 5ms. The
>> platform
>> +        * drivers can override this setting as needed.
>> +        */
>> +       hba->sleep_post_vcc_off = 5000;
>> +
>>
> 
> Hi Bao,
> 
> Since 2ms is sufficient for most devices, wouldn't it make
> sense to set the default value to 2ms?

Agree Peter. This was my preference as well.

> 
> 
>>          init_completion(&hba->dev_cmd.complete);
>>
>>          err = ufshcd_hba_init(hba);
>> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
>> index 1d39437..ad49979 100644
>> --- a/include/ufs/ufshcd.h
>> +++ b/include/ufs/ufshcd.h
>> @@ -1140,6 +1140,8 @@ struct ufs_hba {
>>          int critical_health_count;
>>          atomic_t dev_lvl_exception_count;
>>          u64 dev_lvl_exception_id;
>> +
>> +       u32 sleep_post_vcc_off;
>>
> 
> The name sleep_post_vcc_off might be misunderstood as a
> status or a flag. I suggest changing it to a more explicit
> name, such as vcc_off_delay_ms.

Sure Peter. I will make the change.

Thanks, Bao

> 
> 
> Thanks
> Peter
> 
> 

