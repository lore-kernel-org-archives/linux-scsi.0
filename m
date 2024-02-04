Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92AD225B2;
	Sun,  4 Feb 2024 12:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707050404; cv=none; b=ejSCsRXtpiF1fC1NvdZqGrXHhHV04SLKWjbSOELnZiIe2KL9LxCqGQvR+c3BsJskhtyabVlJULNN+ENxjqqwVQId5s5vT3FGzEnPDLBUONNwH+YFE3E/cbRk13QA5T6wP2U8adynNZhhhJf0CZs9pVaG8egFZhSKVgkwaJIsd4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707050404; c=relaxed/simple;
	bh=Wvgu5GJM9M2ZlCyRyGwtYfjGbwkbXa6p3PWsB31VrFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bC9Ssu4PSMeP5uLaU7e00So7MEV/u+oZXWQMPWjTAGNXX35WGUjmN5PVD+MwmVhhSL+JdW5VfJ31jJYN7Wujj5bmm3/7J7eOELyEUpzFDYCy9WM4oK0z36Ly1X8VM4GaH4SSzF+utyG3/eyDuUX5KrPZngNiZQIbJep1+x6vyOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GbWYWKly; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TeodAU2m; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GbWYWKly; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TeodAU2m; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GbWYWKly";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TeodAU2m";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GbWYWKly";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TeodAU2m"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3E3AF1F80D;
	Sun,  4 Feb 2024 12:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050401; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ojmR3+X07DZddb6GSt+uXfderPg0h6y9OgoQUfN8PSg=;
	b=GbWYWKlyGbNFQd7jYB5DkkTFJFHPkOO1qlgH08TBOxL9F4Od5dENKAX71pATKm8LSKyIU8
	JnfsnCRJuVYgFgvvZPT4+znotRfOst7L2Ta+QwPZ6Jb8NCuUnmSgI/l3HHCTKIWcrVpYW6
	5BbccUBLCqY8JH+jG3ljZWbDZjWP1HA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050401;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ojmR3+X07DZddb6GSt+uXfderPg0h6y9OgoQUfN8PSg=;
	b=TeodAU2myRwp/PgA9NwK5tUWSKM66qEezsOp1WYRpzclR8tkeVI1rxFNs1FhKYasfKuUqB
	NDbPlxF2tRxr4pCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050401; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ojmR3+X07DZddb6GSt+uXfderPg0h6y9OgoQUfN8PSg=;
	b=GbWYWKlyGbNFQd7jYB5DkkTFJFHPkOO1qlgH08TBOxL9F4Od5dENKAX71pATKm8LSKyIU8
	JnfsnCRJuVYgFgvvZPT4+znotRfOst7L2Ta+QwPZ6Jb8NCuUnmSgI/l3HHCTKIWcrVpYW6
	5BbccUBLCqY8JH+jG3ljZWbDZjWP1HA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050401;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ojmR3+X07DZddb6GSt+uXfderPg0h6y9OgoQUfN8PSg=;
	b=TeodAU2myRwp/PgA9NwK5tUWSKM66qEezsOp1WYRpzclR8tkeVI1rxFNs1FhKYasfKuUqB
	NDbPlxF2tRxr4pCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A6D61132DD;
	Sun,  4 Feb 2024 12:39:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OEfHE52Fv2U8JwAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:39:57 +0000
Message-ID: <e7f6ff49-0cb8-425e-802e-ff9015739af5@suse.de>
Date: Sun, 4 Feb 2024 20:39:57 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 24/26] block: Do not special-case plugging of zone write
 operations
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-25-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-25-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -1.37
X-Spamd-Result: default: False [-1.37 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.08)[64.03%];
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
X-Spam-Flag: NO

On 2/2/24 15:31, Damien Le Moal wrote:
> With the block layer zone write plugging being automatically done for
> any write operation to a zone of a zoned block device, a regular request
> plugging handled through current->plug can only ever see at most a
> single write request per zone. In such case, any potential reordering
> of the plugged requests will be harmless. We can thus remove the special
> casing for write operations to zones and have these requests plugged as
> well. This allows removing the function blk_mq_plug and instead directly
> using current->plug where needed.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-core.c       |  6 ------
>   block/blk-merge.c      |  3 +--
>   block/blk-mq.c         |  7 +------
>   block/blk-mq.h         | 31 -------------------------------
>   include/linux/blkdev.h | 12 ------------
>   5 files changed, 2 insertions(+), 57 deletions(-)
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

