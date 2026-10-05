Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4425441BA61;
	Mon,  5 Oct 2026 11:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791200916; cv=none; b=IpDpaZc8CjeBp9fT/349zho0V3lFmlzBrXHN1LkzCTOKpF9yVPeT4lXbfkADuY2NkdFiPWSam7iIGWe0AdBGhjYGo2fZmpBz26yxXDeXkpWX1+ALHiFjAKWyib8M7M7KUCBqij6jEfF3Nq/9IyHW8h0+4k1ILwo/XEPLS5+elQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791200916; c=relaxed/simple;
	bh=dbRmjjAVsEDYci4CTOG6atVVQUySG8H0zGY8R97LliE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ix4Y/rhTEZph2wZX9wYcy1NhY/vkpMrFEjX+hbsGff7INSwr89qqsOBljZTmwsaseWoiA4q8f9hK2s/3iVDuCd4memEDr3cSf15tCFGCSClQUWkHc5yGH+8A7+cMSh02URzxDJYnWpHQIqYDu6H+o9z8gt8lBByuoqhwvZZIsNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qe2sLSQZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uYfhT2ti; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FpZ7DO2G; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TpX+L9OH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qe2sLSQZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uYfhT2ti";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FpZ7DO2G";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TpX+L9OH"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D222C1F45B;
	Mon,  5 Oct 2026 11:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791200909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YhIf2SelFsBR3VCy8S0BpZaH4Ib73u2oUMwj5zODYmA=;
	b=Qe2sLSQZ2NowA8G4SW50XMHh8WFEKzlBr4J+7ujj9vnOSsnwyxgTkMusvZjM3Z/yueco6Y
	kLlbdTzdu6kVHsxwVXJjH30tyDcfvN5yhFjBeoXIfpCQdboh4SbLg21Xn2u3lUV64Hr/7o
	FZimtsb3lHzN4Hph08uCHApa2p6RC6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791200909;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YhIf2SelFsBR3VCy8S0BpZaH4Ib73u2oUMwj5zODYmA=;
	b=uYfhT2tijS5lsOvLE5PI0fy9AZsPDqso4ZPOLc3ZLqi4IPIZAdjrev1C4QVpDQW7pKCJg3
	MNCQneGhho8/m3CA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791200904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YhIf2SelFsBR3VCy8S0BpZaH4Ib73u2oUMwj5zODYmA=;
	b=FpZ7DO2GXKsLPGsKCCaF0pdTELtzMXmaCv0cNLN/eAplis+/Kznl+9Ud8rYxjCU9uIYCDs
	PkGCV+13pwTaTOrsfyu08gIS1t6lIi2tTz7FL7ySDVIjv7VydSverqJPMsP05TtoTRy+Ib
	ndIvh9YRBSkzSQOPJu3lj2ENbZT6rSg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791200904;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YhIf2SelFsBR3VCy8S0BpZaH4Ib73u2oUMwj5zODYmA=;
	b=TpX+L9OHdO2n86grwfP4gGtEY25XTr5JGWGH4AkLTtONWhcK/sjs9vK5UvM8NWc+Zih7M0
	oWGmTD6TRCumcBCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7961C13A61;
	Mon,  5 Oct 2026 11:48:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id S6NBE4iOw2pbfAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 05 Oct 2026 11:48:24 +0000
Message-ID: <dfa4731e-b2d1-484a-a1dd-30e5e04a30d3@suse.de>
Date: Mon, 5 Oct 2026 13:48:24 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] scsi: sd_zbc: define storage element management
 operations
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261005094632.580753-1-dlemoal@kernel.org>
 <20261005094632.580753-8-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261005094632.580753-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO

On 10/5/26 11:46 AM, Damien Le Moal wrote:
> Define the storage element management operations using struct
> blk_storage_elements_ops. These operations are valid only on SMR disks
> supporting the storage element depopulation feature.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/sd.c     |   1 +
>   drivers/scsi/sd.h     |   4 +
>   drivers/scsi/sd_zbc.c | 210 ++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 215 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
