Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=64.68.200.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202350;
	b=eL4IKdKdQRLoYJmclbsC6G+fMvetOUwWdhCv9jJV8XaqWYoU4GC6V52ITp/ewvTusACb
	 LNqlCZr7kQh+Yr2OcMT6nPMWb/54Q33mamEHLETtmeC+7zyNwzlZzhXIdLqFl2lb7R8Vh
	 umMuX0jIzWOdQz0rsUy2t+oPI+VeKr+4KebVIMkWQs/OmvtHklqWdec6OquiZ07FEdnfL
	 dLD1FOhFLneAbolRGXNDtIUwP5c6Y+LOK3XFHyqLyClLiaIcYDIE510TaZrufyaTqfAkK
	 p8V/fct0/j6tDqlNE5OcDxdb2GYjEaC7k/xjNZXVadPRyYYxQMgAaQmap5Atz163sjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202350;
	h=DMARC-Filter:Received:Received:DKIM-Signature:X-Virus-Scanned:
	 Received:Received:DKIM-Signature:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Reply-To:Subject:To:Cc:References:From:
	 Content-Language:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=WwQVlZHVzAfY3mEXsVrF6T2UrGTIl/6KBhHBS1lJ9xg=;
	b=2QaOGfz1xLiAXu6usOWjvtCcdGYW791ygDGXyuJ/MXx2pBliwVgmn6F2+Pn62LfvPp7Q
	 M6ubv0iMxw8y+0NZvmWBgQLFM5C5CIUGuoZoL80ux0KkD2lPSrPkOAvaNs3I+fxSZvc56
	 GOkNH2V4vhSs4wx70lQGWgQsHwN0GNoRn5SvscMzZyW+2iCcjhRB5hqo/aM9x1eco9HuX
	 tZ919IB/wCLAgdTHiL6/ywgSdLFvBUcsuSdaLBVP2pSGYgtZ/o970GPu9x9chyR2cfRCX
	 mTOiT+ttkvbFMn5HirDvR2GMRjadrCvn7rIcwjZknBMOQwjzKHtDcWXP90Msu3E/tiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gonehiking.org;
	spf=pass smtp.mailfrom=gonehiking.org;
	dkim=pass header.d=gonehiking.org header.i=@gonehiking.org header.a=rsa-sha256 header.s=easymail header.b=HB28GRDp;
	dkim=pass header.d=gonehiking.org header.i=@gonehiking.org header.a=rsa-sha256 header.s=easymail header.b=jmqeftvP;
	arc=none smtp.remote-ip=64.68.200.34
