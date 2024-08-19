Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374E117C77;
	Mon, 19 Aug 2024 06:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724050656; cv=none; b=PCRVgzWb3aUPlkwYusfaEkWmmK/YiQTt8d+u8ClXNOin9eW6o+yA7zRoEepnfEy0RSBfcMhEXB4khrWYm6zGYbH0nj7OBaNmsT42eB8NhMD84Gwm37Hz2U5AC1ZkcWx66BQfqU0SGkwrT/4zcmp6pZBX761k7DvtD4N8jo4TJQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724050656; c=relaxed/simple;
	bh=pioZNQSaZ0K9PQCElGjkothCXVvqpP3lbq9EPYtX+FE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O4umzG2KYTsNu7caT1v2WPJlf21EGRsNgD8rYEFQZL826L6tYA9isXZRubo8I9LI78mtlBYBv66gW3IB09E331aX1Q6vroDhjU2hXjhwW3kkhJS+sc4ahm7IsrrhU4WP65W9/Fxy95rMkDQmrjlZXMH+mFryyiS3tif3KrhXR4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LXFfGfnH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bQdgxIcO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LXFfGfnH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bQdgxIcO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LXFfGfnH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bQdgxIcO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LXFfGfnH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bQdgxIcO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1EE6621EE1;
	Mon, 19 Aug 2024 06:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1724050653; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RrTw/ETigKxKU0RpYb1EDM/y8WBPl9JCdtsbKFUq/U0=;
	b=LXFfGfnH0gYMNi2WEJ1XNw6sdZdruUNehw5N4PUTaToc4wHOe20+1VZROquS1JIc1sbMQR
	T5umQED7S8t2o+ZDI91smkd+4xfBav9HrOMTaRS37mbUis9/kiU+xnQ9q4ExhOyqUbD4lP
	2kl1EQC4udJcsC+M5g58YZeqwMjkyVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1724050653;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RrTw/ETigKxKU0RpYb1EDM/y8WBPl9JCdtsbKFUq/U0=;
	b=bQdgxIcOoPbptbR/4uYJ36cWYWCcwRXbUixV5yN4kJRZc81atJNpiUaTnVytXL02ve61h3
	rTlMPnGYytXwysBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1724050653; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RrTw/ETigKxKU0RpYb1EDM/y8WBPl9JCdtsbKFUq/U0=;
	b=LXFfGfnH0gYMNi2WEJ1XNw6sdZdruUNehw5N4PUTaToc4wHOe20+1VZROquS1JIc1sbMQR
	T5umQED7S8t2o+ZDI91smkd+4xfBav9HrOMTaRS37mbUis9/kiU+xnQ9q4ExhOyqUbD4lP
	2kl1EQC4udJcsC+M5g58YZeqwMjkyVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1724050653;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RrTw/ETigKxKU0RpYb1EDM/y8WBPl9JCdtsbKFUq/U0=;
	b=bQdgxIcOoPbptbR/4uYJ36cWYWCcwRXbUixV5yN4kJRZc81atJNpiUaTnVytXL02ve61h3
	rTlMPnGYytXwysBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 07FF11397F;
	Mon, 19 Aug 2024 06:57:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1nWDAN3swmZxdwAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 19 Aug 2024 06:57:33 +0000
Date: Mon, 19 Aug 2024 08:57:32 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: James Smart <jsmart2021@gmail.com>, 
	James Smart <james.smart@broadcom.com>, Ram Vegesna <ram.vegesna@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: libefc: potential use after free in
 efc_nport_vport_del()
Message-ID: <11af2cbb-9474-477b-9067-aeb551ac382a@flourine.local>
References: <b666ab26-6581-4213-9a3d-32a9147f0399@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b666ab26-6581-4213-9a3d-32a9147f0399@stanley.mountain>
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.26 / 50.00];
	BAYES_HAM(-2.96)[99.83%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,broadcom.com,hansenpartnership.com,oracle.com,vger.kernel.org];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.26

On Thu, Aug 15, 2024 at 02:29:05PM GMT, Dan Carpenter wrote:
> The kref_put() function will call nport->release if the refcount drops
> to zero.  The nport->release release function is _efc_nport_free() which
> frees "nport".  But then we dereference "nport" on the next line which
> is a use after free.  Re-order these lines to avoid the use after free.
> 
> Fixes: fcd427303eb9 ("scsi: elx: libefc: SLI and FC PORT state machine interfaces")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> From static analysis.  Untested.  But it seems low risk.

Look reasonable.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
