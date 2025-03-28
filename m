Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DD51E47A8;
	Fri, 28 Mar 2025 19:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743190771; cv=none; b=J/MxOcSQmF1Y1jdWiF4/e1+ax6+D1zPFvI55yzCwPE6FTJ0hpzK2Pa3/rnZk2ZzkVtShi/YMFnnwsblGIAHmbEZiQRfSDibVuKO9VrxFZRwtkragWCsrjQagRqFQpDk6CPRNmorNfKuW8pIflxiafNMB6eQ6U+t9brwqGSowatc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743190771; c=relaxed/simple;
	bh=70fkNDgVuRdao9ds1R1RDHFK6w/M720Gd8LT32q7epg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=QvENAwdAdq6Z3SWHGkCaOIsTPFeedt4rusSabQqw41n/FiPlsZbguFJXPNM/CaZcz+GiTgfAWd1U9QOCvIhxiX9HQ7P52FI/vpC6OLPH465MwM/I6JjtRdPjXwQOjUxOmYvVTzDLfoyr8cBtk/6uN1VnYG0daixys/1slcXztWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=RqJ9w07a; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="RqJ9w07a"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52SCQ7UH021794;
	Fri, 28 Mar 2025 19:39:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	JzVpWdgSyHkZy6apr5Hl3X9Pyf5viBCCDIkCLFQNRXU=; b=RqJ9w07aG0MsP87P
	69Cr2ltem/e0I7MWnwQTYacBJyBlQycFG8j/LzTjULY6vFwsH7xfPeuWmAeW4218
	ecpMt7GsgoBHpDdZ2ceMPolecSSW5bakoHe1vvXoFlOcUVtn8J1hljxkR5OgvCqi
	k0oPNy6leXNfKHic0JCJJuJhPhtFoCwhTeXbNN0ahQGxrMVEYYoJ2PeHgYJul9NR
	qBrGyw5lRyoy6tR11VTyHk+sQBGznplZ+5CkMuJEuuMsryzq3TdoxMadDFT/uKsj
	F2/2VPeuxVk/KoUbhvYPFh1Tl+STpYsXgBiEU1I2hVozKTquqPMH10Rh8rM4KyLF
	Q9WcCQ==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45kyr9u7dx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Mar 2025 19:39:05 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 52SJd4aD029806
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Mar 2025 19:39:04 GMT
Received: from [10.46.162.103] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Fri, 28 Mar
 2025 12:39:03 -0700
Message-ID: <7823d23a-a366-57dc-0e52-36ed26c00d3e@quicinc.com>
Date: Fri, 28 Mar 2025 12:39:03 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v1 1/1] scsi: ufs: core: Removed
 ufshcd_wb_presrv_usrspc_keep_vcc_on()
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        Avri Altman
	<Avri.Altman@sandisk.com>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>,
        "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>,
        "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Alim Akhtar
	<alim.akhtar@samsung.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        open list
	<linux-kernel@vger.kernel.org>
References: <9ff613809e88496b5802a2d45984d2a8dddf92dd.1743057420.git.quic_nguyenb@quicinc.com>
 <PH7PR16MB619627C83309BDCE8BCB952FE5A02@PH7PR16MB6196.namprd16.prod.outlook.com>
 <5f9c7657-d86b-47a4-ba4c-5445325886bb@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <5f9c7657-d86b-47a4-ba4c-5445325886bb@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: avMMtpJPjXZE5OK9DxVY21cWhCkWfI5h
X-Authority-Analysis: v=2.4 cv=UblRSLSN c=1 sm=1 tr=0 ts=67e6fad9 cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=dcbCN6jE24hXbaRKmOMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: avMMtpJPjXZE5OK9DxVY21cWhCkWfI5h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-28_09,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 mlxscore=0 impostorscore=0
 adultscore=0 clxscore=1015 mlxlogscore=730 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503280133

On 3/28/2025 12:33 PM, Bart Van Assche wrote:
> On 3/28/25 1:29 AM, Avri Altman wrote:
>> Maybe just change the function name to better describe what it does,
>> e.g. ufshcd_wb_exceed_threshold ?
> 
> I'm also in favor of renaming ufshcd_wb_presrv_usrspc_keep_vcc_on()
> instead of inlining it.
> 
Thank you both. I will update.

Thanks, Bao
