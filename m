Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48531C28F;
	Wed, 27 Mar 2024 07:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711522928; cv=none; b=Z98qSGe/RZ4PXag4VVFGNp/jD7shfKVADD2l46fYcx6rR9AItdAqcnP6MiQkEEkaPEWJ7kf+g1ariA4yUl/iJHEKSz2LsXIcD7LPlO2VmbW+rF5Cq7rWXX17NHFXjJxud4eLu4LHUnB+fWwSnODCtFgVJDe8qS3Y4ZqyTRkSnjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711522928; c=relaxed/simple;
	bh=jindFJ5MOPucGrnP5I81k/UJr+Ax6BwZ6m/wtj1VOKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M0s+Mtcy+yq3xrv2kxFdS1UXNBT+h/4guaH+lZALqZPG9zgCumWmKb9y61fEzK2ACVrwkZ55kohHSuYeigq5CT9Q8PL/Sh4AuZhxFCKmTj3+MCfM8kk8wICt49J1sZNOM9bg1IL9nhZ3iNAvyZCJ32kEm6iV8Tuh/VOmlPbhcHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2UN0USoy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8xQRE97W; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qIS0H3us; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fiRfutid; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2UN0USoy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8xQRE97W";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qIS0H3us";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fiRfutid"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3A9F4386A7;
	Wed, 27 Mar 2024 07:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711522922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9f6guCBCCX5gVsiss0/i0Pw65KQFxVNRsRCpDMrOZ1M=;
	b=2UN0USoyMoRh9JgU2P1Xlz4tuvpiD++a165pr5Xz/Mmvwxn4ICXNH/Uf2kitx75Tk3G3yT
	Ko128J0/Sh4iC+71FOCLZ1PZMtx/uGFPcnMkbIYbrFyq/56bN+hw1Jq0yx5AVAiCjqiOyu
	fF+R4q/xwPezPgTUJfvulCFoaVRNc+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711522922;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9f6guCBCCX5gVsiss0/i0Pw65KQFxVNRsRCpDMrOZ1M=;
	b=8xQRE97W8KyfHK77l6fukAgUsxFpots4mHViMknJ9aj7xWkUsWi7aRUcxnGGKzUJpqu/gq
	a1mj7daU7BeshOAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711522921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9f6guCBCCX5gVsiss0/i0Pw65KQFxVNRsRCpDMrOZ1M=;
	b=qIS0H3usCqFheuvd5JktHN9zrCqJKkj7doAddiyEMlwPHOKzzoO4sL0YAgrPn+NpEqAYU5
	B+17zwPOuMsnTJf3qmuBzjeSZenZv+v3OQ3UV0sCrOFr60HLX/tubyrrqyyUl0FaBh9paq
	ncrsH0abnECgy3zaAUaTF4ypizv7BfU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711522921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9f6guCBCCX5gVsiss0/i0Pw65KQFxVNRsRCpDMrOZ1M=;
	b=fiRfutidTiGi2DThVLF7pZ2yksDV4eGxmE22zOnb+D5Tps6XQk1lPNL8+VUFF/8pe4vdRN
	pfUz9qT9y4OXJBCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B2B5A13688;
	Wed, 27 Mar 2024 07:01:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id M9rSGWbEA2a5dQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 Mar 2024 07:01:58 +0000
Message-ID: <4d3f229c-64a1-46e7-a906-ecd3dffe8965@suse.de>
Date: Wed, 27 Mar 2024 08:01:55 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/28] block: Introduce blk_zone_update_request_bio()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-4-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240325044452.3125418-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.50
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.50 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.00)[42.32%];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qIS0H3us;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fiRfutid
X-Rspamd-Queue-Id: 3A9F4386A7

On 3/25/24 05:44, Damien Le Moal wrote:
> On completion of a zone append request, the request sector indicates the
> location of the written data. This value must be returned to the user
> through the BIO iter sector. This is done in 2 places: in
> blk_complete_request() and in blk_update_request(). Introduce the inline
> helper function blk_zone_update_request_bio() to avoid duplicating
> this BIO update for zone append requests, and to compile out this
> helper call when CONFIG_BLK_DEV_ZONED is not enabled.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-mq.c | 11 +++++------
>   block/blk.h    | 19 ++++++++++++++++++-
>   2 files changed, 23 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

