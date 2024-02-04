Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719C2224CB;
	Sun,  4 Feb 2024 12:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707050091; cv=none; b=LDbojPYoi5YrYYxJ1wxMAnX+3JPTY2j8uVRHZOI+4cWpF9VTjg6HJOy12IMZS6W9wTd1ChVpK9f4cP7AiGWrzdBbsH0ToeizKCDtaAexHe2LafvLhPhkllRUo1ASjqTbVEQ4SFeQKTQN5mhsqJCOB0fJHfDmmlju9gZYqtZWxzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707050091; c=relaxed/simple;
	bh=W2jhIRICROv1ZbHBaS41clxSkmpy4DsHb2gpYaMtTzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ydq4ZQa75ypM17lXP0Bnbv4+ZN4j1bh50R6Nkf0Yvv5JDp26S15MdkFdiPLW2p3t7tlj1K2eJbHDwQJ4weC5017raBAKwglqXLAZ9EkgPPxzd2VAGlE1w3S3kV9Eda87iouefhK8V+EoRgGkqDPIayM/aXnh8cUiL0yAq/bJY74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=URsBqLrX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sJorLPad; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0lV2p83r; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bNtYZh7p; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="URsBqLrX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sJorLPad";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0lV2p83r";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bNtYZh7p"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9454C1F80C;
	Sun,  4 Feb 2024 12:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050088; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7J2d8xuJ0xTGl8YjCKxDcQv85dJcKHzUY1OoL+nxCAo=;
	b=URsBqLrXPA5kw5OTnt2YNuoMirjXeFpQyjLuyoJx3l2Mh1KWyo0jyesY/0fGTAo9aofwdF
	9HElHs3ru4O2ZP6MzpbdVDRwOUBLoRCVx2Tihdkbo5Znj5RY1LzEwbSkOcYRj3SGg+ZNiF
	XJgIv67QCrRozBLeMayGo7Pfxdp/tuw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050088;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7J2d8xuJ0xTGl8YjCKxDcQv85dJcKHzUY1OoL+nxCAo=;
	b=sJorLPad0XT9iOyxG2pJZVbQmSTj1teemxD3T3qWzNCDvx6rYdYvWQ1oaJhVyezIqUKV0g
	bny1BanQi8F2t2CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050087; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7J2d8xuJ0xTGl8YjCKxDcQv85dJcKHzUY1OoL+nxCAo=;
	b=0lV2p83rKYSd2ynTtQJSPtnQbTq6NP5egzxuaHvvVA6y6/aKtQ2KSBQvif0vy6Vr+ue76a
	sWNVvodSA60l2CkZjEVJSJs4FWSqmrQgUK2zwftVZdQZWbwqoBN9jUSVxxs4MUNOVx0lch
	f5bZf5vncpgIVTSIR3dG7PhSSNbfWJQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050087;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7J2d8xuJ0xTGl8YjCKxDcQv85dJcKHzUY1OoL+nxCAo=;
	b=bNtYZh7pKd/HDy5gD8w0x0em1AUM1DXNLey4+ifZD+xFjIuAO49g7BH7LeBrM4sdduYCMS
	JgSgXO28w5VMocBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8FDBD132DD;
	Sun,  4 Feb 2024 12:34:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IIsKDmOEv2U8JwAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:34:43 +0000
Message-ID: <3e6effd2-cca7-4c44-8ed7-08cc4fd1e6f4@suse.de>
Date: Sun, 4 Feb 2024 20:34:43 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/26] block: Remove BLK_STS_ZONE_RESOURCE
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-18-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0lV2p83r;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bNtYZh7p
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.66 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-2.16)[95.97%];
	 MIME_GOOD(-0.10)[text/plain];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Score: -3.66
X-Rspamd-Queue-Id: 9454C1F80C
X-Spam-Flag: NO

On 2/2/24 15:30, Damien Le Moal wrote:
> The zone append emulation of the scsi disk driver was the only driver
> using BLK_STS_ZONE_RESOURCE. With this code removed,
> BLK_STS_ZONE_RESOURCE is now unused. Remove this macro definition and
> simplify blk_mq_dispatch_rq_list() where this status code was handled.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-mq.c            | 26 --------------------------
>   drivers/scsi/scsi_lib.c   |  1 -
>   include/linux/blk_types.h | 20 ++++----------------
>   3 files changed, 4 insertions(+), 43 deletions(-)
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

