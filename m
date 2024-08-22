Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AA617C217
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 23:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724369689; cv=none; b=M1SZuvKixqQHfnAx/3rsxKXwshLx1XjOyBi1G+0Cfl4lK/7Yrne8wN1k2Ij3Zhel5dk8prfFQRrm212Ntm+/d24trFU/apPnM5I6SHXXZ2q0/dbmrIoonX81+hBBlXzokSBpvU7mTmQMkTnsvGNIURaJyeiFz7GlVmIvAD3y69Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724369689; c=relaxed/simple;
	bh=7z8+7hD4wMMctXwoS37km27HpEABRwcyGdbqvctvO48=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=q9bso08z5pDd5uXJ8IHyXenp/YnzlyizwgdprGyTBWzL+GKYZq29MbXH2MkUHl9rNhMBFWoJ+tul5hp6xRr7nhSweXrDcc2lNhzw5Yez37AWwe8DW8Dd5eCnqjeFeVqmTMHUXhpLX2LKSunKfA6ssX8WpqyiLrMvdV44ZLCml2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=dvSwQLWP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="dvSwQLWP"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47MMSlWQ031755;
	Thu, 22 Aug 2024 23:34:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tWMbhE+I6G7klYSCy9D2x9I5gjzwji6q4ti/bHLZQMs=; b=dvSwQLWPdVF5wSJr
	pvIF3atXPHxpb3bWNythKFL1zjBPljekR82ydipRquyCqcrVSptqFn7n8Q1HtsLe
	22MCyRUe34A0wvpsnsFR0pNvu1RqRuQS4pyK5LlztEUPntF0TEPOQyGY7yDkZaAK
	2zSeboTA0Rug+UCK3PcgW7vcYgA0HlB289H86vwy7VF0MWcN5XeF8JhKhHVZNu5T
	2uf1Z5wOd0M/3IMPqTOJnpoVmWk1zSKkkPQWp38WmSxVGo75FupwfFrD85eBQNXA
	zOcpJ+wCabl2Zr5p1rBPMUnY55YERTxdj1t2Jp/nNwLeCodVjnvv/z4QKrttWNjy
	DgOE+g==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 415nrrut3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Aug 2024 23:34:17 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47MNYGiX009844
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Aug 2024 23:34:16 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 22 Aug
 2024 16:34:16 -0700
Message-ID: <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
Date: Thu, 22 Aug 2024 16:34:15 -0700
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
X-Proofpoint-ORIG-GUID: ILJDUkvcWkIrb-ZNNp7a4V0dIvh334ao
X-Proofpoint-GUID: ILJDUkvcWkIrb-ZNNp7a4V0dIvh334ao
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-22_15,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408220177

