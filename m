Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792576406;
	b=ql6bM/Hdyy3BI/u5g7+9+tHNTsxEUyJcw7D4uwmONWRSS9LhQUdDpBV5dNQPw2VCeMPC
	 GKebhkNY9E1tGDLchb0jy7nHBrarjakcyxucvuz9alXz+z2vL9XuJnhhwiI4PVil38nax
	 vKTbGqabrfCIfAlo9hqk4hS27rAP2w1XJSCzzwWioR2Os/W6TpdcoivhEtHW3YnnP/cFJ
	 SeeKx7YsLzkBCsNcY0bVaw6x6kcnyF3GDkU/FHRv8fgzF4mfS9rRX5Jhp5TyNV0MwMHH+
	 CoYwrtYFIUPT8K6Q6pbr74H2HDp2jQtnwVfceN+BYCPNZHa1bVgXu//kjHMzZsos/3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792576406;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Action:X-Spam-Score:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Level:X-Rspamd-Queue-Id:
	 X-Rspamd-Server;
	bh=KP6eYf8vYa9uwY4vxCeIOOggHMd/wM2cBj1/S932WLc=;
	b=28bTGIM/8ZEWqGAAdZAruBYHidgrQSdDdRTLfUIMQQ6QPJWfqvbzezKHcAT+qECD76Vj
	 XbvPOBX5zV4X4p1pcJbgTYDDz40Im69Z9VtyiKfYeNIGEqYLc8z7ynO+tr4uIbmUNL6cM
	 p9iw5g3IWOKHr6jJ9a62rbGGedJL2vDtEJB0x47EEWJxg5TrLYu4PxY1hSWMSzyCs5Vfh
	 deWqLwIZrbe984USO9myvFlTFNFw7Gn6nP0+kgXePuWYW/XMBZzsAhKnk76rUzAQrO+HM
	 mAc3eTMz3OhECnKQ0sAmMl2khBrLdV6LOE3ja4VaAm1/bVGt8XO8osNmUyYwbUiHdoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=HmGHQ18z;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ikp1S3VY;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=HmGHQ18z;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ikp1S3VY;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0E0606A31F;
	Wed, 21 Oct 2026 09:53:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD0E0606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=HmGHQ18z;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ikp1S3VY;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=HmGHQ18z;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ikp1S3VY
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CE36221D81;
	Wed, 21 Oct 2026 09:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792576403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KP6eYf8vYa9uwY4vxCeIOOggHMd/wM2cBj1/S932WLc=;
	b=HmGHQ18zU3UwD0KpuNkBFfPonCyJJMwhhA62i7qbmncjlQDd2dYuAG+Bp9Brocz9rFoF8a
	08OX86IFK8loiBizuDcn17v8QR5S1/CloZHUE2kctI5QHXRAwqGM952S/fTKYRedFFWtan
	V8qGMh524ubW7lFdqhRaYWQL0Bunbmk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792576403;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KP6eYf8vYa9uwY4vxCeIOOggHMd/wM2cBj1/S932WLc=;
	b=ikp1S3VYPAzH9oAQJqXTeh764OhYL/XqcPoH1gBiPYURfBYd61IDvb9e1xloeNg0aO+sI0
	PKDF9AMhhaXXO3CQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HmGHQ18z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ikp1S3VY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792576403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KP6eYf8vYa9uwY4vxCeIOOggHMd/wM2cBj1/S932WLc=;
	b=HmGHQ18zU3UwD0KpuNkBFfPonCyJJMwhhA62i7qbmncjlQDd2dYuAG+Bp9Brocz9rFoF8a
	08OX86IFK8loiBizuDcn17v8QR5S1/CloZHUE2kctI5QHXRAwqGM952S/fTKYRedFFWtan
	V8qGMh524ubW7lFdqhRaYWQL0Bunbmk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792576403;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KP6eYf8vYa9uwY4vxCeIOOggHMd/wM2cBj1/S932WLc=;
	b=ikp1S3VYPAzH9oAQJqXTeh764OhYL/XqcPoH1gBiPYURfBYd61IDvb9e1xloeNg0aO+sI0
	PKDF9AMhhaXXO3CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC586134FD;
	Wed, 21 Oct 2026 09:53:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HJ4SH4iL2GouLgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 21 Oct 2026 09:53:13 +0000
Message-ID: <4d2c0fba-4fb8-4266-b5e7-49ba1ca72262@suse.de>
Date: Wed, 21 Oct 2026 11:53:09 +0200
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
Subject: Re: [PATCH v6 10/10] scsi: sd_zbc: define storage element management
 operations
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
 <20261013122750.2237843-11-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261013122750.2237843-11-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -4.50
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,lst.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Rspamd-Queue-Id: CE36221D81
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On 10/13/26 2:27 PM, Damien Le Moal wrote:
> Define the storage element management operations using struct
> blk_storage_elements_ops. These operations are valid only on SMR disks
> supporting the storage element depopulation feature.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.c     |   3 +
>   drivers/scsi/sd.h     |   2 +
>   drivers/scsi/sd_zbc.c | 233 ++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 238 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
