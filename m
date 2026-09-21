Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A834A204E;
	Mon, 21 Sep 2026 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789999198; cv=none; b=F7BHICXggjoBfrE24F1W/stHefxRUnN5FRL2m+2eZdsmQpzhu3BEjr/gzTZ8DR4tEI2g0q7CnY1mfYZIYRAtHbxmCe0LloJdVgkgA987bftn1jorO2cPAJ3KHXL5f3x+tijmTG65t6/9+MAH5YoPDCGwIlxQRY3oWd66/Hullk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789999198; c=relaxed/simple;
	bh=nRhAQERN7cLr4iRrzMWoKUoGupsy3gOrX5o7Tl96KAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ABvSfKKESQoMZ2newg/VLpTquCCon20rlU+r4MfcHzudjUseE09pYtMdpiaW+JhWRkFM2DVBkA4p66ajBfk5b/Pw3TKuzhVbQqISHDMTVtw8z9y7xrghICzATebxXbTlIuiuH+gJ1gcdFsycCXZxkNBgaTN+ibiM/Wnhq5cFrUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=liQ7xanl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ucPrQT75; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tMYeHUNQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uDU0Ky2R; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="liQ7xanl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ucPrQT75";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tMYeHUNQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uDU0Ky2R"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 28FBF1F385;
	Mon, 21 Sep 2026 13:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789999191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dXLyIitXIRXihEvVH2hDTFHNE6dERQ29Aq4FyRubbak=;
	b=liQ7xanluPqChOfUvxWbwQSGm6HBzYL1k8ptPIuoP9PgXNwCSHg3BdyGBdOOd9K4v2ZdxG
	X2dOA76qUOdeYQPHH8LGF2gjng5YpFGb3tcOPlpTj4vpQwCVe/ANJc0a9/UcoKKv6Qsgoj
	j7bSKaZLE7Hvmd9LAtjH0BYD8/v0Z7g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789999191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dXLyIitXIRXihEvVH2hDTFHNE6dERQ29Aq4FyRubbak=;
	b=ucPrQT75DSJgN0N8qaefccNRLO9kSTlB/8A8wne+ftwb3I/8S2tMfB0Q2le2B/w9kncFbo
	mUkk1l6JTuR+b3Aw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789999187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dXLyIitXIRXihEvVH2hDTFHNE6dERQ29Aq4FyRubbak=;
	b=tMYeHUNQG1kAn5C2cAjWDYegazwSO0BbuTT0wYYnL2K4VFkWRVfDR/SsfDsurpSiSQst+u
	XOcZJbmUIqnTwWvSc/bJBghqLhInC25LUSBKGxDjpGCHpj++gmbljDgqz/KJ9c+xrRm7my
	xVWIBImYkzjOuBzzu4iKZvVPlRl/+w0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789999187;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dXLyIitXIRXihEvVH2hDTFHNE6dERQ29Aq4FyRubbak=;
	b=uDU0Ky2RlO3l6dJYTYv3jrzqnxq5vhFAQjFkGzgpje3Q8ySW/fSBzmaednVCW5JNp5Yacq
	iIGietpj/vcnnnAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F2091368D;
	Mon, 21 Sep 2026 13:59:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zqTwN1E4sWqSIgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 21 Sep 2026 13:59:46 +0000
Message-ID: <16cda566-f798-427d-bc51-a069b4195c28@suse.de>
Date: Mon, 21 Sep 2026 15:59:45 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] nvme: add NVME_CTRL_MARGINAL flag
To: Jesse Taube <jtaubepe@redhat.com>, linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Justin Tee <justin.tee@broadcom.com>,
 Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
 Paul Ely <paul.ely@broadcom.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 John Meneghini <jmeneghi@redhat.com>, Bryan Gurney <bgurney@redhat.com>,
 Chris Leech <cleech@redhat.com>, "Ewan D . Milne" <emilne@redhat.com>,
 shinichiro.kawasaki@wdc.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
References: <20260902200547.184734-1-jtaubepe@redhat.com>
 <20260902200547.184734-2-jtaubepe@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260902200547.184734-2-jtaubepe@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lwn.net,linuxfoundation.org,kernel.org,kernel.dk,lst.de,grimberg.me,broadcom.com,gmail.com,nvidia.com,hansenpartnership.com,oracle.com,marvell.com,redhat.com,wdc.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On 9/2/26 10:05 PM, Jesse Taube wrote:
> From: Bryan Gurney <bgurney@redhat.com>
> 
> Add a new controller flag, NVME_CTRL_MARGINAL, to help multipath I/O
> policies to react to a path that is set to a "marginal" state.
> 
> The "marginal" flag is initialized to false in `nvme_init_ctrl` and
> cleared in `nvme_fc_ctrl_connectivity_loss` before re-association.
> It is only cleared there, not in the generic `nvme_reset_ctrl` path,
> because the marginal condition reflects a physical link problem.
> An arbitrary controller reset does not signal that a hardware fault has
> been resolved. Calling `nvme_fc_ctrl_connectivity_loss` means the FC
> association has failed and will be re-established, so the prior link
> quality state is no longer meaningful.
> 
> Signed-off-by: Bryan Gurney <bgurney@redhat.com>
> ---
> V10 -> V1:
>   - No change
> V1 -> V2:
>   - Add nvme_ctrl_assign_marginal
>   - Fix nvme_fc_ctrl_connectivity_loss clearing wrong bit.
>   - Update commit message
> ---
>   drivers/nvme/host/core.c |  1 +
>   drivers/nvme/host/fc.c   |  4 ++++
>   drivers/nvme/host/nvme.h | 11 +++++++++++
>   3 files changed, 16 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
