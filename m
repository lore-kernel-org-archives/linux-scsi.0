Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA7B2D1913
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 08:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751531415; cv=none; b=uAoMnPWkd46D5cUvcCGwRHcqobFosg1st5aDHQ/VET7FaCO1D9kG8Vk7W+H0etveA2FJ0r1iFJOmpU2Z6D6v+OyYci95s2O1vafkQOdNU7KjJ6kCPlXh1asw5b4vBFWsL1ZSapMUs0qyFRfF6ZOAjZcYyqboGtSLYUfKd4nwXmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751531415; c=relaxed/simple;
	bh=PMOsQ5JdkDDJxJfCKHqpnayAqxvZu/xcjDJKHRyZV5I=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FDUOABbQgeKC4gUq1w44srr1IIdQmUlS5aqknG6DGnePRQLLOB6hfElluVRlRQiirZ5oy0fkYpPOkiexreIsQ7Z3rLiofyBxPTKIlzvhYc9BywXEJgOysmZwlBzv8vwwXRBvC+gBPYpjsDWo2a1dUFTseRZDreYLsCU3u/DWxBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=A9DgeAgX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="A9DgeAgX"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5636neGj007107;
	Thu, 3 Jul 2025 08:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3st5RJxQxmqJjq8rGcxIqXfe8kCj5mgIkfBVVAOO2LU=; b=A9DgeAgXJtrBqWM4
	0sC/mWnI5SxjN3zynz+9TS4NvsglovbPpB18LgOYFeG3939M9dUuuvFTdB0bR58S
	6rYJ+fq59bIhXHF3uLdqEB4g7eq1psHL/GXLaxyUugVej8XsUzdGmc4XP3LTf0z6
	Gv/I3ZtsK2RE4JpsxRBizj65oojiX/hvtfL0A+2R9Ht5WL0nm6p88qsJ4mv8YNMv
	9BgQ+3Ks1woxrKjBYniRb5//MgBLT6msrHSEIO/78z4bJiCQcAmlHwPDeijIJACw
	AonKvDHGDkJr62da6ZP3aJQ6IkJZRjjtcXvlMqXV2D5JlBFmmEl6HqgG/yxqfR1D
	TbGZpQ==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47napw1w6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Jul 2025 08:29:50 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 5638TopL010852
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 3 Jul 2025 08:29:50 GMT
Received: from [10.239.155.136] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10; Thu, 3 Jul
 2025 01:29:47 -0700
Message-ID: <f8c6ea60-7e39-483e-b850-e658eb8fb13c@quicinc.com>
Date: Thu, 3 Jul 2025 16:29:27 +0800
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
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=dIKmmPZb c=1 sm=1 tr=0 ts=68663f7e cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=aNT7HESWAAAA:8
 a=COk6AnOGAAAA:8 a=N54-gffFAAAA:8 a=-aDNBqhWKghUQ_SmbHwA:9 a=QEXdDO2ut3YA:10
 a=raNApmh9DmsA:10 a=43cLq-sk5vVuZAQyC0FC:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAzMDA2NyBTYWx0ZWRfX+1RcOszj+Po/
 52utTuAoiVZH63iYmmQKXr1IGTB8NPaafvQmaTfM9pBD86m4mzEwBgUMCHOsla5hqCRAlYz95pj
 EPIkkdl7hT7bP64tHHFnKUUf1sNpzQry/wifZ0H9DM2X2Tpk2b0OWd0GMmsaBflRYMAiAnYjaf6
 kFcxaqvTKzbjFEuluXXLRsFcuOdnduAxXpQYiUGysfRUTe455BtSEODsnDT3WZCaGQTDI8g6tkX
 2Bwt4HR0RiQ/cbjBhRs683FEXL84u3OiNBSbe5AXyKQQ7YXe8SgYzhKOjCrb7E9D9XxfFC3OmJI
 CEvcnRnj3o4xFbHIcujQ9UapUl5Pe6FjDQyQjiB9+doPwPTduqDog94LuqvjUed5VqnW41wK0DD
 4TOIRvIvrsSYgrmPJO7o2k4BitfwWa/pilvMStt0HyA5Yye8Cmh0rxXffxxl5mLYqI/K1jEk
X-Proofpoint-GUID: p3MmpETetvQCpEcPR2BQktvAlzEAfoOg
X-Proofpoint-ORIG-GUID: p3MmpETetvQCpEcPR2BQktvAlzEAfoOg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-03_02,2025-07-02_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507030067



On 6/25/2025 4:12 AM, Bart Van Assche wrote:
> ufshcd_clock_scaling_prepare() only supports the lecagy doorbell mode and
> may wait up to 20 ms longer than necessary. Hence this patch that reworks
> ufshcd_clock_scaling_prepare(). Compile-tested only.
> 

