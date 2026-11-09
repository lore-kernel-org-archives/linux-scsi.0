Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794223063;
	b=zSsaYdzldnnGk99A7EH80m8pM20Zl1O395RPpt9H5xpcf53pKKBp8HHhqQjGpHHOYDyr
	 ZtTShSmQ+wXa6PixYBVmGJbjT7On4zA1R/J9WObEKWGVPjBMguUS6EfarPlP1wKruz23O
	 2LxpFrNI7cMVXhjq/dJM3DXj+gs7Om2m0M47hhwxgZ0CrOOcM1kQDNSMyAEiLA6ITeuol
	 pYUqvfve1Sayt40eHUS4YhWAn3y+/1r07kE3yycQK9JhA1Y6UB57ESPseWV1WonYzffAB
	 mg0vknIr/nHVMsBI8UMs2fMbDTpsoDjodMoOZkrvhQBMNMwvUsaEfuN8dU+Tet/eyDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794223063;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=Zu64lQAMfDvZOgTZJc7wWXGbiQeCo1Yra71xvwPkWg4=;
	b=0jrwop1Jcy+te4nuf2vhvsFtoRirf9kvyaFhLTYC5e07HUWLTVDXPStW0459S3092C+O
	 YLoKQr99rQfwno5oYZ8s1Ys0Xy6mV+v9UnLrFiL36Pm9o5ldjU7+dx9bSuLCOR5xEvpyn
	 lrF8xLJh9OqLEvR9SkTCfAxr4jNCDc/7hVa04Csd4eViFklQkzrf+VR4/eYYqhuYr3aKy
	 vHgXkwq/9sj+o9FzF+pHF0ibfyB4KVCroRpD+Q9LKtzfhw2Itc9HP5qM5fLxDHQ8sYOJ+
	 9xDT+vXYyzsyAWLTdF+8eKLrKAP/YH7Vvf2Bttd7kvaX4/qmW5JlIcQNs61wXaoQ0mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=PguRA5oF;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SSvgg3pY;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=PguRA5oF;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SSvgg3pY;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F2D606A322;
	Mon,  9 Nov 2026 11:17:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77F2D606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=PguRA5oF;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SSvgg3pY;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=PguRA5oF;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SSvgg3pY
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 85D75221CE;
	Mon,  9 Nov 2026 11:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794223060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zu64lQAMfDvZOgTZJc7wWXGbiQeCo1Yra71xvwPkWg4=;
	b=PguRA5oFHxXiByYxuQtnlid9GqP5KDuAJRoeKLj8FfkCixIUD1swhd6Ug19ra3gr1tn4qU
	rwd0J2nlDP12KmDa8PwC46HuePD5M/p6wZKEugqlAlC83rfZSH1srz8CI3nQn9Gdkc6FQs
	EHaQ6Sk77ZDHFX0phCaMiLBsvrfCF8A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794223060;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zu64lQAMfDvZOgTZJc7wWXGbiQeCo1Yra71xvwPkWg4=;
	b=SSvgg3pYNyKibj3cxaovK7KVMEwbplamhoSar7lmLfmPuAR0cbtM8hcJ+paEhYI/cx5UiC
	QNDYsexPlW1UrAAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PguRA5oF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SSvgg3pY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794223060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zu64lQAMfDvZOgTZJc7wWXGbiQeCo1Yra71xvwPkWg4=;
	b=PguRA5oFHxXiByYxuQtnlid9GqP5KDuAJRoeKLj8FfkCixIUD1swhd6Ug19ra3gr1tn4qU
	rwd0J2nlDP12KmDa8PwC46HuePD5M/p6wZKEugqlAlC83rfZSH1srz8CI3nQn9Gdkc6FQs
	EHaQ6Sk77ZDHFX0phCaMiLBsvrfCF8A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794223060;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zu64lQAMfDvZOgTZJc7wWXGbiQeCo1Yra71xvwPkWg4=;
	b=SSvgg3pYNyKibj3cxaovK7KVMEwbplamhoSar7lmLfmPuAR0cbtM8hcJ+paEhYI/cx5UiC
	QNDYsexPlW1UrAAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 56A9613319;
	Mon,  9 Nov 2026 11:17:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ExiNC9Sr8WqoHAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Nov 2026 11:17:40 +0000
Message-ID: <22df68f5-da1f-45e2-8c51-ac96cd3f270c@suse.de>
Date: Mon, 9 Nov 2026 12:17:39 +0100
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
Subject: Re: [PATCH v8 09/12] scsi: scsi_proto: refine the definition of
 storage element health
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261109095144.819709-1-dlemoal@kernel.org>
 <20261109095144.819709-10-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261109095144.819709-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 85D75221CE
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -13.50

On 11/9/26 10:51 AM, Damien Le Moal wrote:
> A disk may report the health of a storage element as being within or
> outside of the manufacturer's specification limits using a range of values
> for the health field. However, in scsi_proto.h, we only define the
> start of each range using the SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS and
> SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS enum value.
> 
> Define the full range by renaming SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS
> to SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS_MIN and by defining the
> healthy range end with SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS_MAX. The
> same treatment is done for the outside range with the renaming of
> SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS to
> SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS_MIN, and the definition of the
> range upper value with SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS_MAX.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   include/scsi/scsi_proto.h | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
> index 9c7d31aa6bae..f290a214e3e0 100644
> --- a/include/scsi/scsi_proto.h
> +++ b/include/scsi/scsi_proto.h
> @@ -408,9 +408,11 @@ enum scsi_phys_element_type {
>   /* SCSI physical element health. */
>   enum scsi_phys_element_health {
>   	SCSI_PHYS_ELEM_HEALTH_NOT_REPORTED		= 0x00,
> -	SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS	= 0x01,
> +	SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS_MIN	= 0x01,
> +	SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS_MAX	= 0x63,
>   	SCSI_PHYS_ELEM_HEALTH_AT_SPEC_LIMITS		= 0x64,
> -	SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS	= 0x65,
> +	SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS_MIN	= 0x65,
> +	SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS_MAX	= 0xCF,
>   	SCSI_PHYS_ELEM_HEALTH_DEPOP_REVOKE_ERR		= 0xFB,
>   	SCSI_PHYS_ELEM_HEALTH_DEPOP_REVOKE_IN_PROGRESS	= 0xFC,
>   	SCSI_PHYS_ELEM_HEALTH_DEPOP_ERR			= 0xFD,

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
