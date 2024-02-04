Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F2A224C2;
	Sun,  4 Feb 2024 12:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707050249; cv=none; b=NVFgNIFkarSjVipwg7YE5IncamoKGDBejwCV+1C7e4+NxQgQq/n/gFdL07DVWrCKhLQ4z3tTBA6r30cLc3WD8nukZhwb5ftzk8rv7LcUQbAUiVsVtJLZjRDQI9515Gmhj3zptWmZCvkZBpX0sFZai+CbvuuWBWAcpmlwR2QERW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707050249; c=relaxed/simple;
	bh=tgfeNtN0WuNBO4ZXIAmNHILRPgmMoR+0R+AroMm7W38=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lv+4wTBKmYm0Y7+dSMle3jX/qEiJQvt+bxZiS2yzCGQdSMxhi+3k0Drx8BDXKqSwrT1cYG8kZdabblqzf6WQH7Zc3S7yIHcd4tFPeJl3vs6PGnI1Z0V/iFWFASRumWGtsPeKTXCRMCEuyu54g0kcVEJfRwX7AhQh5IFO/TjhE50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qGha8qX5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qEbopDzk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qGha8qX5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qEbopDzk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qGha8qX5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qEbopDzk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qGha8qX5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qEbopDzk"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1DD821F80C;
	Sun,  4 Feb 2024 12:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wAGNYJJiC5m2AVVtbSHdmmKTLFeyeGqc6w0qoQzkAHg=;
	b=qGha8qX5XEzSI/Wz01K/FGjrBtRtvzSXTd50W1UPBkRGYEBOHfAwBVJXQ7qbryqG0Khh99
	/hME8KHnawkp6jxOtrhk4f7HoK6OlBOviU7PLv0jnOrZ13gCQxukG/2/Ww03Qe136rijfe
	j+1Z/Z1FFZgHc0d8v6zs55PgYdrtB9A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050246;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wAGNYJJiC5m2AVVtbSHdmmKTLFeyeGqc6w0qoQzkAHg=;
	b=qEbopDzkxSWPYlrZf8mCtU/m2lldRtPGQ4Hs8yEqpruHj7+AElRTVUdQ9Lj+Mh1znvzyfW
	hsAvda4p2s/OZEBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wAGNYJJiC5m2AVVtbSHdmmKTLFeyeGqc6w0qoQzkAHg=;
	b=qGha8qX5XEzSI/Wz01K/FGjrBtRtvzSXTd50W1UPBkRGYEBOHfAwBVJXQ7qbryqG0Khh99
	/hME8KHnawkp6jxOtrhk4f7HoK6OlBOviU7PLv0jnOrZ13gCQxukG/2/Ww03Qe136rijfe
	j+1Z/Z1FFZgHc0d8v6zs55PgYdrtB9A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050246;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wAGNYJJiC5m2AVVtbSHdmmKTLFeyeGqc6w0qoQzkAHg=;
	b=qEbopDzkxSWPYlrZf8mCtU/m2lldRtPGQ4Hs8yEqpruHj7+AElRTVUdQ9Lj+Mh1znvzyfW
	hsAvda4p2s/OZEBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 063D2132DD;
	Sun,  4 Feb 2024 12:37:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GBDdJwKFv2U8JwAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:37:22 +0000
Message-ID: <ebeb3572-74e6-4304-8dca-0454a855d1f3@suse.de>
Date: Sun, 4 Feb 2024 20:37:22 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/26] block: Do not check zone type in
 blk_check_zone_append()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-22-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-22-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qGha8qX5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qEbopDzk
X-Spamd-Result: default: False [-2.32 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-2.02)[95.16%];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1DD821F80C
X-Spam-Level: 
X-Spam-Score: -2.32
X-Spam-Flag: NO

On 2/2/24 15:30, Damien Le Moal wrote:
> Zone append operations are only allowed to target sequential write
> required zones. blk_check_zone_append() uses bio_zone_is_seq() to check
> this. However, this check is not necessary because:
> 1) For NVMe ZNS namespace devices, only sequential write required zones
>     exist, making the zone type check useless.
> 2) For null_blk, the driver will fail the request anyway, thus notifying
>     the user that a conventional zone was targeted.
> 3) For all other zoned devices, zone append is now emulated using zone
>     write plugging, which checks that a zone append operation does not
>     target a conventional zone.
> 
> In preparation for the removal of zone write locking and its
> conventional zone bitmap (used by bio_zone_is_seq()), remove the
> bio_zone_is_seq() call from blk_check_zone_append().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-core.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
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

