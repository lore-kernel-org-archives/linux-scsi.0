Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB8A38B7D4;
	Mon, 12 Oct 2026 01:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791769619; cv=none; b=apCfxpN/C/j+wVBrsJS7UHAPtNMr+aUAtiO/euS0S7KlK7wZCW+cZ5HsJfUI5910pg4dw8MfIZyBv4RrSAqLMRcJoITx0VpKh+6AKDaTcxASKDfiwWcU1NvQ0qsqLhiX3b8zQ117g0x1CMA0Q0Gfn1iXy2NYliZ6cYdso1aQEhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791769619; c=relaxed/simple;
	bh=HkWvjSBUmkpg1WnpgKmCYMiraDBRvp9vc4M6E4vr0rs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TwdfOC44f2b2ZgH/pH9o+qLoPkRGnmy1/NXjwQTJUpNo297i4kfDmeLMFIizSXvb/rPrLarFd1Z0ZP70gVU4HAeyTtkUak95xboeDxWsWTP5M0UVic7yhKNUg9L3/SQs6px6BjzBa8kCpe4eVsZYSJ0Xqj7meiwSHOxOacpakBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kf3NW9+D; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yXwCmq+W; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zCwosnfl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9lykVzk7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kf3NW9+D";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yXwCmq+W";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zCwosnfl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9lykVzk7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BFDC521CA9;
	Mon, 12 Oct 2026 01:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791769615; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kc9yCYeEKHP3L6f+TK7ubvJD270BUetSVj9NKQRjQeM=;
	b=kf3NW9+DuPjZXb9OdkjYwqdT/LWXBjC7+Zq/R0vRj36tTkMehJQXoi0mOQ0/hpNo0GOm4y
	vca8AffU0DPcOnfg9lkCziyyVgQfplZA9j1E0V7qqRA7IQIhQuyD2P2jExsQIilzGCBQNL
	tnvjUGL9f+otfFVvs3vwyqonu+0Npl4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791769615;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kc9yCYeEKHP3L6f+TK7ubvJD270BUetSVj9NKQRjQeM=;
	b=yXwCmq+WWZFAfBd/dtJAEkzCzDGGG+XjQIhrmJZcdBi9B9goLBYzLHhdP6el1VLWKoDbg7
	JSDQprfeMN++KKBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zCwosnfl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9lykVzk7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791769614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kc9yCYeEKHP3L6f+TK7ubvJD270BUetSVj9NKQRjQeM=;
	b=zCwosnflmdGeyvupd4rUfSLo3IiOlezhHAmoldfhysiD6JloAat3lFXZ+gM/gKZH+5SoEk
	+hKQST0tt32cWzFka3F6U5aryloFjrG9z2rYcNV/VMw3CXkn8hy5/0LTPSGj4a8tbAacdT
	MuPyuIjmGBV71pY/EusXSJs3ReIPdoY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791769614;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kc9yCYeEKHP3L6f+TK7ubvJD270BUetSVj9NKQRjQeM=;
	b=9lykVzk7GmY0h9XbFjV0lZkAcufmloycU565K01NrO8Sfg0rs5pZgNRwIFnB0MrLRBV8CI
	QL7dW/4Ikoek89AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9916C13314;
	Mon, 12 Oct 2026 01:46:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZHfuAgs8zGrdCAAAD6G6ig
	(envelope-from <ddiss@suse.de>); Mon, 12 Oct 2026 01:46:51 +0000
Date: Mon, 12 Oct 2026 12:46:26 +1100
From: David Disseldorp <ddiss@suse.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Martin K .
 Petersen" <mkp@kernel.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Lee Duncan <lduncan@suse.com>, Alexandru
 Hossu <hossu.alexandru@gmail.com>
Subject: Re: [PATCH] scsi: target: iscsi: Use crypto library API
Message-ID: <20261012124626.6416100b.ddiss@suse.de>
In-Reply-To: <20261011191235.GA22483@quark>
References: <20261001044857.169487-1-ebiggers@kernel.org>
	<20261011233600.5bb5d6c9.ddiss@suse.de>
	<20261011191235.GA22483@quark>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: BFDC521CA9
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-2.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,suse.com,gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim]
X-Spam-Flag: NO
X-Spam-Score: -2.01

On Sun, 11 Oct 2026 21:12:35 +0200, Eric Biggers wrote:

> On Sun, Oct 11, 2026 at 11:36:00PM +1100, David Disseldorp wrote:
> > Could e.g. SHA1 also require fips filtering here in future?  
> 
> It might.
> 
> > If so, would it make sense to track the fips compat status (preferably
> > at build time) in chap_digest_algs?  
> 
> Let's wait until there's actually more than one before generalizing it.

Fair enough. If you're okay with having the extra caller to update /
audit following any fips compliance changes then I think it makes sense
to merge this as-is.
