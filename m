Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9BB3A9639;
	Mon,  5 Oct 2026 11:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791199179; cv=none; b=KiDtBi5YWKfKmhVxfaaeU20Bi2zm4kCPgkMk4L72VBk1XM4xvTtQAUidXlSj4upyUd9H5QjBlZzI21UU131jGW/ZuVjUw3n8cRu68amc+v/UBG2WfAD+KPanoy3PoSvq/8AmMCnb6M/FrkLrjOTgon/8K3gEmywvD4pmhN34geA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791199179; c=relaxed/simple;
	bh=h9uN2wfs7yIf8qLZmsHIutD82EzVNiikGNmtoGlrk8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KRtLUzju40kGJHq3x91T4EB4DW0lal4NcwfyqZl7vihZQ5ykQQOO9lNVbMh4/25goL+BLEdG07jM5rZdo3epoP1FJTiEOAOJVXqH2Pl1phgK6CjPuQ59VjqsaP7oZYDKM3SDAcyya1z+02mpltVjqx6FcQwUmFi0DPEynkyXBj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=u6kA+Akh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AgtmruS3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fGVkIUK/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7+gZeI6T; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="u6kA+Akh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AgtmruS3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fGVkIUK/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7+gZeI6T"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B9CF621CF2;
	Mon,  5 Oct 2026 11:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791199171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L8X0efBnY2o17JWI+KRrWiD0krP+t8S4QB/t7rQHlFU=;
	b=u6kA+AkhSRFv7aEh44nYxkPVpgia/EuxoOZQ+CE3RdFNGME0SDBAPGTmDSvM8pc/v6kskG
	waqTETCyoqocDeGy9/55LSNWcy24PjjhlkNLUhgnDenMzUsc9Nq2+Tf6VoQt3oyc3HA/Pj
	h2gEz3oZTkRGujr/xzqmuyFLhSRbCDg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791199171;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L8X0efBnY2o17JWI+KRrWiD0krP+t8S4QB/t7rQHlFU=;
	b=AgtmruS3cjCpMasskZzD5+y22PAWqJr/G9hKHO0DQaGnAF3V03rv1ExUvhPbkfQUjTg4pe
	dLhDfJvOHMiF9wAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791199167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L8X0efBnY2o17JWI+KRrWiD0krP+t8S4QB/t7rQHlFU=;
	b=fGVkIUK/iyEwbpwavYcWscdc/Xh7xcud9tp6Gu+9ZT4bCsgzAVflD0o35f6JlDjNwqQTFe
	BK3GQeyMMJ90DR1pPcR6/OVCfzbHFEXq+DxzDXEHjn3mRkNyK+oHFYETafFyzMp88tmSNC
	hmooxgI06DZSgJEcvAACgkC8S/4nvI8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791199167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L8X0efBnY2o17JWI+KRrWiD0krP+t8S4QB/t7rQHlFU=;
	b=7+gZeI6TwUb0mc2hGgfZA22acOE+hQUb7HNp9DitCvAYk1utm/GH1FuZN9ZUns/RD0CW3B
	8XBYSK3iM3dUurAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 821AC13A2D;
	Mon,  5 Oct 2026 11:19:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mZrbGL+Hw2piXQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 05 Oct 2026 11:19:27 +0000
Message-ID: <9f31bd88-e149-4003-812e-c97a803180d9@suse.de>
Date: Mon, 5 Oct 2026 13:19:27 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] scsi: sd_zbc: always revalidate zones for disks
 supporting head depopulation
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261005094632.580753-1-dlemoal@kernel.org>
 <20261005094632.580753-7-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261005094632.580753-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO

On 10/5/26 11:46 AM, Damien Le Moal wrote:
> sd_zbc_revalidate_zones() skips revalidating the zones of a ZBC device if
> the zone size and total number of zones of the disk has not changed. This
> is to avoid a call to the rather slow blk_revalidate_disk_zones().
> 
> However, for ZBC devices that support data preserving head depopulation
> (REMOVE ELEMENT AND MODIFY ZONES command), a disk capacity and number of
> zones does not change after a head is depopulated but the condition of
> zones changes as the zones served by the head that was depopulated become
> either read-only or offline. In this case, not calling
> blk_revalidate_disk_zones() prevents the block layer from taking
> appropriate actions on the zone write plugs of the disk for the zones that
> became read-only or offline.
> 
> Avoid any issue with the block layer view of the zone conditions by not
> skipping the call to blk_revalidate_disk_zones() for disks that support
> the REMOVE ELEMENT AND MODIFY ZONES command. This check is done from
> sd_zbc_read_zones() using the helper function sd_zbc_check_modify_zones().
> The new scsi disk flag modify_zones_supported is defined to remember the
> result of this check.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/sd.h     |  1 +
>   drivers/scsi/sd_zbc.c | 26 +++++++++++++++++++++++++-
>   2 files changed, 26 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
