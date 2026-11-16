Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794833364;
	b=mCEKBjXQ/qVVXv8/9gedU1c1d13Zg+4cUVqDxpAufl5PXOLpPPgEncRnvHYnEe8x+Jgm
	 g/50Qxa5DCzPyPAi6cw0aQYhD2OFU92uK998/wnlX6IUnUsyqKNHtF9Q6EfzbHG/1lq/n
	 SnEOrFGSHtpyv6ITQuR5098Le09dIFG1J+maO+avCPCtLLd4WMe7Ujdj2PG4z4dky74i1
	 iyf5tBop/OFhSDb+JMaGaHqVASfufU4RbQRkUMiYBuZRxK0OcpPea/j5bs0mB0EYm9klm
	 Cc3HtuPJX11nf7g+W/jy6Ogv9eDxRqhtwaxfPSyDF9mNI44mQ9+yOaZUJthnbR0kjgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833364;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=3Z6xkQwXxsXU8teVH5qZRDo9Vm2CAwuUYM7o06IkbZM=;
	b=dx1NXDEyYOi6I1PMms+idSUdPiVK1v2X2OWbmHUlmP+JlwlLeOapTRt/jpYgDYpsbdO7
	 iWof88qlK84+9vfthchQuLWj0QpaskvtLvoN1zr85SaDXOaidd4AN3hMVOncT7gVqb23O
	 jGj3PmJ3wF4ytrjtKOxsGIaCzSCCckOauKBjtRokhUcwTOxgg8ViGZE6YVWY4tMO89xV7
	 FWhOLefJCPPsQRbdlVVYixjh3HZN98ZW9TE7LzYDhmZf/h8nqbQKvUTvbEj8uYJiNyDPf
	 4UwOMQgJkBSgZVQn8XbBf2Kg2apCUvB6vaDtF9mFvwybIlWkIlqu562gCZVJRb2c7Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GeN7Qzpz;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=sG0gtLES;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=UDSqWrQI;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hAURySjA;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940FD606A31C;
	Mon, 16 Nov 2026 12:49:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 940FD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GeN7Qzpz;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=sG0gtLES;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=UDSqWrQI;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hAURySjA
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E649122080;
	Mon, 16 Nov 2026 12:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794833362; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Z6xkQwXxsXU8teVH5qZRDo9Vm2CAwuUYM7o06IkbZM=;
	b=GeN7QzpzvtTdhLQQqtLiiVRK+wc65Qxi0uJgIIsfD05YvSJpUXQVuEVPFlbuSguzJRDKQO
	YbHfKnyZnLBIckwzVcAMEEzqPZViNq9LFsx3ntJm5lkrP0viTwjWg/OsDDKB2yKZ3iLp2k
	Zv2oCxNFFnVTXOJX06Y9CeGO13Mviuo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794833362;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Z6xkQwXxsXU8teVH5qZRDo9Vm2CAwuUYM7o06IkbZM=;
	b=sG0gtLESwbF9bQLYMCaTEtKSew61Uf3vXZZ2yc1KrqaQAm8x+ee9vquXv3Fsk3EqgaJODk
	ZZHIF4iDgqVUjDCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794833361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Z6xkQwXxsXU8teVH5qZRDo9Vm2CAwuUYM7o06IkbZM=;
	b=UDSqWrQIA7KRJc/dT3dLaGhw3lVhfbh4oYV5LxlIMrhq5CDdpC5r3EZPcW5uqiKN1yjgbD
	OBLaV7zdhCTMdM7aqxmnwdvU+kd2z2h15sc1JuU/h0PNxhpVbYUFhscjj8abORy3jYQ2pJ
	wKG7UplJl1GMn6GXcB2q6LFyKYFfozA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794833361;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Z6xkQwXxsXU8teVH5qZRDo9Vm2CAwuUYM7o06IkbZM=;
	b=hAURySjAWmj5eOOuzex3mqLKcxSjKTrfIgwYudU1ICRFS90kHnpppEYSdCR6kNQOenopbV
	eMliEMe044z0HpBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD6DC1334C;
	Mon, 16 Nov 2026 12:49:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hdGlJdH7+moBfQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 16 Nov 2026 12:49:21 +0000
Message-ID: <fff1e88a-4f4f-4cf2-9d4a-f646cd9b0540@suse.de>
Date: Mon, 16 Nov 2026 13:49:21 +0100
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
Subject: Re: [PATCH v9 06/13] zloop: keep zone write pointer and condition
 consistent
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261115145015.938426-1-dlemoal@kernel.org>
 <20261115145015.938426-7-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261115145015.938426-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.997];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.29
X-Spam-Level: 
X-Spam-Flag: NO

On 11/15/26 3:50 PM, Damien Le Moal wrote:
> For oredered zone append commands, the function
> zloop_set_zone_append_sector() increments a zone write pointer without
> checking if the zone is already open (implicitly or explicitly). This
> check is done only when the command is later executed using a work item,
> and the zone is implicitly open if needed. This creates a short time
> window where a report zone can show an empty zone with a write pointer
> that is not equal to the zone start sector, which is incorrect.
> 
> Fix this by calling zloop_do_open_zone() in zloop_set_zone_append_sector()
> to make sure that a zone is always first implicitly open if needed. This
> requires changing zloop_set_zone_append_sector() to return a blk_status_t
> so that potential zone resource errors can also be returned correctly.
> 
> Fixes: fcc6eaa3a03a ("zloop: introduce the ordered_zone_append configuration parameter")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/block/zloop.c | 21 +++++++++++++++------
>   1 file changed, 15 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
