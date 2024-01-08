Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1ACBE62;
	Mon,  8 Jan 2024 08:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gjtroc7V";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZyC521+Z";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gjtroc7V";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZyC521+Z"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B0B4D21D87;
	Mon,  8 Jan 2024 08:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704703736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEwqV+ltyzeGoI9hWS3Jhxf5JPsR3jL/UCvFbsl3Bgo=;
	b=gjtroc7VOXuX0doLemNGz20m7dfVck27UZVSsl6BOWG5U0Ln4+svMOQGC6hp38AojXELCl
	LzehW+aKv8ouHdnFsi+q+igrUCMwVkRmSHwoCRxTxus30sGijpXjqPt6reTRNZ7qBcMAnS
	tJjcAyH04HvODokVKkzqwnqbdh6pdFc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704703736;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEwqV+ltyzeGoI9hWS3Jhxf5JPsR3jL/UCvFbsl3Bgo=;
	b=ZyC521+ZvVDKLx+WAq/ZO3p7Muw2JJZ0ukI7GdQMs4qzrodRdp9IB9bb/Qm/d1wlcQx2RD
	TdUiz1RNJ6jJWxCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704703736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEwqV+ltyzeGoI9hWS3Jhxf5JPsR3jL/UCvFbsl3Bgo=;
	b=gjtroc7VOXuX0doLemNGz20m7dfVck27UZVSsl6BOWG5U0Ln4+svMOQGC6hp38AojXELCl
	LzehW+aKv8ouHdnFsi+q+igrUCMwVkRmSHwoCRxTxus30sGijpXjqPt6reTRNZ7qBcMAnS
	tJjcAyH04HvODokVKkzqwnqbdh6pdFc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704703736;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEwqV+ltyzeGoI9hWS3Jhxf5JPsR3jL/UCvFbsl3Bgo=;
	b=ZyC521+ZvVDKLx+WAq/ZO3p7Muw2JJZ0ukI7GdQMs4qzrodRdp9IB9bb/Qm/d1wlcQx2RD
	TdUiz1RNJ6jJWxCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 698F71392C;
	Mon,  8 Jan 2024 08:48:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WEvxFfi2m2VtBAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 08 Jan 2024 08:48:56 +0000
Message-ID: <61c61a9c-2543-4c27-987f-1ccfd133ca5d@suse.de>
Date: Mon, 8 Jan 2024 09:48:56 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] block: remove disk_clear_zoned
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org
References: <20231228075141.362560-1-hch@lst.de>
 <20231228075141.362560-3-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20231228075141.362560-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	none
X-Spamd-Result: default: False [-1.82 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.53)[80.54%];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCPT_COUNT_FIVE(0.00)[6];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -1.82

On 12/28/23 08:51, Christoph Hellwig wrote:
> disk_clear_zoned is unused now that the last warts of the host-aware
> model support in sd are gone.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-zoned.c      | 21 ---------------------
>   include/linux/blkdev.h |  1 -
>   2 files changed, 22 deletions(-)
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

