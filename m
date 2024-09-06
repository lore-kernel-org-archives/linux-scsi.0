Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CE5208A4;
	Fri,  6 Sep 2024 20:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725655185; cv=none; b=kZRKLDeJSB3Bt1GEZnfpCUiu79bOqD87WEl2TE/ktSKGWg5d1Xszj9suWEQhre+AA50xjhyijZ5m1Zi5WdWW5fxZtzeaWbptlHldjpPjzBcVNu2/iDEgcaYfwSBU8VE4KKSoUEC1GZQKFJnOZ3kNZ0YpsA66vyZ0OGBZDElL78o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725655185; c=relaxed/simple;
	bh=ZMX7bu6YbtfKFwPg2r9WyLHy1Rjrb8wzrsHnqudUfOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PC7jmwfTsb6hIrvTVj/Ox54iDBDkP1LfY75iVURHi/5oGMJEDpoo7ca4sGkFm7zPqb6DYI9QB4DBsyTa8T8oMMmKh9ZIlIVH1NNfkf7f6DH/zdJZCvQ9FBmeAo4A6iqzsUN8jxkjLJ8HRJfnOdFo1NMlXEfpXUhSc07hE6HgrwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=S7rHxfJI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="S7rHxfJI"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4868cfTe009882;
	Fri, 6 Sep 2024 20:39:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+yEoVE9ezRV0k1GaCT9ts1NI1+qQ8GsKIXa5rBQHMqQ=; b=S7rHxfJI+5bK9ckN
	M7P7xlZOtzanGqUXY+IhJBUwwdbxSbK17ZAylpnMCawJxKQcnpUOo6MwsdJPNRsT
	iY9X5/dCx4rtj/FfhYHz29OT65oOFjJe6qhR44HMtbQsihtCZBXsW487+JsW/wDI
	Eh/9amAT48WkdkQ3c7yTw2XnAAX4vbqcX6bK0DAg6Nipx472NyQzhqeRf1u6qLgA
	TvSgPpKAjBWrlU58FcGCfsxwIoEfmV7T06kgf/juv+tIv10dFmV8axj8VqWmVEnX
	c77PKa0oGA7TR5BUjh8qzhTa+mlmEnFdfD72ijQu+cG9BjDb9pZq9kSFR9qhyv+l
	XA0oJg==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41fhwruc6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Sep 2024 20:39:20 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 486KdJ5E000469
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 6 Sep 2024 20:39:19 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Fri, 6 Sep 2024
 13:39:18 -0700
Message-ID: <4d28f099-137f-b9b8-463f-40ec2a745694@quicinc.com>
Date: Fri, 6 Sep 2024 13:39:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/2] ufs: core: fix the issue of ICU failure
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
References: <20240902021805.1125-1-peter.wang@mediatek.com>
 <20240902021805.1125-2-peter.wang@mediatek.com>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240902021805.1125-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 0FqclmJWzZByE9vdHfYZGWJeAXKgRavN
X-Proofpoint-GUID: 0FqclmJWzZByE9vdHfYZGWJeAXKgRavN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_05,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 clxscore=1011 priorityscore=1501 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 impostorscore=0 mlxlogscore=936 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2408220000 definitions=main-2409060153

On 9/1/2024 7:18 PM, peter.wang@mediatek.com wrote:

>   	/* SQRTCy.ICU = 1 */
> -	writel(SQ_ICU, opr_sqd_base + REG_SQRTC);
> +	writel(readl(opr_sqd_base + REG_SQRTC) | SQ_ICU,
> +		opr_sqd_base + REG_SQRTC);
Hi Peter,
Instead of readl() here, how about write (SQ_STOP | SQ_ICU) to SQRTC?

Thanks, Bao
