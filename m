Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE867484;
	Thu, 27 Jun 2024 06:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719470314; cv=none; b=Ognzy+V+1hjEeT9w5S4q8Es31tzkbr+EznILpgPbxVYZXGDi5TwQbsRQX67HV9MPCcXHM/ik1l2ykXk1bTAnA1VZF/jysffFGqqPSyBF4fS9kE9ukxTDqfSH3MpRTwrFc6Mxpdr3VhzNr4rFi/bl8RMKSD8qEuvFd9ANjHGUmhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719470314; c=relaxed/simple;
	bh=qT6AjEvC4OIfKkZzntq+dSwTVo10rsu4ximGXs/w0QE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JUxzA2pl0P4xhg5xeQ667G7hqu2DqzzJDSnLt5R7r7xBDjAde+mn8spndBsXQVOawnZ7+FtMeFukao1Z0DBi6Vour63vtSTfwOtx/ABwIZhf/Z1R8IvUXSicWufGtyosF1+aY4K+xKn6tcAb+5JAeUmSWzqrnqQZO+qUrdxSsdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PYx91y5m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VxV36yon; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PYx91y5m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VxV36yon; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PYx91y5m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VxV36yon";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PYx91y5m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VxV36yon"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A9D6721979;
	Thu, 27 Jun 2024 06:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719470311; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RhOdz456nD3fHnnLFx2CcxD0PS/isZcsyNJooJ2LcII=;
	b=PYx91y5mC+9mhSoCVorV9XTwXEtB8twsbkn3DmSWRv5N9Kb1Vs5CnTL8AJcnZsjhv5T4bz
	6moeXYQ+G0V1Ul0atEiUOmGuItiAbl00C1jSKOA0z6mI0p213/ESFE0p80hjUvBzoxiGW6
	wQoZi+fIyqRSR97ajE02EuCTNibgX8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719470311;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RhOdz456nD3fHnnLFx2CcxD0PS/isZcsyNJooJ2LcII=;
	b=VxV36yonnZf4YNgG1QbMtZOyMNxoG4yHejgY2UUrIXOqTRUQPBObiLnidGUqWBQIpTh+ba
	afIQmaCHhKv0/mAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719470311; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RhOdz456nD3fHnnLFx2CcxD0PS/isZcsyNJooJ2LcII=;
	b=PYx91y5mC+9mhSoCVorV9XTwXEtB8twsbkn3DmSWRv5N9Kb1Vs5CnTL8AJcnZsjhv5T4bz
	6moeXYQ+G0V1Ul0atEiUOmGuItiAbl00C1jSKOA0z6mI0p213/ESFE0p80hjUvBzoxiGW6
	wQoZi+fIyqRSR97ajE02EuCTNibgX8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719470311;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RhOdz456nD3fHnnLFx2CcxD0PS/isZcsyNJooJ2LcII=;
	b=VxV36yonnZf4YNgG1QbMtZOyMNxoG4yHejgY2UUrIXOqTRUQPBObiLnidGUqWBQIpTh+ba
	afIQmaCHhKv0/mAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C65B9137DF;
	Thu, 27 Jun 2024 06:38:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IAO0LeYIfWaAagAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Jun 2024 06:38:30 +0000
Message-ID: <f0f091f5-a3cd-4ae8-a789-bd7a48261981@suse.de>
Date: Thu, 27 Jun 2024 08:38:30 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/13] ata: libata: Assign print_id at port allocation
 time
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-25-cassel@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240626180031.4050226-25-cassel@kernel.org>
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
> While the assignment of ap->print_id could have been moved to
> ata_host_alloc(), let's simply move it to ata_port_alloc().
> 
> If you allocate a port, you want to give it a unique name that can be used
> for printing.
> 
> By moving the ap->print_id assignment to ata_port_alloc(), means that we
> can also remove the ap->print_id assignment from ata_sas_port_alloc().
> 
> This will allow a LLD to use the ata_port_*() print functions before
> ata_host_register() has been called.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   drivers/ata/libata-core.c | 6 +-----
>   drivers/ata/libata-sata.c | 1 -
>   2 files changed, 1 insertion(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

