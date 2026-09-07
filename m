Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8498456E0F;
	Mon,  7 Sep 2026 12:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788783550; cv=none; b=raZOj+HaMEyCNYW81dailBeRkN9hFujo7u2T+/3WrcwsRh65zytTX7sATYjHjL5m1Lv4OFXO0ZZPAmOE6l6qZi90qGYqzMw6zJQFFuTc4BKB7fIY6qu8iIgpycRRbMyLOmz/pCPvc1tYh3so2l+5m6w4SJlMk4Mv5YCusikYFps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788783550; c=relaxed/simple;
	bh=XuyntIOBx1gtjqICGa3j3qhzESOX6ONY+vCKzBGn/dQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lbtqIEVsrzO+z1lj+kJcFTaECtBcXCwM4gHp9nYoQ2Yic8xCEjH4jv+nei56+eBlYfbWB6ExXi+KJMSX60go1JUUfdhHewruh2P3/a8w63Rs/67RbUrRtzho9qvJ/KgtQY8Jtk5Hp3lbP3PDpaaAFZMQkbEG9o6VYV/XMwPqQxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zoTD3xv3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Uo4/8VwY; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KPoEATF7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sXmeGZxC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zoTD3xv3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Uo4/8VwY";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KPoEATF7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sXmeGZxC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B4FD11F797;
	Mon,  7 Sep 2026 12:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788783542; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IV1sFaC7g+6ExKyT6lyRXTYLToxm6P3E2z8H64pnf7U=;
	b=zoTD3xv38dVMCFE5JiWMDHf9NzUqbF+qVTgcJFJquqnlu0o3PKwcTHThSLyOc8ml20fR3J
	j2bPYOw8itkpLyFvK8vVkruSUq0xNUv5gPrHKiN8OVenWpk9akZKDsaACDwQcrKG+AdfpE
	6hlVAIri/4dgjq6KoxTDxzNrI79aLZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788783542;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IV1sFaC7g+6ExKyT6lyRXTYLToxm6P3E2z8H64pnf7U=;
	b=Uo4/8VwYRbW6y9UvwPDaY60Ijw9Ism1Vob1Ua+eSFKhOS/hr78RpjVIKjeIxxIJWmwDogE
	e1Wa0SbYeNwayvAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788783538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IV1sFaC7g+6ExKyT6lyRXTYLToxm6P3E2z8H64pnf7U=;
	b=KPoEATF7T49PMGfUa91qyu36jSF2MTo9B1n2+dZrV9QPC1979FP+LIFzybgTNIrW/76x3B
	udyZbv2dAkE8Yl3y19PJ55icg88Y+Md5GhFcoCsQTWvgH8qLg7u/lv3nkJXnnji/DiaQw2
	px+jhy2pmbuLpQQnLfWOnnfzLFKDWT4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788783538;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IV1sFaC7g+6ExKyT6lyRXTYLToxm6P3E2z8H64pnf7U=;
	b=sXmeGZxCPD8HhZMs+lN8/OOj9bfRPVVo9ZEhrKk1I9xzdbWrEDsP/+OUGBNDnTwyHX4dCd
	vhl0lUpxTtiCJzBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5EA691339B;
	Mon,  7 Sep 2026 12:18:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lKAFFrKrnmq1JQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:18:58 +0000
Message-ID: <97ca7f22-070f-4faa-bf52-62ba1d3077c5@suse.de>
Date: Mon, 7 Sep 2026 14:18:57 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/40] scsi: use struct scsi_sense_hdr to log sense
 keys and codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-7-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Instead of passing the sense key, additional sense code and additional
> sense code qualifier as separate parameters, change the functions
> scsi_extd_sense_format(), scsi_format_extd_sense(), and
> usb_stor_show_sense() to take a pointer to a struct scsi_sense_hdr to
> access the sense key and sense code with a single argument.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/constants.c        | 11 +++++------
>   drivers/scsi/scsi_logging.c     | 22 ++++++++++++----------
>   drivers/usb/storage/debug.c     | 12 +++++-------
>   drivers/usb/storage/debug.h     |  4 ++--
>   drivers/usb/storage/transport.c |  2 +-
>   include/scsi/scsi_dbg.h         |  6 +++---
>   6 files changed, 28 insertions(+), 29 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
