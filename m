Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04444CB8AA;
	Mon,  7 Sep 2026 13:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788787091; cv=none; b=E4nsraRlI6l4Sia2FzXfAoCIkRqwk8/rKXVqPrmbJawTE+gAgBfZkz8oHy4R3h1GP+BAi+l9+Qb4tkl2vG2w/RWDogEoKlHRBrWhmHQ8xo33seiRQzsMdXnJcHnt7K9YXS6C3Y2x1EcCnpPPtJq1dKCiArTXHxAPn8TB59T3JD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788787091; c=relaxed/simple;
	bh=O8uD2nbZB0Kt9/+io9cvL2eRlnC2Z2oKlAmoSDOxyqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ezOubL77J/RMfKS6MXc21kOAfJp8SFphF7ysAI5z2OiqgFwJRPlfrRn2qIlAvuLMz+k0YTCLf0mIKF31nn/Pm3zMJvyrQVSRri3lafc+0xy4KKapk5lI6isV2jEYqW7KZfSx8szjieD7yzkvQWu46sNqcJvcJhiWAKCWn9gjDpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=W4CCJWHo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=589G9XlD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nOCPtAZd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3YygAve1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="W4CCJWHo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="589G9XlD";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nOCPtAZd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3YygAve1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 675361F794;
	Mon,  7 Sep 2026 13:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788787078; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6JzXSexZp9RLB4Ar/DI+xtlDtytp3zP+xY/lsYQUObs=;
	b=W4CCJWHoJpAUWQysS9RW38ww3QIbCjI3T3z8/iWBE+NO1cv/haNnfjLvtxyK2M2+i6UmjS
	heYamMyd9QcA6TIjBBLXgp23LFkL5TqF3MlO6n/PF3BE9OofUh6GoXcjXPmxjOUg2g1jbW
	MtE06fo7CtLwkAaomco9gb5j0XYtImc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788787078;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6JzXSexZp9RLB4Ar/DI+xtlDtytp3zP+xY/lsYQUObs=;
	b=589G9XlDhmn33fzJwTwqdXzGXeDQGvpAqyto+3p7vHgc2PjMuI7r1vCU+5T22PGr2WhccA
	kmmxSWpMGsqeglDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788787074; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6JzXSexZp9RLB4Ar/DI+xtlDtytp3zP+xY/lsYQUObs=;
	b=nOCPtAZdo23FqRnNrGl1Nxc+EufP8/cMxRDZVVWD7Bxw9xvHx7Vp4Y4d28UouHPuVgZhzu
	mAg9f+ha9VvhdJ7Fhs4wLuC3fBm9G/6gnbm3eUS9VjnU4GwQSy1yz5KZGeiFi47lBlTu0u
	k6THNrTfmD6kB9tU20Qvw87/04zBVkY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788787074;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6JzXSexZp9RLB4Ar/DI+xtlDtytp3zP+xY/lsYQUObs=;
	b=3YygAve1GCdMF0oH3Mr9HgRt8D2f7TNVJQQh4H+E/kzS20yJccBWYvWy0brFgtr3+Dm9uI
	0sWBzf57PH6Ep1AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C95813432;
	Mon,  7 Sep 2026 13:17:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sIXuAYK5nmocYAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 13:17:54 +0000
Message-ID: <f1b95798-300e-495b-bf0d-338db425021a@suse.de>
Date: Mon, 7 Sep 2026 15:17:53 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 36/40] cdrom: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-37-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-37-dlemoal@kernel.org>
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
> Refactor the cdrom driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/cdrom/cdrom.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
