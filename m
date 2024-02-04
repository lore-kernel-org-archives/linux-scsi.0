Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511082260B;
	Sun,  4 Feb 2024 12:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707050051; cv=none; b=MFLInBVhjnkrguQ33Ny3QAV3T9rYJA6jebjv6DjfZwVFtLWRqHTcGl7EHY1sO5pVlZ8JcsHJK4tOb7tS/VfkLlYKInc7L5EJt2niKin1vHoE/qRr4B41v+3Zn+88ozj8xVMf/KggM9zKBbB/7koFIC08Ql2zKxYl7tnlb/APDGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707050051; c=relaxed/simple;
	bh=KAqHPeyqbbkM7mz1XzpXeSeC9X9I4IZ2eDqHgRWSKdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RNpZqp+jn/H6MtCaxYuvLiSgzUpRX5WePA5ifSFKCMZUCF270FKOsAl+fovzyTD9HSCo4fziA8u3gAizoxerl7KdhdbYxj0sqAPMKHNgG3fCvcUppi1sjjzcVk6bD61ezhr6nHh1/aVv4C6dWZYtWHSExUoESBPH64nZihLhpns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RNVaQwMr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BKyg+fCp; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RNVaQwMr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BKyg+fCp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RNVaQwMr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BKyg+fCp";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RNVaQwMr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BKyg+fCp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A39392200A;
	Sun,  4 Feb 2024 12:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dXfZEyKv8LlqEtOyLYelqN+E5lNrn2Sc4lHmcFdtqnc=;
	b=RNVaQwMr5PJ3m5/p0Va+YMLcPr95aYCSACAg19QHx4cTjpkNTtirJ9U5tFxCH43epK4m/H
	9RUxbLIT5xoJcHZjpA6JfDjuyInPGerx4G0ODHv/3o69+OoS5sc3kOQeedHKZEUuODd6Zh
	dfiWRKbgmkaNymIPepa3YtB+dJIhCrU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050048;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dXfZEyKv8LlqEtOyLYelqN+E5lNrn2Sc4lHmcFdtqnc=;
	b=BKyg+fCprhQVrALPZG9wsZd+H5QXgMv7yBCCaXwFPEzkD/QVFQuxFrgmMLcOVyaq83LNWy
	PzkXY/UakTAi/NAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dXfZEyKv8LlqEtOyLYelqN+E5lNrn2Sc4lHmcFdtqnc=;
	b=RNVaQwMr5PJ3m5/p0Va+YMLcPr95aYCSACAg19QHx4cTjpkNTtirJ9U5tFxCH43epK4m/H
	9RUxbLIT5xoJcHZjpA6JfDjuyInPGerx4G0ODHv/3o69+OoS5sc3kOQeedHKZEUuODd6Zh
	dfiWRKbgmkaNymIPepa3YtB+dJIhCrU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050048;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dXfZEyKv8LlqEtOyLYelqN+E5lNrn2Sc4lHmcFdtqnc=;
	b=BKyg+fCprhQVrALPZG9wsZd+H5QXgMv7yBCCaXwFPEzkD/QVFQuxFrgmMLcOVyaq83LNWy
	PzkXY/UakTAi/NAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9616A132DD;
	Sun,  4 Feb 2024 12:34:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GBUWDTyEv2U8JwAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:34:04 +0000
Message-ID: <416fb9dc-2ce0-494e-95ef-64271800366a@suse.de>
Date: Sun, 4 Feb 2024 20:34:04 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/26] nvmet: zns: Do not reference the gendisk
 conv_zones_bitmap
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-17-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-17-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spamd-Result: default: False [-1.36 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-1.27)[89.81%];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -1.36

On 2/2/24 15:30, Damien Le Moal wrote:
> The gendisk conventional zone bitmap is going away. So to check for the
> presence of conventional zones on a zoned target device, always use
> report zones.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/nvme/target/zns.c | 10 +++-------
>   1 file changed, 3 insertions(+), 7 deletions(-)
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