Received: from outbound.easymail.ca (outbound.easymail.ca [64.68.200.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2857606A329
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 15:45:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2857606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gonehiking.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gonehiking.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gonehiking.org header.i=@gonehiking.org header.a=rsa-sha256 header.s=easymail header.b=HB28GRDp;
	dkim=pass (2048-bit key) header.d=gonehiking.org header.i=@gonehiking.org header.a=rsa-sha256 header.s=easymail header.b=jmqeftvP
Received: from mailout.easymail.ca (pco.easydns.net [64.68.203.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by outbound.easymail.ca (Postfix) with ESMTPS id 2D3B320ACE;
	Wed, 28 Oct 2026 15:45:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mailout.easymail.ca (Postfix) with ESMTP id 1AAF860D1B;
	Wed, 28 Oct 2026 15:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gonehiking.org;
	s=easymail; t=1793202343;
	bh=WwQVlZHVzAfY3mEXsVrF6T2UrGTIl/6KBhHBS1lJ9xg=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HB28GRDpLDPvjGQqaKVOnF+zB1qziuMqjacBod2WYWMIZe9J/5aiHBNZA/hFfgmWK
	 AAfXphJr8nS4dAjS5HJCdBKW9NFG2n5MhTf5n4vsKzvEmDFHXnfTSd8RdV1Ldr6c+k
	 VPByMqcHwVX5kE/namnM7fjGBge4TL6sbI80QYjNGvhxE+vgfbgZWzpZHIYflf+a2I
	 LmM41rQOvHwTU5UsmtMPP0/YwccU/JMBCP2jgnBFVmwriA2vTFhlgdv2N6f8yHmsEj
	 sbDjJzX9XnMSKASSBER4BxqilFZdwoKE07AL8TuJhXTzkEnQ/Q8tkHzF0i7k1XDwJX
	 Ta4iTWkPpRu9Q==
X-Virus-Scanned: Debian amavisd-new at emo09-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
	by localhost (emo09-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DIG8KVX5uqrZ; Wed, 28 Oct 2026 15:45:42 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by mailout.easymail.ca (Postfix) with ESMTPSA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gonehiking.org;
	s=easymail; t=1793202342;
	bh=WwQVlZHVzAfY3mEXsVrF6T2UrGTIl/6KBhHBS1lJ9xg=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jmqeftvPvDlGOBWT7r92sutGqRTJqKw/Cdy9BxKd0C7z0A2N2y4GNZq+Re8PjLVYu
	 gkMkbzs+0xpsf3xpmzYbH7SaF68dQkjeOFytelGhtcq2fko44GaLsp3ipvHSIKDrDr
	 6Aivk3XrpAWfwnRNO2AvQqSK7iQZ+f2QAcNLaGZhhYosJsMY5jZPFlnh6d2xzN+k5t
	 pFXzjk6OG/2DNCAQbZPONooCDDIzDTw8eXiJXHW73AueX9SNQo6/OLGbhrnhbbolj5
	 cd61rmdT5UCCQinrpirwWlV7yNvJwhpQo7ZsCLBSBhKNIQRP/RSPdWIJsoz8NGWqTp
	 q/Aaeq7JtdP3Q==
Received: from [127.0.0.1] (localhost [127.0.0.1]) by mailout.easymail.ca (Postfix) with ESMTPSA
Message-ID: <10f06b90-1012-401b-93b5-331d487973ab@gonehiking.org>
Date: Wed, 28 Oct 2026 09:45:40 -0600
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: khalid@gonehiking.org
Subject: Re: [PATCH v4 04/54] scsi: BusLogic: Pass the host pointer directly
 to several functions
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <cover.1790360262.git.bvanassche@acm.org>
 <09e99ec9c6fa24ee5fe3c47110c88a1be076e01a.1790360262.git.bvanassche@acm.org>
From: Khalid Aziz <khalid@gonehiking.org>
Content-Language: en-US
Autocrypt: addr=khalid@gonehiking.org; keydata=
 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
In-Reply-To: <09e99ec9c6fa24ee5fe3c47110c88a1be076e01a.1790360262.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/26 12:25 PM, Bart Van Assche wrote:
> Pass the struct Scsi_Host pointer directly to multiple functions. This
> prepares the BusLogic driver for enabling compiler-based lock context
> analysis. No functionality has been changed.
> 
> Cc: Khalid Aziz <khalid@gonehiking.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/BusLogic.c | 93 +++++++++++++++++++++++------------------
>   drivers/scsi/BusLogic.h |  2 +-
>   2 files changed, 54 insertions(+), 41 deletions(-)
> 

Hi Bert,

Sorry about the delay in picking this back up.

I looked at a few other ways of accomplishing what you are trying to do and 
those result in more code churn than I would like. This might be the least 
disruptive. I found that MPT Fusion and FCoE drivers also define their 
queuecommand functions without using DEF_SCSI_QCMD(). These are very 
commonly used drivers so that makes me feel more comfortable with the 
change you are proposing. I am ok with this change:

Acked-by: Khalid Aziz <khalid@gonehiking.org>

--
Khalid

> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 27b446c0c5d0..75aaf35383a9 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -276,8 +276,9 @@ static void blogic_create_addlccbs(struct blogic_adapter *adapter,
>     Lock should already have been acquired by the caller.
>   */
>   
> -static struct blogic_ccb *blogic_alloc_ccb(struct blogic_adapter *adapter)
> +static struct blogic_ccb *blogic_alloc_ccb(struct Scsi_Host *host)
>   {
> +	struct blogic_adapter *adapter = (void *)host->hostdata;
>   	static unsigned long serial;
>   	struct blogic_ccb *ccb;
>   	ccb = adapter->free_ccbs;
> @@ -307,7 +308,8 @@ static struct blogic_ccb *blogic_alloc_ccb(struct blogic_adapter *adapter)
>     caller.
>   */
>   
> -static void blogic_dealloc_ccb(struct blogic_ccb *ccb, int dma_unmap)
> +static void blogic_dealloc_ccb(struct Scsi_Host *host, struct blogic_ccb *ccb,
> +			       int dma_unmap)
>   {
>   	struct blogic_adapter *adapter = ccb->adapter;
>   
> @@ -2596,8 +2598,10 @@ static void blogic_scan_inbox(struct blogic_adapter *adapter)
>     should already have been acquired by the caller.
>   */
>   
> -static void blogic_process_ccbs(struct blogic_adapter *adapter)
> +static void blogic_process_ccbs(struct Scsi_Host *host)
>   {
> +	struct blogic_adapter *adapter = (void *)host->hostdata;
> +
>   	if (adapter->processing_ccbs)
>   		return;
>   	adapter->processing_ccbs = true;
> @@ -2621,7 +2625,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
>   			/*
>   			   Place CCB back on the Host Adapter's free list.
>   			 */
> -			blogic_dealloc_ccb(ccb, 1);
> +			blogic_dealloc_ccb(host, ccb, 1);
>   #if 0			/* this needs to be redone different for new EH */
>   			/*
>   			   Bus Device Reset CCBs have the command field
> @@ -2650,7 +2654,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
>   				if (ccb->status == BLOGIC_CCB_RESET &&
>   						ccb->tgt_id == tgt_id) {
>   					command = ccb->command;
> -					blogic_dealloc_ccb(ccb, 1);
> +					blogic_dealloc_ccb(host, ccb, 1);
>   					adapter->active_cmds[tgt_id]--;
>   					command->result = DID_RESET << 16;
>   					scsi_done(command);
> @@ -2721,7 +2725,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
>   			/*
>   			   Place CCB back on the Host Adapter's free list.
>   			 */
> -			blogic_dealloc_ccb(ccb, 1);
> +			blogic_dealloc_ccb(host, ccb, 1);
>   			/*
>   			   Call the SCSI Command Completion Routine.
>   			 */
> @@ -2740,11 +2744,12 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
>   static irqreturn_t blogic_inthandler(int irq_ch, void *devid)
>   {
>   	struct blogic_adapter *adapter = (struct blogic_adapter *) devid;
> +	struct Scsi_Host *host = adapter->scsi_host;
>   	unsigned long processor_flag;
>   	/*
>   	   Acquire exclusive access to Host Adapter.
>   	 */
> -	spin_lock_irqsave(&adapter->scsi_host->host_lock, processor_flag);
> +	spin_lock_irqsave(&host->host_lock, processor_flag);
>   	/*
>   	   Handle Interrupts appropriately for each Host Adapter type.
>   	 */
> @@ -2794,25 +2799,25 @@ static irqreturn_t blogic_inthandler(int irq_ch, void *devid)
>   	   Process any completed CCBs.
>   	 */
>   	if (adapter->firstccb != NULL)
> -		blogic_process_ccbs(adapter);
> +		blogic_process_ccbs(host);
>   	/*
>   	   Reset the Host Adapter if requested.
>   	 */
>   	if (adapter->adapter_extreset) {
>   		blogic_warn("Resetting %s due to External SCSI Bus Reset\n", adapter, adapter->full_model);
>   		blogic_inc_count(&adapter->ext_resets);
> -		blogic_resetadapter(adapter, false);
> +		blogic_resetadapter(host, false);
>   		adapter->adapter_extreset = false;
>   	} else if (adapter->adapter_intern_err) {
>   		blogic_warn("Resetting %s due to Host Adapter Internal Error\n", adapter, adapter->full_model);
>   		blogic_inc_count(&adapter->adapter_intern_errors);
> -		blogic_resetadapter(adapter, true);
> +		blogic_resetadapter(host, true);
>   		adapter->adapter_intern_err = false;
>   	}
>   	/*
>   	   Release exclusive access to Host Adapter.
>   	 */
> -	spin_unlock_irqrestore(&adapter->scsi_host->host_lock, processor_flag);
> +	spin_unlock_irqrestore(&host->host_lock, processor_flag);
>   	return IRQ_HANDLED;
>   }
>   
> @@ -2823,9 +2828,10 @@ static irqreturn_t blogic_inthandler(int irq_ch, void *devid)
>     already have been acquired by the caller.
>   */
>   
> -static bool blogic_write_outbox(struct blogic_adapter *adapter,
> +static bool blogic_write_outbox(struct Scsi_Host *host,
>   		enum blogic_action action, struct blogic_ccb *ccb)
>   {
> +	struct blogic_adapter *adapter = (void *)host->hostdata;
>   	struct blogic_outbox *next_outbox;
>   
>   	next_outbox = adapter->next_outbox;
> @@ -2859,17 +2865,16 @@ static int blogic_hostreset(struct scsi_cmnd *SCpnt)
>   {
>   	struct blogic_adapter *adapter =
>   		(struct blogic_adapter *) SCpnt->device->host->hostdata;
> -
> +	struct Scsi_Host *shost = adapter->scsi_host;
>   	unsigned int id = SCpnt->device->id;
>   	struct blogic_tgt_stats *stats = &adapter->tgt_stats[id];
>   	int rc;
>   
> -	spin_lock_irq(&SCpnt->device->host->host_lock);
> -
> +	spin_lock_irq(&shost->host_lock);
>   	blogic_inc_count(&stats->adapter_reset_req);
> +	rc = blogic_resetadapter(shost, false);
> +	spin_unlock_irq(&shost->host_lock);
>   
> -	rc = blogic_resetadapter(adapter, false);
> -	spin_unlock_irq(&SCpnt->device->host->host_lock);
>   	return rc;
>   }
>   
> @@ -2878,11 +2883,11 @@ static int blogic_hostreset(struct scsi_cmnd *SCpnt)
>     Outgoing Mailbox for execution by the associated Host Adapter.
>   */
>   
> -static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
> +static enum scsi_qc_status blogic_qcmd_lck(struct Scsi_Host *shost, struct scsi_cmnd *command)
>   {
>   	void (*comp_cb)(struct scsi_cmnd *) = scsi_done;
>   	struct blogic_adapter *adapter =
> -		(struct blogic_adapter *) command->device->host->hostdata;
> +		(struct blogic_adapter *) shost->hostdata;
>   	struct blogic_tgt_flags *tgt_flags =
>   		&adapter->tgt_flags[command->device->id];
>   	struct blogic_tgt_stats *tgt_stats = adapter->tgt_stats;
> @@ -2913,12 +2918,12 @@ static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
>   	   probably hung so signal an error as a Host Adapter Hard Reset
>   	   should be initiated soon.
>   	 */
> -	ccb = blogic_alloc_ccb(adapter);
> +	ccb = blogic_alloc_ccb(shost);
>   	if (ccb == NULL) {
> -		spin_unlock_irq(&adapter->scsi_host->host_lock);
> +		spin_unlock_irq(&shost->host_lock);
>   		blogic_delay(1);
> -		spin_lock_irq(&adapter->scsi_host->host_lock);
> -		ccb = blogic_alloc_ccb(adapter);
> +		spin_lock_irq(&shost->host_lock);
> +		ccb = blogic_alloc_ccb(shost);
>   		if (ccb == NULL) {
>   			command->result = DID_ERROR << 16;
>   			comp_cb(command);
> @@ -3046,7 +3051,7 @@ static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
>   	if (dma_mapping_error(&adapter->pci_device->dev, sense_buf)) {
>   		blogic_err("DMA mapping for sense data buffer failed\n",
>   				adapter);
> -		blogic_dealloc_ccb(ccb, 0);
> +		blogic_dealloc_ccb(shost, ccb, 0);
>   		return SCSI_MLQUEUE_HOST_BUSY;
>   	}
>   	ccb->sensedata = sense_buf;
> @@ -3061,15 +3066,15 @@ static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
>   		   so signal an error as a Host Adapter Hard Reset should
>   		   be initiated soon.
>   		 */
> -		if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START, ccb)) {
> -			spin_unlock_irq(&adapter->scsi_host->host_lock);
> +		if (!blogic_write_outbox(shost, BLOGIC_MBOX_START, ccb)) {
> +			spin_unlock_irq(&shost->host_lock);
>   			blogic_warn("Unable to write Outgoing Mailbox - Pausing for 1 second\n", adapter);
>   			blogic_delay(1);
> -			spin_lock_irq(&adapter->scsi_host->host_lock);
> -			if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START,
> +			spin_lock_irq(&shost->host_lock);
> +			if (!blogic_write_outbox(shost, BLOGIC_MBOX_START,
>   						ccb)) {
>   				blogic_warn("Still unable to write Outgoing Mailbox - Host Adapter Dead?\n", adapter);
> -				blogic_dealloc_ccb(ccb, 1);
> +				blogic_dealloc_ccb(shost, ccb, 1);
>   				command->result = DID_ERROR << 16;
>   				scsi_done(command);
>   			}
> @@ -3089,12 +3094,20 @@ static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
>   		   pending.
>   		 */
>   		if (ccb->status == BLOGIC_CCB_COMPLETE)
> -			blogic_process_ccbs(adapter);
> +			blogic_process_ccbs(shost);
>   	}
>   	return 0;
>   }
>   
> -static DEF_SCSI_QCMD(blogic_qcmd)
> +static enum scsi_qc_status blogic_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
> +{
> +	enum scsi_qc_status rc;
> +
> +	spin_lock_irq(&shost->host_lock);
> +	rc = blogic_qcmd_lck(shost, cmd);
> +	spin_unlock_irq(&shost->host_lock);
> +	return rc;
> +}
>   
>   #if 0
>   /*
> @@ -3103,9 +3116,8 @@ static DEF_SCSI_QCMD(blogic_qcmd)
>   
>   static int blogic_abort(struct scsi_cmnd *command)
>   {
> -	struct blogic_adapter *adapter =
> -		(struct blogic_adapter *) command->device->host->hostdata;
> -
> +	struct Scsi_Host *const shost = command->device->host;
> +	struct blogic_adapter *adapter = (void *) shost->hostdata;
>   	int tgt_id = command->device->id;
>   	struct blogic_ccb *ccb;
>   	blogic_inc_count(&adapter->tgt_stats[tgt_id].aborts_request);
> @@ -3144,7 +3156,7 @@ static int blogic_abort(struct scsi_cmnd *command)
>   				adapter->fw_ver[0] < '5') {
>   			blogic_warn("Unable to Abort CCB #%ld to Target %d - Abort Tag Not Supported\n", adapter, ccb->serial, tgt_id);
>   			return FAILURE;
> -		} else if (blogic_write_outbox(adapter, BLOGIC_MBOX_ABORT,
> +		} else if (blogic_write_outbox(shost, BLOGIC_MBOX_ABORT,
>   					ccb)) {
>   			blogic_warn("Aborting CCB #%ld to Target %d\n",
>   					adapter, ccb->serial, tgt_id);
> @@ -3169,7 +3181,7 @@ static int blogic_abort(struct scsi_cmnd *command)
>   		   may still be pending.
>   		 */
>   		if (ccb->status == BLOGIC_CCB_COMPLETE)
> -			blogic_process_ccbs(adapter);
> +			blogic_process_ccbs(shost);
>   		return SUCCESS;
>   	}
>   	return SUCCESS;
> @@ -3181,8 +3193,9 @@ static int blogic_abort(struct scsi_cmnd *command)
>     currently executing SCSI Commands as having been Reset.
>   */
>   
> -static int blogic_resetadapter(struct blogic_adapter *adapter, bool hard_reset)
> +static int blogic_resetadapter(struct Scsi_Host *host, bool hard_reset)
>   {
> +	struct blogic_adapter *adapter = (void *)host->hostdata;
>   	struct blogic_ccb *ccb;
>   	int tgt_id;
>   
> @@ -3203,7 +3216,7 @@ static int blogic_resetadapter(struct blogic_adapter *adapter, bool hard_reset)
>   
>   	for (ccb = adapter->all_ccbs; ccb != NULL; ccb = ccb->next_all)
>   		if (ccb->status == BLOGIC_CCB_ACTIVE)
> -			blogic_dealloc_ccb(ccb, 1);
> +			blogic_dealloc_ccb(host, ccb, 1);
>   	/*
>   	 * Wait a few seconds between the Host Adapter Hard Reset which
>   	 * initiates a SCSI Bus Reset and issuing any SCSI Commands.  Some
> @@ -3212,9 +3225,9 @@ static int blogic_resetadapter(struct blogic_adapter *adapter, bool hard_reset)
>   	 */
>   
>   	if (hard_reset) {
> -		spin_unlock_irq(&adapter->scsi_host->host_lock);
> +		spin_unlock_irq(&host->host_lock);
>   		blogic_delay(adapter->bus_settle_time);
> -		spin_lock_irq(&adapter->scsi_host->host_lock);
> +		spin_lock_irq(&host->host_lock);
>   	}
>   
>   	for (tgt_id = 0; tgt_id < adapter->maxdev; tgt_id++) {
> diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
> index 24697a5bedc8..6ace3c307a90 100644
> --- a/drivers/scsi/BusLogic.h
> +++ b/drivers/scsi/BusLogic.h
> @@ -1279,7 +1279,7 @@ static int blogic_sdev_configure(struct scsi_device *,
>   				 struct queue_limits *lim);
>   static void blogic_qcompleted_ccb(struct blogic_ccb *);
>   static irqreturn_t blogic_inthandler(int, void *);
> -static int blogic_resetadapter(struct blogic_adapter *, bool hard_reset);
> +static int blogic_resetadapter(struct Scsi_Host *host, bool hard_reset);
>   static void blogic_msg(enum blogic_msglevel, char *, struct blogic_adapter *, ...);
>   static int __init blogic_setup(char *);
>   

