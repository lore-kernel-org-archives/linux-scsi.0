Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1979B4A8A37;
	Mon,  7 Sep 2026 12:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784703; cv=none; b=c289+dTClSpg5GoN74En2ambEY4lh52OIpK/uGNq2jSAgYjwUUrQX6p6nHPZDEZb0ZH78Q0jvJtMN8FWqncXkDh8tNt8hFTTr2WozIaGrzfKDfVjfK+xcMGwtc/HXxKVZ0MAQZ90N7olxr3+efABrllICULuwoHpBt6imfweMhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784703; c=relaxed/simple;
	bh=yNpcMaa9OAvACXkCpuAHfEAeqiccqelrJMms1tJhEc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mY6pZFKbMs86GCPKxuVO8nyXRHIaeqnnp7YLWYEFgnlKy9e4VDRw04KxqtxFtvVeby3PGfTiiCUbEtrMrLoohm3/V3RSp+F+nP1P8pqFEoqt/Bl3rDwe+6FI7XPO9m9WjpN+qc+/AAry4AsHM0YN+C8KWYUnN0oJhimIeap3lO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MVi/V9gY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kdMe848D; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kRQCNA7i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RT08C9UI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MVi/V9gY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kdMe848D";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kRQCNA7i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RT08C9UI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E982321971;
	Mon,  7 Sep 2026 12:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UzarGzus+9UqI+phxmteOgix+J18btSzqlpLlUk9x4A=;
	b=MVi/V9gYIROBzYADKApB3pxDDLN31Rp3xdE6IjF1dQmkQ9GT1tg319Qxkpcv21Dt83mV7Y
	+sanlTLkHO+jMhQ3KSLrzcYij3r6mAKXMfHtz98lLbLPqfkj/R1BJaF0/YOp4722hqHbPI
	A+BJzwUggZlqnwOX9Arlc12/9rXz70w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784696;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UzarGzus+9UqI+phxmteOgix+J18btSzqlpLlUk9x4A=;
	b=kdMe848D4/8tfA0Bg+xrxaB2tYclQ9l/8tDUuSzQTBzyl7oOgoZbl0aaoqSv07SWrd03AK
	VTtgvOawbSrKBnCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784691; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UzarGzus+9UqI+phxmteOgix+J18btSzqlpLlUk9x4A=;
	b=kRQCNA7iT0T2FMtrzZ90mnYYBbPX8d0ROtFUDBunCmG8WcgU9xvfaFmA0s746vE2ciuann
	I1zQAu4ukn1BOBubG5CM7fOHdZerjQCSn6OBzlAtsfXk/Na013OgxcRlxU+nBTDHO1+jZQ
	BjXrxPyOG0CdiOeLwdvli1lumk9EvNk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784691;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UzarGzus+9UqI+phxmteOgix+J18btSzqlpLlUk9x4A=;
	b=RT08C9UIAQi4kmKif51VuliqK3IWUqsG29w0UPJ9WUuccGQ2FtF6HUJ/iRgFWDmdiKIK4d
	UrpClJjm6hn5ZyCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 955301339B;
	Mon,  7 Sep 2026 12:38:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ixdaIzOwnmpdOAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:38:11 +0000
Message-ID: <02612da5-f521-470f-8c4e-df553265e1f0@suse.de>
Date: Mon, 7 Sep 2026 14:38:11 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 27/40] scsi: stex: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-28-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-28-dlemoal@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the stex driver to use scsi_set_sense() and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/stex.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
