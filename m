Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059114A0EFE;
	Mon,  7 Sep 2026 12:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784242; cv=none; b=l8MEKtXnQd9OW8u+oHdwDGDL2aTFbRrxG39jBHEF1y0YuPBqG4AkzbtXs7htc9QbZdZXspzqFK1MrQOf+Xboz5PFsv5VtNiccyC0N4BWDKOX2MHXzezuarvYebGDFufNSBvFHwCxrsOoK+Q02o6yeg32YmJk9ccA44PelVC4wIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784242; c=relaxed/simple;
	bh=xH+QS4Os1ARC+G4AaHyarkWEO0de/hqY2YElqlmY4oE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TXXQs48bTg3AgczNzJSi15LQa3nazbRN5Qk0w1YfoNn78IFa/jMumjXnBH0gp/2hKWYp03xGR4+/4q2AMz4y2tfaRv1B4x9GZy8pVxlRpk8AtG9tdsI05ksybiShGbddcCzLE5xukS/+am4QezBWcdFmj94Yx/YB7zkpubpMEBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OldZPyiO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=58P/wp2C; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LApGi/QB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=us2B1KWE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OldZPyiO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="58P/wp2C";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LApGi/QB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="us2B1KWE"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 342F11F7AF;
	Mon,  7 Sep 2026 12:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CmFxZfODUZgcELY2+shgzzZDEd/nubFb0ysdRKCccJw=;
	b=OldZPyiOuJpAnBec4gT8jLN75fYfMRjM67kCstrWvedztV1+Z/wRov062EIarvFly3NPcr
	xMBdUTR1w10x70dOkdtxkYcvw1lcxTQQY33iZpdOH8T0aId+2QyQhZIgoEwomdH5qVIH6T
	TzaIJIfzq4R/dxTsEl3DUG1mdsKigCg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784232;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CmFxZfODUZgcELY2+shgzzZDEd/nubFb0ysdRKCccJw=;
	b=58P/wp2C5P1wlROrJ4us2XqqRc+icDngsGaTDjUnhie0ka1q50B5ByBTDasfh02WG/q6Ru
	y5882p1css2UhJBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="LApGi/QB";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=us2B1KWE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784228; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CmFxZfODUZgcELY2+shgzzZDEd/nubFb0ysdRKCccJw=;
	b=LApGi/QBVnJL0tQx09TTt835+D9x+6PNWzz9v7sI8CuCJ2clUpFTAecnLYrSGuyeO3yj5O
	q45h4M4cGqG4UnmWKTxkOPU4t/plT0DvlLT3gbfIxOUT5Rv1+0Hu/15Lk97eOkVpNO45Nd
	X8YMdYcbddNT8G61W2Xle6vC77F1Yo8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784228;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CmFxZfODUZgcELY2+shgzzZDEd/nubFb0ysdRKCccJw=;
	b=us2B1KWEoKjJ2wTld9TbxQ2OeBThVmSazRX3+fI8qCeJAs2uRzXKaQB44FFk5E3p1nFGNI
	t3TgqTuYBTi4EoCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D04C51368D;
	Mon,  7 Sep 2026 12:30:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HjrJMWOunmqjMAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:30:27 +0000
Message-ID: <541884a0-33fe-4c86-b237-e2779bdfd054@suse.de>
Date: Mon, 7 Sep 2026 14:30:27 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/40] scsi: mpi3mr: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-19-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-19-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 342F11F7AF
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the mpi3mr driver to use the 16-bits sense_code field of struct
> scsi_sense_hdr and replace all hard-coded additional sense codes and
> additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/mpi3mr/mpi3mr_fw.c |  3 +-
>   drivers/scsi/mpi3mr/mpi3mr_os.c | 50 +++++++++++++++++----------------
>   2 files changed, 28 insertions(+), 25 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
