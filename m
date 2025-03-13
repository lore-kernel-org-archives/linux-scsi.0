Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634851F4C83;
	Thu, 13 Mar 2025 21:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741901805; cv=none; b=c9aDN1t3Q1J9wBY3pm9TpyBPYX0VQzA2CEqXVXyMACPoIBk7/7AmPNGSmvuhSe0AG75UscVuOeIj+OyO22vfWMNVRufBon/gCrWgiaBqI2WwTieqV7OIGRL0MGw2Mb+4LC4bNYPjJe04SNgNeTk0Hi4Ws9/q0ZA17f4toX7uj/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741901805; c=relaxed/simple;
	bh=Eqs8bJGp0lv40lbgYhiTihiy4TfvnfAjF88TY/Ar27w=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BInFkyqC0OGHbGmjidmb7v7UYYP+okeZDr/xYmFqxfMKz6zSRqk6EFep1ObdtOFH9FMFBqSoMXOzPZBu3q6nQ9tMkallR+nhPbpVVrB28NGZigZD/mVqXfZ0yzUq1hcBqgvAHp/EdN2bYOkblJDePXCsVhq/ug0FNhMu/Y1OYSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=fGn7IIyi; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="fGn7IIyi"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DH6THf019717;
	Thu, 13 Mar 2025 21:36:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vKC2yzbG9UebsJ1VbEFgVRutkTrHq8RK6afAmCBtcMs=; b=fGn7IIyicUiVyiUr
	av9A8XC/1OI+OddxR1ryC3iXOVQOOK8Q6XdZlYb5Lwz7aCMmwBwXX/6cCIPgVlsw
	kGHg0ynn4vxD/cyw67i3E9OBFTb2WyVHdoSADkW4PT04yvSML5SEbuabWC8JvRA0
	u8zTupEUcdK1OrieAbu83Ke/hE79UO4GLKbl9vC9e7yJU2H9xzT9Z9O/4ldKvJLa
	Fjrm4g1tXYL8Fjtyfidj3tBXs+ZL+923mxQ0/DhGPoeJA+zzmHL1ArfR8aaw9MZz
	HNH85ZlOeFYcVdzOPeKjwX9cvtn3S7I4x29qgri78yaoHVuE85K000NQ7Gkuc2+e
	vgyjXg==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45bts0j9er-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 21:36:16 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 52DLaF6Q009365
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 21:36:15 GMT
Received: from [10.46.162.103] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 13 Mar
 2025 14:36:14 -0700
Message-ID: <4c83f8c3-6cfd-81a0-afeb-3e8854fa1efc@quicinc.com>
Date: Thu, 13 Mar 2025 14:36:14 -0700
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
To: Bart Van Assche <bvanassche@acm.org>, <quic_cang@quicinc.com>,
        <quic_nitirawa@quicinc.com>, <avri.altman@wdc.com>,
        <peter.wang@mediatek.com>, <manivannan.sadhasivam@linaro.org>,
        <minwoo.im@samsung.com>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Bean Huo
	<beanhuo@micron.com>, Ziqi Chen <quic_ziqichen@quicinc.com>,
        Keoseong Park
	<keosung.park@samsung.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        Al Viro
	<viro@zeniv.linux.org.uk>, Eric Biggers <ebiggers@google.com>,
        open list
	<linux-kernel@vger.kernel.org>
References: <772730b9a036a33bebc27cb854576a012e76ca91.1741282081.git.quic_nguyenb@quicinc.com>
 <41678800-470f-4ea2-802c-f9f4d21817f6@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <41678800-470f-4ea2-802c-f9f4d21817f6@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: Q0afexFiAYp-Gn5hVVujUtAR5GRi8940
X-Authority-Analysis: v=2.4 cv=DNSP4zNb c=1 sm=1 tr=0 ts=67d34fd0 cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=COk6AnOGAAAA:8 a=ChCBPZhDfTThoWy9I0sA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: Q0afexFiAYp-Gn5hVVujUtAR5GRi8940
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_10,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 spamscore=0 bulkscore=0 impostorscore=0
 suspectscore=0 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503130166

