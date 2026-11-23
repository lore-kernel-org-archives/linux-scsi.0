Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795451907;
	b=qTmPU1aOYGUNj9x99ILMKuikYWWFhb7FwMaGAyUJzkO9hd1Hu0SbBb5E839sHzGwknF/
	 wVwj90ocv+Py7nsjWhaSZHIkR1o6eCCmes8Aat62eGxeVOslvkGGd8iqng0D7QPHskzOG
	 HKNkaYP8+Dcv0vPGsrjASnoNycrnE1hOKEBDKiGpJ2O7IopYmFiY3JTl8a4fu7UyVkLZb
	 086AMl3icEwyjofVbkRZrKJlrGJXk6dgie5dWa8MXir02X6ChGbEDaGnPOgLR2Nnm9PUX
	 iM0SLe3kbnluE8EiscAxrdahOnQQN0xfjY8JgaoVnN8Wb1PdkU5XAHLSpWPkeqn6UHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795451907;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=aYPAr8C4xnLTxtYkhQI3Bwh0Sx/atle2gFHpTJk8O/8=;
	b=3xcm64JeTb1Bzy8xJ5G2UHx86XXyCPm7h+ZIu54K7aXE/BBWbRI/uI7x9vhKiALxXZLb
	 c/2P3jssgwBggKRdHIy3UkFbK6J1mcV4xiFfsp2aSgZKOQA2UA+RuNbnfWYBNlxQekqxF
	 u3mPg119+x4fbpsuJoCorKK98wkEg9911cCTIghowf9Devo8J+uMeKN2zxT7+RfcTDUqf
	 7UTGJwatSjc1g54ackcRtzg6Da0sPnr53FfC5EUdFYUe1mAvRGvEImVSjRe3AgVpADIn8
	 lF4v8eKGER+ZcmjXDpneQEUABK7T/2N4rl8p0bLtWhXJcAmc7O8Pc2pnSVMcubc27HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=a4OfJP3c;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5ec6cRNi;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=a4OfJP3c;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5ec6cRNi;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21ED9606A31A;
	Mon, 23 Nov 2026 16:38:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21ED9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=a4OfJP3c;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5ec6cRNi;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=a4OfJP3c;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5ec6cRNi
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1CC7A220FD;
	Mon, 23 Nov 2026 16:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795451905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aYPAr8C4xnLTxtYkhQI3Bwh0Sx/atle2gFHpTJk8O/8=;
	b=a4OfJP3cfakyj+bd+uVP560Ufc3LlS09Y/mhODPvL8jTTfqiztnWBLk75Qlo8cXuN1PgPi
	sDHZ7dnOUI73IAPozTtX1W2LSzackzpAp3jkIzKxBDZmG4qpWGHUVFMfWyvXCoL89GkShi
	BT7/BbReD11FIBOIdVNNtTp88fVwcPg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795451905;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aYPAr8C4xnLTxtYkhQI3Bwh0Sx/atle2gFHpTJk8O/8=;
	b=5ec6cRNiAa8Nm3VjOcKS83+6HcylU8plSE5zL1AQCDxrrYo85XjzJ6HUqJJu1BtNHChsUH
	eAep4v2coaDPL5Cg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795451905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aYPAr8C4xnLTxtYkhQI3Bwh0Sx/atle2gFHpTJk8O/8=;
	b=a4OfJP3cfakyj+bd+uVP560Ufc3LlS09Y/mhODPvL8jTTfqiztnWBLk75Qlo8cXuN1PgPi
	sDHZ7dnOUI73IAPozTtX1W2LSzackzpAp3jkIzKxBDZmG4qpWGHUVFMfWyvXCoL89GkShi
	BT7/BbReD11FIBOIdVNNtTp88fVwcPg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795451905;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aYPAr8C4xnLTxtYkhQI3Bwh0Sx/atle2gFHpTJk8O/8=;
	b=5ec6cRNiAa8Nm3VjOcKS83+6HcylU8plSE5zL1AQCDxrrYo85XjzJ6HUqJJu1BtNHChsUH
	eAep4v2coaDPL5Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C0D4A13505;
	Mon, 23 Nov 2026 16:38:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id atHMHwBsBGtnYQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 23 Nov 2026 16:38:24 +0000
