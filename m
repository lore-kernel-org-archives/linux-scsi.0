Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792575674;
	b=LgWevFLgH2IoTvAXnZNW3N6HcVzWpxVOWsi1hXE2A69+uQBaE7/Rt30pUEwhsPyJvb3z
	 D1VIkaskHPh62kM+//+2B8OKJC8gDQns2ZQs4ptqBW6tbvm6Tck3dYjkFEMwegcOUqhmr
	 3LEi2kl/5MzqgaMtDRcpQDLYFat+sz7dgYryl/8Df05bPIujBtq8SPmKjQOWDzbtUa/+H
	 itT8fxtNPylf1D3U7Zm9hMc4nXbep83hUNQh7QyaKJnfcbgBBKe8IZlT6QJpcJh1y+ny+
	 ngummZGGdHMGtwhLwDP7IbLkWFgfdfFlhPdMVYKDXaPb34AwFTxKzN/wDfmCV9yNGjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792575674;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-Rspamd-Action:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Flag:X-Spam-Score;
	bh=DomER6fWHoHIQgJEFnnPaixRJWOEGbpCft0dhZMvVZM=;
	b=PlmIuqQ/qbHl/pmXfZ+2gGppyVzhN6wUbZBs+z+/3MYrzLozSUZr//GkAYb/kK3AmaED
	 e+UZOzSk3KAI7zn6SaZx3Gn5SEbD7uoGbVtZysUIzKgudGOvL6aWgtIugRsZvwzAqRfzr
	 OWgWTlOo9bEWM0d3mfjNPogic+uiwaeJ6etQssrx9DKJ+eTRNxSMTots3yUrIi++QBcIF
	 6Wn9a4ZHhHo13UANnQ90ffoMTEIq2abYKHZfgC1GNyeDAPEvJYQejaz7AWAXEFX0Skg0K
	 c7zm3kVUHvIe+Eg+K4QvqP/yJ3mD971xd51wc5j+qp2uLUvA8pwHKzI4hOcOtm9EzXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=0tukjKi2;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=njw8MjqA;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=0tukjKi2;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=njw8MjqA;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C9C606A31A;
	Wed, 21 Oct 2026 09:41:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79C9C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=0tukjKi2;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=njw8MjqA;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=0tukjKi2;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=njw8MjqA
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BDED61F799;
	Wed, 21 Oct 2026 09:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792575671; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DomER6fWHoHIQgJEFnnPaixRJWOEGbpCft0dhZMvVZM=;
	b=0tukjKi2UW/OCTycSn2pYziX/X59G6XE1xC1ZuC7u6nbTzFOApYxTOFKEgHkI/nzWg8Dpg
	vAXeM4ge51USVoenTds7eup6hEsCGEuXRrs0DAVOBlpsX1xXuOlwKW/3nQVQsUZCuyqCpB
	LBVGmEymX3/32R4h4rLbzxR7338EJuk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792575671;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DomER6fWHoHIQgJEFnnPaixRJWOEGbpCft0dhZMvVZM=;
	b=njw8MjqAVJlwIWqP+jLtmQ3wNhI9m9X1d4Nwdez34TxuqD75yuEkEnu8RvNurCcsMrHXlD
	h81xVI75hWufukBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0tukjKi2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=njw8MjqA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792575671; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DomER6fWHoHIQgJEFnnPaixRJWOEGbpCft0dhZMvVZM=;
	b=0tukjKi2UW/OCTycSn2pYziX/X59G6XE1xC1ZuC7u6nbTzFOApYxTOFKEgHkI/nzWg8Dpg
	vAXeM4ge51USVoenTds7eup6hEsCGEuXRrs0DAVOBlpsX1xXuOlwKW/3nQVQsUZCuyqCpB
	LBVGmEymX3/32R4h4rLbzxR7338EJuk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792575671;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DomER6fWHoHIQgJEFnnPaixRJWOEGbpCft0dhZMvVZM=;
	b=njw8MjqAVJlwIWqP+jLtmQ3wNhI9m9X1d4Nwdez34TxuqD75yuEkEnu8RvNurCcsMrHXlD
	h81xVI75hWufukBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 80C23134FD;
	Wed, 21 Oct 2026 09:41:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qJBIFreI2Gp7IQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 21 Oct 2026 09:41:11 +0000
Message-ID: <be5404ab-459e-445f-8488-4d087fb9352a@suse.de>
Date: Wed, 21 Oct 2026 11:41:11 +0200
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
Subject: Re: [PATCH v6 02/10] block: refactor blk_revalidate_disk_zones()
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
 <20261013122750.2237843-3-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261013122750.2237843-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: BDED61F799
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.50

On 10/13/26 2:27 PM, Damien Le Moal wrote:
> Split out most of the code of blk_revalidate_disk_zones() into the
> internal function disk_revalidate_zones(). This will allow calling this
> new helper together with other code under the zone revalidation mutex.
> No functional change.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-zoned.c | 63 +++++++++++++++++++++++++----------------------
>   1 file changed, 34 insertions(+), 29 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
