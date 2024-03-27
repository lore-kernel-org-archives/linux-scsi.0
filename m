Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03FC1C11;
	Wed, 27 Mar 2024 07:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711523142; cv=none; b=qF9bDVsL9qqyIB4Hi7IRbkdj34LmVt2V05/fC3Wouq8x7ha0wDwPNLdDdUdfWPbFsMIB3fZEZ98R6scFPE6Bshk7nXWojR2nsQUR7JI7OY55DeOeDZY4RLk68usmnGGoEY57ZySkSwSdn780Ua2SxLQN+BKeY+Ku42YQZ6O+JAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711523142; c=relaxed/simple;
	bh=XOBlX09e+v1j/udaOw/wYT2yZj6VgSRElukmOnK4HV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FoPlnKGQNZr4b8xLw99WGE0/bIERyBNhwfv9cSOud2EgeMt+4MmIKzLV66ECxd0M+puzKQjP37tFVYpt8BIVpqDpJq1VbBdd2DKjvGdFC4AxTXB5pTVhqJdkWlcDQbLHDqaOzC0P8mFN5rfxVjx8R4/SlPMUpZpM7EH7oxc2+KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yqMsbqiK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mRa/yHnm; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yqMsbqiK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mRa/yHnm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yqMsbqiK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mRa/yHnm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yqMsbqiK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mRa/yHnm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9E490386AC;
	Wed, 27 Mar 2024 07:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711523136; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLW+/MaVrU3M8GnOjQqL2d7nAeSWgcaHhlcif43J8fw=;
	b=yqMsbqiKOZGycNfEgzTa/GKjGjYoavviXAl2nbYEwkGjDzTWyfPnhGdrA46CEn4iSlsZut
	hoyOK7LN8S6Mer3AGxdzcTZCF+9czx+00M18lXhcnEWiOrUdx4e3J9481gk39DxmLXKwW9
	pj6th46imryhV5ikOnOWFJGg8kzPUGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711523136;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLW+/MaVrU3M8GnOjQqL2d7nAeSWgcaHhlcif43J8fw=;
	b=mRa/yHnme6la7nDnsZ4uHvp2PZtD3dnL5JAZwtDLXl19lCQ9Bfe+6hSVdliyWXkU7F3Uu+
	0xw70lhIsviXsqCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711523136; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLW+/MaVrU3M8GnOjQqL2d7nAeSWgcaHhlcif43J8fw=;
	b=yqMsbqiKOZGycNfEgzTa/GKjGjYoavviXAl2nbYEwkGjDzTWyfPnhGdrA46CEn4iSlsZut
	hoyOK7LN8S6Mer3AGxdzcTZCF+9czx+00M18lXhcnEWiOrUdx4e3J9481gk39DxmLXKwW9
	pj6th46imryhV5ikOnOWFJGg8kzPUGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711523136;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLW+/MaVrU3M8GnOjQqL2d7nAeSWgcaHhlcif43J8fw=;
	b=mRa/yHnme6la7nDnsZ4uHvp2PZtD3dnL5JAZwtDLXl19lCQ9Bfe+6hSVdliyWXkU7F3Uu+
	0xw70lhIsviXsqCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 850DE13688;
	Wed, 27 Mar 2024 07:05:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bf4gED7FA2Z0dgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 Mar 2024 07:05:34 +0000
Message-ID: <542328d6-f1af-494c-a497-64a653ac3072@suse.de>
Date: Wed, 27 Mar 2024 08:05:31 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/28] block: Remember zone capacity when revalidating
 zones
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-7-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240325044452.3125418-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.29
X-Spamd-Result: default: False [-1.29 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.00)[29.35%];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Flag: NO

On 3/25/24 05:44, Damien Le Moal wrote:
> In preparation for adding zone write plugging, modify
> blk_revalidate_disk_zones() to get the capacity of zones of a zoned
> block device. This capacity value as a number of 512B sectors is stored
> in the gendisk zone_capacity field.
> 
> Given that host-managed SMR disks (including zoned UFS drives) and all
> known NVMe ZNS devices have the same zone capacity for all zones
> blk_revalidate_disk_zones() returns an error if different capacities are
> detected for different zones.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c      | 15 +++++++++++++++
>   include/linux/blkdev.h |  1 +
>   2 files changed, 16 insertions(+)
> 
That again. We should never have allowed zones with different sizes.
Anyway.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

