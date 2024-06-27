Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB04022EF0;
	Thu, 27 Jun 2024 06:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719469756; cv=none; b=LxTFVY2H78fKTC9lNetv5yIFgLw9ENXP50uwMDd6V1EAUr+Yk23XFxiHCcfJqPznTYWaV2oG0iKGQSomkjJEcdmtgVwCvCZ0hBI2XLtfpsE13FzTC0RQvykYh5SNiT/OmIZalReM5sbcEStYTtPRNknjXclY/ll4iwJc1hUv1qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719469756; c=relaxed/simple;
	bh=YcD+LK9qSH7rzZ/XdCn0qzu/jr6FAaEpKAgs4+uAPZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BgXA5szU9AXR0Lu4PuS/GsSwGGeU4g3lscpKj7+cUaIj/gIhpLSd3wO5CR2cqBsqfuZtXFr+srbrtFaXNEwuNFyz5DxjCvwSC+M/Riusjn688nPxG2RDWhlzJ+hlUCOfM6+nbMMSdIRKOUugVCA5nEbSZGhZZoZUtef1+J3/wcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RKqy73v2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iehdWrRW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Nc+rpmvi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cWlcpvVW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RKqy73v2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iehdWrRW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Nc+rpmvi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cWlcpvVW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 96FDE1FBA1;
	Thu, 27 Jun 2024 06:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719469752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xp/LfimJhSrly0Zj8cO05ae8x4zVw8Af55DB5wPeop0=;
	b=RKqy73v2PwkfuSVgxpP8KT1bLEbKpapwbxf4y15TRYxXiogQ8C1oIYLTP84M2wmV+f9Gxg
	nMfrobqw1R/3f+nkk+Kj0z0mjyvpmC1utFNVHwMfQjbu3gjqbM7b0mPTbCGKlBGOHmvJBL
	DS9/Iyon081OkuyqYkP4JqZo292lPH4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719469752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xp/LfimJhSrly0Zj8cO05ae8x4zVw8Af55DB5wPeop0=;
	b=iehdWrRW+Y1PH0gBOKV/dKgSgwN4H5H3LhtwyFbsH7kHEDecozcJqGQf228BNLAmInr22t
	22BoofTr5pAcssCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719469751; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xp/LfimJhSrly0Zj8cO05ae8x4zVw8Af55DB5wPeop0=;
	b=Nc+rpmvijT4GOsdpf3vzNwMzjeedXRhL/sAfdDD/jmscwfXcZwWPAToRlPCfEzt/i5QnNv
	Hwc28VGQC7EqyfQ6YPIqldSlNUTMtt38ldTPJRWteuEku2m3MZRYV2ww93exF5P8RSj38A
	/ml9MYxDXFXXAIsLfTAFq7U6Ezr+Ork=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719469751;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xp/LfimJhSrly0Zj8cO05ae8x4zVw8Af55DB5wPeop0=;
	b=cWlcpvVWSCBoGUMOvmGAgCMdHeu997uV9Mr048wLR6R5tml+QIoD8xa1L0LifR9mJwY9hD
	n9a/HGPHyq5NmIBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C0832137DF;
	Thu, 27 Jun 2024 06:29:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kKdkLLYGfWa2aAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Jun 2024 06:29:10 +0000
Message-ID: <4b728283-6ef7-412c-bab7-8d8c39c53543@suse.de>
Date: Thu, 27 Jun 2024 08:29:11 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/13] ata,scsi: Remove useless wrappers
 ata_sas_tport_{add,delete}()
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-19-cassel@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240626180031.4050226-19-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]

On 6/26/24 20:00, Niklas Cassel wrote:
> Remove useless wrappers ata_sas_tport_add() and ata_sas_tport_delete().
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   drivers/ata/libata-sata.c          | 12 ------------
>   drivers/ata/libata-transport.c     |  2 ++
>   drivers/ata/libata-transport.h     |  3 ---
>   drivers/scsi/libsas/sas_ata.c      |  2 +-
>   drivers/scsi/libsas/sas_discover.c |  2 +-
>   include/linux/libata.h             |  4 ++--
>   6 files changed, 6 insertions(+), 19 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

