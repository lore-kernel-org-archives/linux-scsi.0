Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1C522EE4;
	Thu, 27 Jun 2024 06:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719470280; cv=none; b=laniYrJv2xO1T64YHvvX9kUUxejvMT0ZNW+oZkNa5CC2T6F+U2vUR4zXVugvrHcEnPkPsJbHXfCNULBNbQDlMb3emS9nMlPzI1usTWuvYv5upvkx/8SmONtG1qQ85uFXZieZqs5C73pDjfwqU+vw8PM96sp8PFZGJJELkH22Tq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719470280; c=relaxed/simple;
	bh=rN2TkWI2LhBDJVAPoYwj+stIvXabljVWwhPE+RtktjM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t8ItYnkRjNydpi/mhhoWdyyyzwIN5B3uAJ9sBZnxTXKSwCzIyN1DQL8R3Vwziu0EeV4Mjvl/QSH241N6YpOpOpWuGBb0YsxQRwZfXRSkvFhC7V0k3g5nI7BjkUpMNz3E6jdjoFT9S7oMwy1crXuvMQGNGB1S0wYim53YGDeD+sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jEZzUADf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZHSPa4m+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Slqktdc3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JOBYLS0L; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jEZzUADf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZHSPa4m+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Slqktdc3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JOBYLS0L"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1FB701FBA6;
	Thu, 27 Jun 2024 06:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719470277; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XlN6/CsmyIrJqdR+sTMwH31nUWVEvpoJ98n1ASrXksw=;
	b=jEZzUADfumOMVmfjZ9oFJdMm2fIzlbA1vd3rzuV00b0SzE9A/P2Jgev5DO5Mkko6Huiyum
	j11ZQJOnBbe3jSK098dT7FgxjCg+KDniJZiMIiHiJhEjGhf3pY7+OhffedHiIa9GXap+v5
	uYTsvEi6fPSahxrm+r3uarnxJHyOUFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719470277;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XlN6/CsmyIrJqdR+sTMwH31nUWVEvpoJ98n1ASrXksw=;
	b=ZHSPa4m+p9tMseKeyXufqFOx/K/xEnuXDEjghint+wH1pCepHaXW13dTLrFW/ADn3Rdqx9
	RTtigVqNyjtRkXAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719470275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XlN6/CsmyIrJqdR+sTMwH31nUWVEvpoJ98n1ASrXksw=;
	b=Slqktdc3icaYJD9r1X+wqvCHe6Q1QgFceRtT28at7IpqmDO8VN+a6HmO78elsP4hbERxn9
	vsdN5YvC6KBYZdR2HhL3S6FU4/WUoigpFlPauStQ5ACMUN0tW2tLsqmai7EkNwDCdLfxkh
	fN+kGyY/EYfupcrwntlEtcL4g58REmY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719470275;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XlN6/CsmyIrJqdR+sTMwH31nUWVEvpoJ98n1ASrXksw=;
	b=JOBYLS0L+TZVr/7EDg/heEUMqN5lSffkp/zkTQ8/VWaD+uEMNQxHcv/EsOiZ5rYo5BctOg
	VcWWuUcf2/vh0mDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81CDB137DF;
	Thu, 27 Jun 2024 06:37:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aMl0HcIIfWaAagAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Jun 2024 06:37:54 +0000
Message-ID: <fd59c720-f7a0-471c-93c9-51aa913e0376@suse.de>
Date: Thu, 27 Jun 2024 08:37:54 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/13] ata: libata-core: Remove local_port_no struct
 member
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-24-cassel@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240626180031.4050226-24-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 

On 6/26/24 20:00, Niklas Cassel wrote:
> ap->local_port_no is simply ap->port_no + 1.
> Since ap->local_port_no can be derived from ap->port_no, there is no need
> for the ap->local_port_no struct member, so remove ap->local_port_no.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   drivers/ata/libata-core.c      | 5 +----
>   drivers/ata/libata-transport.c | 3 ++-
>   include/linux/libata.h         | 1 -
>   3 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index a213a9c0d0a5..ceee4b6ba3dd 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5464,7 +5464,6 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
>   	ap->pflags |= ATA_PFLAG_INITIALIZING | ATA_PFLAG_FROZEN;
>   	ap->lock = &host->lock;
>   	ap->print_id = -1;
> -	ap->local_port_no = -1;
>   	ap->host = host;
>   	ap->dev = host->dev;
>   
> @@ -5912,10 +5911,8 @@ int ata_host_register(struct ata_host *host, const struct scsi_host_template *sh
>   		WARN_ON(host->ports[i]);
>   
>   	/* give ports names and add SCSI hosts */
> -	for (i = 0; i < host->n_ports; i++) {
> +	for (i = 0; i < host->n_ports; i++)
>   		host->ports[i]->print_id = atomic_inc_return(&ata_print_id);
> -		host->ports[i]->local_port_no = i + 1;
> -	}
>   
>   	/* Create associated sysfs transport objects  */
>   	for (i = 0; i < host->n_ports; i++) {
> diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
> index d24f201c0ab2..9e24c33388f9 100644
> --- a/drivers/ata/libata-transport.c
> +++ b/drivers/ata/libata-transport.c
> @@ -217,7 +217,8 @@ static DEVICE_ATTR(name, S_IRUGO, show_ata_port_##name, NULL)
>   
>   ata_port_simple_attr(nr_pmp_links, nr_pmp_links, "%d\n", int);
>   ata_port_simple_attr(stats.idle_irq, idle_irq, "%ld\n", unsigned long);
> -ata_port_simple_attr(local_port_no, port_no, "%u\n", unsigned int);
> +/* We want the port_no sysfs attibute to start at 1 (ap->port_no starts at 0) */
> +ata_port_simple_attr(port_no + 1, port_no, "%u\n", unsigned int);
>   
>   static DECLARE_TRANSPORT_CLASS(ata_port_class,
>   			       "ata_port", NULL, NULL, NULL);
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index b7c5d3f33368..84a7bfbac9fa 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -814,7 +814,6 @@ struct ata_port {
>   	/* Flags that change dynamically, protected by ap->lock */
>   	unsigned int		pflags; /* ATA_PFLAG_xxx */
>   	unsigned int		print_id; /* user visible unique port ID */
> -	unsigned int            local_port_no; /* host local port num */
>   	unsigned int		port_no; /* 0 based port no. inside the host */
>   
>   #ifdef CONFIG_ATA_SFF

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

