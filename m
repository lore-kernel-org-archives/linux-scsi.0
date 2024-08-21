Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08217183061
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 23:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724282819; cv=none; b=aSB3kpZfPFDWEOJbmzGI19/pKSRqKbrCXNx4F9PldqCA/E0AQcXDSARfI8kOEwM+poKxE8NM/+x8Pii7MAwlriyOrspIupFHvnERcmhs/m1NPgIVsqTUX7bJmi1Ij7sKZGQvd9VpvazMMuGh2qzq1riL9lWU0tlLLSwkY8cBen0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724282819; c=relaxed/simple;
	bh=v6KoAKPfbiJOoIK7Cv33RUziEXYKcnBzblGX9bG1c7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uY6SZTUorLsVzbxdeZL+wNKcs7LSTVUEdrqc1SO9feidKcXx8J8WzVYKCP4x/wNpS1k5PwESEGeOkXsUCdJhcl3qjso0xNbuCIv6eXV1G1cZZo/wVH7qtEEed2zRjsRB/YPBSjH2ZEl4pn5jLc63kSIGJbfecxPb88XDy0Dt6FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=NgyaBgkY; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="NgyaBgkY"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47LB51Z9024408;
	Wed, 21 Aug 2024 23:26:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8NeISFti2IKphi6Tw+Q6+2kHAR4Ew82j2en+ybmTzo0=; b=NgyaBgkY/owE3Nd8
	RZ+zN0AH1pRlSXKbajRtm4fX03NEm+yNQN6T3gMyOJ5AZbvelzM1ZHwGmZ8G9CAN
	oke9uN9N8kYySKnti+yyxvqe/nc0Sm+Rg+msFXSRh1RVL5EnD0pvaq+nx10gpEQp
	30G78b7//ou/WrvcVrcf/087NbOAadJJMuDQ9pZWRKIbo2XbqOMbD9Sy2J1rJi/S
	g8mh04rKd4iF87rpL8cZFAuV2/3cA/oRHsO+ixnOHGrmvnyKFBxIzKWqXe6IMu5w
	3Q9V2GbGEwZOU2+WKb2/rML3yE/W9u3a27fdYXuCRfzQwdyotGbt3x0OmY3WbSEK
	cimQJg==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 414pdmx7xa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Aug 2024 23:26:11 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47LNQAH8002820
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Aug 2024 23:26:10 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 21 Aug
 2024 16:26:09 -0700
Message-ID: <41e5ed21-8ea6-3a4c-2f25-922458593f38@quicinc.com>
Date: Wed, 21 Aug 2024 16:26:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        Peter Wang
	<peter.wang@mediatek.com>,
        Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>,
        Avri Altman <avri.altman@wdc.com>,
        "Andrew Halaney" <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
        Alim
 Akhtar <alim.akhtar@samsung.com>,
        Eric Biggers <ebiggers@google.com>, Minwoo
 Im <minwoo.im@samsung.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20240821182923.145631-3-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: FbTM9jrYm3PSzeRESGoBA2uXb0fzKq5i
X-Proofpoint-GUID: FbTM9jrYm3PSzeRESGoBA2uXb0fzKq5i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-21_15,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408210169

On 8/21/2024 11:29 AM, Bart Van Assche wrote:
> Accessing a host controller register after the host controller has
> entered the hibernation state may cause the host controller to exit the
> hibernation state. Hence rework the hibernation entry code such that it
> does not modify the interrupt enabled status. Bart,
I am not clear on the offending condition, particularly the term 
"hibernation" used in this context. In the function 
ufshcd_uic_pwr_ctrl() where you are making the change, the host 
controller is fully active at this point, right?
Please help me clarify the issue.

Thanks, Bao
