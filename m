Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911C92AEE2;
	Wed, 19 Mar 2025 09:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742374900; cv=none; b=hzsn0nn96b7Tp71FguxVponS4DJ4LQRoHA+O9RhbvV8FrUELSirot+q0mzJvy7k8Qt70azZEeV7KdvwSQzOGeGFgU4zKN5Mps7/QIULkxrPJsYib+5QcJL2QqTev6zeshLv6izWyTbDKy5FMuQsMbLRl1M0sz3cAa4Yy9S7GAWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742374900; c=relaxed/simple;
	bh=4QYmdqDSlZst6cuHIklbZ+nRYC2qbggdO/eAZEQSiD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=aks5cMx5OZIKlu/iKw12rHSkhNquqL2GG3XyvnHmgnGxHB73ZUwNOOmcnCT2QoYasdOv2Ipdv8HPx13e2Y9cmHJG9ufJscLIoEuSJ7FFZVEuk13DxY2AGAL9XYsqM9WHSM4MppmtTag7DQ+cy8TumXuZIgQ7kd4oJg5KBiP4QO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=jPK/w8Gx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="jPK/w8Gx"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52J4lfPp013111;
	Wed, 19 Mar 2025 09:01:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oZJFFFU75xnAfcL8zLuM4V6jHSfHq6sIXUl/50bulpc=; b=jPK/w8GxtQuXHbR/
	THyDFV+bjrPVEyCfjqnsr6kVT6Qb8xvw1dkTqSVcw54F+9D5EdKroUBYLswzFReX
	qcIG4oHmI8Chq2+eYPDqPi7iRT0e7/2QWdR2Zq+dEa59eceEb8tFbml1PBZB1oSq
	PiBAYrAcwVCcI4hGavpNQUW555lyNfOcZmeLxJrTJ679/7pb4KhoQ5VglYpWEjBo
	mtJ49UR8FdAuWUbmnFi38PYunzDCSlrV3EAUfUETHF6a8kR1Ea5y1nKyhhpj9ilB
	KZh5DZDcXO1/K11k68vKRxaol1zdp/qGuOJp3k63g00hKWc2ihfV71nJUXSKVtTC
	UdYSgA==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45exwtmtb3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Mar 2025 09:01:08 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 52J918qf015779
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Mar 2025 09:01:08 GMT
Received: from [10.46.162.103] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 19 Mar
 2025 02:01:07 -0700
Message-ID: <9cf88cda-cf9c-9dbd-d586-5463ce2a0cfc@quicinc.com>
Date: Wed, 19 Mar 2025 02:01:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 1/1] scsi: ufs: core: add device level exception
 support
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
        "minwoo.im@samsung.com" <minwoo.im@samsung.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>,
        "ebiggers@google.com"
	<ebiggers@google.com>,
        "gwendal@chromium.org" <gwendal@chromium.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "AngeloGioacchino
 Del Regno" <angelogioacchino.delregno@collabora.com>,
        "quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "keosung.park@samsung.com" <keosung.park@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>,
        "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
References: <6109425449ac4d18249ce7254e4fa1252138a94a.1742369183.git.quic_nguyenb@quicinc.com>
 <61570104d58cef22716fefe459c0c45670108aad.camel@mediatek.com>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <61570104d58cef22716fefe459c0c45670108aad.camel@mediatek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: vr39mJyDo-GZa-ntTDHhauSuOWF0_4ug
X-Proofpoint-ORIG-GUID: vr39mJyDo-GZa-ntTDHhauSuOWF0_4ug
X-Authority-Analysis: v=2.4 cv=UoJjN/wB c=1 sm=1 tr=0 ts=67da87d4 cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=RWTcRH6CgHNVpisSJ_IA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-19_03,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1015 spamscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503190061

On 3/19/2025 12:56 AM, Peter Wang (王信友) wrote:
> Hi Bao,
> 
> Could use atomic_t for counter protect?
Hi Peter,
Are you suggesting to convert the dev_lvl_exception_count type from u32 
to atomic_t type? Because the value of dev_lvl_exception_count is 
returned to the user space via the device_lvl_exception_count_show() 
using the sysfs_emit() function, keeping the dev_lvl_exception_count as 
u32 data type probably works better in terms of the format.

Thanks, Bao
