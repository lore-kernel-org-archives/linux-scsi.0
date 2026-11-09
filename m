Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794222858;
	b=x7MTuHHHgYG7QER8P6lsiPKCXzp9rAl6mA09+dlrshKZtL+cNkK6A6iUf8abE1YD2aHw
	 4GtHAgtfom21VbG7okS8+rJAHGAnLtL9YAaq9K1cvgknTeMov868gM/Q5T4x85OoIXCiD
	 cuI+ffG/I1D1QBuANXkNEZ+oeWF5xy29cgdSdJR7x0lS7+fBOXI21T0NpODUh2NTJwChR
	 iQ+KtzNiDpTp8HTekhRdo9irOhD9I3VunTnnAIIzPENGAsT7+fmMuXFwN3px0vO/d4+Qu
	 2YjWQB2xLry+3iZnvtOm4fB0TbgmO7s+N/BSLBHpEAMeK3Te2lh1tsajco9ETJ3mF9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794222858;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=WAmWIdEsqoUgWiOzogeCTmQOgEAbUo40d3Bmp9qpOhg=;
	b=knbL2q4RSQvXrxwUzKLOZiHTrvxrf0ohmRxXiTYKBzIUA+5aNojRiT0D50bZ5VbGmp8q
	 B7XqEnh0bAgoh078pjKD6dZiV1bzMtWoV9XSG4M0GY4BRgSOTij2k9Q0J+DLvdWzLlgCb
	 1DQ1pmvD/4B5qvt7Me+ik7aO96S+SZAfDmTniZHk3OL2lJgecUeFyLVN7s49FVSmG1aeJ
	 Oxs80npYuOKBkRZBR7p6We+eKHaf0KMCxh5a/XVorMV65HfAnCb4GM/8KgvDy7K/Oa8cb
	 nZ4RTSzW8Mx2nM/6VevGRyTr7rb0HDlVexuqX+KqqPqbx2GIJycCthJ2i+GryP02lnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=KR4aCGqU;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WYi5dFrH;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=KR4aCGqU;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WYi5dFrH;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E53606A31C;
	Mon,  9 Nov 2026 11:14:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12E53606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=KR4aCGqU;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WYi5dFrH;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=KR4aCGqU;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WYi5dFrH
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 25A8021ECA;
	Mon,  9 Nov 2026 11:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794222856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WAmWIdEsqoUgWiOzogeCTmQOgEAbUo40d3Bmp9qpOhg=;
	b=KR4aCGqUIP+OMqzbzIhYjkd6HzW/WHVGpCaAVEemNMJELuJZR10Anoo9O/OJ6GXvpoywup
	cWaBS2EbGpL0gYrCgB5pZG2J8HoDnTZjcqlwcxDpUlBEANfDupe78WRjR+SNUkRbGvNbLE
	cIrQBNtvTkJaRm1eblSBhqyJ0xMg46g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794222856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WAmWIdEsqoUgWiOzogeCTmQOgEAbUo40d3Bmp9qpOhg=;
	b=WYi5dFrHUca0XJ2RLRjaz/UJOk4kLx/bNaXooGujwonxq9uDuMLjiqED0Hf1v5Y8PZNcp+
	4q0PqQgHKNcKAMDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794222856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WAmWIdEsqoUgWiOzogeCTmQOgEAbUo40d3Bmp9qpOhg=;
	b=KR4aCGqUIP+OMqzbzIhYjkd6HzW/WHVGpCaAVEemNMJELuJZR10Anoo9O/OJ6GXvpoywup
	cWaBS2EbGpL0gYrCgB5pZG2J8HoDnTZjcqlwcxDpUlBEANfDupe78WRjR+SNUkRbGvNbLE
	cIrQBNtvTkJaRm1eblSBhqyJ0xMg46g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794222856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WAmWIdEsqoUgWiOzogeCTmQOgEAbUo40d3Bmp9qpOhg=;
	b=WYi5dFrHUca0XJ2RLRjaz/UJOk4kLx/bNaXooGujwonxq9uDuMLjiqED0Hf1v5Y8PZNcp+
	4q0PqQgHKNcKAMDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D66D313319;
	Mon,  9 Nov 2026 11:14:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GojYKger8WokGQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Nov 2026 11:14:15 +0000
Message-ID: <d22682f4-a83c-4870-a9b2-21f6de064606@suse.de>
Date: Mon, 9 Nov 2026 12:14:15 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/12] block: introduce storage element management
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261109095144.819709-1-dlemoal@kernel.org>
 <20261109095144.819709-5-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261109095144.819709-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.997];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -13.29
X-Spam-Level: 
X-Spam-Flag: NO

On 11/9/26 10:51 AM, Damien Le Moal wrote:
> Recent SCSI (SBC) and ATA (ACS) standards define the storage element
> depopulation feature. This feature is intended for managing hard-disks
> heads, either combined read-write heads or pairs of read and write heads,
> allowing to keep disks with defective heads longer in production by
> allowing "depopulating" (removing) defective heads.
> 
> This feature comes in two different flavors:
>   - A destructive version which removes a head and reformats the disk at a
>     lower capacity point, restoring a fully functional contiguous LBA
>     address space.
>   - A data preserving version restricted to host-managed zoned disks, which
>     marks the zones served by a removed head as offline or read-only.
> 
> In preparation for using the data-preserving flavor of the depopulation
> feature in file systems natively supporting zoned block devices, introduce
> a set of storage element management operations and functions to define
> generic calls into block device drivers for managing storage elements.
> 
> The set of operations is defined with struct blk_se_ops and includes three
> operations:
>   - report_elements: get information on a device storage elements state
>     reported with the new struct blk_se.
>   - remove_element: depopulate a defective storage element, blocking until
>     the operation completes.
>   - restore_elements: restore depopulated storage elements, blocking until
>     the operation completes.
> 
> Each operation is called from the functions
> bdev_report_storage_elements(), bdev_remove_storage_element() and
> bdev_restore_storage_elements() respectively.
> 
> Removing a healthy storage element from a device is possible and useful
> for testing. The storage element restoration operation restore_elements
> allows repopulating such healthy element. Repopulating defective storage
> elements is generally not allowed by devices.
> 
> The remove_element and restore_elements operations are executed under the
> zone revalidation lock so that they are serialized against each other and
> also serialized against user initiated device revalidation, thus allowing
> to always have a consistent view of the device zone conditions after
> executing these operations. In case of failure, zone revalidation is still
> executed, which may give an unstable view of the zone states. In such
> case, stable zone states will be recovered with zone access error handling
> or later zone revalidation.
> 
> The device drivers of zoned block devices can indicate support for the
> storage element depopulation feature by specifying the storage element
> management operations with the se_ops field of struct
> block_device_operations.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c             | 205 ++++++++++++++++++++++++++++++++++
>   block/blk.h                   |   5 +
>   block/genhd.c                 |   4 +
>   include/linux/blkdev.h        |  55 +++++++++
>   include/uapi/linux/blkzoned.h |  65 +++++++++++
>   5 files changed, 334 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
