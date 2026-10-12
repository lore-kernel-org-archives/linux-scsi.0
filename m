Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B0C470EB6;
	Mon, 12 Oct 2026 09:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791797808; cv=none; b=bfeVgpq/3b88AjwuvWVK3TREksAmpMFAbAeQdjNr/iih+szq5BfZHtn6UV7QHIV20Du2LRWXKOSQivKwrMNa+H6kJmV4MgiE1DNstcrfDA0RjsPlFHgxhaCSwPK5rQ+qtwaN/Ev548C0ZPz09MPRvoWylflEvxYDX0rjj/3AkiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791797808; c=relaxed/simple;
	bh=cdDL0fzdx3mSzbY6TTuzweN50io87oRpsq5NP0mGu9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lmgQBjwNYr5PC2BvroUoAZ4jJgm++EuJ6eKf4oTonnMlH3A8V6qFw0SuqJRHhQ20qAVRA1VgYxFkkkJgRo2l4KOjHkQ6AAfdV1w92xoMh7PDtDVBG69u0d3HSjjI3jQbFeAM2lP6P1spCzLrhFJS2T00FpcslZ8idyx2CYTc4CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2OTJ80RF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=znqgkLXb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2OTJ80RF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=znqgkLXb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2OTJ80RF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="znqgkLXb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2OTJ80RF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="znqgkLXb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6F07E1F78F;
	Mon, 12 Oct 2026 09:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791797802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jUbDVs8WhAScRqzw3RYhzfZg79or6YVW3F8tIHyJCGo=;
	b=2OTJ80RFVJpLH4brQUgFWWIHURnUUrZIuf5DLJnvEHpYhKk2F6vEBIYNPigEMVtRr2eqpY
	DBps6agVeTdZu1Qk1ObLasxW7leU2GJp5TChsae6g8b4It9jsScKDR/pbKeo4QR8tXMHVC
	q+6Msyo1PgncydOOe2B6kwv/iVjRyJo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791797802;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jUbDVs8WhAScRqzw3RYhzfZg79or6YVW3F8tIHyJCGo=;
	b=znqgkLXb3nsAqVh0GKKDV7FiD43o49QDO4kwDBnBSnhVzm+1dB0xnVR2xhFj7J2KUW8I+p
	6sQVLXiuKk4ERGCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791797802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jUbDVs8WhAScRqzw3RYhzfZg79or6YVW3F8tIHyJCGo=;
	b=2OTJ80RFVJpLH4brQUgFWWIHURnUUrZIuf5DLJnvEHpYhKk2F6vEBIYNPigEMVtRr2eqpY
	DBps6agVeTdZu1Qk1ObLasxW7leU2GJp5TChsae6g8b4It9jsScKDR/pbKeo4QR8tXMHVC
	q+6Msyo1PgncydOOe2B6kwv/iVjRyJo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791797802;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jUbDVs8WhAScRqzw3RYhzfZg79or6YVW3F8tIHyJCGo=;
	b=znqgkLXb3nsAqVh0GKKDV7FiD43o49QDO4kwDBnBSnhVzm+1dB0xnVR2xhFj7J2KUW8I+p
	6sQVLXiuKk4ERGCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 437D913314;
	Mon, 12 Oct 2026 09:36:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZsTBCSqqzGoDcgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 12 Oct 2026 09:36:42 +0000
Date: Mon, 12 Oct 2026 11:36:33 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Haotian Zhang <vulab@iscas.ac.cn>
Cc: Ram Vegesna <ram.vegesna@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: libefc: fix resources leak in efcport_init()
 error path
Message-ID: <8b13f55e-acab-4515-9059-87862a4fbdea@flourine.local>
References: <20261008185403.2791781-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008185403.2791781-1-vulab@iscas.ac.cn>
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[broadcom.com,hansenpartnership.com,kernel.org,gmail.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO

On Fri, Oct 09, 2026 at 02:54:03AM +0800, Haotian Zhang wrote:
> efcport_init() creates efc->node_pool and efc->node_dma_pool before
> allocating efc->els_io_pool. When the latter allocation fails it returns
> -ENOMEM without releasing the node dma pool or the node pool, leaking
> both. The caller efct_efclib_config() only logs the error and
> efct_device_attach() failure path never calls efcport_destroy(), so the
> resources are never freed.
> 
> Destroy node_dma_pool and node_pool before returning from the
> els_io_pool allocation failure path.
> 
> Fixes: d7b71fd2195e ("scsi: elx: libefc: Emulex FC discovery library APIs and definitions")
> Assisted-by: DeepSeek-V4.1-Flash
> Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>

Patch looks correct.

I didn't follow your other submission and this fix here is simple
enough, so I don't mind it.

Though, I see Krzysztof's response and thus you should not take my
Reviewed by tag here as free ticket to overload other maintainers.
Please follow our community guidelines.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
