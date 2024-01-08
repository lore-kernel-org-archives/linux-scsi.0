Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E217BE5D;
	Mon,  8 Jan 2024 08:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dIDcLKa5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Nh6pJo17";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dIDcLKa5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Nh6pJo17"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2506521D87;
	Mon,  8 Jan 2024 08:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704703699; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+U+tkFWBWpiQKiu8uApu5AsWb4Hb76jA3uYJ/J5w8jM=;
	b=dIDcLKa5bkKdY+0Z7pp9aD5UeSNad3aF8j3ADs+42DPxQFbYmjnSG68fzTpMhzcuqHqbDj
	FZn/rm8ru5EMwjRhkQXvI8riLrTvNWUAwohbNP9/rlgwrwqVo419npXkBilwzx8vzyfIlj
	Im5c7NVgfgjnsoxmPs3GkdvFcmiJmMc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704703699;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+U+tkFWBWpiQKiu8uApu5AsWb4Hb76jA3uYJ/J5w8jM=;
	b=Nh6pJo173dDVDUDWS2Oe95eGEd7X2lBoydnTRR0tynLF4rPlthDaaDW33FOpydu9bB1DoN
	Dnudc3onvikU0yAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704703699; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+U+tkFWBWpiQKiu8uApu5AsWb4Hb76jA3uYJ/J5w8jM=;
	b=dIDcLKa5bkKdY+0Z7pp9aD5UeSNad3aF8j3ADs+42DPxQFbYmjnSG68fzTpMhzcuqHqbDj
	FZn/rm8ru5EMwjRhkQXvI8riLrTvNWUAwohbNP9/rlgwrwqVo419npXkBilwzx8vzyfIlj
	Im5c7NVgfgjnsoxmPs3GkdvFcmiJmMc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704703699;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+U+tkFWBWpiQKiu8uApu5AsWb4Hb76jA3uYJ/J5w8jM=;
	b=Nh6pJo173dDVDUDWS2Oe95eGEd7X2lBoydnTRR0tynLF4rPlthDaaDW33FOpydu9bB1DoN
	Dnudc3onvikU0yAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D77A91392C;
	Mon,  8 Jan 2024 08:48:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8G1HMtK2m2VtBAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 08 Jan 2024 08:48:18 +0000
Message-ID: <0b7f1137-37ea-4ec1-b3f1-7e40b8a15e82@suse.de>
Date: Mon, 8 Jan 2024 09:48:18 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] sd: remove the !ZBC && blk_queue_is_zoned case in
 sd_read_block_characteristics
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org
References: <20231228075141.362560-1-hch@lst.de>
 <20231228075141.362560-2-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20231228075141.362560-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dIDcLKa5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Nh6pJo17
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-6.48 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-2.98)[99.92%];
	 MIME_GOOD(-0.10)[text/plain];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	 RCPT_COUNT_FIVE(0.00)[6];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 SUBJECT_HAS_EXCLAIM(0.00)[];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Score: -6.48
X-Rspamd-Queue-Id: 2506521D87
X-Spam-Flag: NO

On 12/28/23 08:51, Christoph Hellwig wrote:
> Now that host-aware devices are always treated as conventional this case
> can't happen.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 6bedd2d5298f6d..dace4aa8e3534d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3149,12 +3149,11 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
>   		 * the device physical block size.
>   		 */
>   		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
> -	} else if (blk_queue_is_zoned(q)) {
> +	} else {
>   		/*
> -		 * Anything else.  This includes host-aware device that we treat
> -		 * as conventional.
> +		 * Host-aware devices are treated as conventional.
>   		 */
> -		disk_clear_zoned(sdkp->disk);
> +		WARN_ON_ONCE(blk_queue_is_zoned(q));
>   	}
>   #endif /* CONFIG_BLK_DEV_ZONED */
>   
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

