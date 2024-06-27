Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF3E29CA;
	Thu, 27 Jun 2024 06:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719469542; cv=none; b=OB8BBTIRgIM1T6mHiDFOcc/FVZoE+LPyEaeqZIp1s4fAneGc95NEX/l5MUe5e4Ir07ttKKt2K6dJlVoQ/36Bhb1lkDgLJfcs+steMySnPZ9+46et9XTiN2Bv7ca+1FFrGEDAZ2IJ1sI6YzbaH0FAa3iIFd2TsUjKokoXoOZ0At8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719469542; c=relaxed/simple;
	bh=fsETAd+pArzYwEN6jXxEWFn5BoqDXOjL+x6+0LlYivw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KB3VLRTxDNRMXlgYbhAkuCZUitLkJ4pXbXZy4ps3dq/q9GsKX7/CayOptIXCE/dh8nlhpyApQO40l5DUKxgrV5zgGP/6QjVj4FhbEdg9PdOUHycoNvVIxWsMX/CUi3q75cepkf8arzH4XXOhBxFppzw/tXYfa5mZd7zjYeYEJSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2G9FWRZU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NDpWxsZz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2G9FWRZU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NDpWxsZz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2G9FWRZU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NDpWxsZz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2G9FWRZU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NDpWxsZz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9679B21B6E;
	Thu, 27 Jun 2024 06:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719469538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0UD65wwP++d01IcCJYPLs5ryPXZXmx88t3FecvqwqPk=;
	b=2G9FWRZUkcC+ggePueenIy99QL/nh2znIb1iRueMXiA8QlN2M38xjvXxnPUrp4hln2JN1Z
	BFszAEmHr5f6Ojx87DR9O9a4A4hTDHS2ILhQHitMphzZahHgT+2JMR1pH/NhDHQQUXeUdP
	2+C4vNcGJbvEX5DFEhjimoqydexpUMY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719469538;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0UD65wwP++d01IcCJYPLs5ryPXZXmx88t3FecvqwqPk=;
	b=NDpWxsZzPdZYI7Au5fwWRp2pmxol5KD0gwHEPl6n1HP1KftAJ8fcVAVCNNCqYKUZ6qqTo2
	U4chDQH1vnUEy8Ag==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719469538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0UD65wwP++d01IcCJYPLs5ryPXZXmx88t3FecvqwqPk=;
	b=2G9FWRZUkcC+ggePueenIy99QL/nh2znIb1iRueMXiA8QlN2M38xjvXxnPUrp4hln2JN1Z
	BFszAEmHr5f6Ojx87DR9O9a4A4hTDHS2ILhQHitMphzZahHgT+2JMR1pH/NhDHQQUXeUdP
	2+C4vNcGJbvEX5DFEhjimoqydexpUMY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719469538;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0UD65wwP++d01IcCJYPLs5ryPXZXmx88t3FecvqwqPk=;
	b=NDpWxsZzPdZYI7Au5fwWRp2pmxol5KD0gwHEPl6n1HP1KftAJ8fcVAVCNNCqYKUZ6qqTo2
	U4chDQH1vnUEy8Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6A031137DF;
	Thu, 27 Jun 2024 06:25:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OGysE+EFfWbJZwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Jun 2024 06:25:37 +0000
Message-ID: <dccae0ae-9c32-49b5-b242-42376593722a@suse.de>
Date: Thu, 27 Jun 2024 08:25:37 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/13] ata: libata-core: Fix double free on error
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 Colin Ian King <colin.i.king@gmail.com>, Tejun Heo <tj@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 stable@vger.kernel.org, linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-17-cassel@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240626180031.4050226-17-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.79
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]

On 6/26/24 20:00, Niklas Cassel wrote:
> If e.g. the ata_port_alloc() call in ata_host_alloc() fails, we will jump
> to the err_out label, which will call devres_release_group().
> devres_release_group() will trigger a call to ata_host_release().
> ata_host_release() calls kfree(host), so executing the kfree(host) in
> ata_host_alloc() will lead to a double free:
> 
> kernel BUG at mm/slub.c:553!
> Oops: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 11 PID: 599 Comm: (udev-worker) Not tainted 6.10.0-rc5 #47
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-2.fc40 04/01/2014
> RIP: 0010:kfree+0x2cf/0x2f0
> Code: 5d 41 5e 41 5f 5d e9 80 d6 ff ff 4d 89 f1 41 b8 01 00 00 00 48 89 d9 48 89 da
> RSP: 0018:ffffc90000f377f0 EFLAGS: 00010246
> RAX: ffff888112b1f2c0 RBX: ffff888112b1f2c0 RCX: ffff888112b1f320
> RDX: 000000000000400b RSI: ffffffffc02c9de5 RDI: ffff888112b1f2c0
> RBP: ffffc90000f37830 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffc90000f37610 R11: 617461203a736b6e R12: ffffea00044ac780
> R13: ffff888100046400 R14: ffffffffc02c9de5 R15: 0000000000000006
> FS:  00007f2f1cabe980(0000) GS:ffff88813b380000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f2f1c3acf75 CR3: 0000000111724000 CR4: 0000000000750ef0
> PKRU: 55555554
> Call Trace:
>   <TASK>
>   ? __die_body.cold+0x19/0x27
>   ? die+0x2e/0x50
>   ? do_trap+0xca/0x110
>   ? do_error_trap+0x6a/0x90
>   ? kfree+0x2cf/0x2f0
>   ? exc_invalid_op+0x50/0x70
>   ? kfree+0x2cf/0x2f0
>   ? asm_exc_invalid_op+0x1a/0x20
>   ? ata_host_alloc+0xf5/0x120 [libata]
>   ? ata_host_alloc+0xf5/0x120 [libata]
>   ? kfree+0x2cf/0x2f0
>   ata_host_alloc+0xf5/0x120 [libata]
>   ata_host_alloc_pinfo+0x14/0xa0 [libata]
>   ahci_init_one+0x6c9/0xd20 [ahci]
> 
> Ensure that we will not call kfree(host) twice, by performing the kfree()
> only if the devres_open_group() call failed.
> 
> Fixes: dafd6c496381 ("libata: ensure host is free'd on error exit paths")
> Cc: stable@vger.kernel.org
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   drivers/ata/libata-core.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 88e32f638f33..c916cbe3e099 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5573,8 +5573,10 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
>   	if (!host)
>   		return NULL;
>   
> -	if (!devres_open_group(dev, NULL, GFP_KERNEL))
> -		goto err_free;
> +	if (!devres_open_group(dev, NULL, GFP_KERNEL)) {
> +		kfree(host);
> +		return NULL;
> +	}
>   
>   	dr = devres_alloc(ata_devres_release, 0, GFP_KERNEL);
>   	if (!dr)
> @@ -5606,8 +5608,6 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
>   
>    err_out:
>   	devres_release_group(dev, NULL);
> - err_free:
> -	kfree(host);
>   	return NULL;
>   }
>   EXPORT_SYMBOL_GPL(ata_host_alloc);
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

