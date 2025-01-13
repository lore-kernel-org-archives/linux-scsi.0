Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DDE28FD;
	Mon, 13 Jan 2025 07:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736752776; cv=none; b=PitooXaDqFsEst2fVseagdDn2FfvLqdaWrSp5brLb9aYwKEKF5uk2J4XUNrsxdOs17tyzawQF590WLiJbAVE+tbByh1BwOwXyGEuL8/H7PAW/u6g0mFWeKNRiF6DHJZVPgVygPEdgZi9wTSXXlwjUruarh0xuQ7xTTK2YY21UoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736752776; c=relaxed/simple;
	bh=hmfbTHASTZMpQbS+sIQInLzJ98WhnXdS3GxPOH/PPo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ptnsCH/ft2Cq5Uujt47eBR77N3txLhfIh7D94d10EGl5cFIIFnvspenL62TGPdcYGCVPXQ01HKPlvN+JOoKdP6+YitjD63MHpUrNq3Z1VXA5vycFmSYPFg+ZNWk7TYNvRWtSf4xPoRlw7yMwk7qgvaTTjIuKGC+K5C+i/bRWLhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ggUI+tdd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=m2FrsZqX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ggUI+tdd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=m2FrsZqX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ggUI+tdd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="m2FrsZqX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ggUI+tdd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="m2FrsZqX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0C19A1F365;
	Mon, 13 Jan 2025 07:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752773; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wdlX6/MCN1dGm0u1BqAi4ZRf68cuEwzfR65EqwHsmxQ=;
	b=ggUI+tddjrsS5sXUHTJtv7n54qdz0cKTSistdN9mph+XcFShimrFpaa7viPEglAWXkJRPH
	81IUKNDimBCBxt1ZTIbtquUJqU97iJauMgKDY04+mPw40BDjg4Vg6SsxISAJUXN/t1OazI
	4b/l6/FpoPMnPx9W5dl7eoPS3uY3h8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752773;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wdlX6/MCN1dGm0u1BqAi4ZRf68cuEwzfR65EqwHsmxQ=;
	b=m2FrsZqXYjn+70MskwU5RF6XF3vX0hNAi0O2da34VaVuPjHd3eY/B1kOzFmNyKiF4dAvll
	BjHjIlMkOIx4uLCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ggUI+tdd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=m2FrsZqX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752773; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wdlX6/MCN1dGm0u1BqAi4ZRf68cuEwzfR65EqwHsmxQ=;
	b=ggUI+tddjrsS5sXUHTJtv7n54qdz0cKTSistdN9mph+XcFShimrFpaa7viPEglAWXkJRPH
	81IUKNDimBCBxt1ZTIbtquUJqU97iJauMgKDY04+mPw40BDjg4Vg6SsxISAJUXN/t1OazI
	4b/l6/FpoPMnPx9W5dl7eoPS3uY3h8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752773;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wdlX6/MCN1dGm0u1BqAi4ZRf68cuEwzfR65EqwHsmxQ=;
	b=m2FrsZqXYjn+70MskwU5RF6XF3vX0hNAi0O2da34VaVuPjHd3eY/B1kOzFmNyKiF4dAvll
	BjHjIlMkOIx4uLCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9DA3E13310;
	Mon, 13 Jan 2025 07:19:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oHpUJIS+hGerLAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jan 2025 07:19:32 +0000
Message-ID: <3e664960-52c0-4cae-8209-85fa4c52f82d@suse.de>
Date: Mon, 13 Jan 2025 08:19:32 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] block: fix docs for freezing of queue limits
 updates
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
 Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, nbd@other.debian.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-2-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250108092520.1325324-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0C19A1F365
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 1/8/25 10:24, Christoph Hellwig wrote:
> queue_limits_commit_update is the function that needs to operate on a
> frozen queue, not queue_limits_start_update.  Update the kerneldoc
> comments to reflect that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
> ---
>   block/blk-settings.c   | 3 ++-
>   include/linux/blkdev.h | 3 +--
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
