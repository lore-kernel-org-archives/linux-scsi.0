Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E9C1C1F02;
	Wed,  8 Oct 2025 00:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759882329; cv=none; b=USZnU0sEXCyp9R4c0O/GAiu+7sfpn84vmY2DxN1md1gat8eRw2O3g4m+BLNWHAetM3oQnUBeJhNF30sTPUJe51KzN5uoT7VPMf3RyJ+3k9niBl/Agl+IcIyuIjVm2wxOrlhjOB/aUEjshHW0d6vw1AoUNZyhbeARykzuTESgzSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759882329; c=relaxed/simple;
	bh=iRZoJVKLsFuVvBrKt7NUReEdS1D5y6RonF+RnAt82jw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=L3tiDP+s1ccOTPJGpoTk5MqMS3h2kvARlbyGaQ6v8xQq21Vn2Me5kj0fzWq99bpMptksLsIin6rgHyFsv4Ij+R1LqthA4j0iAM1b47kUctGRlhdfjRRV76js5JAjS3THMgeyhn4WNuHPHeG5AEZNE81WZ/jKTET2vqwvlCP11AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=X4kzAdIi; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="X4kzAdIi"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59803bMa023246;
	Wed, 8 Oct 2025 00:11:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	42PBIu9FB3Ker/XT74UNgaTW5RwXoKBZQHzZh/OUeR4=; b=X4kzAdIioAQF7fFV
	tHYfdWWoGUxxX8xO47a6TX3J6FWLADYlL17F+lCEFKB6GgLu177L7p/05WrlwviM
	7XMQdNv3AGgfh2r5dGFo7+dLq09xs0y5EZW56MoUy00MTxhGswHKN7zoM8o+iio/
	KyYQRNmeLRcctScrzdW001NCFkW9hXchlWMu1KOkvGkH+/GMJPd3WfWJltoGPdEC
	8rLjSIqWVXs+u+iwjzacn0/BgcLNieUR4Ho6a0Aocuql2IrPa0f4jXBQs27BcwiB
	vBU2TGuhKkQWOMMthVS4aHtOYntGIGrYQPmzpmvW47vcuV+g+2ubVvsZqXubmid4
	bdBA1Q==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49jtk70xp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 00:11:04 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 5980B3bl032438
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 8 Oct 2025 00:11:03 GMT
Received: from [10.46.162.103] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.24; Tue, 7 Oct
 2025 17:10:50 -0700
Message-ID: <8f52b5a3-6104-9659-b60b-4d57007c1efe@quicinc.com>
Date: Tue, 7 Oct 2025 17:10:50 -0700
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
To: Bart Van Assche <bvanassche@acm.org>,
        =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>,
        "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>,
        "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>,
        "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
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
 <a1eaae1e-3e10-4512-bc83-ae25eacc43d6@quicinc.com>
 <4943d9d6e31b2993ee0563722b8bc38c3b1ef069.camel@mediatek.com>
 <234a5185-d7f3-fe81-9c02-7895691c1fbd@quicinc.com>
 <85bce5dc28293f48e32b64eed5591d66c54c9e69.camel@mediatek.com>
 <2ce08f9f-af8c-4cac-8d66-97517eb18037@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <2ce08f9f-af8c-4cac-8d66-97517eb18037@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA0MDAxNyBTYWx0ZWRfX+X41kdnXXiCM
 AxQWBkjIVyWKSDKTCX28tGsk65B8OxctgubOD/vvcotwWP6wMQpojQtA6ZlI9xQRxuU0IbnSrJ1
 M/jDanG6X9ABCB644kJMA7/89PtHN8VY1yXTi2VGZk4BqQwTMNEoEHePsHpcbfv8xuFBo6m5npp
 K20pw4cIh3UEtxP9FPc3rmBp5lDguXr5JnDWB03+SKR/lS6VKiDoiUhnfM+4yvVunAKnO4CopUX
 mPBYCsbQdHkkjIdXiRPb50XGMk7xKBsh9F4Wws6ncbCkS3DXHpz07l3AAtJPWSvYM70A+4o2hht
 1F7Gqd2g7i9NvRfo+p5DJEC9fCOgywG0BdLoZpvBdTO05qsvh5AHIU2UmCQva+26Ek/JykQcUor
 Bs8eUolS22vanfpV/BdhCWphA71MOw==
X-Authority-Analysis: v=2.4 cv=do3Wylg4 c=1 sm=1 tr=0 ts=68e5ac18 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10
 a=LtKb1gxV1D1uiVA0b5EA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: IrKg6yCU72R0iozqFDUSfBu8yIDMmP7s
X-Proofpoint-ORIG-GUID: IrKg6yCU72R0iozqFDUSfBu8yIDMmP7s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-07_02,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 malwarescore=0 spamscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2510040017

On 10/7/2025 9:19 AM, Bart Van Assche wrote:
> 
> On 10/7/25 12:04 AM, Peter Wang (王信友) wrote:
>> On Fri, 2025-10-03 at 14:27 -0700, Bao D. Nguyen wrote:
>>> With the current or recent offerings of ufs devices in the market, 
>>> the requirement is 1ms. For example, the Kioxia datasheet says
>>> "Vcc shall be kept less than 0.3V for at least 1ms before it goes
>>> beyond 0.3V again". Similarly other vendors have this 1ms
>>> requirement. So I believe this indicates the worst case scenario. I 
>>> understand there may be very old devices that are upgrading the 
>>> kernel only. In that case I don't know the specifics for these old
>>> ufs parts as mentioned.
>>
>> Hi Bao,
>>
>> Please consider using module_param_cb to set the default
>> delay to 2ms(or 1ms). At the same time, we should keep the
>> flexibility for devices that may require a longer delay by
>> allowing them to extend the delay through a module parameter.
> 
> Why a kernel module parameter? Why can't the default delay be set by
> ufshcd_variant_ops.init()?
> 

I am also not sure if it is worth adding complexity to the driver using 
a kernel parameter for this particular case.
I can try Bart's suggestion to override the default value with the 
platform driver init, or drop the change trying to reduce the sleep time 
from 5ms to 2ms.

Thanks, Bao

> Thanks,
> 
> Bart.

