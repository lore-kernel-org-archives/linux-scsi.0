Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB1E22098;
	Sun,  4 Feb 2024 12:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707048058; cv=none; b=aXAkMGzWaLR1dLRxsKXu9SGNOpqwe/D4SiW0QOGAmflurA9Oy28wLQuFEcipVeo/Ns4nUnfn0321WPCh2t9PpLRGi1T342oIB5VcJOr2cwgbtURG1sqdHVGrrUdYMmo3j0jIBFUQLsf8C13c8EmH9DYijq3Tcc2lV7sRcpLo7tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707048058; c=relaxed/simple;
	bh=qsauI59fIsbq7wQGIbN12gPAFK/a8w/5SKTHIoBEuOU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pK0IGib4kKFwk5P4HmYjpZLYlE6htJzEMXZnlVgQC9/YO8c+fJq89hAGa+aJ90b65mhHQBoz7maGcv5XOETd9mRG9fEUtfdGCYUs0xPsal2j04TxIXBd/GkbaHPV+7Y+qAmc0JfysGsr/68LekqcCZX4xGjgpK4xhob/oFOE2EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mJWz8No0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=So2BgTIj; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mJWz8No0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=So2BgTIj; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mJWz8No0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="So2BgTIj";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mJWz8No0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="So2BgTIj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3D11D21D97;
	Sun,  4 Feb 2024 12:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707048054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L2SylTSOQKbJ5WTDuwqhItET2gQDXtvufW6eijw5k8Q=;
	b=mJWz8No0GDT6rvbhG4RmCO9lP80AkQHmOkdZb5JBBolJVObAcptAi4JzfLAP504JZ0w9qm
	V9aUaKjQCu3b/qD1+sgsqRCTO5BeNWJYx/18UlIkYlOCxVll6WXqKPX331y1bCQB7V/kil
	phT45aWE80L6bSmLeX04XpMDPSSBvbA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707048054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L2SylTSOQKbJ5WTDuwqhItET2gQDXtvufW6eijw5k8Q=;
	b=So2BgTIj+6csktC1IEnFfxOnJQ2SSir+rj/l0eteYhELT88JSn4iDFEhBna2PQ8Y1Y0F36
	Aqu2zYqNM34ot8BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707048054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L2SylTSOQKbJ5WTDuwqhItET2gQDXtvufW6eijw5k8Q=;
	b=mJWz8No0GDT6rvbhG4RmCO9lP80AkQHmOkdZb5JBBolJVObAcptAi4JzfLAP504JZ0w9qm
	V9aUaKjQCu3b/qD1+sgsqRCTO5BeNWJYx/18UlIkYlOCxVll6WXqKPX331y1bCQB7V/kil
	phT45aWE80L6bSmLeX04XpMDPSSBvbA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707048054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L2SylTSOQKbJ5WTDuwqhItET2gQDXtvufW6eijw5k8Q=;
	b=So2BgTIj+6csktC1IEnFfxOnJQ2SSir+rj/l0eteYhELT88JSn4iDFEhBna2PQ8Y1Y0F36
	Aqu2zYqNM34ot8BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A07661338E;
	Sun,  4 Feb 2024 12:00:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aEhjGWp8v2WjIAAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:00:42 +0000
Message-ID: <e381faba-28db-4f77-babf-397d5d3257a1@suse.de>
Date: Sun, 4 Feb 2024 20:00:42 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/26] block: Allow using bio_attempt_back_merge()
 internally
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-6-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mJWz8No0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=So2BgTIj
X-Spamd-Result: default: False [-2.60 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-2.30)[96.72%];
	 MIME_GOOD(-0.10)[text/plain];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 3D11D21D97
X-Spam-Level: 
X-Spam-Score: -2.60
X-Spam-Flag: NO

On 2/2/24 15:30, Damien Le Moal wrote:
> Remove the static definition of bio_attempt_back_merge() to allow using
> this function internally from other block layer files. Add the
> definition of enum bio_merge_status and the declaration of
> bio_attempt_back_merge() to block/blk.h.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-merge.c | 8 +-------
>   block/blk.h       | 8 ++++++++
>   2 files changed, 9 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

