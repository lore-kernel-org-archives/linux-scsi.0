Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1294C77B1;
	Mon,  7 Sep 2026 12:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788785615; cv=none; b=T7nq2ckRIT+Iu9sztBN6P7R4C3hcyv8rQDLC7Is3L5LqamTzzMMve60UOP1x1zZYBJTe/6T30/+rbJ9JfO8sTyl0WCV8lDc00uYbGTPDCDYtjTv1zN3Z4DmccPtFKRpQ2/zdLY8s6lUJInYI+shZh2QUG4w6zhRnSZ+rnl0irvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788785615; c=relaxed/simple;
	bh=mF19lEF0iVvdQT5zcjCQzri1w0G9stWGhqWvND5BBWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=de9SL4yjFdbTT/g+ofWFaa18/fd+2EmBaXTlnXtnd2vt8JKq1iqWiKyN2fnYo0o87HCa+nkWs3KUnrevIh+dR3Jw28PGJKBiBMMxt22sqPOqdW5Q4XHkcij0XBnI9UGOqRELSTi/YFwu41uwG1ZCNsghtjlfdKtN18nkuXXoW98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CLPXaN3Z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0yBF4kd6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vz3Msu86; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eQSEN1Lm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CLPXaN3Z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0yBF4kd6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vz3Msu86";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eQSEN1Lm"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5BFAE21AF3;
	Mon,  7 Sep 2026 12:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788785607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sZty2cXD+ivhu8+qte8nqVsOhhVz19mcnNpeZY5mhhk=;
	b=CLPXaN3ZYL6qrSL5oK5rd8wYntCmuhaSLpFkxM9/8iJc4YbYXvf7YpgmAJxi36reFwf/Sz
	fy0QViZhQWN1zozi2CjpNCNXh1QfphMbk+Q4qwBM8k/JhS/7TnEwvD4BDI9jMOzyRi5lsZ
	+GQl90w2lVySL2no9OetWLR77Gp4BPk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788785607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sZty2cXD+ivhu8+qte8nqVsOhhVz19mcnNpeZY5mhhk=;
	b=0yBF4kd6PJjB9WrQ2llXGqycrvDG0sKnbfENrENf6vIk1Q7L7ZT3FxDqcNMtO12tf+9LCR
	ev5y/fzccw3E2yDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788785603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sZty2cXD+ivhu8+qte8nqVsOhhVz19mcnNpeZY5mhhk=;
	b=vz3Msu866SbyZjR/ClrFRX1NeIrDd5uP+osUVuDoqt11pJa+Ac75LPSUFkiXYm8Yjy2hT0
	bgq9YwxD+wH7lWtxGQJtH1VXuX6bQYSAjH8qXMrebttDJ2BweLIDBTVxKZdAu33fntJyx1
	t8bs+GREMTxpsJthMFMsNlpa3LnisAo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788785603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sZty2cXD+ivhu8+qte8nqVsOhhVz19mcnNpeZY5mhhk=;
	b=eQSEN1LmGKGzZ75OWBa0bPPYkopOjZ6IUfVk03RC5Qhe1O07/voEmHjS+ITkvFD430qEHF
	yyKqla9TdA6JAlCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08D341339B;
	Mon,  7 Sep 2026 12:53:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w8sQAcOznmp9RwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:53:23 +0000
Message-ID: <4ddf9fe5-8366-4b85-b158-99aee77ca7d5@suse.de>
Date: Mon, 7 Sep 2026 14:53:22 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 33/40] scsi: storvsc: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-34-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-34-dlemoal@kernel.org>
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
> Refactor the storvsc driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/storvsc_drv.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
