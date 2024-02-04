Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5F2225D0;
	Sun,  4 Feb 2024 12:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707048927; cv=none; b=rPzj/vsq38kHq4Ihijh0+PQZ8VgcVS1/vObpFRz2KV+8r68ya8b2ILY0xKEjE7cvycstxSBOaAJr79qqgFNaHvsBOfjvmXnGyrZzmCb7VrTPsm+WCOQ5lukjeKqhOd2CGwv5OyIXFyan6eII45vbjZwJ8dS9/GyVCIsrNWDWavw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707048927; c=relaxed/simple;
	bh=JRY0Lkn1XNO700MNJG1+6Ebjj4wQvi0CREhOQrCJz2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eZi+cmghCBqa0rcISAtagL8Y1vI+TegKMRIdX3kEnUxj2tgvE3ktphFdZUNSsKqoxLmP7T2SqOwcHqiyFPYdQf4Iuur5LjLehT1s68vteoe2qaNiiv+Zpmmy0wOvKVAtcbK9AOSp0S9i6CcM4AAApa7JN40bfhETnLNtU/MvG3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FmpYUTCH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PRonNNCi; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FmpYUTCH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PRonNNCi; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FmpYUTCH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PRonNNCi";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FmpYUTCH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PRonNNCi"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A50A71F80B;
	Sun,  4 Feb 2024 12:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707048921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7flFR1q75tIqEYT1Wun6NAUbBD0R69IiiiB9FikbXgI=;
	b=FmpYUTCHmoiL7R37cesWrlr+esXAzM+2b5C5RSNHZ1bjp4jq7kW7SDON3QdqJTlk2N9h1b
	Q+6lhdyaw1MEx7ferGl8BgrYVWTosWK0D3/haM6kpSihCLM+kgl5XIfUWk8Tx4M5a4JLzv
	wKCoX1vbuUrXjvjJavGMRoFykphXrqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707048921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7flFR1q75tIqEYT1Wun6NAUbBD0R69IiiiB9FikbXgI=;
	b=PRonNNCibCR3bZ4z2KJ1tTzflz3UG0d0CBdFs1dDUOI3E3E3HA5j6lY2hNXPgaFFYHiVeO
	QBL3yBI8mV4VYSAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707048921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7flFR1q75tIqEYT1Wun6NAUbBD0R69IiiiB9FikbXgI=;
	b=FmpYUTCHmoiL7R37cesWrlr+esXAzM+2b5C5RSNHZ1bjp4jq7kW7SDON3QdqJTlk2N9h1b
	Q+6lhdyaw1MEx7ferGl8BgrYVWTosWK0D3/haM6kpSihCLM+kgl5XIfUWk8Tx4M5a4JLzv
	wKCoX1vbuUrXjvjJavGMRoFykphXrqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707048921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7flFR1q75tIqEYT1Wun6NAUbBD0R69IiiiB9FikbXgI=;
	b=PRonNNCibCR3bZ4z2KJ1tTzflz3UG0d0CBdFs1dDUOI3E3E3HA5j6lY2hNXPgaFFYHiVeO
	QBL3yBI8mV4VYSAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D692D132DD;
	Sun,  4 Feb 2024 12:15:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +PUnIdZ/v2UMJAAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:15:18 +0000
Message-ID: <9efc1799-78e9-4a7b-806c-6c1458bb4b2f@suse.de>
Date: Sun, 4 Feb 2024 20:15:18 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/26] block: Allow zero value of max_zone_append_sectors
 queue limit
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-8-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FmpYUTCH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PRonNNCi
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-8.00 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 DWL_DNSWL_HI(-3.50)[suse.de:dkim];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Score: -8.00
X-Rspamd-Queue-Id: A50A71F80B
X-Spam-Flag: NO

On 2/2/24 15:30, Damien Le Moal wrote:
> In preparation for adding a generic zone append emulation using zone
> write plugging, allow device drivers supporting zoned block device to
> set a the max_zone_append_sectors queue limit of a device to 0 to
> indicate the lack of native support for zone append operations and that
> the block layer should emulate these operations using regular write
> operations.
> 
> blk_queue_max_zone_append_sectors() is modified to allow passing 0 as
> the max_zone_append_sectors argument. The function
> queue_max_zone_append_sectors() is also modified to ensure that the
> minimum of the max_sectors and chunk_sectors limit is used whenever the
> max_zone_append_sectors limit is 0.
> 
> The helper functions queue_emulates_zone_append() and
> bdev_emulates_zone_append() are added to test if a queue (or block
> device) emulates zone append operations.
> 
> In order for blk_revalidate_disk_zones() to accept zoned block devices
> relying on zone append emulation, the direct check to the
> max_zone_append_sectors queue limit of the disk is replaced by a check
> using the value returned by queue_max_zone_append_sectors(). Similarly,
> queue_zone_append_max_show() is modified to use the same accessor so
> that the sysfs attribute advertizes the non-zero limit that will be
> used, regardless if it is for native or emulated commands.
> 
> For stacking drivers, a top device should not need to care if the
> underlying devices have native or emulated zone append operations.
> blk_stack_limits() is thus modified to set the top device
> max_zone_append_sectors limit using the new accessor
> queue_limits_max_zone_append_sectors(). queue_max_zone_append_sectors()
> is modified to use this function as well. Stacking drivers that require
> zone append emulation, e.g. dm-crypt, can still request this feature by
> calling blk_queue_max_zone_append_sectors() with a 0 limit.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-core.c       |  2 +-
>   block/blk-settings.c   | 35 +++++++++++++++++++++++------------
>   block/blk-sysfs.c      |  2 +-
>   block/blk-zoned.c      |  2 +-
>   include/linux/blkdev.h | 20 +++++++++++++++++---
>   5 files changed, 43 insertions(+), 18 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

