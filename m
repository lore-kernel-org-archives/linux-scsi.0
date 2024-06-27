Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FF51CD3B;
	Thu, 27 Jun 2024 06:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719469726; cv=none; b=Ot76NmA+iI7rt5V5rXYwv1TMOzt+tx/rGmixY1y+5ybJ4ZguTzYyVA/eFqHeKXFVNy0tCZl4RrVcDn7oQyEZE45gE6n6CEHjqNpeLaIXTPr0TbSPncuHLrsR1eHzZpZFl+nBDcCMSPjcZZkMAazIL5RfsRq/+RSJFlS/C4Rpv5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719469726; c=relaxed/simple;
	bh=o3IkQ1x/q4gdUtpw2mAHNGDZiF4awzWlLLvg1s5a9yk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SngD85rawAb5wZ7Bl3RfSdugKx7GHMo78BVnlpqo9H4dYpfT3Ea6PqlFNVXGlB2vLOjiHVIB2uDL8/KzHj0jHXYEHIGAPoFGm5tok95LtoVdoPZNLvCnIR2vdp07uYkId1Jvr9ZyommzVj/Rsa2J2fu0goPpoXfZJ/NlvSKxZMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=y7VLVCnK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=v7cXUBun; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mPKzwQcr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RVPZkGnc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="y7VLVCnK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="v7cXUBun";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mPKzwQcr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RVPZkGnc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E52D721B6A;
	Thu, 27 Jun 2024 06:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719469723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3qSvMsDKzSsPMA7otHglT3mrp3n1nHCCCAse22emslg=;
	b=y7VLVCnKk1JWnWns7A/dViSrZuqETQp9pA7nXm7vG+4KZLJPFXfIcKuMK+c7hTo6vlISDO
	VHd4NX2+U6zOKzn7U482pSukaXla67hm3QGivP02LicE8ErVOPb+XdALWEiTYy6FHdr1qn
	g2iaG25nKUPQOcPt7zK7huXADJSPbNc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719469723;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3qSvMsDKzSsPMA7otHglT3mrp3n1nHCCCAse22emslg=;
	b=v7cXUBun4qJkNSA+n8nIdjXqQPI6Wf13Q2ppkIBv2UbMzIcNqDg0AgygWLZvRJdhtzTcVb
	F/HtmNC1CBWnELCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719469722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3qSvMsDKzSsPMA7otHglT3mrp3n1nHCCCAse22emslg=;
	b=mPKzwQcrPIT4keW208rWApa3lcjDFQ4u4q03ZqOG/HavzAEWXofSBG9Es1T6Ij3d5FG4lp
	gnkaD4+bW0hyeEZ4zKNmdmUqyHGSZP+ks2Mk5AHoBUPDhffy0TdQX7E1Ux3OCaDlmtEY8H
	ETlDMPC+nLrsxf0B/keyaLM+GS/fW2A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719469722;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3qSvMsDKzSsPMA7otHglT3mrp3n1nHCCCAse22emslg=;
	b=RVPZkGncWniw1TaZEzoJQV/d5o4IigQF94rO8u9JArmYO3S5yAp/wqhsLifJSBVmvIyThw
	yh3oejKJt5nvruBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0178B137DF;
	Thu, 27 Jun 2024 06:28:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id irseNpkGfWa2aAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Jun 2024 06:28:41 +0000
Message-ID: <6ef0cede-aa7c-4abe-8a8b-dfdd78d90a6f@suse.de>
Date: Thu, 27 Jun 2024 08:28:37 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/13] ata: ahci: Clean up sysfs file on error
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 Kai-Heng Feng <kai.heng.feng@canonical.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 stable@vger.kernel.org, linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-18-cassel@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240626180031.4050226-18-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[11];
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
> .probe() (ahci_init_one()) calls sysfs_add_file_to_group(), however,
> if probe() fails after this call, we currently never call
> sysfs_remove_file_from_group().
> 
> (The sysfs_remove_file_from_group() call in .remove() (ahci_remove_one())
> does not help, as .remove() is not called on .probe() error.)
> 
> Thus, if probe() fails after the sysfs_add_file_to_group() call, we get:
> 
> sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:04.0/remapped_nvme'
> CPU: 11 PID: 954 Comm: modprobe Not tainted 6.10.0-rc5 #43
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-2.fc40 04/01/2014
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x5d/0x80
>   sysfs_warn_dup.cold+0x17/0x23
>   sysfs_add_file_mode_ns+0x11a/0x130
>   sysfs_add_file_to_group+0x7e/0xc0
>   ahci_init_one+0x31f/0xd40 [ahci]
> 
> Fixes: 894fba7f434a ("ata: ahci: Add sysfs attribute to show remapped NVMe device count")
> Cc: stable@vger.kernel.org
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   drivers/ata/ahci.c | 17 ++++++++++++-----
>   1 file changed, 12 insertions(+), 5 deletions(-)
> 


Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

