Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792576323;
	b=ATMFyzKj8XsEX5Lm3v0MIfbryu/AOnD6l/dfoZ2Z8FkuUUkHkGl4VvmDZwUyjsRGHvNl
	 5CR7kznLR8rQs5TsTE5oSxR9nvBP2nSfwu4KEL9QJdHJJKwo5qvVZl6xA8yrCGHEGXf71
	 CSk6zywp53/It9Dckoiz2lKl94wxMHVJ/pvgxGlYoUDGE2McewgDLitPCNPhL5EWDvtL4
	 1OPianoYZib4YjTDNlH9MK7j+InBhmQspuxUYE5jWT3A2hwCGluECGaXqW1hLLm7CxKsk
	 ptrZ/2yRQ0UDHk560Qk/76vZ5+nZfJGOubpZQYsJllAvTl9sYanFFYC67xCkrrsNEzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792576323;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Action:X-Spam-Score:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Level:X-Rspamd-Queue-Id:
	 X-Rspamd-Server;
	bh=5CYzqfutyNMeBEsKtKtL9EnIbuHsfff9RBnqTd0OkxQ=;
	b=JODHmVuEuCWJVyZKkC2ZBpeHoTxGv7nrGD5IkWBDRyPnUU7iOlEy+k1NhMwKq8XK7Vih
	 03BI+3YB/tPga7TtDhA9HnTdhK9pGidR3Pb5pgG8ezfzYqwidWBJi3Cmu/Bmwi086yAdM
	 oacxZNOtM5Hfyw8TW7bpgPK+ydwEMZvKLT7RkL6sq+D60MiXsiIZXHiXO95hG9z1D6yhD
	 bVxg8Ip/x+j3WQqs9rc+/B00QofD7t8AMtmGFo3GGS0AScbAyQ/ZhnrUAzR50haqsyBzg
	 JaFfPF90ZohjNMxlUYrm6mn97h5HvDtCqLHAIMEhy4Xs2ptXkpO/TTtjjAn+uaxNw9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FxIEHpu1;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cGVNDn4S;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FxIEHpu1;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cGVNDn4S;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876FC606A31A;
	Wed, 21 Oct 2026 09:52:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 876FC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FxIEHpu1;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cGVNDn4S;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FxIEHpu1;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cGVNDn4S
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D0F8F21DCD;
	Wed, 21 Oct 2026 09:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792576320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5CYzqfutyNMeBEsKtKtL9EnIbuHsfff9RBnqTd0OkxQ=;
	b=FxIEHpu1yhpAdwg0yO6kzFXCsaJ3HRYofINGl6OKb8jC+PbcdIlo6pjhZymiPq9Moomi0S
	toLOwZ0gn89m+VR4evsoZoQ9y79XdMVbOYWfwNw86SVcgnDzx5+UQu90lFX7s8nTAuRDTP
	yG+KHQdnI59+IyC/TjqGyU4fKnBuKdg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792576320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5CYzqfutyNMeBEsKtKtL9EnIbuHsfff9RBnqTd0OkxQ=;
	b=cGVNDn4Supk4UdpEYnp0Qdzu9KnTyatKDaJ9+wcFlssTlsk0Ohixuji3GRhzDp686/ghnd
	jMjDKJMxb6ubsoAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FxIEHpu1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cGVNDn4S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792576320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5CYzqfutyNMeBEsKtKtL9EnIbuHsfff9RBnqTd0OkxQ=;
	b=FxIEHpu1yhpAdwg0yO6kzFXCsaJ3HRYofINGl6OKb8jC+PbcdIlo6pjhZymiPq9Moomi0S
	toLOwZ0gn89m+VR4evsoZoQ9y79XdMVbOYWfwNw86SVcgnDzx5+UQu90lFX7s8nTAuRDTP
	yG+KHQdnI59+IyC/TjqGyU4fKnBuKdg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792576320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5CYzqfutyNMeBEsKtKtL9EnIbuHsfff9RBnqTd0OkxQ=;
	b=cGVNDn4Supk4UdpEYnp0Qdzu9KnTyatKDaJ9+wcFlssTlsk0Ohixuji3GRhzDp686/ghnd
	jMjDKJMxb6ubsoAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D6C4134FD;
	Wed, 21 Oct 2026 09:52:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 35r+GECL2Go/LQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 21 Oct 2026 09:52:00 +0000
Message-ID: <1991de84-6e5a-4248-b92a-13fe9d17e7e2@suse.de>
Date: Wed, 21 Oct 2026 11:51:59 +0200
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
Subject: Re: [PATCH v6 08/10] scsi: sd: fail read commands to offline zones
 early
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
 <20261013122750.2237843-9-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261013122750.2237843-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -4.50
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim]
X-Spam-Level: 
X-Rspamd-Queue-Id: D0F8F21DCD
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On 10/13/26 2:27 PM, Damien Le Moal wrote:
> Issuing read commands to offline zones of a ZBC disk will result in
> failures. So do not issue such command and fail then early in
> sd_setup_read_write_cmnd(). This change also checks write commands, which
> is fine but should actually never happen as the block layer zone write
> plugging code already fails write BIOs to offline zones early in the
> submission path.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index a1b21ea14e54..db7c19d1c2ff 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1424,7 +1424,8 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
>   {
>   	struct request *rq = scsi_cmd_to_rq(cmd);
>   	struct scsi_device *sdp = cmd->device;
> -	struct scsi_disk *sdkp = scsi_disk(rq->q->disk);
> +	struct gendisk *disk = rq->q->disk;
> +	struct scsi_disk *sdkp = scsi_disk(disk);
>   	sector_t lba = sectors_to_logical(sdp, blk_rq_pos(rq));
>   	sector_t threshold;
>   	unsigned int nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
> @@ -1456,6 +1457,11 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
>   		goto fail;
>   	}
>   
> +	/* Prevent read/write to offline zones of ZBC disks. */
> +	if (sdkp->device->type == TYPE_ZBC &&
> +	    disk_zone_is_offline(disk, blk_rq_pos(rq)))
> +		goto fail;
> +
>   	/*
>   	 * Some SD card readers can't handle accesses which touch the
>   	 * last one or two logical blocks. Split accesses as needed.
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
