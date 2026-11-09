Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794222927;
	b=mxeyFW4hb5jyf/g+2nRuxBT0eG/Ke5UrkW5tWgc6vnT8RFb7lFKCs9tbwo+H3GREYIlO
	 L8gnsgWaWrl2UZKe2g6NtyC/kB/uoCBq/PieKw2q0j0qZKESdrvx0Dt1dzXj4Zc5RiTlY
	 XcUwaKM+cbXACePgjhDHYdYmMEVqANIo/P1PBvboXbpCxJdJ5XufWtssMhXGaVwVkLlCQ
	 z/8JIqHaI+4cE/8JPIlsIz6kFeYqz/UJ7gx9bR2OyvvzLCZn1fcJzvrm8c+onEXaXR5nP
	 aQIJqBD3rTE98/DqnAD2MQVXFexi5+WlBt9TbwuUNphU/e5DlVFkBiOI00/4IAegpzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794222927;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=sdXoj3F6QxIJQqtATncujMivEp5O/ra7ZkUgNGviLtM=;
	b=qFwoLbbon9GRykokzjGrHmQwZ2bTbzVvfNtYJ7pUowMddYwujDXe+Gf7XjONSabrsZFi
	 IdF5q9d9bhNsPWptD9bbjq+IB483Ko+868S9ygPvSagh0qqC1eXEQW+SdttyJ8ovi7B1H
	 j9lOKs4VYorfjnXCwtzhSotaq2p+5xLULtwLIV00/0+vPhrdtjPZFROty1bQejS3ivsn4
	 OkAO1Yz1KKQj+p16wk1GWHJv816oBG9h/ogDzs/CH8etp8KPTCeExeo7fgdWSFNcjLvLS
	 AzT4KZxiC72H9R3Ye/rfqvz8yyZBWC0kc5bx1JjgmirJ0G4TSMaxd7ENlFmxVWAhrgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=JdxpoW4p;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vUH2gg3s;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=JdxpoW4p;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vUH2gg3s;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B6B606A333;
	Mon,  9 Nov 2026 11:15:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7B6B606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=JdxpoW4p;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vUH2gg3s;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=JdxpoW4p;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vUH2gg3s
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E6A3D2218B;
	Mon,  9 Nov 2026 11:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794222924; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sdXoj3F6QxIJQqtATncujMivEp5O/ra7ZkUgNGviLtM=;
	b=JdxpoW4pyJTkUJ6Hhotm41XSsIHQht1IcPmaIEfNzy0lsM3GkLM2sLDcBW9PQCfMEMLNw3
	lqcMiiuu8vQ+ETzq12ggY4fiSBKjOoSX9qgxCcqUWkiTNl7HWdUgJfltmfx79i98Vs4sAO
	Q9jbz7zcNtCr3wLjZCEcp2NlgSOBybg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794222924;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sdXoj3F6QxIJQqtATncujMivEp5O/ra7ZkUgNGviLtM=;
	b=vUH2gg3svweh6xewX+fFPr0EowsdFR3z4E27Kphb/fQDoC8hvoGn6PikRddhxYwcsM0Qx9
	ym1lV4/KsVSk0tDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794222924; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sdXoj3F6QxIJQqtATncujMivEp5O/ra7ZkUgNGviLtM=;
	b=JdxpoW4pyJTkUJ6Hhotm41XSsIHQht1IcPmaIEfNzy0lsM3GkLM2sLDcBW9PQCfMEMLNw3
	lqcMiiuu8vQ+ETzq12ggY4fiSBKjOoSX9qgxCcqUWkiTNl7HWdUgJfltmfx79i98Vs4sAO
	Q9jbz7zcNtCr3wLjZCEcp2NlgSOBybg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794222924;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sdXoj3F6QxIJQqtATncujMivEp5O/ra7ZkUgNGviLtM=;
	b=vUH2gg3svweh6xewX+fFPr0EowsdFR3z4E27Kphb/fQDoC8hvoGn6PikRddhxYwcsM0Qx9
	ym1lV4/KsVSk0tDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A264413319;
	Mon,  9 Nov 2026 11:15:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z79rHkyr8WozGgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Nov 2026 11:15:24 +0000
Message-ID: <0756d89f-f22b-4717-aa1e-c62ad72b582d@suse.de>
Date: Mon, 9 Nov 2026 12:15:24 +0100
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
Subject: Re: [PATCH v8 05/12] block: add storage element management ioctls
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261109095144.819709-1-dlemoal@kernel.org>
 <20261109095144.819709-6-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261109095144.819709-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.997];
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

On 11/9/26 10:51 AM, Damien Le Moal wrote:
> Define the new ioctl commands BLKREPORTSTORELEMS, BLKREMOVESTORELEM, and
> BLKRESTORESTORELEMS to provide users accessing zoned block devices
> directly with an interface to the storage elements management operations
> of the block layer.
> 
> The ioctl BLKREPORTSTORELEMS allows to get the total number of storage
> elements of a zoned block device and to get an array of storage element
> descriptors (struct blk_se) describing the current state of the device
> storage elements.
> 
> The ioctl BLKREMOVESTORELEM can be used to remove (depopulate) a storage
> element, in particular storage elements that have a degraded status
> (i.e. BLK_SE_STS_DEGRADED). But healthy elements (BLK_SE_STS_OK) can also
> be removed, and later restored.
> 
> Finally, the BLKRESTORESTORELEMS ioctl interfaces with
> bdev_restore_storage_elements() to restore the depopulated storage
> elements of a zoned device.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c             | 163 ++++++++++++++++++++++++++++++++++
>   block/blk.h                   |   9 ++
>   block/ioctl.c                 |   4 +
>   include/uapi/linux/blkzoned.h |  41 +++++++++
>   include/uapi/linux/fs.h       |   1 +
>   5 files changed, 218 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
