Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061A3224CB;
	Sun,  4 Feb 2024 12:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707050291; cv=none; b=OwZZuAbnSyaPFo9ftVueWjGHc//Ya6YGQvtM0pL0M6qxzQXjJmk4LjK9DKgHElQX3ZTs8sIQEnhEceINu+2xisu8b82QN8FpGtBE/eGeE+SXqg/nvA11QLuFgLMKB6Kvs/0MqmngtCX7VvU/jJmzi7TZF7a1b8UPpRYKPfCB4kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707050291; c=relaxed/simple;
	bh=V76arEgWKa0xBm2owIzh4Nh0J2XqoUsXZbFtIGBGTaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bD0kDOdhQhEeeCQC3Bap99JmWA3OGlGYUPWoAsTGI5bPzNR2APnmMNGLVvju/eaX8a8Nk/gD/kO3dX0/qkoXIAfI4q1kXrvHsR/WA75yMlE4kQ6jbYVdic2GrF5tB0D2hpekilTYmdv2pO0Q09OIa3g+Kf1HN7mQpexpZVWV0Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BWPtaP8L; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7xqAgpsN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BWPtaP8L; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7xqAgpsN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BWPtaP8L";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7xqAgpsN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BWPtaP8L";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7xqAgpsN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 40F2A21E95;
	Sun,  4 Feb 2024 12:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050288; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ck9pHKxLjKpfoVOgyyF6t1y5Tv9Q8B/uaLtWCYLsuLE=;
	b=BWPtaP8LybkuHL93XYmN5Uq1QMBtVofA3HhFjBEf9lQDnT1SlWXxNJE1OwlQFJnIsI1D/M
	EQBLIUIbdg/akstzuOKIn+OIlxquF6Ox7m3G4aIzcQZIM7YZo8rZek8p5r4n7RkwuxWOr1
	f24sPJo8pqw5o5NEM9WnQt4m913YA3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050288;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ck9pHKxLjKpfoVOgyyF6t1y5Tv9Q8B/uaLtWCYLsuLE=;
	b=7xqAgpsN/ck5YrFoSEMgGxX0Z4BdDaBFIvhpGjK7H5UPHLVTARqB8aLSkkeE/sCnfxZAnl
	n4+3yL9vpfTIoHAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050288; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ck9pHKxLjKpfoVOgyyF6t1y5Tv9Q8B/uaLtWCYLsuLE=;
	b=BWPtaP8LybkuHL93XYmN5Uq1QMBtVofA3HhFjBEf9lQDnT1SlWXxNJE1OwlQFJnIsI1D/M
	EQBLIUIbdg/akstzuOKIn+OIlxquF6Ox7m3G4aIzcQZIM7YZo8rZek8p5r4n7RkwuxWOr1
	f24sPJo8pqw5o5NEM9WnQt4m913YA3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050288;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ck9pHKxLjKpfoVOgyyF6t1y5Tv9Q8B/uaLtWCYLsuLE=;
	b=7xqAgpsN/ck5YrFoSEMgGxX0Z4BdDaBFIvhpGjK7H5UPHLVTARqB8aLSkkeE/sCnfxZAnl
	n4+3yL9vpfTIoHAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 50E58132DD;
	Sun,  4 Feb 2024 12:38:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2OKoNyyFv2U8JwAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:38:04 +0000
Message-ID: <a7b17939-ae20-480b-85a4-f56bf6e30a70@suse.de>
Date: Sun, 4 Feb 2024 20:38:04 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/26] block: Move zone related debugfs attribute to
 blk-zoned.c
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-23-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-23-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -1.46
X-Spamd-Result: default: False [-1.46 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.17)[69.60%];
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

On 2/2/24 15:31, Damien Le Moal wrote:
> block/blk-mq-debugfs-zone.c contains a single debugfs attribute
> function. Defining this outside of block/blk-zoned.c does not really
> help in any way, so move this zone related debugfs attribute to
> block/blk-zoned.c and delete block/blk-mq-debugfs-zone.c.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/Kconfig                |  4 ----
>   block/Makefile               |  1 -
>   block/blk-mq-debugfs-zoned.c | 22 ----------------------
>   block/blk-mq-debugfs.h       |  2 +-
>   block/blk-zoned.c            | 20 ++++++++++++++++++++
>   5 files changed, 21 insertions(+), 28 deletions(-)
>   delete mode 100644 block/blk-mq-debugfs-zoned.c
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

