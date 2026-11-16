Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794833923;
	b=WTh3taRhm3Ey+ZezRm3iF7eFvI+WGels7i0ZkXApBFrUuzZcchTuBlkMzq8KklfVYoh1
	 XIoYNyfDMWkp3cYvoS3h8JtB8ZNDVDkhIc6XMa9Dq88tOkT7qsfLwm4qyhfcZku4gmLQp
	 jGVMRc25Ufd0pRJSjWzjf3e1a86XE8fGp2O4DtudJXUTlTodQEnPlAsu8caoFVkrWOQcz
	 unx1dRHLWDT1IkGJkxcIT4RAY4qx/Thqp2qWw07S+ZaqM3rhJcykkvQEvCKLcPyydUguZ
	 7ol/RrKcICk8SdLJno8WST9jyEJBh1NO40miqeG7eYBV7efnlcmAEzxSw75wPmFBFkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833923;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=jmM0EnfcW/xyPCaRhKKnwHaeaT7pl8pcEuf4V0yjU4c=;
	b=Gj7dzZ9gulDxLepV2xlQ22RPa6H5qL3Zz17lKME5vwptiAzBWTgmS93vja3tOrQN7OSI
	 AQsMTeSAjwk1RQKGgmi3SYhCF8JB7gf1wzCS8f/a46Ik6bm1dZzTVYKnibplur0mp4PP/
	 /1lHWS2S/xetxZ6VQelrmM+KkUs3+sRzLeu9hq6cfWdvySPS+4KT6Fj6D42rh0sDVK8fJ
	 LOOA9clgbZvma0DcmFr7yvcnIViY5tZKPrpDfZruxJfA8A10aBQwnNk6mRlhMBsKzjOqw
	 r8VpnUka6T+eTKZHteGi+UMOKVtZk0dGEq7f1RtAulE8Wrrzzpy7Hmc1QNrXtAzaIxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=idjAsPe1;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GheU7oCs;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=idjAsPe1;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GheU7oCs;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1434606A329;
	Mon, 16 Nov 2026 12:58:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1434606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=idjAsPe1;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GheU7oCs;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=idjAsPe1;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GheU7oCs
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 152F91F7D2;
	Mon, 16 Nov 2026 12:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794833921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jmM0EnfcW/xyPCaRhKKnwHaeaT7pl8pcEuf4V0yjU4c=;
	b=idjAsPe1BzybrV3usn+9SrCeGgBA1Tin/GKpC15jEhVGzx9fisu2XHHy3J2SWHn4Is6xSm
	b7sR556TRCevfKd6R2xr/lyi62RDoQqWAHuIZWTqd2LzuqDuREGqNeI4OU+01JhLLsdWRT
	mAHQ9mqQCHScVoH+S6A9nTzoqSbwkgw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794833921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jmM0EnfcW/xyPCaRhKKnwHaeaT7pl8pcEuf4V0yjU4c=;
	b=GheU7oCsZ1+yp1qX5WYKKm/9WHZ+P0j1eqdChQKZEFEkECExrmQI5seVOPeXNmrlJMAtjt
	of0ZZuhrztuBNWAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=idjAsPe1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GheU7oCs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794833921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jmM0EnfcW/xyPCaRhKKnwHaeaT7pl8pcEuf4V0yjU4c=;
	b=idjAsPe1BzybrV3usn+9SrCeGgBA1Tin/GKpC15jEhVGzx9fisu2XHHy3J2SWHn4Is6xSm
	b7sR556TRCevfKd6R2xr/lyi62RDoQqWAHuIZWTqd2LzuqDuREGqNeI4OU+01JhLLsdWRT
	mAHQ9mqQCHScVoH+S6A9nTzoqSbwkgw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794833921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jmM0EnfcW/xyPCaRhKKnwHaeaT7pl8pcEuf4V0yjU4c=;
	b=GheU7oCsZ1+yp1qX5WYKKm/9WHZ+P0j1eqdChQKZEFEkECExrmQI5seVOPeXNmrlJMAtjt
	of0ZZuhrztuBNWAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AFF8A1334C;
	Mon, 16 Nov 2026 12:58:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WRPPIQD++moeCAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 16 Nov 2026 12:58:40 +0000
Message-ID: <5969a6dd-62f7-47ca-a38e-f19d5290388c@suse.de>
Date: Mon, 16 Nov 2026 13:58:40 +0100
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
Subject: Re: [PATCH v9 12/13] scsi: sd_zbc: define storage element management
 operations
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261115145015.938426-1-dlemoal@kernel.org>
 <20261115145015.938426-13-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261115145015.938426-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Queue-Id: 152F91F7D2

On 11/15/26 3:50 PM, Damien Le Moal wrote:
> Define the storage element management operations using struct blk_se_ops.
> These operations are valid only on SMR disks supporting the storage
> element depopulation featu, with support for the GET PHYSICAL ELEMENTS
> STATUS command being mandatory. The support for the modify_zones operation
> is already indicated by the depop_modify_zones_supported SCSI disk flag.
> sd_zbc_check_depop_supported() is modified to add detection for the
> command RESTORE ELEMENTS AND REBUILD, which is indicated with the new
> SCSI disk flag depop_restore_supported.
> 
> Both the remove_element and restore_elements operations will block
> until the operation completes or an error is detected.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/sd.c     |   3 +
>   drivers/scsi/sd.h     |   3 +
>   drivers/scsi/sd_zbc.c | 493 +++++++++++++++++++++++++++++++++++++++++-
>   3 files changed, 498 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
