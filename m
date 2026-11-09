Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794223109;
	b=Ohg264zFuX72+XhMLvUdR5OayIpjCR1dr5/aiN2BGVR8aZARsVuwPy68iIaOYMPfGG9I
	 2VmLJ0HxSQaDDq8rDMv5nWdg/h7+t2Udg6jHtfTFNZQ/qWFQdXcmE9zvO2/s2v40lzOzC
	 G2aBtQ8BmBvdETeRquENvUd8f0Ia1NqFRqKO0VpgNXDL3L8uPpsZcAtPmQk1+UpfYjMOq
	 3mOWlsfVv7QRoAXe8km0SOc8pAdk3IIhLYEPcxJOPiaJXQ0rveMaw37hhauGV/JoY3Mu1
	 NKJRsMIHc4LPLumW7WhjEofOmMdA3ZHjREDu9vwE0BY+OzER76R2946+feSN+z/AI3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794223109;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=mEtOkUwwyP+xJoi15AVmfNcIo1llGRaCD9lMi4bXdDg=;
	b=jP0JP+gM3l6IhKxsZ11T9tOEYuyIR+l4b8ovLWyl8JViNMYK1aiL0pAfBwkMi/Ll0//f
	 pE8c+AFm/YJna717H9mp+yNvSy/JDa1y9kc6NyzUu+Z2ioNO7zV1LbJt05toSEytKIuao
	 kdRRjOxrmMYeSzMKO4OooLvKQpBKp951PdkS5gw33mjsjT3Thuj+UIbHAJNs4iv2ulf8v
	 wvskwMof+e/kNXALAhev37eVIGUHbIXvWYtmwvTCIAMDSo6IldrD0PldouY+VxEj5sOGC
	 wSBEcR5AAlo/b2dUrK4v7Y0GDQul7Wj/3oxCsQZMl1bNBWfZ5b3W/VOoWY6OFiytNNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Lbmvn3KQ;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ihBPg8Gh;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Lbmvn3KQ;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ihBPg8Gh;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A187606A31C;
	Mon,  9 Nov 2026 11:18:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A187606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Lbmvn3KQ;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ihBPg8Gh;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Lbmvn3KQ;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ihBPg8Gh
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2100622184;
	Mon,  9 Nov 2026 11:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794223107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mEtOkUwwyP+xJoi15AVmfNcIo1llGRaCD9lMi4bXdDg=;
	b=Lbmvn3KQBpidly7Y7rfXq3MGDNzdd0LH1gDbi7h72VIe6CoyUQakH2xFXEMFmWcNGwyXG0
	Wi9KEZVV+/YyAur2Wtqgiff4Nw/XSEXdDAd5oc9WD7czfMY7TpcJM95ZO/OGJ70epqbbGt
	8ItGc2QDLnbuElckKTvcw5BdYbZd0sk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794223107;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mEtOkUwwyP+xJoi15AVmfNcIo1llGRaCD9lMi4bXdDg=;
	b=ihBPg8GhLLKSMDyLRvy3qNbW5rjKNlLq+P0u9Zvxr1QK0Vt4UkLnHcllM7MvRFKvqoA4Eu
	biwqoth72WZzr3Cg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794223107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mEtOkUwwyP+xJoi15AVmfNcIo1llGRaCD9lMi4bXdDg=;
	b=Lbmvn3KQBpidly7Y7rfXq3MGDNzdd0LH1gDbi7h72VIe6CoyUQakH2xFXEMFmWcNGwyXG0
	Wi9KEZVV+/YyAur2Wtqgiff4Nw/XSEXdDAd5oc9WD7czfMY7TpcJM95ZO/OGJ70epqbbGt
	8ItGc2QDLnbuElckKTvcw5BdYbZd0sk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794223107;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mEtOkUwwyP+xJoi15AVmfNcIo1llGRaCD9lMi4bXdDg=;
	b=ihBPg8GhLLKSMDyLRvy3qNbW5rjKNlLq+P0u9Zvxr1QK0Vt4UkLnHcllM7MvRFKvqoA4Eu
	biwqoth72WZzr3Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE09113319;
	Mon,  9 Nov 2026 11:18:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id L5pzKAKs8WptHQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Nov 2026 11:18:26 +0000
Message-ID: <74a847f9-994b-49ba-a91f-a0f3adc81b15@suse.de>
Date: Mon, 9 Nov 2026 12:18:26 +0100
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
Subject: Re: [PATCH v8 10/12] scsi: sd_zbc: always revalidate zones for disks
 supporting head depopulation
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261109095144.819709-1-dlemoal@kernel.org>
 <20261109095144.819709-11-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261109095144.819709-11-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.998];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.29
X-Spam-Level: 
X-Spam-Flag: NO

On 11/9/26 10:51 AM, Damien Le Moal wrote:
> sd_zbc_revalidate_zones() skips revalidating the zones of a ZBC device if
> the zone size and total number of zones of the disk has not changed. This
> is to avoid the sometimes slow report zones for the entire disk that
> blk_revalidate_disk_zones() will generate.
> 
> For ZBC devices that support the storage element depopulation feature, a
> revalidation after executing a passthrough REMOVE ELEMENT AND TRUNCATE
> command will thus correctly trigger a zone revalidation as the disk
> capacity and number of zones changed.
> 
> However, for devices supporting the data preserving head depopulation
> variant of the depopulation feature (REMOVE ELEMENT AND MODIFY ZONES
> command), a disk capacity and number of zones does not change after a head
> is depopulated. Only the conditions of the zones served by the head that
> was depopulated change. These zones are transitioned to either read-only
> or offline.
> 
> While the block layer storage element management functions always call
> blk_revalidate_disk_zones() to catch these changes, a user scan, libata
> device rescan after EH or a depopulation or restoration action executed
> through SG_IO would not. In these cases, not calling
> blk_revalidate_disk_zones() prevents the block layer from taking
> appropriate actions on the zone write plugs of the disk.
> 
> Avoid any issue with the block layer view of the zone conditions by not
> skipping the call to blk_revalidate_disk_zones() for disks that support
> both the GET PHYSICAL ELEMENTS STATUS and REMOVE ELEMENT AND MODIFY ZONES
> commands. This check is done from sd_zbc_read_zones() using the helper
> function sd_zbc_check_depop_supported(). The new SCSI disk flags
> depop_report_supported and depop_modify_zones_supported are defined to
> remember the result of this check.
> 
> This change will slow down a little SMR disk revalidation. However, user
> forced revalidations are normally rare, and other revalidations triggered
> by udev only happen when the disk device files is not in use anymore
> (closed). So this slow down should in practice not be an issue.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/sd.h     |  2 ++
>   drivers/scsi/sd_zbc.c | 47 +++++++++++++++++++++++++++++++++++++++++--
>   2 files changed, 47 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
