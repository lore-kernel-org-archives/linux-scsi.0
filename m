Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9B52561B;
	Wed, 27 Mar 2024 07:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711524602; cv=none; b=Rf7Ug9ZET8wRY1T0betPms5CkhfuwpTYLnvDEqaZxRzo6gEwreCktg0ojkkEedfksy5cRD4tiVMfv4IxGB2zlZpq1LRd1xplZmmyTLICKcezGQK8sbFG8H3xO3EphEwCs5Bdqrg13NuN5qekFDOcwYmlBT7jW4yEQGURWKR3ls4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711524602; c=relaxed/simple;
	bh=MnocuUCGdCEFdbDJw54B4Lhyjoh2AOT5tZQds7j/LT4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=reXOw0iVLgCmmX/Tyw3dRTLHiM/QTzYPy4DNMJ/L1DjMGhevltD2V80IM7Kh8giMfM8tcRcq78bkpdsINHX0qr48SkWpoeRW1msDBJv58Byeo9rSvfpnzy4D+hf7kOedG50xp7UH3DsoCDV7tJw3K6q5Y5FYSSiXI/PlrGJJsK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kLBvAHIa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0uca3kAt; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kLBvAHIa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0uca3kAt; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kLBvAHIa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0uca3kAt";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kLBvAHIa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0uca3kAt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 88A515FFF5;
	Wed, 27 Mar 2024 07:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711524590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hPTfYArnFdc1vpqrQJXua+9c9CzunWnvt07nVd9Q+b0=;
	b=kLBvAHIaWzJt5g77XxMLBKc8FUDBsDTDmdElQSYG3vmCyQOgpiJbXX+JMsa8CQZ+iS4DEi
	ecg73NG2yDhby8AeKniI16UZi87qxfvNW3QIR308v6Q80xwKz48l1gUbe42vynkxQbuWz3
	5e3Q6M69L321iCOMYMcGPzWhcKNruAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711524590;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hPTfYArnFdc1vpqrQJXua+9c9CzunWnvt07nVd9Q+b0=;
	b=0uca3kAtJYakWxP8NlfW35khonp3s4Cj0osO6ZG1iEkokahOAllGbUID2FpfTLVo5nsp1n
	fGTpplxv9UHPWYBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711524590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hPTfYArnFdc1vpqrQJXua+9c9CzunWnvt07nVd9Q+b0=;
	b=kLBvAHIaWzJt5g77XxMLBKc8FUDBsDTDmdElQSYG3vmCyQOgpiJbXX+JMsa8CQZ+iS4DEi
	ecg73NG2yDhby8AeKniI16UZi87qxfvNW3QIR308v6Q80xwKz48l1gUbe42vynkxQbuWz3
	5e3Q6M69L321iCOMYMcGPzWhcKNruAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711524590;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hPTfYArnFdc1vpqrQJXua+9c9CzunWnvt07nVd9Q+b0=;
	b=0uca3kAtJYakWxP8NlfW35khonp3s4Cj0osO6ZG1iEkokahOAllGbUID2FpfTLVo5nsp1n
	fGTpplxv9UHPWYBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 58F2F13688;
	Wed, 27 Mar 2024 07:29:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iDurE+3KA2ZKewAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 Mar 2024 07:29:49 +0000
Message-ID: <8e7b7edb-e7ca-4abf-84ff-407e74661ce6@suse.de>
Date: Wed, 27 Mar 2024 08:29:47 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/28] block: Allow BIO-based drivers to use
 blk_revalidate_disk_zones()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-13-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240325044452.3125418-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kLBvAHIa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0uca3kAt
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-2.50 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.02)[53.28%];
	 MIME_GOOD(-0.10)[text/plain];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.18)[-0.881];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Score: -2.50
X-Rspamd-Queue-Id: 88A515FFF5
X-Spam-Flag: NO

On 3/25/24 05:44, Damien Le Moal wrote:
> In preparation for allowing BIO based device drivers to use zone write
> plugging and its zone append emulation, allow these drivers to call
> blk_revalidate_disk_zones() so that all zone resources necessary to zone
> write plugging can be initialized.
> 
> To do so, remove the check in blk_revalidate_disk_zones() restricting
> the use of this function to mq request-based drivers to allow also
> BIO-based drivers to use it. This is safe to do as long as the
> BIO-based block device queue is already setup and usable, as it should,
> and can be safely frozen. The zone write plug hash table and
> conventional zone bitmap are allocated and initialized only for mq
> devices and for BIO-based devices that require zone append emulation.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c | 26 ++++++++++++++++++++------
>   1 file changed, 20 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

