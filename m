Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7600E1C84BB
	for <linux-scsi@vger.kernel.org>; Tue,  1 Jul 2025 04:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751342732; cv=none; b=aA/tAuIVYfq29z8ovvPUR44xevDXygIZwA2J/Hlp3gAS7PlODPKX0tuDIOUMmeQ6eYzQaR8rKHqIyl/I183EpIHBpzbPzP+dUGTjhJjbaNzJL8IejNRLpqpssmKZEVbCu3hy+uzxxw8UWKnkQ3FXlZL2MOOChUYJacASc8KHk3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751342732; c=relaxed/simple;
	bh=FfIFYtO810XsRb/A1m/0MZftVd0htcVM1zhw1SZIOnA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=EsizoGWkyb0MBhmMk+SJiU470HhQAp0vmFap1ZgRsaZxdtrj+WwCbmvLMT0/7835tkjVDEZOBTLcdcYRHsDKZYre86WJzqRMf2qsDpwLZOmRW7SORTb+oo4exw5lZDXn+Vq9zP3nFHsQMIVA96Gi+l/Ch3iB/8XIYOIpmmkD1gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=g+PBlJ8A; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="g+PBlJ8A"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5613tM1p024817;
	Tue, 1 Jul 2025 04:05:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kaX6Hg+XI+TuIgUs/H48/x2Q7SU0vnnkh0AuWeDOkhA=; b=g+PBlJ8A6BO7nGST
	TO4g6v/e9eD+w3yW+AJodmeAVIzW6tNuqLWJ7Vg0BHvp41sPH3ZtI204OFqE6JmE
	pt/On7yvSK+QiIudonYwOZWlZpzgUg+CYIMs1OJM6YFULAUm0e+ygMkYJBbDZzH7
	S+lGA1+cp1na/HcVkvTT1Fw/gXgxcJYBduVNdSeukECYLHc0cbl1goWBX14OFO/Q
	26lE6psQRI4S7JtltAImnKY4rRQPjgviTSFpRP0WcUIsoZdMGVFOZWr036u8rsLk
	wV2cUEXL365YECvIqe0YSPCDrk4cnS/0/HZ0B2xmzPj9aTp5Cq6u3eNpHDuyPwZS
	5aXV6A==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47j8s9extq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Jul 2025 04:05:09 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 561458jZ017684
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 1 Jul 2025 04:05:08 GMT
Received: from [10.239.155.136] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 30 Jun
 2025 21:05:04 -0700
Message-ID: <24e5836f-1391-4444-8d03-fc8f5cafacff@quicinc.com>
Date: Tue, 1 Jul 2025 12:04:53 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Make ufshcd_clock_scaling_prepare() compatible
 with MCQ
To: Bart Van Assche <bvanassche@acm.org>
CC: <linux-scsi@vger.kernel.org>, Can Guo <quic_cang@quicinc.com>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang
	<peter.wang@mediatek.com>,
        Avri Altman <avri.altman@sandisk.com>,
        "Manivannan
 Sadhasivam" <mani@kernel.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Stanley Jhu <chu.stanley@gmail.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20250624201252.396941-1-bvanassche@acm.org>
Content-Language: en-US
From: Ziqi Chen <quic_ziqichen@quicinc.com>
In-Reply-To: <20250624201252.396941-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=H/Pbw/Yi c=1 sm=1 tr=0 ts=68635e75 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10
 a=lDNoC2b2T2UTmXs0YmoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: gcYa8u6t2HTgWL-OYngT2opw_yfiuzAC
X-Proofpoint-GUID: gcYa8u6t2HTgWL-OYngT2opw_yfiuzAC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAxMDAxOCBTYWx0ZWRfX6E4BihQ4zMRG
 g7g0CajgKZiYmojl351gPJhMdNVtJ9t57rz1PHHGUMofIR54c8Ai0y/AQMAA708uXVC6P9bxwLA
 QJ8xq3VXgE3REbT1Zp+4TBaqU0jwjIWPirgfPL6eTdv476xkt9sNrP54duqeqEATyzAg39+ewS5
 a2QGebg1KQcXhn/AgSyFrO1XglzGlainrFL60VBiMSUqOoporrtashOS0GKKIx9RdaYf6HG87fU
 +pHGRouAOVrZ4rhIwL/suxx1FbBZJMi/i8SzBR47aVCSMqViOJorHlS1Iy24TgFzQW1RZE7CZEv
 YhdMyZpXO1Qr10YqT9jzilFadDjEaXU8N38hBiGHsUG0m2PFScJAyyDpZ7n22MBN9d46GzY0tRC
 uxVsgbs7ogDM3bc3CPrXusVqD2IuSqb3e1eLILR+hqPbFY/rcsWA4iT/iG3Atr/6JfTCadQZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-01_01,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 suspectscore=0 mlxlogscore=765
 priorityscore=1501 clxscore=1011 mlxscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2507010018

Hi Bart,

I am reviewing, will test it also and get back to you.

BRs,
Ziqi

On 6/25/2025 4:12 AM, Bart Van Assche wrote:
> On 6/24/25 1:12 PM, Bart Van Assche wrote:
>> ufshcd_clock_scaling_prepare() only supports the lecagy doorbell mode and
>> may wait up to 20 ms longer than necessary. Hence this patch that reworks
>> ufshcd_clock_scaling_prepare(). Compile-tested only.
> 
> Can someone from Qualcomm please help with reviewing and/or testing this
> patch? I'd like to get rid of the ufshcd_wait_for_doorbell_clr()
> function before anyone adds more callers to that function.
> ufshcd_wait_for_doorbell_clr() supports the legacy doorbell mode but not
> MCQ.
> 
> Thanks
> 
> Bart.
> 

