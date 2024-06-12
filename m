Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E7484A22;
	Wed, 12 Jun 2024 08:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718181226; cv=none; b=iIdbp2xJSC+BMXBhiDEFb0ibCFNvZONoOfhMGic3gNFI/D11oMQ8BUc+Rcw8dQ1GgzOTREYf+je21YZcAEnBHakTJPwaeIwrRzgW3suMw5uHjkiH020rNadIR23xEITEGj7ASbcWGSef7LDQSAdhFakgP6zK+qXzZ35iA6+l3HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718181226; c=relaxed/simple;
	bh=SuEdPAV6zFASfN6QuboL4vVbuP0MOntQ0ttRpzAV9so=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=o2womhZBgM6wg2rIpOn3DCMj3aeE0yj9aUU5Vj/PpmKDNgOjilGH1bd1CGwlemDpVarOqECUCAkMWn3nCUhPHKO0TjDpnM0Go1ow05MUPT7XI0+0to4MZu1K6BWTGr8eGPIljIv4EUKmNRTpFZt4sKJb5kke/ge5Izegp8IdxlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=t1AnBKfU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=t8nVDWOx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=t1AnBKfU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=t8nVDWOx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="t1AnBKfU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="t8nVDWOx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="t1AnBKfU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="t8nVDWOx"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D5432226A9;
	Wed, 12 Jun 2024 08:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718181222; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ueJMaSkE900pfLLr+27qj+1ZIC482XYU/yIHmHljQ/4=;
	b=t1AnBKfUF2RsbukpwJEfKaR1aPiqW1F1d+/Q0r/QLz8lTJKWhEUL+idN6Lh9dfM8EFHgq6
	FvLqysXp7HuSSgb6vtaFelblMCdh3cz+DYfxaXmpKWbsKaZluoquULwdo/zKjCh0WpSJSd
	ILFxKeGod39vM2r9OVcHeKNh0SXOxdw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718181222;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ueJMaSkE900pfLLr+27qj+1ZIC482XYU/yIHmHljQ/4=;
	b=t8nVDWOxFes9cP2i9pSMJXoLhEbVHkPGibpmfF4ugEBpcQU0ghtUHo2DFJz56jxndOrJsX
	dAHfi2ie+JB4tyCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718181222; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ueJMaSkE900pfLLr+27qj+1ZIC482XYU/yIHmHljQ/4=;
	b=t1AnBKfUF2RsbukpwJEfKaR1aPiqW1F1d+/Q0r/QLz8lTJKWhEUL+idN6Lh9dfM8EFHgq6
	FvLqysXp7HuSSgb6vtaFelblMCdh3cz+DYfxaXmpKWbsKaZluoquULwdo/zKjCh0WpSJSd
	ILFxKeGod39vM2r9OVcHeKNh0SXOxdw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718181222;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ueJMaSkE900pfLLr+27qj+1ZIC482XYU/yIHmHljQ/4=;
	b=t8nVDWOxFes9cP2i9pSMJXoLhEbVHkPGibpmfF4ugEBpcQU0ghtUHo2DFJz56jxndOrJsX
	dAHfi2ie+JB4tyCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C019C1372E;
	Wed, 12 Jun 2024 08:33:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UnetLGZdaWZGXgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 12 Jun 2024 08:33:42 +0000
Message-ID: <3b24ef4a-996b-4a8b-89f3-385872573039@suse.de>
Date: Wed, 12 Jun 2024 10:33:42 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] scsi: core: Add new helper to iterate all devices
 of host
To: Wenchao Hao <haowenchao22@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240605091731.3111195-1-haowenchao22@gmail.com>
 <20240605091731.3111195-2-haowenchao22@gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240605091731.3111195-2-haowenchao22@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,HansenPartnership.com,oracle.com,vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]

On 6/5/24 11:17, Wenchao Hao wrote:
> shost_for_each_device() would skip devices which is in SDEV_CANCEL or
> SDEV_DEL state, for some scenarios, we donot want to skip these devices,
> so add a new macro shost_for_each_device_include_deleted() to handle it.
> 
> Following changes are introduced:
> 
> 1. Rework scsi_device_get(), add new helper __scsi_device_get() which
>     determine if skip deleted scsi_device by parameter "skip_deleted".
> 2. Add new parameter "skip_deleted" to __scsi_iterate_devices() which
>     is used when calling __scsi_device_get()
> 3. Update shost_for_each_device() to call __scsi_iterate_devices() with
>     "skip_deleted" true
> 4. Add new macro shost_for_each_device_include_deleted() which call
>     __scsi_iterate_devices() with "skip_deleted" false
> 
> Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
> ---
>   drivers/scsi/scsi.c        | 46 ++++++++++++++++++++++++++------------
>   include/scsi/scsi_device.h | 25 ++++++++++++++++++---
>   2 files changed, 54 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 3e0c0381277a..5913de543d93 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -735,20 +735,18 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
>   	return 0;
>   }
>   
> -/**
> - * scsi_device_get  -  get an additional reference to a scsi_device
> +/*
> + * __scsi_device_get  -  get an additional reference to a scsi_device
>    * @sdev:	device to get a reference to
> - *
> - * Description: Gets a reference to the scsi_device and increments the use count
> - * of the underlying LLDD module.  You must hold host_lock of the
> - * parent Scsi_Host or already have a reference when calling this.
> - *
> - * This will fail if a device is deleted or cancelled, or when the LLD module
> - * is in the process of being unloaded.
> + * @skip_deleted: when true, would return failed if device is deleted
>    */
> -int scsi_device_get(struct scsi_device *sdev)
> +static int __scsi_device_get(struct scsi_device *sdev, bool skip_deleted)
>   {
> -	if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL)
> +	/*
> +	 * if skip_deleted is true and device is in removing, return failed
> +	 */
> +	if (skip_deleted &&
> +	    (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL))
>   		goto fail;

Nack.
SDEV_DEL means the device is about to be deleted, so we _must not_ 
access it at all.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

