Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DCD14BFBC
	for <linux-scsi@vger.kernel.org>; Thu, 23 May 2024 14:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716474537; cv=none; b=VaG4uNNUWwFXcjd03e6RK1y5BCel09F1FZNOG+ItfL6+FhDFwJkc0W5JOaNrS+9ac20DvBN58weNiaBENGihw0CJKNvRrydUP5RJ8lpbz+xy3OvrDMWViuT+ZwGPZj0xkEfn5JWQXSs24B1T7CmwTJSxYMEexaVIQ8jT9JePSGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716474537; c=relaxed/simple;
	bh=c8ClMgBfzeob5Vfq23gTXJ/Ac7b2K0mRb9rHllsSCPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=KklsLfrerI0Qb/rGNRiUlbRFC9gNjmLBBegJDIykTjZgPiwfiB0+Pi8d1fS+C/CjKLhuAZpJ5l305xuym+aAiHGhQYVtAyoTrc/cId7pt8dltPlEGGr4SWsSMv/6XYIq+8a1trH2qCqrfKdlUnod7WtlGFO4Ub1hKQm5+BXGKHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Hx+HW1Zf; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Hx+HW1Zf"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44N4jjA4011896;
	Thu, 23 May 2024 14:28:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	P3GHzsedeByDsjcYt67zau9WhmQfHMrN9cMPE8aIc7c=; b=Hx+HW1ZfT+ZV5ZFD
	5qRvE1MTdXMfe852D5GzKxVzIqcllZk+QbZ6x0f/SSwiK16iQepNpbSf3s334UKK
	qnQGT4qWeeaLdIICNUVVLtmzof4Ysj3yDW2Ewh0AXYRgYXVih6JCeyAdaq1rw9X9
	d7XSbHncMifCwjpNhzBs9MiQPopWVa4GNS6IlIPMWucd23NSskcJSYBoRCGfm2Iq
	qyPNRvR6/ALZNcr4GRAGYSd3ftgoROE26m6eQuqCwNkiT+FbWOCqJyyijix6FRTi
	K4WxBKg3JOEU3ZIck/LUxWe1yoqHtdFLa2vKjTdPZecg3l4nMf353SCrRiE3kLMJ
	1yRpLw==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3y9y29sc1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 14:28:42 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44NESg0Z005480
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 14:28:42 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 23 May
 2024 07:28:41 -0700
Message-ID: <8346c963-75e7-9319-563f-dcc75ce6a6d6@quicinc.com>
Date: Thu, 23 May 2024 07:28:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v1 0/2] Allow vendor drivers to update UIC command timeout
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
CC: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <beanhuo@micron.com>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
References: <cover.1716359578.git.quic_nguyenb@quicinc.com>
 <Zk77mPfY5FpEszXk@infradead.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <Zk77mPfY5FpEszXk@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: lBk5ej_o29oOrR6MKe4fVlGRQw4D6I_K
X-Proofpoint-GUID: lBk5ej_o29oOrR6MKe4fVlGRQw4D6I_K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_09,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=659
 mlxscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1011 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405010000
 definitions=main-2405230099

On 5/23/2024 1:17 AM, Christoph Hellwig wrote:
> There is no such thing as a vendor driver in Linux.
> 
I will reword it in the next revision.

Thanks, Bao