Hi Bart,

I finished the test on your patch. The patch functional is OK, it can
pass our clock scaling test and I didn't observed errors. But I didn't
run stress test and stability test.

Although patch functional is OK, but I found this patch will increase
the latency of ufshcd_clock_scaling_prepare():

MTP 8550 (upstream kernel):
Original:
  spent: 226302 ns, avg: 2135214 ns, count: 200, total:427042923 ns
with patch:
  spent: 1213333 ns, avg: 4583551 ns, count: 200, total:916710316 ns

MTP 8650 (upstream kernel):
Original:
  spent: 2013386 ns, avg: 1464596 ns, count: 150, total:219689530 ns
with patch:
  spent: 2718802 ns, avg: 4329696 ns, count: 150, total:649454539 ns

MTP8850 (downstream kernel)
Original:
  spent: 144323 ns, avg: 1080332 ns, count: 2005, total:2166066242 ns
with patch:
  spent: 2530208 ns, avg: 1307159 ns, count: 2005, total:2620855033 ns


I think this increament is come from you replaced blk_mq_quiesce_queue()
with blk_freeze_queue(), as my understading , the blk_mq_quiesce_queue()
just only block new IO be dispatched to hardware queue but the
blk_freeze_queue() will freeze whole queue and wait all IOs get
complete.

I am not understand you said "ufshcd_wait_for_doorbell_clr() supports
the legacy doorbell mode but not MCQ". In ufshcd_wait_for_doorbell_clr()
, tr_pending = ufshcd_pending_cmds(hba) is counted from budget_map, not
read from legacy doorbell, it is used to get inflight cmds for MCQ mode.
So I don't know the details of your saying on
"ufshcd_wait_for_doorbell_clr() supports the legacy doorbell mode but
not MCQ".


BRs,
Ziqi

