Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE1D16C86D;
	Wed, 12 Jun 2024 08:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718181302; cv=none; b=ERvn0MvzSuJZvU5DuriI2osUDgvE2r8WGmnnIo5lzOw5fwcRKVECU5TYyeXfEKB4ed97m3f3ZvfS0ZTLCUYZ8km1+rtd/9YYuS3WGb00LQM+yi7OF4YTpZ1cvKLd0KC6V7k8QuVd1sTbpE7kuYLm6WzGpYQsBYgw7qgAPEMo9zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718181302; c=relaxed/simple;
	bh=EmrSL3kSXUyeQL8xY73FfjAoGugX+WVDJ2EuF/58iTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Bcndo46RAQIlc3ucMalGEPYtV4Xoz0RDs+qxBnYJqqCoI5J6puaWtdY2sU12unnduwZhGzWlyOmBuBNQWns2tph9F01JbnaJ2HZDykPhmZkNNurLipBoNlE0/X+O7wEO8XeUfy4TFLv/Rut20FV8PYnKBCFcmKvj5RVsPlVPeyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VyWD2YzY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ttOl3drv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VyWD2YzY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ttOl3drv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VyWD2YzY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ttOl3drv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VyWD2YzY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ttOl3drv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 15E2034098;
	Wed, 12 Jun 2024 08:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718181299; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8LlGlipcreMWva2qU2h/snzS8eogdqZBY7PivNh3e0s=;
	b=VyWD2YzYdoApXe1YHgrvTmtMzYp6GICGmgQe+ZHta1eEEw4Jc++kF4Takknl1w6qA7le4r
	IiNoUTTYxG/tPX1N2GIPWo+0QIBpkP2K7DM0e8KlSRLEAOA3ukLUEnBGxF1Ey+JOZCgrOC
	/ybweWQiLCbjyFNaJJsu0ruSjc079H4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718181299;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8LlGlipcreMWva2qU2h/snzS8eogdqZBY7PivNh3e0s=;
	b=ttOl3drvovNZT8dNdQZd0u4XsPgbPmv4DEnk6whUf9FOKSqf9ZuurtDj//0SB9rzrkc2d6
	A2djXBeAFViN1hBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718181299; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8LlGlipcreMWva2qU2h/snzS8eogdqZBY7PivNh3e0s=;
	b=VyWD2YzYdoApXe1YHgrvTmtMzYp6GICGmgQe+ZHta1eEEw4Jc++kF4Takknl1w6qA7le4r
	IiNoUTTYxG/tPX1N2GIPWo+0QIBpkP2K7DM0e8KlSRLEAOA3ukLUEnBGxF1Ey+JOZCgrOC
	/ybweWQiLCbjyFNaJJsu0ruSjc079H4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718181299;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8LlGlipcreMWva2qU2h/snzS8eogdqZBY7PivNh3e0s=;
	b=ttOl3drvovNZT8dNdQZd0u4XsPgbPmv4DEnk6whUf9FOKSqf9ZuurtDj//0SB9rzrkc2d6
	A2djXBeAFViN1hBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 053B51372E;
	Wed, 12 Jun 2024 08:34:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PCvWALNdaWaYXgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 12 Jun 2024 08:34:59 +0000
Message-ID: <15f0fb9b-3b30-413d-9f30-81c246b6bae1@suse.de>
Date: Wed, 12 Jun 2024 10:34:54 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] scsi: scsi_error: Fix wrong statistic when print
 error info
To: Wenchao Hao <haowenchao22@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240605091731.3111195-1-haowenchao22@gmail.com>
 <20240605091731.3111195-3-haowenchao22@gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240605091731.3111195-3-haowenchao22@gmail.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]

On 6/5/24 11:17, Wenchao Hao wrote:
> shost_for_each_device() would skip devices which is in progress of
> removing, so commands of these devices would be ignored in
> scsi_eh_prt_fail_stats().
> 
> Fix this issue by using shost_for_each_device_include_deleted()
> to iterate devices in scsi_eh_prt_fail_stats().
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
> ---
>   drivers/scsi/scsi_error.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 612489afe8d2..a61fd8af3b1f 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -409,7 +409,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
>   	int cmd_cancel = 0;
>   	int devices_failed = 0;
>   
> -	shost_for_each_device(sdev, shost) {
> +	shost_for_each_device_include_deleted(sdev, shost) {
>   		list_for_each_entry(scmd, work_q, eh_entry) {
>   			if (scmd->device == sdev) {
>   				++total_failures;

That is wrong. We should rather add a failure counter to the SCSI host, 
and have the scsi device increase it every time a failure occurs.
Then we can avoid this loop completely.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

