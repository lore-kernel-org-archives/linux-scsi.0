Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F324756C4;
	Mon,  7 Sep 2026 12:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782703; cv=none; b=WA5ovAnTLzYkjSAocjmwibOquciit2nuvL9AMYTsOIuYaCcUNmZhWPW7RpR0008ymshQS20X3Un2/A8XJ3NqjQigJeHyna2gnctGcgFHchpcqOtP0JcAXZD8B6s82fAPkiMz5JFoyhBZ94Kj+7LachzLKNmnOHLow4VwjC3JOYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782703; c=relaxed/simple;
	bh=w8VS46d+D0Z2kODIr5EcV6KSxNjlAQshEk54xKy/IrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Y60wbo0/34OcH2M8aM7vxrvQRixw6lNSM7dgO3Pp0bJ/UENLjCkmA3Tnp5NZBaJTysF6LXdJEvpnF1SqlgiNlikAYIZYFsPNDL8kxiOe+0cgF79ffEsj0aqM9s17sMlcrRV7xHUfR06sYWy2o4UFzDa1okWcDfyPdnEnbSNWt3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UVeYlHtm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5hdfSuru; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=K2xH8Eif; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nBoY8eeJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UVeYlHtm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5hdfSuru";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="K2xH8Eif";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nBoY8eeJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF97B1F78B;
	Mon,  7 Sep 2026 12:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788782696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ucTBYiva6bntVsdLRifND6L/1V4CuvnpLUUStKFWFmc=;
	b=UVeYlHtmNyxwTq2VkcfvZajoz7hRTLwCCEzvZbGKQIcGvOkEleFiUeXS7f0ST+rvXXvdxF
	+S8tBe8PFma1yqpkv3AlfXDdsZIPs6ZTr3YukjCnv0B8fW0+7BAsapvrpSmgStDYEznuJr
	xx7x8yY0839tD14xjnhLHyWQzXCRovs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788782696;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ucTBYiva6bntVsdLRifND6L/1V4CuvnpLUUStKFWFmc=;
	b=5hdfSuruhQyYuHDr0Db7WyooiUHXxm3e8fJQUc2mj7AB7aUSDgYpW70SXZYXTpWzWfaoCs
	30lkIDqxZh0M2hCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788782691; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ucTBYiva6bntVsdLRifND6L/1V4CuvnpLUUStKFWFmc=;
	b=K2xH8EifUb6mw3BDl6VQ7/DQF0FlvKRscuQlZYLmSKc4Bb4F9YI0MQcqpw+gat7OLh7r4h
	PLO8EGscr4nfbUIrVd1vqX4uIZ+/3Vn+SeTFkNUy0Y7rmHnsP8I2xbnQ4qhuC/MLTHf0XY
	gYzTK+bSW6AvWaj4T7/hXlR35v4rKg4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788782691;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ucTBYiva6bntVsdLRifND6L/1V4CuvnpLUUStKFWFmc=;
	b=nBoY8eeJlHYNAyXBvvBBEceimBJKT4f/pfsEzvjibZdA6MxkI+NE28okV8lNypSvzRvAOc
	i/iwV3Uhy4xijqCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D2751339B;
	Mon,  7 Sep 2026 12:04:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DFQjEWOonmqnFwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:04:51 +0000
Message-ID: <59d3ec1f-1b9c-4c1b-b277-1cbd073dee9d@suse.de>
Date: Mon, 7 Sep 2026 14:04:50 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/40] scsi: constants: rename internal struct field
 names
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-4-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-4-dlemoal@kernel.org>
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
> To make the code more clear, rename the code12 field of struct error_info
> to the more natural name "code" and the fields code1, code2_min and
> code2_max of struct error_info2 to the more explicit asc, ascq_min and
> ascq_max.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/constants.c | 22 ++++++++++++----------
>   1 file changed, 12 insertions(+), 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
