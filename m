Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B10A4A64CA;
	Mon,  7 Sep 2026 12:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784507; cv=none; b=TiHaDA26GI+Y5bw4QN4JkLODqjWIu2E3WRUCu1bb8M1ZYOZWD91lPS5B5l0YS9kcLQjrv94Ar4LzItsFJ84iZVrYv8ncSIMXX9QEKuF26XeqaKcxxYuftRCJHfjJVN++OMRJ9jYuRWtOAj7L3YjuS6KV0e5OA4yrqz0xiKT+Lwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784507; c=relaxed/simple;
	bh=qkh63eQzySZVgxdxFxt7x0ulS1bRfDNYTKHNepzWTpI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Lt6kqW97DT5QPfa9NqbIU8PCgqvdHE8cHzfG7J7uIMqDx/gDELzZZMhzHVrFoF4/gl6rmOfZJcl3BxtWAnbLZJeJ3v7LFvnv1ksbg18ztHQPrlhJ+IsoKfnbXbWzm9DI4O6RIpR938ZgeidFqrExwyKHZ1i7UuQnwPehtgvkPSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=K0Ofalp5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=n6AmhhsZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cPMeU+jZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=r4sqpanK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="K0Ofalp5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="n6AmhhsZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cPMeU+jZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="r4sqpanK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 89A0E21AED;
	Mon,  7 Sep 2026 12:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gkr06rIilcwLC9M7H0pjBjOlR4eY0QINWaNA090+OIE=;
	b=K0Ofalp5cUo2tZ5zJSeFpIoB+Fz3Ka16SVtiTp2mojQWKEdGAfXgvl99uc9LA8GXISMsCk
	n0Nm39u3FYUJS40mbu+MFiXLp0bVLKoeX3ufJW0P7rj/ddwAwL1JCsEOqyh4424qN5o899
	1bp+M4fqPHbzgybGX1DIHpzDiuhtpy0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784499;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gkr06rIilcwLC9M7H0pjBjOlR4eY0QINWaNA090+OIE=;
	b=n6AmhhsZWgaKv+R5TyjDRi7VBI6lWCsHYeEyYsXeluV9I2F9Li8I9pDhhMo/xoWMSAQGhd
	MNBdqm3egBqE4cBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784495; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gkr06rIilcwLC9M7H0pjBjOlR4eY0QINWaNA090+OIE=;
	b=cPMeU+jZB0nG6fUcmOOqa6cX21ZqSl4kgibT7S57J8U2HFrgw7+7771k+aFGHBoM1tvbWy
	5z9zl5RFPG40JQERZ9GHn4Zs7uEkybkecHOHJN0+W2JGDgrHR/Nyl3A7b6bM8Gkai7dAdj
	Yuk/2PrIGrgDQM08Z55XzoZ6LrJDIz0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784495;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gkr06rIilcwLC9M7H0pjBjOlR4eY0QINWaNA090+OIE=;
	b=r4sqpanKaZ/CUAPFFWfzuhQ0p/0Bp0Xdlmzsqn6Y0IiDvthDJ+yGDXfB3NaK3B7/DVt7CH
	P/btUgD1Zp2xR9CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 267981339B;
	Mon,  7 Sep 2026 12:34:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aLYuCG+vnmpgNQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:34:55 +0000
Message-ID: <46449423-117f-448c-b8ff-d83c45e01a14@suse.de>
Date: Mon, 7 Sep 2026 14:34:54 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 22/40] scsi: myrX: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-23-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-23-dlemoal@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the Mylex RAID controller driver to use scsi_set_sense() and the
> 16-bits sense_code field of struct scsi_sense_hdr and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/myrb.c | 67 +++++++++++++++++++++++----------------------
>   drivers/scsi/myrs.c | 23 ++++++++++------
>   2 files changed, 48 insertions(+), 42 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
