Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795073046;
	b=qfWTEQEJNhI1QX08TTY1lYwNPgf9qMeRkKufeY+76G8bLMMDQdrCg5iBcR2DIn9zGJ6s
	 SFN9cXxiMDO9yUJZiRdnRV0VaEslSPPuCm/AOewBvG3inhTW3BC/SucRrUjV++xTB8PEb
	 l4W6rKw3fwMsTDOAfY4Gg5E2uzeQ+6Cj8btRN9j+4hKaFIIFCF/I0FknW+cc4vnCwEQdn
	 yZY5vS2eGT1hOk4kJ3r1NT4fFvC5DJ787DVGnqWT8KuPQmuMyIVatepgpoz80hTs7AF/P
	 NkrayiFLTty0+PCHv3uY7mK9JC3Yc6b4bjXepCe5sv65UqvNVC1aCluJWzIh1s59E7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795073046;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=C4xqzgREGutE1f93+d/o5fMvUHdWSmh5XWt7vN0i1ww=;
	b=q/poW1PsxD+2fYQ12wcuhjYtYULtq7gJf2/xV8dGWud+hEJMow3tnZbyJV22RP/5c8vR
	 AVeGUaUXE36JLFX1KfLmSm4fxBGW/iFSw4ClkSuulBFgoa2Od2G6fjs4L1FkAP76HAT9v
	 +0kGXZhqVXjedgjkFxSUauKceQDXcH8xrTCQGvF6wSMg5SyD9nb/4fqmoCORnU202HRAK
	 8SAi62PV2ZvmR+QnLOBb9+yXKDWDnRlloldeS5LFvGOP28JVi6qIQzby0IOBOghm6er3m
	 /WIpFXk5ciegVRMS7OjSthgjr2dl/6M6SEn+empt1KLd5q/rGxc9RFWn7s4Nt21GGDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Dd+XDA0J;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fuKrcJ+c;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Dd+XDA0J;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fuKrcJ+c;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0765A606A33D;
	Thu, 19 Nov 2026 07:24:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0765A606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Dd+XDA0J;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fuKrcJ+c;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Dd+XDA0J;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fuKrcJ+c
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1AB382224F;
	Thu, 19 Nov 2026 07:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795073044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4xqzgREGutE1f93+d/o5fMvUHdWSmh5XWt7vN0i1ww=;
	b=Dd+XDA0JVwEgcBOoP76OUbmlpF6Ww/pSLpHMc6IGoEiewCH0Sl8W4tAG9DKAkVp+hxkv6W
	6XfSpMuTu5fWqjCOJgiZSxl2sj914HsQi/6xBpFMi8XSY+XfO0U9zvF9uWcS2i3OuSACoF
	VodVyT3ZHym8zy7gImi9VX720DB1+9M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795073044;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4xqzgREGutE1f93+d/o5fMvUHdWSmh5XWt7vN0i1ww=;
	b=fuKrcJ+cd+djfRSgX1DtvJkqqwNX5LgMU7Puwna3XC+G4O5IwkZPlnJGSIKEQ1muw1kCFe
	usvv38KKAYaIeMCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795073044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4xqzgREGutE1f93+d/o5fMvUHdWSmh5XWt7vN0i1ww=;
	b=Dd+XDA0JVwEgcBOoP76OUbmlpF6Ww/pSLpHMc6IGoEiewCH0Sl8W4tAG9DKAkVp+hxkv6W
	6XfSpMuTu5fWqjCOJgiZSxl2sj914HsQi/6xBpFMi8XSY+XfO0U9zvF9uWcS2i3OuSACoF
	VodVyT3ZHym8zy7gImi9VX720DB1+9M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795073044;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4xqzgREGutE1f93+d/o5fMvUHdWSmh5XWt7vN0i1ww=;
	b=fuKrcJ+cd+djfRSgX1DtvJkqqwNX5LgMU7Puwna3XC+G4O5IwkZPlnJGSIKEQ1muw1kCFe
	usvv38KKAYaIeMCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C73391334C;
	Thu, 19 Nov 2026 07:24:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id P4g0IxOk/mocUQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 19 Nov 2026 07:24:03 +0000
Message-ID: <a102ffd1-7eb3-420d-84eb-eb4705a43b4c@suse.de>
Date: Thu, 19 Nov 2026 08:24:03 +0100
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
Subject: Re: [PATCH v11 08/13] zloop: add storage element emulation
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261116213702.225970-1-dlemoal@kernel.org>
 <20261116213702.225970-9-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261116213702.225970-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.997];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.29

On 11/16/26 10:36 PM, Damien Le Moal wrote:
> Emulate the storage element depopulation feature of SMR disks in the
> zloop driver. This emulation is controlled using the new stor_elements
> option. This option can take several values:
>   - ZLOOP_STOR_ELEMENTS_NONE (0): no emulation (default)
>   - ZLOOP_STOR_ELEMENTS_RDWR (1): emulate all access storage elements
>     (e.g.  read+write heads)
>   - ZLOOP_STOR_ELEMENTS_PAIRS (2): emulate fractional access storage
>     elements (e.g. pairs of read and write heads)
> 
> If enabled with the value 1 or 2, the number of storage elements, or of
> pairs of fractional access storage elements, is automatically calculated
> based on the number of zones of the device so that we have at least 2 and
> at most 32 storage elements or pairs of fractional access storage
> elements.
> 
> The mapping of zones to storage elements is defined simply as the modulo
> of a zone number with the number of storage elements for the all access
> storage elements emulation and with the number of storage element pairs
> for the fractional access storage element emulation case. E.g, removing
> a storage element from a set of 4 all access storage elements will
> offline 1 zone every 4 zones.
> 
> The storage element management operations are specified with the
> structure zloop_se_ops (struct blk_se_ops).
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   .../admin-guide/blockdev/zoned_loop.rst       |  11 +-
>   drivers/block/zloop.c                         | 710 +++++++++++++++++-
>   2 files changed, 694 insertions(+), 27 deletions(-)
> 
[ .. ]
> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 6bb68022ab30..1731e4ad5c98 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
> @@ -18,6 +18,7 @@
>   #include <linux/parser.h>
>   #include <linux/seq_file.h>
>   #include <linux/xattr.h>
> +#include <linux/delay.h>
>   
>   /*
>    * Options for adding (and removing) a device.

[ ..  ]

> @@ -1149,6 +1699,74 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
>   	return ret;
>   }
>   
> +#define ZLOOP_MIN_STOR_ELEMENTS			2
> +#define ZLOOP_MAX_STOR_ELEMENTS			32
> +#define ZLOOP_MIN_ZONES_PER_STOR_ELEMENTS	32
> +

Any particular reason for these limits?
Can't we infer these limits from other settings
(eg number of zones)?

Otherwise looks good.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
