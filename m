Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E764964F;
	Mon,  7 Sep 2026 12:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788785729; cv=none; b=qYK2fUiKOt6/F0NQZmT/v9cDNYc4brX+F4UlRtJI66Cs3n2ke38j0iq3NWdMRjph/5YHpJ0+AemzFkQfaZY1lPt+fC9fLHrcFoOJfUIiCe++cYHdwBTdxW5tyvExyqruxy3tQs9cx1F3djzzUQDf2P1ke3l6J/KgD4LIyR/J6XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788785729; c=relaxed/simple;
	bh=7I+2jwZ2ab74oIExpfOn1MEBUuXu9rJASsfPr2XUbmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TyOBum9H5U26hXGB43Ny92hClHN4TQINLPKUyBmx3DykcVa5LaXYx43p402USbK7PlFLbY7aBeYm4oDLGx+1YkyPE2yZIBq1PBhU3AfxV28Phq5nad0l4e+08vX2NKZvopSuY1/ouKcrUTz2470x1zydlj8NGSpv7JVzrr4d5yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=y6mKQwvT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9m8doNuV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dUsS339y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mHlhXugC; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="y6mKQwvT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9m8doNuV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dUsS339y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mHlhXugC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 714D921992;
	Mon,  7 Sep 2026 12:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788785720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xaLxO8P9j3J4a5uXIkU449quQwQTaiQCxhEq9XQb5nc=;
	b=y6mKQwvTf5phOepezYDj39wcTjNx7by4xvqfo/60PJQZmeE+ZORUw1Cd4JhlQ44BSVrxOZ
	09tQyWAQAL3PwbxBvKOhhLbUxK7Rtj8bcT9QPxFW+EH8jUEvY5fcqoZDtLO9BzF0tefToB
	cMo/GELWWmxzCTMZWmaicAug1nLPhsM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788785720;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xaLxO8P9j3J4a5uXIkU449quQwQTaiQCxhEq9XQb5nc=;
	b=9m8doNuV15rn1EfXHuKOwklIJJ3HFIBJ/1NQ7nHBTUjtxZelZpKZZRNQ4fbNVGsS+88RiL
	+zVzzIDsa9UvCOCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788785716; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xaLxO8P9j3J4a5uXIkU449quQwQTaiQCxhEq9XQb5nc=;
	b=dUsS339y47XQhoAxxWD4Ysqag5683pwcugUwq5G1i9t6Dfd2Tp4P2w2EOXOE8yx5MlH9Qj
	30hobCzElG6cBVAG24VhXdT/BsAacIWR6u53PDZ3yFcF0QNJsEy1+s1WUwFwr+Y8QDY8Y3
	YgRYqkPWInFjh9WXVE8DM40t6Oe/ca4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788785716;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xaLxO8P9j3J4a5uXIkU449quQwQTaiQCxhEq9XQb5nc=;
	b=mHlhXugCWYgQo7bpodLQD2800YI6U40VOww4L2/zHc8a3ndo6VpnNv5cepgjBW8IDVlMzN
	bSKvqhF6WZ8PK/Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C7BC1339B;
	Mon,  7 Sep 2026 12:55:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w0udBTS0nmq1SQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:55:16 +0000
Message-ID: <2d84a46d-1f3b-4166-aaef-833b08a65b18@suse.de>
Date: Mon, 7 Sep 2026 14:55:15 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 34/40] target: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-35-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-35-dlemoal@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the target core code to use the 16-bits sense codes for building
> sense and replace all hard-coded additional sense codes and additional
> sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/target/target_core_spc.c       | 11 +++++-----
>   drivers/target/target_core_transport.c | 11 +++++-----
>   drivers/target/target_core_ua.c        | 28 ++++++++++----------------
>   drivers/target/target_core_ua.h        |  7 +++----
>   4 files changed, 25 insertions(+), 32 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
