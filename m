Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCDF134415;
	Mon, 24 Jun 2024 09:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719223050; cv=none; b=Gqay7Z7QAaNITUNpZKJ2xM4k7Ty9egZdFdlAHsCBCtrFxq/JYI5gtoQEjloHF5H9PUn7Miv/lYXwPU3QmdejuVvfXMrDLrl32vhBzH8pHW8zspbsy12VUhL0OrZcBZtGNkqW19MGxSzvGXlf3odBvuykTlMTPP68gcDYJbGVOiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719223050; c=relaxed/simple;
	bh=U/dHmr41kSdAMMOP+CZ305DC17dN9mb+SoChcEWhjZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Wfo8zAZNTZ0QmsN6a/ClQoby2Xm+oLLORZjYHMGO10q9aet/9GEScHvRgxveN8Ms6S/D5qHVwwsvbbraE/riroTjX7iHecT3//V0O9qDwWFrN1N6K3eWnzWHFM6ifHFeWLjiK4enELuOE6nQ4g8jMsLe6qWKDwNPhYHj9NzmjTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=i8bVCSgC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="i8bVCSgC"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45O8Yxhd014125;
	Mon, 24 Jun 2024 09:57:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3aIkUUgxmJs6PltGbqIASV7A0KbPnw80yw9a+GN6nik=; b=i8bVCSgCrGbeB0Gm
	pwtpp6cZhvsciZXH9me631NLpTdMYP+1Ptdbf/mVUiItlGL0KkimGIiRAAqGnLcc
	ZDQi6IJLDl8BPxj/VN9CE7MTWRUDr6FO5AeiFCsvq5Z0QnP3T1aEZSkvYtLKOzjL
	xNRnrD4XEjdiqd5OZTMV6z4teujL/Ixo1pDP9cye4Je9uVkzh/mv7g3QHYPOHsCE
	bx/CkbIt1wiZchIg3sdFzXeqjCryh1mmsPXkvFPJ+lMguPNAqFciccHqkeM/aU53
	c7fqTJYLnO3KHJiTGAKuIDi/J8/O062F8qL54b01uT+zyOLhNJ42+OYXoYbHSkEz
	wjVnbA==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ywnxgu6ud-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 09:57:09 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45O9v7KQ012236
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 09:57:07 GMT
Received: from [10.239.155.136] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 24 Jun
 2024 02:57:03 -0700
Message-ID: <efc80348-46c0-4307-a363-a242a7b44d94@quicinc.com>
Date: Mon, 24 Jun 2024 17:56:52 +0800
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
 list" <linux-kernel@vger.kernel.org>
References: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
 <d3fc4d2b-81b0-4ab2-9606-5f4a5fb8b867@acm.org>
Content-Language: en-US
From: Ziqi Chen <quic_ziqichen@quicinc.com>
In-Reply-To: <d3fc4d2b-81b0-4ab2-9606-5f4a5fb8b867@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: vmvkDPb7tr3cTuUf0ZNsBO0Fjwz8I7qO
X-Proofpoint-ORIG-GUID: vmvkDPb7tr3cTuUf0ZNsBO0Fjwz8I7qO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-24_09,2024-06-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 suspectscore=0 spamscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406240080

On 6/21/2024 4:57 AM, Bart Van Assche wrote:
> On 6/7/24 3:06 AM, Ziqi Chen wrote:
>> Fix this race condition by quiescing the request queues before calling
>> ufshcd_pending_cmds() so that block layer won't touch the budget map
>> when ufshcd_pending_cmds() is working on it. In addition, remove the
>> scsi layer blocking/unblocking to reduce redundancies and latencies.
> 
> Can you please help with testing whether the patch below would be a good
> alternative to your patch (compile-tested only)?
> 
> Thanks,
> 
> Bart.

Hi Bart,
Compile-tested is OK, but I don't think it is a better alternative way.

1. Why do we need to call blk_mq_quiesce_tagset() into 
ufshcd_scsi_block_requests() instead directly replace all 
ufshcd_scsi_block_requests() with blk_mq_quiesce_tagset()?

2. This patch need to to do long-term stress test, I think many OEMs 
can't wait as it is a blocker issue for them.

BRs
Ziqi

> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index aa00978c6c0e..1d981283b03c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -332,14 +332,12 @@ static void ufshcd_configure_wb(struct ufs_hba *hba)
> 
>   static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
>   {
> -    if (atomic_dec_and_test(&hba->scsi_block_reqs_cnt))
> -        scsi_unblock_requests(hba->host);
> +    blk_mq_quiesce_tagset(&hba->host->tag_set);
>   }
> 
>   static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
>   {
> -    if (atomic_inc_return(&hba->scsi_block_reqs_cnt) == 1)
> -        scsi_block_requests(hba->host);
> +    blk_mq_unquiesce_tagset(&hba->host->tag_set);
>   }
> 
>   static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned 
> int tag,
> @@ -10590,7 +10588,7 @@ int ufshcd_init(struct ufs_hba *hba, void 
> __iomem *mmio_base, unsigned int irq)
> 
>       /* Hold auto suspend until async scan completes */
>       pm_runtime_get_sync(dev);
> -    atomic_set(&hba->scsi_block_reqs_cnt, 0);
> +
>       /*
>        * We are assuming that device wasn't put in sleep/power-down
>        * state exclusively during the boot stage before kernel.
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 443afb97a637..58705994fc46 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -889,7 +889,6 @@ enum ufshcd_mcq_opr {
>    * @wb_mutex: used to serialize devfreq and sysfs write booster toggling
>    * @clk_scaling_lock: used to serialize device commands and clock scaling
>    * @desc_size: descriptor sizes reported by device
> - * @scsi_block_reqs_cnt: reference counting for scsi block requests
>    * @bsg_dev: struct device associated with the BSG queue
>    * @bsg_queue: BSG queue associated with the UFS controller
>    * @rpm_dev_flush_recheck_work: used to suspend from RPM (runtime power
> @@ -1050,7 +1049,6 @@ struct ufs_hba {
> 
>       struct mutex wb_mutex;
>       struct rw_semaphore clk_scaling_lock;
> -    atomic_t scsi_block_reqs_cnt;
> 
>       struct device        bsg_dev;
>       struct request_queue    *bsg_queue;
> 