> Cc: Can Guo <quic_cang@quicinc.com>
> Fixes: 305a357d3595 ("scsi: ufs: core: Introduce multi-circular queue capability")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 162 +++++++++++++++-----------------------
>   1 file changed, 64 insertions(+), 98 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index b3fe4335d56c..c8eb5bf65e22 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1248,87 +1248,6 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
>   	return false;
>   }
>   
> -/*
> - * Determine the number of pending commands by counting the bits in the SCSI
> - * device budget maps. This approach has been selected because a bit is set in
> - * the budget map before scsi_host_queue_ready() checks the host_self_blocked
> - * flag. The host_self_blocked flag can be modified by calling
> - * scsi_block_requests() or scsi_unblock_requests().
> - */
> -static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
> -{
> -	const struct scsi_device *sdev;
> -	unsigned long flags;
> -	u32 pending = 0;
> -
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> -	__shost_for_each_device(sdev, hba->host)
> -		pending += sbitmap_weight(&sdev->budget_map);
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> -
> -	return pending;
> -}
> -
> -/*
> - * Wait until all pending SCSI commands and TMFs have finished or the timeout
> - * has expired.
> - *
> - * Return: 0 upon success; -EBUSY upon timeout.
> - */
> -static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
> -					u64 wait_timeout_us)
> -{
> -	int ret = 0;
> -	u32 tm_doorbell;
> -	u32 tr_pending;
> -	bool timeout = false, do_last_check = false;
> -	ktime_t start;
> -
> -	ufshcd_hold(hba);
> -	/*
> -	 * Wait for all the outstanding tasks/transfer requests.
> -	 * Verify by checking the doorbell registers are clear.
> -	 */
> -	start = ktime_get();
> -	do {
> -		if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
> -			ret = -EBUSY;
> -			goto out;
> -		}
> -
> -		tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
> -		tr_pending = ufshcd_pending_cmds(hba);
> -		if (!tm_doorbell && !tr_pending) {
> -			timeout = false;
> -			break;
> -		} else if (do_last_check) {
> -			break;
> -		}
> -
> -		io_schedule_timeout(msecs_to_jiffies(20));
> -		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
> -		    wait_timeout_us) {
> -			timeout = true;
> -			/*
> -			 * We might have scheduled out for long time so make
> -			 * sure to check if doorbells are cleared by this time
> -			 * or not.
> -			 */
> -			do_last_check = true;
> -		}
> -	} while (tm_doorbell || tr_pending);
> -
> -	if (timeout) {
> -		dev_err(hba->dev,
> -			"%s: timedout waiting for doorbell to clear (tm=0x%x, tr=0x%x)\n",
> -			__func__, tm_doorbell, tr_pending);
> -		ret = -EBUSY;
> -	}
> -out:
> -	ufshcd_release(hba);
> -	return ret;
> -}
> -
>   /**
>    * ufshcd_scale_gear - scale up/down UFS gear
>    * @hba: per adapter instance
> @@ -1391,36 +1310,86 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, u32 target_gear, bool scale_up
>    * Return: 0 upon success; -EBUSY upon timeout.
>    */
>   static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
> +	__cond_acquires(hba->host->scan_mutex)
> +	__cond_acquires(hba->wb_mutex)
> +	__cond_acquires(hba->clk_scaling_lock)
>   {
> -	int ret = 0;
> +	const unsigned long deadline = jiffies + usecs_to_jiffies(timeout_us);
> +	struct Scsi_Host *host = hba->host;
> +	struct scsi_device *sdev;
> +	long timeout;
> +
>   	/*
> -	 * make sure that there are no outstanding requests when
> -	 * clock scaling is in progress
> +	 * Hold scan_mutex to prevent that SCSI devices are added or removed
> +	 * while this function is in progress.
>   	 */
> -	mutex_lock(&hba->host->scan_mutex);
> -	blk_mq_quiesce_tagset(&hba->host->tag_set);
> +	mutex_lock(&host->scan_mutex);
>   	mutex_lock(&hba->wb_mutex);
>   	down_write(&hba->clk_scaling_lock);
> +	/* Call ufshcd_hold() to serialize clock gating and clock scaling. */
> +	ufshcd_hold(hba);
>   
>   	if (!hba->clk_scaling.is_allowed ||
> -	    ufshcd_wait_for_doorbell_clr(hba, timeout_us)) {
> -		ret = -EBUSY;
> -		up_write(&hba->clk_scaling_lock);
> -		mutex_unlock(&hba->wb_mutex);
> -		blk_mq_unquiesce_tagset(&hba->host->tag_set);
> -		mutex_unlock(&hba->host->scan_mutex);
> +	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
>   		goto out;
> +
> +	blk_freeze_queue_start(hba->tmf_queue);
> +	shost_for_each_device(sdev, host)
> +		blk_freeze_queue_start(sdev->request_queue);
> +
> +	/*
> +	 * Calling synchronize_*rcu_expedited() reduces the wait time from
> +	 * milliseconds to less than a microsecond. See also
> +	 * https://paulmck.livejournal.com/67547.html.
> +	 */
> +	if (host->tag_set.flags & BLK_MQ_F_BLOCKING)
> +		synchronize_srcu_expedited(host->tag_set.srcu);
> +	else
> +		synchronize_rcu_expedited();
> +
> +	timeout = deadline - jiffies;
> +	if (timeout <= 0 ||
> +	    blk_mq_freeze_queue_wait_timeout(hba->tmf_queue, timeout) <= 0)
> +		goto unfreeze;
> +	shost_for_each_device(sdev, host) {
> +		timeout = deadline - jiffies;
> +		if (timeout <= 0 ||
> +		    blk_mq_freeze_queue_wait_timeout(sdev->request_queue,
> +						     timeout) <= 0) {
> +			goto unfreeze;
> +		}
>   	}
>   
> -	/* let's not get into low power until clock scaling is completed */
> -	ufshcd_hold(hba);
> +	return 0;
> +
> +unfreeze:
> +	blk_mq_unfreeze_queue_nomemrestore(hba->tmf_queue);
> +	shost_for_each_device(sdev, host)
> +		blk_mq_unfreeze_queue_nomemrestore(sdev->request_queue);
> +
> +	dev_err(hba->dev, "%s timed out\n", __func__);
>   
>   out:
> -	return ret;
> +	ufshcd_release(hba);
> +	up_write(&hba->clk_scaling_lock);
> +	mutex_unlock(&hba->wb_mutex);
> +	mutex_unlock(&host->scan_mutex);
> +
> +	return -EBUSY;
>   }
>   
>   static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err)
> +	__releases(hba->host->scan_mutex)
> +	__releases(hba->wb_mutex)
> +	__releases(hba->clk_scaling_lock)
>   {
> +	struct scsi_device *sdev;
> +
> +	blk_mq_unfreeze_queue_nomemrestore(hba->tmf_queue);
> +	shost_for_each_device(sdev, hba->host)
> +		blk_mq_unfreeze_queue_nomemrestore(sdev->request_queue);
> +
> +	ufshcd_release(hba);
>   	up_write(&hba->clk_scaling_lock);
>   
>   	/* Enable Write Booster if current gear requires it else disable it */
> @@ -1428,10 +1397,7 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err)
>   		ufshcd_wb_toggle(hba, hba->pwr_info.gear_rx >= hba->clk_scaling.wb_gear);
>   
>   	mutex_unlock(&hba->wb_mutex);
> -
> -	blk_mq_unquiesce_tagset(&hba->host->tag_set);
>   	mutex_unlock(&hba->host->scan_mutex);
> -	ufshcd_release(hba);
>   }
>   
>   /**
> 