On 3/13/2025 11:14 AM, Bart Van Assche wrote:
> On 3/6/25 9:31 AM, Bao D. Nguyen wrote:
>> +What:        /sys/bus/platform/drivers/ufshcd/*/device_lvl_exception
>> +What:        /sys/bus/platform/devices/*.ufs/device_lvl_exception
>> +Date:        March 2025
>> +Contact:    Bao D. Nguyen <quic_nguyenb@quicinc.com>
>> +Description:
>> +        The device_lvl_exception is a counter indicating the number
>> +        of times the device level exceptions have occurred since the
>> +        last time this variable is reset. Read the 
>> device_lvl_exception_id
>> +        sysfs node to know more information about the exception.
>> +        The file is read only.
> 
> Shouldn't this sysfs attribute have a "_count" suffix to make it clear
> that it represents a count?
Thank you, Bart. I agree. Will make the change.

> 
> Additionally, here and below, please change "file" into "attribute".
> 
>> +What:        /sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id
>> +What:        /sys/bus/platform/devices/*.ufs/device_lvl_exception_id
>> +Date:        March 2025
>> +Contact:    Bao D. Nguyen <quic_nguyenb@quicinc.com>
>> +Description:
>> +        Reading the device_lvl_exception_id returns the device JEDEC
>> +        standard's qDeviceLevelExceptionID attribute. The definition 
>> of the
>> +        qDeviceLevelExceptionID is the ufs device vendor specific 
>> design.
>> +        Refer to the device manufacturer datasheet for more information
>> +        on the meaning of the qDeviceLevelExceptionID attribute value.
>> +        The file is read only.
> 
> I'm not sure it is useful to export vendor-specific information to
> sysfs.
Because each ufs vendor defines the data differently according to the 
device spec, we probably can't have a defined handling on this event in 
the kernel. For some applications such as automobile, the information is 
useful. If you have suggestions for the user applications to access this 
data, I am all ears.

> 
>> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
>> index 90b5ab6..0248288a 100644
>> --- a/drivers/ufs/core/ufs-sysfs.c
>> +++ b/drivers/ufs/core/ufs-sysfs.c
>> @@ -466,6 +466,56 @@ static ssize_t critical_health_show(struct device 
>> *dev,
>>       return sysfs_emit(buf, "%d\n", hba->critical_health_count);
>>   }
>> +static ssize_t device_lvl_exception_show(struct device *dev,
>> +                     struct device_attribute *attr,
>> +                     char *buf)
>> +{
>> +    struct ufs_hba *hba = dev_get_drvdata(dev);
>> +
>> +    if (hba->dev_info.wspecversion < 0x410)
>> +        return -EOPNOTSUPP;
>> +
>> +    return sysfs_emit(buf, "%u\n", hba->dev_lvl_exception_count);
>> +}
> 
> The preferred approach for sysfs attributes that are not supported is to 
> make these invisible rather than returning an error code.I was thinking it would be useful for the user application to know the 
ufs device does not support this feature, so that it would not keep 
trying to read the data.

> 
>> +static ssize_t device_lvl_exception_id_show(struct device *dev,
>> +                        struct device_attribute *attr,
>> +                        char *buf)
>> +{
>> +    struct ufs_hba *hba = dev_get_drvdata(dev);
>> +    u64 exception_id;
>> +    int err;
>> +
>> +    ufshcd_rpm_get_sync(hba);
>> +    err = ufshcd_read_device_lvl_exception_id(hba, &exception_id);
>> +    ufshcd_rpm_put_sync(hba);
>> +
>> +    if (err)
>> +        return err;
>> +
>> +    hba->dev_lvl_exception_id = exception_id;
>> +    return sysfs_emit(buf, "%llu\n", exception_id);
>> +}
> 
> Just like device_lvl_exception, this attribute shouldn't be visible if
> device level exceptions are not supported.
Same reasoning, to inform the user application the feature is not 
supported so that it does not keep trying.

> 
>> +    if (status & hba->ee_drv_mask & MASK_EE_DEV_LVL_EXCEPTION) {
>> +        hba->dev_lvl_exception_count++;
>> +        sysfs_notify(&hba->dev->kobj, NULL, "device_lvl_exception");
>> +    }
> 
> sysfs_notify() may sleep and hence must not be called from an interrupt
> handler.
I will look into this.

Thanks, Bao

> 
> Thanks,
> 
> Bart.

