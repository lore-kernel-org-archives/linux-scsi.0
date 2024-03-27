Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A622C1AF;
	Wed, 27 Mar 2024 07:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711524534; cv=none; b=ZZl+p52cePyf9cXYFDLQxJ5cD6mzdI8xdlCD+KSocuh8H90QiA/3DEyYxfMaFiTH5+DhgXi0CqR9QCq/AHM9QM1NYyMiKpWTWL+E3RbRqTFxxfBc8N6X85DNQ3qyboTa7BImK0bliBRvvx2953rSa6+f8RasH2ap5rEMwyR1QRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711524534; c=relaxed/simple;
	bh=Dc5ZqE3TXScMkyc9NcIsvu3KTupSo6+RW84glheLrss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AiYdOLCTbmLCqpsUaxtspxj8KuyUWFZXmmyrX8vtBs8dTztr+whXzo7y2HHJu9AlolR8zrN0abpfmTRBVk1oGpgsICmsH7YCRG+i+z/DKHv2HxVEnaOWrK6m0uEB7+vlJJExu+g4A3+HBW+KdfKUIcQu3CqU5uQo26D0HMRysSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rgqMSNjr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=glypdop/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rgqMSNjr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=glypdop/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rgqMSNjr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="glypdop/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rgqMSNjr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="glypdop/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 89F06386EE;
	Wed, 27 Mar 2024 07:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711524527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GB9Hca2p0B5XcyWmXAEZGtwV274y6PiIwG4GTpkJ5FY=;
	b=rgqMSNjrOEDzqHyciEi59OQ1w5quA36zoNSuGu+0X8czoe6u09vRxsTMXzg+8uqMllgpXI
	osz5InudRcXP7qcQWb3QLoRFbDsJdYPbmPXD+YxHrTNg1ZNZ02zZIQIzB458uwnfJgulx9
	NHcrCV5ThR6ewCq3Iv/kMo4qvPizLmw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711524527;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GB9Hca2p0B5XcyWmXAEZGtwV274y6PiIwG4GTpkJ5FY=;
	b=glypdop/6+a/xeLdfmUuBtGjQ0lzIz06zsxS7rann0BLKYJFZ8ero4mvhTrDeLSRVKP1gh
	/xXRjGQy/bWhcwCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711524527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GB9Hca2p0B5XcyWmXAEZGtwV274y6PiIwG4GTpkJ5FY=;
	b=rgqMSNjrOEDzqHyciEi59OQ1w5quA36zoNSuGu+0X8czoe6u09vRxsTMXzg+8uqMllgpXI
	osz5InudRcXP7qcQWb3QLoRFbDsJdYPbmPXD+YxHrTNg1ZNZ02zZIQIzB458uwnfJgulx9
	NHcrCV5ThR6ewCq3Iv/kMo4qvPizLmw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711524527;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GB9Hca2p0B5XcyWmXAEZGtwV274y6PiIwG4GTpkJ5FY=;
	b=glypdop/6+a/xeLdfmUuBtGjQ0lzIz06zsxS7rann0BLKYJFZ8ero4mvhTrDeLSRVKP1gh
	/xXRjGQy/bWhcwCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3AC9113688;
	Wed, 27 Mar 2024 07:28:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f3zRDK/KA2ZKewAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 Mar 2024 07:28:47 +0000
Message-ID: <64e0f9ef-1196-47ed-b191-1913f3e51253@suse.de>
Date: Wed, 27 Mar 2024 08:28:44 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/28] block: Implement zone append emulation
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-12-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240325044452.3125418-12-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -5.50
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spamd-Result: default: False [-5.50 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
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
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rgqMSNjr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="glypdop/"
X-Rspamd-Queue-Id: 89F06386EE

On 3/25/24 05:44, Damien Le Moal wrote:
> Given that zone write plugging manages all writes to zones of a zoned
> block device and track the write pointer position of all zones,
> emulating zone append operations using regular writes can be
> implemented generically, without relying on the underlying device driver
> to implement such emulation. This is needed for devices that do not
> natively support the zone append command, e.g. SMR hard-disks.
> 
> A device may request zone append emulation by setting its
> max_zone_append_sectors queue limit to 0. For such device, the function
> blk_zone_wplug_prepare_bio() changes zone append BIOs into
> non-mergeable regular write BIOs. Modified zone append BIOs are flagged
> with the new BIO flag BIO_EMULATES_ZONE_APPEND. This flag is checked
> on completion of the BIO in blk_zone_write_plug_bio_endio() to restore
> the original REQ_OP_ZONE_APPEND operation code of the BIO.
> 
> The block layer internal inline helper function bio_is_zone_append() is
> added to test if a BIO is either a native zone append operation
> (REQ_OP_ZONE_APPEND operation code) or if it is flagged with
> BIO_EMULATES_ZONE_APPEND. Given that both native and emulated zone
> append BIO completion handling should be similar, The functions
> blk_update_request() and blk_zone_complete_request_bio() are modified to
> use bio_is_zone_append() to execute blk_zone_update_request_bio() for
> both native and emulated zone append operations.
> 
> This commit contains contributions from Christoph Hellwig <hch@lst.de>.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-mq.c            |  2 +-
>   block/blk-zoned.c         | 69 +++++++++++++++++++++++++++++++--------
>   block/blk.h               | 14 ++++++--
>   include/linux/blk_types.h |  1 +
>   4 files changed, 69 insertions(+), 17 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

