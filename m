Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D105744C662;
	Mon,  7 Sep 2026 12:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788785570; cv=none; b=HLAJAXfKTpXucy0f+V/LsPWbPW68wm9AVcMCyLIhdqgv8QV+zUwNn2uVBM2l9cNQ+qqtQd2g0My3DS8RaZaMT959i4QpPeK4dD5YTaJFZnqLRX7oXVFVlBG+M6/4FSOcOyst+Tke46Y1xGYCCEZl9g1Of21XSiS7F4NhIB8im0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788785570; c=relaxed/simple;
	bh=/7BVpMvjxAWSL4C1MNMm1O8cq9P1RiV/kZfFX6qKANk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Wljgj3UkWe84+EhSlh7ksDwsjZO3baUi4qmMiykGvMv8E2eePrqNoLTBtK2IwgOaXu/Ffl8Bv/q34lP9LvcXP78ls0oU44ZmsRvBvvZdqWryEOyxUx/fgu175WncLHfxJZA54iUVKDiJbAn57fF4CWBoj2q/ifpTeen3JMKcrqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=srKDo1Lb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AlnRwcZs; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MDGV3vwp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NTiOy8kG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="srKDo1Lb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AlnRwcZs";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MDGV3vwp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NTiOy8kG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 997D421962;
	Mon,  7 Sep 2026 12:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788785562; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nO9f4dMJPDoz1HkOn++xm94rfzO6F2syu7l/9T9EPoE=;
	b=srKDo1Lb5x/K43wh/5t/POTJTOoG3L+w+CagBTToo3RTEtBPHKVPB/laf0eRfUe6soMuyV
	XwzZj3Q7G08XIbiv5WPE/vc7mOvaJAElLJsFOMGyO+xP2zjMfQ2mVT6UjBOcpar5TQ1dK1
	plxEc0RFyytqLDwVewxGRbz4r9p2+14=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788785562;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nO9f4dMJPDoz1HkOn++xm94rfzO6F2syu7l/9T9EPoE=;
	b=AlnRwcZsWtqZSHEt8q6Mk5yieXC9bE9FDZ+Bdw8N6XYHFCmZc4zVqJYKWed78OzWxV60bg
	LfGx5S9Ke7zlEnBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788785558; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nO9f4dMJPDoz1HkOn++xm94rfzO6F2syu7l/9T9EPoE=;
	b=MDGV3vwpHRgZMyobahR96jGtJkyfTWXEBsL+DIedvxHbM+TtMEmaBj5NAlOMQ6z7Isd5/H
	Friq0XaRXzhsGgjEFFFRyCDiVb8wroPaXXA4qgEgGfjJcIUD8jCTkOgxT0wC1lsN+6ixMS
	yztYntH1EEsV8e/ORtIiocQyJp1zm/s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788785558;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nO9f4dMJPDoz1HkOn++xm94rfzO6F2syu7l/9T9EPoE=;
	b=NTiOy8kGnz9yxNHlevwFBS4scBD9pcURV1kv33vfn2hEuvPA4ju3oI5giqQvtssPQyE6x0
	EBzUN7u1vuZyN7AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 410321339B;
	Mon,  7 Sep 2026 12:52:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gUREDpaznmrIRgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:52:38 +0000
Message-ID: <2a4e4aec-669c-4b8c-9c9c-7c46e05908a9@suse.de>
Date: Mon, 7 Sep 2026 14:52:37 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 32/40] scsi: hpsa: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-33-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-33-dlemoal@kernel.org>
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
> Refactor the hpsa driver to replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> The function decode_sense_data() is also modified to take a pointer to a
> 16-bits sense_code variable in place of the two pointers to the additional
> sense code and its code qualifier. The local definitions of ASCs and ASCQs
> are deleted too.
> 
> No functional change intended, but the function hpsa_volume_offline() was
> checking only the addditional sense code qualifier with checking the
> additional sense code. This change assumes that the intended additional
> sense code to check is ASC_LU_NOT_READY.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/hpsa.c     | 69 +++++++++++++++++++++--------------------
>   drivers/scsi/hpsa_cmd.h | 23 --------------
>   2 files changed, 35 insertions(+), 57 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
