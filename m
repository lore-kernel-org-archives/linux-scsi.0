Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8FD224CA;
	Sun,  4 Feb 2024 12:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707050600; cv=none; b=heQkWnqSi5xTIILmOXUQGCvVHuiGPIat88gR0F+Y12U+grRF/NQ3HT6VRUF4hjx+vnH0GwnZiA3NA6TNvsiaY56QKQSmroZlhq4JCc6nF6FlDA2cFKJoXJ3XaDBOEil7aszTpca0csRNFUD3n7CJvKpa4fZZ1GCGUxVxoDGprwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707050600; c=relaxed/simple;
	bh=H+8ZOD+EV6874ewenOL63UDBI8WotOeUisntd9Ftmg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p5jVj7DlpDWyrtpbpCJ5Qxvfqy3MT7JntzHtHq6g5gCvPNpz6hlgU4vQ9QCyl7oE59e/Nays9C3koxA1j/tm7RJ6LnatQc69Qp9qYS+ixyYZgiczvMvVvGgAUvC0BuirR86X+/ZG/MAAr5bm05Np4osy9k2bRkkZzd5BAuH6Luk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Nm2OVEOQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=F721itGG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vcte8JUC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cX27UzCq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Nm2OVEOQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="F721itGG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vcte8JUC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cX27UzCq"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D8C2121FC4;
	Sun,  4 Feb 2024 12:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQU0P0YHrG/zkvEwd8pWtpr4BRZxXW4b+snrTHeFCbQ=;
	b=Nm2OVEOQKmVBoD81Lpu0auvf9Nj43Xg0GP5HNB0TFqbKwNNfkSBjHFbrhBz8viyuP99BEE
	paRApGDomBA0qUxetkr7n5PNzcp9BEYJEzVcHQBxmXDw1OHD+/9kekk8u2j0SUK107z6hk
	3e8ruCdFFp3FI0oSQ8uV4/ZzQ1odzQk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050597;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQU0P0YHrG/zkvEwd8pWtpr4BRZxXW4b+snrTHeFCbQ=;
	b=F721itGGJKYCnyGbO+jgXWtJ3O37yeNQX8UiJMH70DI9QnolqfLkRtCnmY/2iB4By8eh22
	oNfLIyED7kUEHtDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQU0P0YHrG/zkvEwd8pWtpr4BRZxXW4b+snrTHeFCbQ=;
	b=vcte8JUCveqPK4LIwPLMUtVVBn5jOShewOx9dAK5fRqkvzKMngJu68fY3EYOsvz567avN7
	9J+T1DZDIUmykyqNsq9SEEggNX8CZeL72dwLDe1xhwau7RpYn3zqqDXWCSD4hjG5J7sh5s
	EkQ6SNoAU9lqTh+F7Ac4gLbvrTbcz2A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050596;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQU0P0YHrG/zkvEwd8pWtpr4BRZxXW4b+snrTHeFCbQ=;
	b=cX27UzCqZg/RCv5qfbzCCaBic/UxBilwz3c5YcomJWvjiHyRyzi50ZDu9ukh5Px+d4xvLZ
	QWcrw8me4f/cL5Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E695E132DD;
	Sun,  4 Feb 2024 12:43:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0IL/G2GGv2WuKQAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:43:13 +0000
Message-ID: <d22e276d-ab29-4963-8596-8add32310209@suse.de>
Date: Sun, 4 Feb 2024 20:43:13 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 26/26] block: Add zone_active_wplugs debugfs entry
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-27-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-27-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vcte8JUC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cX27UzCq
X-Spamd-Result: default: False [-1.08 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.78)[84.47%];
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
X-Rspamd-Queue-Id: D8C2121FC4
X-Spam-Level: 
X-Spam-Score: -1.08
X-Spam-Flag: NO

On 2/2/24 15:31, Damien Le Moal wrote:
> Add the zone_active_wplugs debugfs entry to list the zone number and
> write pointer offset of zones that have an active zone write plug.
> 
> This helps ensure that struct blk_zone_active_wplug are reclaimed as
> zones become empty or full and allows observing which zones are being
> written by the block device user.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-mq-debugfs.c |  1 +
>   block/blk-mq-debugfs.h |  5 +++++
>   block/blk-zoned.c      | 27 +++++++++++++++++++++++++++
>   3 files changed, 33 insertions(+)
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

