Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F3029CA;
	Thu, 27 Jun 2024 06:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719469490; cv=none; b=SfM/RxYSmDe0qQ0ga2QVp5+AbNL+ZGL/Kw14h+xyokJ1HobHFdFTXFc1Wfp+w6ZM/YwLuGtCpho+WQJUIjaxxvQYKor0S4m/yOrvUEky5u2CGlACbTI9rh4MHRZqaWbBeeor4r+rCtAokzafCjirmiHAZN/EBD1bCTr1ERqKLGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719469490; c=relaxed/simple;
	bh=/ofAYEMxGwYvf5eduXOa6r5AeVczbP3mJGCc+wBYp+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MQ4eCnO02p+6rDisbT1zPmn3SJVJUYS3N+Zz1nF5LhHj60j7MLhTgpCiH3CtUy5/l3+gUQBmn30MOMtUlpebGKEqd29qA132g/uV6aIG8aLqb97znCm4Cf0m76ERjCH10Rp9F4bkJx9n+b1AttnoGz0ZzXyhYJEPrYxczJ/nm2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fo0eZyxT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=S4qRE43L; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fo0eZyxT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=S4qRE43L; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fo0eZyxT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="S4qRE43L";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fo0eZyxT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="S4qRE43L"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6C27A21B6B;
	Thu, 27 Jun 2024 06:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719469486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/hyAF5FlhW0/dqXdH1OMQysWsgAlPzbiMhnj+y9abqc=;
	b=fo0eZyxTQAGbFNYsZGuhg37oUWd1SBEvJQ/7jISGTY6hlOXiB1eVv2nmhXlWj6p3R1Ir8O
	dITQYsRGliUdUgtlEDQT9L0VBHA5P+lZlGb6q6glu2KDhbk4U67xxxTXMPqTN4RYn8VXSI
	6exX/UXEaW1hBalYVTq3l4KaI9GU9KY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719469486;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/hyAF5FlhW0/dqXdH1OMQysWsgAlPzbiMhnj+y9abqc=;
	b=S4qRE43LnfUGaS5VWdZduqmgSqX4WDCaJlSVnRmzKYbxEE5plgEn4t7NWHFRTiqIs5nNit
	5LaVTLWx1Ikq3VCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719469486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/hyAF5FlhW0/dqXdH1OMQysWsgAlPzbiMhnj+y9abqc=;
	b=fo0eZyxTQAGbFNYsZGuhg37oUWd1SBEvJQ/7jISGTY6hlOXiB1eVv2nmhXlWj6p3R1Ir8O
	dITQYsRGliUdUgtlEDQT9L0VBHA5P+lZlGb6q6glu2KDhbk4U67xxxTXMPqTN4RYn8VXSI
	6exX/UXEaW1hBalYVTq3l4KaI9GU9KY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719469486;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/hyAF5FlhW0/dqXdH1OMQysWsgAlPzbiMhnj+y9abqc=;
	b=S4qRE43LnfUGaS5VWdZduqmgSqX4WDCaJlSVnRmzKYbxEE5plgEn4t7NWHFRTiqIs5nNit
	5LaVTLWx1Ikq3VCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 126E6137DF;
	Thu, 27 Jun 2024 06:24:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hIG/Aq4FfWbJZwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Jun 2024 06:24:46 +0000
Message-ID: <34beb975-575d-4890-801c-6b4a931c3e88@suse.de>
Date: Thu, 27 Jun 2024 08:24:41 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/13] ata: libata-core: Fix null pointer dereference
 on error
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 stable@vger.kernel.org, linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-16-cassel@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240626180031.4050226-16-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com,garzik.org];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 

On 6/26/24 20:00, Niklas Cassel wrote:
> If the ata_port_alloc() call in ata_host_alloc() fails,
> ata_host_release() will get called.
> 
> However, the code in ata_host_release() tries to free ata_port struct
> members unconditionally, which can lead to the following:
> 
> BUG: unable to handle page fault for address: 0000000000003990
> PGD 0 P4D 0
> Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 10 PID: 594 Comm: (udev-worker) Not tainted 6.10.0-rc5 #44
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-2.fc40 04/01/2014
> RIP: 0010:ata_host_release.cold+0x2f/0x6e [libata]
> Code: e4 4d 63 f4 44 89 e2 48 c7 c6 90 ad 32 c0 48 c7 c7 d0 70 33 c0 49 83 c6 0e 41
> RSP: 0018:ffffc90000ebb968 EFLAGS: 00010246
> RAX: 0000000000000041 RBX: ffff88810fb52e78 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffff88813b3218c0 RDI: ffff88813b3218c0
> RBP: ffff88810fb52e40 R08: 0000000000000000 R09: 6c65725f74736f68
> R10: ffffc90000ebb738 R11: 73692033203a746e R12: 0000000000000004
> R13: 0000000000000000 R14: 0000000000000011 R15: 0000000000000006
> FS:  00007f6cc55b9980(0000) GS:ffff88813b300000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000003990 CR3: 00000001122a2000 CR4: 0000000000750ef0
> PKRU: 55555554
> Call Trace:
>   <TASK>
>   ? __die_body.cold+0x19/0x27
>   ? page_fault_oops+0x15a/0x2f0
>   ? exc_page_fault+0x7e/0x180
>   ? asm_exc_page_fault+0x26/0x30
>   ? ata_host_release.cold+0x2f/0x6e [libata]
>   ? ata_host_release.cold+0x2f/0x6e [libata]
>   release_nodes+0x35/0xb0
>   devres_release_group+0x113/0x140
>   ata_host_alloc+0xed/0x120 [libata]
>   ata_host_alloc_pinfo+0x14/0xa0 [libata]
>   ahci_init_one+0x6c9/0xd20 [ahci]
> 
> Do not access ata_port struct members unconditionally.
> 
> Fixes: 633273a3ed1c ("libata-pmp: hook PMP support and enable it")
> Cc: stable@vger.kernel.org
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   drivers/ata/libata-core.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index e1bf8a19b3c8..88e32f638f33 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5518,10 +5518,12 @@ static void ata_host_release(struct kref *kref)
>   	for (i = 0; i < host->n_ports; i++) {
>   		struct ata_port *ap = host->ports[i];
>   
> -		kfree(ap->pmp_link);
> -		kfree(ap->slave_link);
> -		kfree(ap->ncq_sense_buf);
> -		kfree(ap);
> +		if (ap) {
> +			kfree(ap->pmp_link);
> +			kfree(ap->slave_link);
> +			kfree(ap->ncq_sense_buf);
> +			kfree(ap);
> +		}
>   		host->ports[i] = NULL;
>   	}
>   	kfree(host);
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

