Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1356C227BA4;
	Thu,  2 Oct 2025 19:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759431717; cv=none; b=DW6CI8dAOtEdoukrS+UuwA4yOKAOWNXq8ZTFp7stiYwAxZzHd/YH+OIBkRK0QpTLiu2vpY93dJV5T1vHvqcs7xBDcz0C8beNHXtUk+xyKqS8M7zi0OhNwpesN4Q2zbSzbYmndQbQWnNhTUSP8rPOBDEhKdVx6QOy8S88Hma3Y5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759431717; c=relaxed/simple;
	bh=BIRXcMcYlnT2qRtRS9L/KanakP3NnLg4JkabLY2BhGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=NX5I9AB92Xj2wvI/izNLw/IuKLaCjwq6vTNIvzXrqmgJz2Y6IX8Un7qgR099q/nl9wCmmu6t17eA/I2Qfmqq/JgERh5Oc0JlzHr4FCKmsI6zHZSAcsKmHhMcN8LPO7peqEG7ycbMaDARXD46KnKM0aFNUoJEr4fQoDixkH4mCxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=eIITPge2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="eIITPge2"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59291Fmp012307;
	Thu, 2 Oct 2025 19:01:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vLGcVnmGtcHtpwx437JCo2SIBkaMdI8GxLjQ7mfFOeQ=; b=eIITPge2kcJ5mlKO
	zMsGXjJCiJKVIMJ11o/n1LIpShFiEv29DwhkmPy4O5NbFoaKtBNz4zo+cw/eqH1q
	fs9fF7740sTPnFcd2OlelNAkh85IdIQqg2FxUvlUwFyQNyhvAaAoe4lJTAEaUajr
	/4KVvStD0qVrduBr44XHdMDYIjeySwuzJlNM2TeC8jjHkJHOlUJWZju09VPp9CCm
	CzkGiMNAd1j+DD4HT0Ftue4YaXeOOBonXllIoV4vx+mpI/HEr/25hk90oWbKe7eJ
	CnEYLgGSiFxeLkYypWtvdFTMoKOnhMiTJ9YINqlUu6Qlogumy7EI+y2Kkyuo2KFe
	fiRp6A==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49e80u0wq7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 19:01:07 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 592J16VH025504
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 2 Oct 2025 19:01:06 GMT
Received: from [10.46.162.103] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.24; Thu, 2 Oct
 2025 12:00:06 -0700
Message-ID: <a1eaae1e-3e10-4512-bc83-ae25eacc43d6@quicinc.com>
Date: Thu, 2 Oct 2025 12:00:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v1 2/2] scsi: ufs: core: Reduce the sleep before vcc can
 be powered on
Content-Language: en-US
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>,
        "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>,
        "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>,
        "bvanassche@acm.org"
	<bvanassche@acm.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>,
        "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <cover.1759348507.git.quic_nguyenb@quicinc.com>
 <b9467720ccabbabd6d3d230a21f9ffb24721f1ed.1759348507.git.quic_nguyenb@quicinc.com>
 <c12b15699ad8176760c220100247af15954f30d8.camel@mediatek.com>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <c12b15699ad8176760c220100247af15954f30d8.camel@mediatek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyOSBTYWx0ZWRfX1f6qDvpvBEnf
 c2A8zfmPtvwTwo3mhFEgBTL7IbuNeSMcKuontuYTzNZWdHGlXIyuY2fLb3XubqPTAADCZvTEe12
 s1MvqGOznBO0SWFl0DZWhtepHRL+3b94UzbwEAL3DLiFFH9W45UGLBQPnOf61jRZdvMO8KOOl84
 /KTiA0+jx7qDUILeDgQlrXYBFO7+KtCnpGQawyB0Otp5qsZH/9Ks+l2/pgPlZ9oPnx+yuMboXET
 NdoFFx7sa+rtyY7FoK828BJO1P9zSqxrh7jr/34ff6XV8fQyvQVsir4EEIxKV9vBj1P8jVY0/Tf
 zhSdoKpftPlXVbnxuSwQPH9urhy3SYipsVoosYSA/IZkfGlaDr/4ebGXT5LFAfcrQU0eT/7bY4W
 nhUr1cab3pjK4IT4hVYQsIR1ojYgqg==
X-Proofpoint-GUID: Kqx_AozSygtMiDlgskCLp-0VSLZNqlBe
X-Authority-Analysis: v=2.4 cv=OMkqHCaB c=1 sm=1 tr=0 ts=68decbf3 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=COk6AnOGAAAA:8
 a=S_OyvZkQoYFM77ySt2sA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=TjNXssC_j7lpFel5tvFf:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: Kqx_AozSygtMiDlgskCLp-0VSLZNqlBe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-02_07,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2509150000
 definitions=main-2509270029

On 10/2/2025 12:59 AM, Peter Wang (王信友) wrote:
> On Wed, 2025-10-01 at 13:57 -0700, Bao D. Nguyen wrote:
>>
>> After the ufs device vcc is powered off, all the ufs device
>> manufacturers require a minimum of 1ms of power-off time before
>> vcc can be powered on again. This requirement has been verified
>> with all the ufs device manufacturer's datasheets.
>> Improve the system resume latency by reducing the required power-off
>> time from 5ms to 2ms. The chosen 2ms should include enough
>> additional buffer time without being wasteful.
>>
>> Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
>> ---
>>   drivers/ufs/core/ufshcd.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 45e509b..83bd731 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -9741,7 +9741,7 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba
>> *hba)
>>           * All UFS devices require delay after VCC power rail is
>> turned-off.
>>           */
>>          if (vcc_off && hba->vreg_info.vcc)
>> -               usleep_range(5000, 5100);
>> +               usleep_range(2000, 2100);
> 
> Hi Bao,
> 
> This delay should be compatible with legacy devices.
> The initial value was set to 5ms, does that mean there
> is a device that actually needs 5ms?

Hi Peter,
I have discussed with the major ufs vendors (Samsung, Kioxia, Micron, 
and SK Hynix) via emails. They are all in agreement that 2ms is good. I 
did check the current device's datasheets and 1ms is what their 
specifications require. I admit that I may have missed some very old ufs 
device's datasheets. However, I take the words of the ufs vendor's 
engineering teams and the current device's datasheets that the 2ms is 
good for their devices and try to improve the potentially conservative 
5ms delay parameter.

Thanks, Bao

> 
> Thanks
> Peter
> 

