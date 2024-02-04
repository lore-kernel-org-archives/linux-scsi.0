Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53C411721;
	Sun,  4 Feb 2024 12:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707049831; cv=none; b=QJhoJk3vFx3SadJWhu+kY0leUdanEEos/P87SLl5a3Y4gbpch+OP3lJXqBI1JBnldxkhTIy5o/dfd9N3F8ByBigoqgiTwY4dqsfQz+TibVfg09avzQ8cRGp3xfjHwLYTDmkdY/6ItdOdihxzCHImxpI65ni80/eb8iHu4501Jf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707049831; c=relaxed/simple;
	bh=6YJDghiv3iJwsdnmRAxMVvZMQnID+d715TiL56s05Zs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SfTZktlL8LCTT7rLNo6Fw/gM88ttaRRrILFk5AsD5y7AkMvP8YufRxnavAAAVSi8lpqINGYpfr0UcgQOT8yFj6QpVqrW8DhVtfH9I36oedQ9VPHmE54bMyfln9tb6QKY6AkHYg66A6WCYEYVAUmrIkGkdvysDokuNYpLX4f5Ihg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gQ8v34WU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=O1/7dmDG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gQ8v34WU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=O1/7dmDG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gQ8v34WU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="O1/7dmDG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gQ8v34WU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="O1/7dmDG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1B67722065;
	Sun,  4 Feb 2024 12:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707049827; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cmz04ZwpupMln4vF3hJrYBvqpaXdOKln2cmh65yEh5c=;
	b=gQ8v34WUzSayvRFeEzKK2kPbY5F758mroCafQEfaeOfuxQl2GdPB6mKubCdajQgPZL+IDd
	tj7mDQMTL08FOvVd7L7xaOPWNI0sbVjNGYcgdFcxdtCDCo31m7WQHbqbNb0sDHgrn9xH+X
	qElbnCjRq4DtTBJx1b4B7vU7TtvREJ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707049827;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cmz04ZwpupMln4vF3hJrYBvqpaXdOKln2cmh65yEh5c=;
	b=O1/7dmDGiXb9FQt6TV4+N9poO2pZ9IZnuXgIBaECRMJjUM1uBclRzTdQVBAlzFPXv4B9b9
	jmGDfBXuWXXRs5AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707049827; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cmz04ZwpupMln4vF3hJrYBvqpaXdOKln2cmh65yEh5c=;
	b=gQ8v34WUzSayvRFeEzKK2kPbY5F758mroCafQEfaeOfuxQl2GdPB6mKubCdajQgPZL+IDd
	tj7mDQMTL08FOvVd7L7xaOPWNI0sbVjNGYcgdFcxdtCDCo31m7WQHbqbNb0sDHgrn9xH+X
	qElbnCjRq4DtTBJx1b4B7vU7TtvREJ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707049827;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cmz04ZwpupMln4vF3hJrYBvqpaXdOKln2cmh65yEh5c=;
	b=O1/7dmDGiXb9FQt6TV4+N9poO2pZ9IZnuXgIBaECRMJjUM1uBclRzTdQVBAlzFPXv4B9b9
	jmGDfBXuWXXRs5AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BB90A132DD;
	Sun,  4 Feb 2024 12:30:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BRgxHV+Dv2U8JwAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:30:23 +0000
Message-ID: <7dd46f0d-7796-41ec-9d18-8561c5c84d92@suse.de>
Date: Sun, 4 Feb 2024 20:30:20 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/26] dm: Use the block layer zone append emulation
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-11-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-11-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -4.29
X-Spamd-Result: default: False [-4.29 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Flag: NO

On 2/2/24 15:30, Damien Le Moal wrote:
> For targets requiring zone append operation emulation with regular
> writes (e.g. dm-crypt), we can use the block layer emulation provided by
> zone write plugging. Remove DM implemented zone append emulation and
> enable the block layer one.
> 
> This is done by setting the max_zone_append_sectors limit of the
> mapped device queue to 0 for mapped devices that have a target table
> that cannot support native zone append operations. These includes
> mixed zoned and non-zoned targets, or targets that explicitly requested
> emulation of zone append (e.g. dm-crypt). For these mapped devices, the
> new field emulate_zone_append is set to true. dm_split_and_process_bio()
> is modified to call blk_zone_write_plug_bio() for such device to let the
> block layer transform zone append operations into regular writes. This
> is done after ensuring that the submitted BIO is split if it straddles
> zone boundaries.
> 
> dm_revalidate_zones() is also modified to use the block layer provided
> function blk_revalidate_disk_zones() so that all zone resources needed
> for zone append emulation are allocated and initialized by the block
> layer without DM core needing to do anything. Since the device table is
> not yet live when dm_revalidate_zones() is executed, enabling the use of
> blk_revalidate_disk_zones() requires adding a pointer to the device
> table in struct mapped_device. This avoids errors in
> dm_blk_report_zones() trying to get the table with dm_get_live_table().
> The mapped device table pointer is set to the table passed as argument
> to dm_revalidate_zones() before calling blk_revalidate_disk_zones() and
> reset to NULL after this function returns to restore the live table
> handling for user call of report zones.
> 
> All the code related to zone append emulation is removed from
> dm-zone.c. This leads to simplifications of the functions __map_bio()
> and dm_zone_endio(). This later function now only needs to deal with
> completions of real zone append operations for targets that support it.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/md/dm-core.h |  11 +-
>   drivers/md/dm-zone.c | 470 ++++---------------------------------------
>   drivers/md/dm.c      |  44 ++--
>   drivers/md/dm.h      |   7 -
>   4 files changed, 68 insertions(+), 464 deletions(-)
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

