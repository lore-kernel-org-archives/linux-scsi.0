Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CBA13CFB0;
	Wed, 12 Jun 2024 06:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718172774; cv=none; b=RasQaFz7l2EcLJfN546ArDTm1WWh9zkhbMkOF5ddevw76dy4J7nIfau/wXuJbeNB0HGsv0u+Ww3ljSE5+gZrrrbg0Sl3XTKxBa3QvJhZEid9fcgJU0QUTSawXjyGlbtGcA0UVHZ1/T6Q6qzucujelfqTDB2oS/kMPgSQQ28U38Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718172774; c=relaxed/simple;
	bh=zo4pdTcHd8FQMwJZM2TIfPr8WX9aXERYXLbSCPAIl2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=AblL9SuUsMkk7MdzOmy7vU/68QYAKk5+N7iBZcSLcsvO1GV7Y6b85tJnQC10GchLj70Xm52c7Bm6lNG/AI8WmsX70JMjKWmWDyuK0kFMvhLAgGgRONY+yWWgQSCj0d0ZGbINwV4ec5LQJQGqmLMqOPyemBmAUdUX/NzsIamyg2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=O9DylEYo; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="O9DylEYo"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45C1BNwN004113;
	Wed, 12 Jun 2024 06:07:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Gz1XV3cxEedHzX2ppgnLw2HKCj5hYGYjsPxXTwzROJM=; b=O9DylEYoTV2KhTR8
	OYjKVtFAQcK85pLTmr5a9CXcYtrmyQN17sz5SVXo8+F6TBT0ZZ5PfYheJAo5CX8f
	JdK2ARqCws3kDPGqNDAu7+cSoOw3auyVnCI1yLxA245Z3aGApSkLrhUUeTTF1itP
	YD9gzXQ6B0e+ZvPua1rsB+sdb5nIPUVqYv4/a0V/9g6aooa+4HiLdqGvllv5ZL46
	nV2MmN4LqJbu4IFj/c1Tl9b2NtUIO1ptbySXUSZ4l2oGjoAq09nublYV1ZpSCb2q
	OzJJFJgKHxHNjNDj8q6PLGGlopK5sFPbLFNrqCGNNAXGYx1y7rUOEOXh99FEIVRj
	jgp6eQ==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yphsatys6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 06:07:27 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45C67Qs6031749
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 06:07:26 GMT
Received: from [10.239.155.136] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 11 Jun
 2024 23:07:22 -0700
Message-ID: <dc0f11ba-2ca7-498a-b2dd-26a48e9cdf90@quicinc.com>
Date: Wed, 12 Jun 2024 14:07:19 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: quiesce request queues before check
 pending cmds
To: Bart Van Assche <bvanassche@acm.org>, <quic_cang@quicinc.com>,
        <mani@kernel.org>, <beanhuo@micron.com>, <avri.altman@wdc.com>,
        <junwoo80.lee@samsung.com>, <martin.petersen@oracle.com>,
        <quic_nguyenb@quicinc.com>, <quic_nitirawa@quicinc.com>,
        <quic_rampraka@quicinc.com>
CC: <linux-scsi@vger.kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Peter Wang
	<peter.wang@mediatek.com>,
        Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>,
        Maramaina Naresh
	<quic_mnaresh@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "open
 list" <linux-kernel@vger.kernel.org>,
        <quic_richardp@quicinc.com>
References: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
 <7ba3bbb8-a5c3-4ecd-9c2a-c9586c9d6bf2@acm.org>
 <6d636c36-ce05-4825-b916-b97484c41c5b@quicinc.com>
 <16b2cd1b-8f1a-4fb1-823f-a73463c6f7a0@acm.org>
Content-Language: en-US
From: Ziqi Chen <quic_ziqichen@quicinc.com>
In-Reply-To: <16b2cd1b-8f1a-4fb1-823f-a73463c6f7a0@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: UKNVGE4CoyxyZkkVhe81RFt86ruRx0ZI
X-Proofpoint-GUID: UKNVGE4CoyxyZkkVhe81RFt86ruRx0ZI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-12_02,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 adultscore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 mlxscore=0
 priorityscore=1501 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2405170001 definitions=main-2406120042



On 6/11/2024 9:51 PM, Bart Van Assche wrote:
> On 6/11/24 04:02, Ziqi Chen wrote:
>> As for removing the rest calls to ufshcd_scsi_block_requests() and 
>> ufshcd_scsi_unblock_requests(), I think you are right, but I am not 
>> quite sure because we haven't seen issue reported w.r.t those spots. 
>> If possible, we can co-work on this sometime later.
> 
> If you want I can work on the removal of the
> ufshcd_scsi_block_requests() and ufshcd_scsi_unblock_requests()
> functions.

Thank you, Bart. I will help to review and give you support as possible 
as I can.

BRs,

Ziqi
> 
> Thanks,
> 
> Bart.
> 
