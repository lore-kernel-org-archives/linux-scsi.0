Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0077475338;
	Mon,  5 Oct 2026 11:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791199064; cv=none; b=iRmQfzn756S11GxGgpKIlGwwpjVuNWIyldHXSDnkEY1utPfeD9/qX5owf7A3KvzDZrx/ZRdltnINWWqPqUhCIxKhHT3gKaY+/xsCy6EeSPQy1kVFWcI1kw65edlWrrHO3UkyqpvLbkoBMrfqQNgDy9zBlX50heBXzzc21KksFVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791199064; c=relaxed/simple;
	bh=E+uvttdsNAzSDo20fcmcEdvtICN4Eh5R3UljBe0+Fxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cEuHYwhjl312pesWVfTtVI3Nybjx0Z7AM1LUMm4bD94WXvoEtmvdrB4oP3HrORGfdWsSG+4/nTmsMuynLZ+zQ4clkbRiCy1DpZ/J4P2C8gPCC4+0w2aBCPtWKPLcJFGT0GoIYvdnOaIAf5qiaQIapE8AEN4KTqM/hKGs04G/3oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cbM79Ie/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bCYMnKlu; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kKpRxH9X; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=57OLRd6A; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cbM79Ie/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bCYMnKlu";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kKpRxH9X";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="57OLRd6A"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 563F221DD9;
	Mon,  5 Oct 2026 11:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791199056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jQTHz6JHwiw8MwTkMeynQLqvfwk55Pm4WN7odpWTdEM=;
	b=cbM79Ie/VoQFW53qbKpAFk4+Y2VIzwUz0h+g19koYJuvRiZKenD0/YaDw+rfCa+eUz+6tE
	wf1v9L0HFqyOrq3gMlA0geM+3tnhzvcvDftyZVZRb8O9/4nNixfUi/TyyNh6/wSA3aMHnu
	W/idP+/1PDYyn3Nrv5VRkhgdUXVJHc0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791199056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jQTHz6JHwiw8MwTkMeynQLqvfwk55Pm4WN7odpWTdEM=;
	b=bCYMnKluLBeuHGAUygq2yxMvoiIR6TbSZjrHgIGiD7Z26WP2zateagYiyDNWAalGNxoZWx
	p3msL+HWQs3VtDCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791199052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jQTHz6JHwiw8MwTkMeynQLqvfwk55Pm4WN7odpWTdEM=;
	b=kKpRxH9XBj7Ru9VLocamXUgstdTWOUUoCJud/tPJJDrXPGyIjAhn8/KMbIk9ZdqgjPJn+m
	0aGpq4Yx+gKSc39iy0TgUFPnrySQh7rcYm7wSuRDWFoL0GQMjwzQCZyuDk9KgNLpxvRx9d
	cq3WU5W6tp/8yHaNLbqMclYG/91/NKs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791199052;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jQTHz6JHwiw8MwTkMeynQLqvfwk55Pm4WN7odpWTdEM=;
	b=57OLRd6A/6NeCPBBBvM2aMwl4rCLqUNWeIAPKvO5xpKTgB8Oy5gbFH07MqdAYJTfF0v0xB
	h0wDETw5TOxFuvCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 185FE132D3;
	Mon,  5 Oct 2026 11:17:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R3gZOEuHw2o+WwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 05 Oct 2026 11:17:32 +0000
Message-ID: <70cfcb24-c36b-445d-8881-e302089d3935@suse.de>
Date: Mon, 5 Oct 2026 13:17:27 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] zloop: add degrade_element control command
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261005094632.580753-1-dlemoal@kernel.org>
 <20261005094632.580753-6-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261005094632.580753-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 10/5/26 11:46 AM, Damien Le Moal wrote:
> Allow users to mark storage elements of a zloop device as degraded using
> the new "degrade_element" control command. The element to degrade is
> indicated using the element_id option. Example:
> 
> echo "degrade_element id=0,element_id=2" > /dev/zloop-control
> 
> If the element ID identifies an all access storage element, read and write
> operations targeting a zone served by the degraded lement are failed.
> For a partial access storage element, read or write operations are failed
> depending on the storage element type.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/block/zloop.c | 112 ++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 107 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
