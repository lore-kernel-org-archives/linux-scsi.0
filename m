Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B4F26AF6
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 03:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724384637; cv=none; b=NeWOrQfdIDROMWT44Zb+ZJH8zSRh4L9zZH1iECImVmWT6JTl03g/zhdBhIHd04vtFlcuAqCeNKzY+SjLO5r9qz6ScUpbmKukq4BWjJXP1uE2tU78hNmT8+w6uqRj7i8tRjUrhMXE3rLgYMSSEjt3RWlxMaOTys69sGIeXr+2iAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724384637; c=relaxed/simple;
	bh=dt7/Ufh9qCMBvcaphB+5GO5ptsc1Up+ZNHcK2/otNvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=lV4MXb6KCYdGktdtp0kmFP+YO1bR7uO151ipnLYp8kpie6Wck8mQbjK7rA0eq+EtVf49uxmvJ9LM+Zqf5sQc3JTmfkLMImplemiQPKuZvpO5E1IwUj52u0NZoXe3jbVRa91Jpet/zwJBYZiBXJvxtPZD028OBnXvfngDElbV8jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=aGIlWvx1; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="aGIlWvx1"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0PZBu029841;
	Fri, 23 Aug 2024 03:43:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PK/pJTnFdIQo2kA43qlokEypAKDYyxnUPyIq9jThp40=; b=aGIlWvx1FJ3s+m9z
	gseBd4Bq28ZjbwgdAV0qlmlRGnapCbi/F2odhTcFbRPMaS6UwXOdDODbTSZADT1y
	dctnjbx+v1sxbPjJN202CF1d/DEJg1jsWqQPeb2W8wWLQ7yd98Hf8FU+12JPWYlK
	3EhINAuzq68RSXjFe3/cSLEwq+1CXGpK5O+6KpWV3XmiEnqsnEhbBkDm/sy494gw
	TrqT+WzvFf0nV5rqXzytI3sGbKWJBMkJtFirvO99Q+E9xsDDSldQTAiRXAAOzTuv
	Zo9XXDsZVWuubYyiodnZG/1WCwDjGVNtHM3z3AuXqz2ylux7d8kIIJ/XrobwGtnu
	E0qN+w==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4159adewyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Aug 2024 03:43:38 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47N3hbM9014731
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Aug 2024 03:43:37 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 22 Aug
 2024 20:43:36 -0700
Message-ID: <1bc51b34-0d2f-59ec-f025-bcc68da74718@quicinc.com>
Date: Thu, 22 Aug 2024 20:43:36 -0700
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
 <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
 <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: h1ezaCbIHacZonQa2R5h8KhhM66pNCXT
X-Proofpoint-ORIG-GUID: h1ezaCbIHacZonQa2R5h8KhhM66pNCXT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-23_02,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1011 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408230023

On 8/22/2024 7:06 PM, Bart Van Assche wrote:
> On 8/22/24 4:34 PM, Bao D. Nguyen wrote:
>> Let's say you are sending a ufshcd_uic_pwr_ctrl() command. You will 
>> get 2 uic completion interrupts:
>> [1] ufshcd_uic_cmd_compl() is called for the first interrupt which 
>> happens to be UFSHCD_UIC_PWR_MASK only. At the end of the 
>> ufshcd_uic_pwr_ctrl(), you would set the hba->active_uic_cmd to NULL.
> 
> That's not correct. ufshcd_uic_pwr_ctrl() only clears
> hba->active_uic_cmd after the power mode change interrupt has been
> processed.
> 
Agree.

>> [2]The second uic completion interrupt for UIC_COMMAND_COMP is delayed.
>> This interrupt is newly introduced by this patch.
> 
> If UIC_COMMAND_COMPL is delivered after UFSHCD_UIC_PWR_MASK then the
> UIC_COMMAND_COMPL interrupt will be ignored because hba->active_uic_cmd
> is cleared by ufshcd_uic_pwr_ctrl() after it has processed the
> power mode change interrupt.
Agree.

> 
>> Now let's say you have a new UIC command coming via 
>> ufshcd_send_uic_cmd(). The ufshcd_dispatch_uic_cmd() will update your 
>> hba->active_uic_cmd to the new uic_cmd.
> 
> UIC command processing is serialized by hba->uic_cmd_mutex. Hence only
> one UIC command is processed at any given time.
> 
> Does this address your concerns?
Not really. I agree that the uic commands are serialized by the 
hba->uic_cmd_mutex. However, the UIC_COMMAND_COMPL extra interrupt 
belonging to the previous PMC/hibern8_enter/exit() command can come late 
and causes the ufshcd_uic_cmd_compl() to complete the current uic 
command incorrectly.

Thanks, Bao

> 
> Thanks,
> 
> Bart.

