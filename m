Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A98228EC;
	Mon,  9 Sep 2024 14:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725893523; cv=none; b=qQHIioKoTEeH0ZwcIb2Qg/Hy2/ezTl9WkPchv8qIkdBYjdOV3ftawlS6GP0uUqWx13OQKHhhE/RtR5rm4q+O2CmLsYZFNnH+vFyBFSvHWL8vtVu6yxRMq1iepKihPt8Mo5rX/7UUMEmzD/05/TlGtaigWMXtZPMve0UzzHyhWUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725893523; c=relaxed/simple;
	bh=pLZ5KfsWDtAOi+9pBh4TXhl1PKUKCxpwGHqM1/9+ReQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UD29Jak6SSY+9zM6SZu7CVSg5c1VmcLK/ENc+ZUmN6yQdmRPSZkjp3By1nVJlqTur6eHDaVRj7At4CluNvsU6oANnKg/fP3+5bxLNsYvCeayXJpLnwMYv5zZTe0dirLFC/HP57qNv7F1icn4M2M2ZZcgCHgYIMslHeDsPVl3ykM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=OuobNaCR; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="OuobNaCR"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 489DRRU1018266;
	Mon, 9 Sep 2024 14:51:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oOjcXjUbwSgzNSp733a017RyzNlbU++LiGHcquc+GRM=; b=OuobNaCRXJPSD37/
	h6GFvdKWgDwZ9E+aaDB0rDm8XV/Kxf71t+5iRBp+8a7P8wx5rEb+esby1oxOTcR9
	eBXKjbWHa3sT6pvWcLOlGNj1Aq2FH46w/DviifBzn4RoeeYMiYUbR4BnjpoC6Ie/
	ykhT2XwpGWEggk3nFb76qHOzr+ovF+sumy45M031XEDF4DMEgwllqYwvdu5V4HUS
	O1O53chC9mWmp3ttzqTtg+Ea1A+blx6UWaYCTbLkL/nSDpgKspBm+RwPBKfV5uCu
	g3Qn5VBh1OgCU6bY3zdreNRzY+a6nJZhrzXLJAYKxEqTvNjiSJ1U+l3gRBe4+Pxj
	EJPhYA==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41gy7fk3xt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Sep 2024 14:51:36 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 489Epaw6007195
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 9 Sep 2024 14:51:36 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 9 Sep 2024
 07:51:35 -0700
Message-ID: <f133990e-548e-1d57-ccfd-b130a642fc58@quicinc.com>
Date: Mon, 9 Sep 2024 07:51:35 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 1/2] ufs: core: fix the issue of ICU failure
Content-Language: en-US
To: <peter.wang@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>,
        <stable@vger.kernel.org>
References: <20240909082100.24019-1-peter.wang@mediatek.com>
 <20240909082100.24019-2-peter.wang@mediatek.com>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240909082100.24019-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: OERjaQ1dmJ05ckrU32UtKX53KSI__z5R
X-Proofpoint-GUID: OERjaQ1dmJ05ckrU32UtKX53KSI__z5R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409090118

On 9/9/2024 1:20 AM, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> When setting the ICU bit without using read-modify-write,
> SQRTCy will restart SQ again and receive an RTC return
> error code 2 (Failure - SQ not stopped).
> 
> Additionally, the error log has been modified so that
> this type of error can be observed.
> 
> Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
