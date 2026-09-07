Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E4D4E66D4;
	Mon,  7 Sep 2026 13:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788951; cv=none; b=mOgZimN8QA+8PeFyiGvhPWfGLujN3IadS/myBtCLNS3af/y78RJfVuhcOZzmkj4OR7Snk6o16pnhHU5VHT99gZOdB/u7Iy7tvxnRoA5pEUdfoEg/Cv396O8e+hWa8AfrOJ7Y3S9NdFY9tQSsSLz3vTQUlmPFt7dk5EZiYcXmv5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788951; c=relaxed/simple;
	bh=jgONqcwRuCL90QmP/WhIGsew4b8Ql9dH0+1gnbRg0T0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TsoRbvh/d3ZLYpSJ6I46xVAT1jLqQtCOfP4xh2fDUKUa15nDWwxWgZbxLf9+wkyK1RIzABzZzj1fcEcUTypGF+0pJn3XPqBs71pR0ooY7MeLp0spUacJMzcNzd26xDeiJuYLQMvOH4Pw++xd62KyrMYmqjS65C7E5FIJ/yNKI6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UTi1+hE4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SM7VcCse; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RCOKBA2/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6RLPGA9d; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UTi1+hE4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SM7VcCse";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RCOKBA2/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6RLPGA9d"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 340031F78E;
	Mon,  7 Sep 2026 13:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788788939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hk6DXs+G60VQ0enLiAR++HoAPpI7nBVuuHiRqJorHIA=;
	b=UTi1+hE4zQ8YIcaxfDpk6E+R3/lqL8qm0SlksSWcFvTn87zRFuFmPsp6cjNIKttkOqyjOF
	sTSBjeELPPCFZl7ZiVdcaOtmgdpoVakJ7wLiw8TuZA7iHOTkduCSFSYx1O4sDsSFKke9+F
	OptiDpfhq7vMT1sLYFaeQWj9yrz/jfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788788939;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hk6DXs+G60VQ0enLiAR++HoAPpI7nBVuuHiRqJorHIA=;
	b=SM7VcCsefoqgcqoB9W0mtAQqZTPpQTqGHF0qgTB0PF5+RiH4J0lckEVz4fQ3Pk4qZWL4o6
	OMVlpQrp3BxBANDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788788935; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hk6DXs+G60VQ0enLiAR++HoAPpI7nBVuuHiRqJorHIA=;
	b=RCOKBA2/QkyYPWm1Xj7JplDzQwR6U2/Hk59X+I3OuU9YfVrOrt0I1QyF9s3NR6+PgX4Ozg
	0S9TaeqMZ8PUBR1jTS9WXffMHqFLkLVSQi1XV/sXk6cjBewXwqwdTEVqqNghwlJs+LehfU
	Dganc8IYu9xM8K/Hb4bRI8/Yt2zrBOg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788788935;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hk6DXs+G60VQ0enLiAR++HoAPpI7nBVuuHiRqJorHIA=;
	b=6RLPGA9df9/NyAeb484t4Aqs2S9cJ74ft1fz8Rvrh+voX7leg64X2M2y8E2DzPm0eD98Gw
	k/RM1PZorLRuRfBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D0AC613432;
	Mon,  7 Sep 2026 13:48:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E4raMcbAnmpufwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 13:48:54 +0000
Message-ID: <04d64ba7-99c5-4f2a-80cf-3fe554308167@suse.de>
Date: Mon, 7 Sep 2026 15:48:54 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 15/40] scsi: device_handlers: emc: use 16-bits defined
 sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-16-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-16-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the EMC SCSI device handler driver to use the 16-bits sense_code
> field of struct scsi_sense_hdr and replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/device_handler/scsi_dh_emc.c | 28 ++++++++++++-----------
>   1 file changed, 15 insertions(+), 13 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
