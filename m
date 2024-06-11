Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01315179957;
	Tue, 11 Jun 2024 11:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718103819; cv=none; b=gabEsahcik45WK/G+j7CFXrvdjZ8xlW3qv1EPDrwaqgsiZZpQ3LdzGjBWGtLUYjTCKEq2+6lpdhJLD8SNz3J7zNhC3vNGcKkBA7IxjTKt5O/93YQKVKz/MCzwGxA9zaiYQanl8iVYufGCodEuYpdlBkcf8b+D4nDfd+ddVn7s0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718103819; c=relaxed/simple;
	bh=lpqmEf33VziRa7kuX+3uIhurD1rM9/vPwxxbkU+9lFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=c/jF9eDUgZOYkFMfP1WofTSOp7Ua+2IwsQfSLKreQp2FhCE3MIdODMZdrYsiPzWfiya4n/M8KUaIMNFjiI/CLT0gfaC3XAm1tovvg+egJqmwZQ/ySRxFfH3wm+P+8/wO1oX1y/QtQbL43DXcFx9pOadD0Jn6YJxK4zxY40I92Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=SHohea0H; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="SHohea0H"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45B2wI4W008389;
	Tue, 11 Jun 2024 11:03:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	b18rKC2zLhX3gxijZqdd4sMdxetYAmDaB+xc1b1B1Ic=; b=SHohea0HMaTs9ekU
	vIjgIb+Ig6FTIfHdTVRPMLmjZRxI/xVouIig2Esz38BwJiB/Q5NjlLEwW/rB+Gvn
	Cbs818/a8+vp7ET2N3+C+yGMiTkWuAwahq9Ae3EOXgnALnk2DtoemSsBz9+u9LZK
	Hzs+KKiB1HCWmgdTTwKjHrLYx0AZVzRHSsZ74OOPiqIU9L/AepRqs0FlsTwFR+yf
	srfSzgj7iu9zm4Pxz+NwQomi/ZpuNm8Wyo5Qjsz0GEwsWNOwZ7P3TmzjI2b09VZI
	Ud33CzGpW+Z+/pwMBuoFftO7o1mJMJps1eTLOTbSFSTpndF2pYUIwjQucsc94QIf
	SxUvMw==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ype910xcr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 11:03:15 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA05.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45BB3Elt017498
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 11:03:14 GMT
Received: from [10.239.155.136] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 11 Jun
 2024 04:03:10 -0700
Message-ID: <6d636c36-ce05-4825-b916-b97484c41c5b@quicinc.com>
Date: Tue, 11 Jun 2024 19:02:43 +0800
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
Content-Language: en-US
From: Ziqi Chen <quic_ziqichen@quicinc.com>
In-Reply-To: <7ba3bbb8-a5c3-4ecd-9c2a-c9586c9d6bf2@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: b1TrvMujKKfEeOCvM6MIMdGvG5HNMAEp
X-Proofpoint-ORIG-GUID: b1TrvMujKKfEeOCvM6MIMdGvG5HNMAEp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_07,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406110082



On 6/7/2024 8:33 PM, Bart Van Assche wrote:
> On 6/7/24 04:06, Ziqi Chen wrote:
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 21429ee..1afa862 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -1392,7 +1392,7 @@ static int ufshcd_clock_scaling_prepare(struct 
>> ufs_hba *hba, u64 timeout_us)
>>        * make sure that there are no outstanding requests when
>>        * clock scaling is in progress
>>        */
>> -    ufshcd_scsi_block_requests(hba);
>> +    blk_mq_quiesce_tagset(&hba->host->tag_set);
>>       mutex_lock(&hba->wb_mutex);
>>       down_write(&hba->clk_scaling_lock);
>> @@ -1401,7 +1401,7 @@ static int ufshcd_clock_scaling_prepare(struct 
>> ufs_hba *hba, u64 timeout_us)
>>           ret = -EBUSY;
>>           up_write(&hba->clk_scaling_lock);
>>           mutex_unlock(&hba->wb_mutex);
>> -        ufshcd_scsi_unblock_requests(hba);
>> +        blk_mq_unquiesce_tagset(&hba->host->tag_set);
>>           goto out;
>>       }
>> @@ -1422,7 +1422,7 @@ static void 
>> ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err, bool sc
>>       mutex_unlock(&hba->wb_mutex);
>> -    ufshcd_scsi_unblock_requests(hba);
>> +    blk_mq_unquiesce_tagset(&hba->host->tag_set);
>>       ufshcd_release(hba);
>>   }
> 
> Why to replace only those ufshcd_scsi_block_requests() /
> ufshcd_scsi_unblock_requests() calls? I don't think that it is ever safe to
> use these functions instead of  blk_mq_quiesce_tagset() /
> blk_mq_unquiesce_tagset(). Please replace all 
> ufshcd_scsi_block_requests() /
> ufshcd_scsi_unblock_requests() calls and remove the
> ufshcd_scsi_*block_requests() functions.

Hi Bart,

Thank you for the review.

This issue was not easy to debug, it took us more than 3 months to 
narrow down to the root cause. Our mutual customers and internal test 
teams had to pull in quite amount of resources to help narrow down the 
issue and test the fix. It is a key change to unblock customers from 
commercializing Android15, so we are pushed to upstream this fix ASAP.

As for removing the rest calls to ufshcd_scsi_block_requests() and 
ufshcd_scsi_unblock_requests(), I think you are right, but I am not 
quite sure because we haven't seen issue reported w.r.t those spots. If 
possible, we can co-work on this sometime later.

Hope you can understand.

Thanks,

Ziqi

> 
> Thanks,
> 
> Bart.
> 
