Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E790654A7C5;
	Tue,  8 Sep 2026 14:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788877784; cv=none; b=EKqa/FRTZM+y5ERQwoHBA90d4xCM4YFmEAyFG9OFameLZlC6b09fQBAz0dRD35dypQBHXbFNitj4iD67GlSKEE3D3PGSjwTSZY5JLzdR4vaUX5CKcL2HMrLu6DZHTZBrs8Eqye1zNL4NFqgB03NHWPpx7dsRDR8drzMrHpAokVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788877784; c=relaxed/simple;
	bh=qt2b9KsboVT1GH0s38SD5C3UCiKfrPzq7yTqTpYYpAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WtzbAezzgMDm28h5wRxPKu7g+JvTygUwo1Zh76lMJI/qBh/XpwZGBv2DVbTIG3mphEVkc+Weg+mgWh54xsgfiJZp4xQL9RK5gqBwUmgDBzsva/v2JbN8G7JIMDEDIZvrpENYzx53lls8/F+IFM6mMyANOQ6bSwAAlq7jPuA9EaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1dwBb2Rl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=swJ5enVK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KZaC3ne5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nWi+jAOx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1dwBb2Rl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="swJ5enVK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KZaC3ne5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nWi+jAOx"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7C8551F834;
	Tue,  8 Sep 2026 14:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788877759; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V32DLLYQQzWVcX1Q3n4upFOrQoOskBDe9ipQikXd1rI=;
	b=1dwBb2RlsCgbTmDPzZZd5VK4bbh/9mmHXfknvR1z3LBQ2lcHtttWheqn9qaYjcuCiURoTD
	HvYVTnZVUVLg2VKYVScndhfM6Zs6tF02Ld/t13d7kt4Qr73uMNGxvRj6EeQF8+d8LrCEVc
	15R3oh33S58asl7FxUMgY+TgBhF05PU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788877759;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V32DLLYQQzWVcX1Q3n4upFOrQoOskBDe9ipQikXd1rI=;
	b=swJ5enVKMTghuLLSIrrBVZT4R2zWG9wsEfCzvbIkOLuCOqZ2r7o9138WB2d1rvr0U5JvYh
	EVavVyk1Lo27s4Ag==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788877755; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V32DLLYQQzWVcX1Q3n4upFOrQoOskBDe9ipQikXd1rI=;
	b=KZaC3ne5RBRn9Ms6r4LECAce1E+jANgnVZd5s9kFmkXEnDoDOW2ZzKO7OGL3E0zuhtdBNi
	A/1k93WBvz7NIbn2rcCwsUP8qOgN3LXqKGG3dCylbu/OE9siUUN82RtadR256MtbZHZWfS
	GOAi7BfTh0Eg90GQqcygxIOwcBGPbzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788877755;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V32DLLYQQzWVcX1Q3n4upFOrQoOskBDe9ipQikXd1rI=;
	b=nWi+jAOxKDy51dcKwNqN/PVFA23mk1shNMn5bzfX5QYON5J7U28EPtUdq/Oi0FZB1Y5oZn
	he54jjJHmmg6OsAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29D161347F;
	Tue,  8 Sep 2026 14:29:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zsatCbsboGqJCwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 08 Sep 2026 14:29:15 +0000
Message-ID: <fa7b32d0-6e1d-4550-af0b-85b89b0fafd3@suse.de>
Date: Tue, 8 Sep 2026 16:29:14 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/40] scsi: prepare for using 16-bits defined sense
 codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-6-dlemoal@kernel.org>
 <cb08459f-ac72-4f37-b241-b4cc047f4890@suse.de>
 <2d926172-4ae8-458b-a7c3-e870e36e043d@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <2d926172-4ae8-458b-a7c3-e870e36e043d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]

On 9/8/26 2:22 AM, Damien Le Moal wrote:
> On 9/7/26 21:16, Hannes Reinecke wrote:
>>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>>> index e321471e8ca2..11910142ac50 100644
>>> --- a/include/scsi/scsi_device.h
>>> +++ b/include/scsi/scsi_device.h
>>> @@ -518,6 +518,7 @@ extern void scsi_sanitize_inquiry_string(unsigned char
>>> *s, int len);
>>>     * to match any sense key, ASC, and ASCQ value.
>>>     */
>>>    #define SCMD_FAILURE_SENSE_KEY_ANY    0xff
>>> +#define SCMD_FAILURE_SENSE_CODE_ANY    0xffff
>>>    #define SCMD_FAILURE_ASC_ANY        0xff
>>>    #define SCMD_FAILURE_ASCQ_ANY        0xff
>>>    /* Always retry a matching failure. */
>>> @@ -526,8 +527,18 @@ extern void scsi_sanitize_inquiry_string(unsigned char
>>> *s, int len);
>>>    struct scsi_failure {
>>>        int result;
>>>        u8 sense_key;
>>> -    u8 asc;
>>> -    u8 ascq;
>>> +    union {
>>> +        struct {
>>> +#if defined(__BIG_ENDIAN)
>>> +            u8 asc;
>>> +            u8 ascq;
>>> +#elif defined(__LITTLE_ENDIAN)
>>> +            u8 ascq;
>>> +            u8 asc;
>>> +#endif
>>> +        };
>>> +        u16 sense_code;
>>> +    };
>>>        /*
>>>         * Number of times scsi_execute_cmd will retry the failure. It does
>>>         * not count for the total_allowed.
>>
>> Why do we have two definitions for the sense code header? Can't we combine it
>> with the definitions in scsi_common.h ?
> 
> This is *not* the sense header. This is the struct used to filter errors for
> internal SCSI commands issued with scsi_execute_cmd(). And since that function
> is devlared in scsi_device.h, this struct declaration is here too.
> 
Oh, I know. I just thought we could combine them.
But if not that's fine, too.

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