Message-ID: <a0740379-6e93-43eb-a81b-02302423a6f9@suse.de>
Date: Mon, 23 Nov 2026 17:38:24 +0100
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
 <a102ffd1-7eb3-420d-84eb-eb4705a43b4c@suse.de>
 <bebc3f8c-822e-40b8-b7fb-c2fd8277b10f@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <bebc3f8c-822e-40b8-b7fb-c2fd8277b10f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.998];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[suse.de:email];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.29
X-Spam-Level: 
X-Spam-Flag: NO

On 11/19/26 1:57 PM, Damien Le Moal wrote:
> On 11/18/26 23:24, Hannes Reinecke wrote:
>> On 11/16/26 10:36 PM, Damien Le Moal wrote:
>>> Emulate the storage element depopulation feature of SMR disks in the
>>> zloop driver. This emulation is controlled using the new stor_elements
>>> option. This option can take several values:
>>>    - ZLOOP_STOR_ELEMENTS_NONE (0): no emulation (default)
>>>    - ZLOOP_STOR_ELEMENTS_RDWR (1): emulate all access storage elements
>>>      (e.g.  read+write heads)
>>>    - ZLOOP_STOR_ELEMENTS_PAIRS (2): emulate fractional access storage
>>>      elements (e.g. pairs of read and write heads)
>>>
>>> If enabled with the value 1 or 2, the number of storage elements, or of
>>> pairs of fractional access storage elements, is automatically calculated
>>> based on the number of zones of the device so that we have at least 2 and
>>> at most 32 storage elements or pairs of fractional access storage
>>> elements.
>>>
>>> The mapping of zones to storage elements is defined simply as the modulo
>>> of a zone number with the number of storage elements for the all access
>>> storage elements emulation and with the number of storage element pairs
>>> for the fractional access storage element emulation case. E.g, removing
>>> a storage element from a set of 4 all access storage elements will
>>> offline 1 zone every 4 zones.
>>>
>>> The storage element management operations are specified with the
>>> structure zloop_se_ops (struct blk_se_ops).
>>>
>>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>>> ---
>>>    .../admin-guide/blockdev/zoned_loop.rst       |  11 +-
>>>    drivers/block/zloop.c                         | 710 +++++++++++++++++-
>>>    2 files changed, 694 insertions(+), 27 deletions(-)
>>>
>> [ .. ]
>>> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
>>> index 6bb68022ab30..1731e4ad5c98 100644
>>> --- a/drivers/block/zloop.c
>>> +++ b/drivers/block/zloop.c
>>> @@ -18,6 +18,7 @@
>>>    #include <linux/parser.h>
>>>    #include <linux/seq_file.h>
>>>    #include <linux/xattr.h>
>>> +#include <linux/delay.h>
>>>    
>>>    /*
>>>     * Options for adding (and removing) a device.
>>
>> [ ..  ]
>>
>>> @@ -1149,6 +1699,74 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
>>>    	return ret;
>>>    }
>>>    
>>> +#define ZLOOP_MIN_STOR_ELEMENTS			2
>>> +#define ZLOOP_MAX_STOR_ELEMENTS			32
> 
> This one is indeed a limit, so that we do not go crazy on the number of storage
> elements, resulting in an emulation that is representative of a real disk. Note
> that for a real disk, this would mean that we have 16-disks (1 head per surface,
> 2 heads per disk) and no disk today on the market have that many. So this is
> already "large".
> 
Well, typically an emulation (on this level) also serves to evaluate
scaling limitations, where HW limitations are less interesting.

>>> +#define ZLOOP_MIN_ZONES_PER_STOR_ELEMENTS	32
> 
> This one is not a limit, but rather what we aim for when the number of zones is
> low so that we have a reasonable number of zones per element. Basically, to
> avoid the rather silly case on one zone per element for small devices.
> 
Oh, yeah, I get why you set these limits.
My intention was more to use zloop to precisely evaluate these daft 
corner cases.

But okay, if it's just to emulate 'real' HW than I'm fine.

So:
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
