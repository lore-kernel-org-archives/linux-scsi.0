Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B5720E338;
	Wed, 19 Mar 2025 06:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742367445; cv=none; b=aDFJ6i2IXi7nfNQp1y2vLUjn//rozcXPsKHNmICz51WuB5ZXHfC/lswlOzWzZxqC6ih5R3fZMXXSskgbkm/Jcawnwm00mmdMMcdQF1eZYqU5cge3G/JR93UmibV6drAFkwjajwXwPB335vbX09muSDL4RuePCafdvZgMtBqhD3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742367445; c=relaxed/simple;
	bh=Q9KONftyTP39dEgJLykYMFqa9ua1MO/VxLSZGkdtsz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BGu3NhJGx5w+rxalpqus29Mx+hY4VKNtitRoY2bRN8omVlKx7doPX5ge6pBFuecRa3zmRs5zFlYcZDvzPNy/T+odtDBYotUbHAFZJCZW2PCon1bTfT6YK9myW5NS/BIq9OJZkcQ/5jD6eDHoTmQ1t7ppWRUk81nPm6UaCXKkrTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=SVZgIGtC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="SVZgIGtC"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52J4lufQ017200;
	Wed, 19 Mar 2025 06:56:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UKVqFMWmBtwphuq3FFUfdJ01jR0JGmYl+NWZOhrrUrU=; b=SVZgIGtCYVne5HeJ
	a1ZnXECpZ7O44k12c4N7dpx2plId4Ld03MsA1LpWEmGvlSPSx+MaADEXRiPaLEQ/
	kQvvNWY3mxnHuZqf/gXdz6dWo9OL5zUsIA72Vp1XoxyGD49L3N4pzLA1F9HJEhbH
	s0V7ASA7h7U1dIPJ6gaLXbevmf6lOAI7OS/AZ8Oj+yaC9VOySipihs3Teln49xPF
	oUrh4hy9qVpZc23clFTpEhXQ76FGiPB+z/iIHvWhRWs2EDFftBS7eXU/r/j45mjF
	GJDSyIaVRMDUvnGxNDdtwtjNxHa97YB5N9hQv8gKIh6Djwjs4JxKjwlO0Vw6YPUZ
	xSMOQw==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45d1sy2pw8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Mar 2025 06:56:58 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 52J6uu2A014520
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Mar 2025 06:56:56 GMT
Received: from [10.46.162.103] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 18 Mar
 2025 23:56:55 -0700
Message-ID: <8d268fec-98e9-ab70-5b82-3a492895e565@quicinc.com>
Date: Tue, 18 Mar 2025 23:56:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/1] scsi: ufs: core: add device level exception
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
References: <df2a1843d1dbfd0d3fef87b9730089969b6f00bd.1741992586.git.quic_nguyenb@quicinc.com>
 <98b420e3-87ee-4034-8cb4-76b8e30d7920@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <98b420e3-87ee-4034-8cb4-76b8e30d7920@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: UhxtNe0vtElE03-jJoYRI4Y6fI-AUC9U
X-Proofpoint-ORIG-GUID: UhxtNe0vtElE03-jJoYRI4Y6fI-AUC9U
X-Authority-Analysis: v=2.4 cv=XKcwSRhE c=1 sm=1 tr=0 ts=67da6aba cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=wwyYcussyjTYpm2M6PYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-19_02,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1015 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 spamscore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503190046

On 3/18/2025 2:21 PM, Bart Van Assche wrote:
> On 3/14/25 3:55 PM, Bao D. Nguyen wrote:
>> +    if (status & hba->ee_drv_mask & MASK_EE_DEV_LVL_EXCEPTION) {
>> +        hba->dev_lvl_exception_count++;
>> +        sysfs_notify(&hba->dev->kobj, NULL, 
>> "device_lvl_exception_count");
>> +    }
> This increment can race with the code in 
> device_lvl_exception_count_store() for clearing
> hba->dev_lvl_exception_count. Shouldn't the clearing code and the
> code for incrementing hba->dev_lvl_exception_count be serialized in
> some way?
Thank you for the good catch, Bart. I do need to protect this racing 
condition in the functions you mentioned. This dev_lvl_exception_count 
variable is also initialized in the ufshcd_device_lvl_exception_probe() 
function at which point the sysfs nodes have already been initialized, 
but since both the device_lvl_exception_count_store() and the 
ufshcd_device_lvl_exception_probe() write 0 to dev_lvl_exception_count, 
it should be no problem there.

I will fix it.

Thanks, Bao