On 8/21/2024 11:29 AM, Bart Van Assche wrote:
> Accessing a host controller register after the host controller has
> entered the hibernation state may cause the host controller to exit the
> hibernation state. Hence rework the hibernation entry code such that it
> does not modify the interrupt enabled status. This patch relies on the
> following:
> * If an UIC command is submitted that should be completed by the UIC
>    command completion interrupt, hba->uic_async_done == NULL.
> * If an UIC command is submitted that should be completed by the power
>    mode change interrupt or by a hibernation state change interrupt,
>    hba->uic_async_done != NULL.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 22 ++++++----------------
>   include/ufs/ufshcd.h      |  7 ++++---
>   2 files changed, 10 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index d0ae6e50becc..e12f30b8a83c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2585,6 +2585,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
>   	ufshcd_hold(hba);
>   	mutex_lock(&hba->uic_cmd_mutex);
>   	ufshcd_add_delay_before_dme_cmd(hba);
> +	WARN_ON(hba->uic_async_done);
>   
>   	ret = __ufshcd_send_uic_cmd(hba, uic_cmd, true);
>   	if (!ret)
> @@ -4255,7 +4256,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
>   	unsigned long flags;
>   	u8 status;
>   	int ret;
> -	bool reenable_intr = false;
>   
>   	mutex_lock(&hba->uic_cmd_mutex);
>   	ufshcd_add_delay_before_dme_cmd(hba);
> @@ -4266,15 +4266,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
>   		goto out_unlock;
>   	}
>   	hba->uic_async_done = &uic_async_done;
> -	if (ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
> -		ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
> -		/*
> -		 * Make sure UIC command completion interrupt is disabled before
> -		 * issuing UIC command.
> -		 */
> -		ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
> -		reenable_intr = true;
> -	}
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   	ret = __ufshcd_send_uic_cmd(hba, cmd, false);
>   	if (ret) {
> @@ -4318,8 +4309,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
>   	spin_lock_irqsave(hba->host->host_lock, flags);
>   	hba->active_uic_cmd = NULL;
>   	hba->uic_async_done = NULL;
> -	if (reenable_intr)
> -		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
>   	if (ret) {
>   		ufshcd_set_link_broken(hba);
>   		ufshcd_schedule_eh_work(hba);
> @@ -5472,11 +5461,12 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
>   		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
>   
>   	if (intr_status & UIC_COMMAND_COMPL && cmd) {

Let's consider this corner case. I am not sure if it's a valid concern, 
but it is a corner case that the extra interrupt (new behavior 
introduced by this patch) may bring.

Let's say you are sending a ufshcd_uic_pwr_ctrl() command. You will get 
2 uic completion interrupts:
[1] ufshcd_uic_cmd_compl() is called for the first interrupt which 
happens to be UFSHCD_UIC_PWR_MASK only. At the end of the 
ufshcd_uic_pwr_ctrl(), you would set the hba->active_uic_cmd to NULL.
[2]The second uic completion interrupt for UIC_COMMAND_COMP is delayed.
This interrupt is newly introduced by this patch.

Now let's say you have a new UIC command coming via 
ufshcd_send_uic_cmd(). The ufshcd_dispatch_uic_cmd() will update your 
hba->active_uic_cmd to the new uic_cmd.

The delayed interrupt mentioned in [2] arrives late. The 
ufshcd_uic_cmd_compl() is called. In this scenario, this check here may 
return true "if (intr_status & UIC_COMMAND_COMPL && cmd) {..}"

Now, the ufshcd_uic_cmd_compl() would proceed to complete the 
UIC_COMMAND_COMPL interrupt for the new command intended for the 
previous "old" uic command.

Thanks, Bao

> -		cmd->argument2 |= ufshcd_get_uic_cmd_result(hba);
> -		cmd->argument3 = ufshcd_get_dme_attr_val(hba);
> -		if (!hba->uic_async_done)
> +		if (!hba->uic_async_done) {
> +			cmd->argument2 |= ufshcd_get_uic_cmd_result(hba);
> +			cmd->argument3 = ufshcd_get_dme_attr_val(hba);
>   			cmd->cmd_active = 0;
> -		complete(&cmd->done);
> +			complete(&cmd->done);
> +		}
>   		retval = IRQ_HANDLED;
>   	}
>   
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index a43b14276bc3..0577013a4611 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -868,9 +868,10 @@ enum ufshcd_mcq_opr {
>    * @tmf_tag_set: TMF tag set.
>    * @tmf_queue: Used to allocate TMF tags.
>    * @tmf_rqs: array with pointers to TMF requests while these are in progress.
> - * @active_uic_cmd: handle of active UIC command
> - * @uic_cmd_mutex: mutex for UIC command
> - * @uic_async_done: completion used during UIC processing
> + * @active_uic_cmd: active UIC command pointer.
> + * @uic_cmd_mutex: mutex used to serialize UIC command processing.
> + * @uic_async_done: completion used to wait for power mode or hibernation state
> + *	changes.
>    * @ufshcd_state: UFSHCD state
>    * @eh_flags: Error handling flags
>    * @intr_mask: Interrupt Mask Bits
> 

