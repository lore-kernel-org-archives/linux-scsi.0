Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C39722307;
	Sun,  4 Feb 2024 11:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707047911; cv=none; b=PONC98VXUEUsC/Muv804KQMD7+KDXp0dp1lGlY9pXM3ZP9hNDLLbU9/zG3nvMImhfYLusugaDMo8odAxqkrUWiPt1ja7/SPMMccglihv0HtmnqCzFdOumCJgkD2uLX/AByqRY4I/WmILnArgDHYlja7i6cfsd7anToe0zczpSRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707047911; c=relaxed/simple;
	bh=UDGWpj5MY57wj+YxTUDG1yh4fb3IM1zpDzGIobLgjlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rCleFW7DyeNUfO+Wv/4IEbfjQ06eR9XmM60g72i4Bw244/Zi3ET5jFmoc8Vbk//w6RtoxclhPJsOkpccIaVax0EiFaib8zqUcMZMcfGx7zh4Us5mQ6mKB/Udxg6SO06aF1Rd5ulMIdHTfRy+DkHDuJDZ3J//cdIskVfMaMvF0P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cdrXN0Z6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tDwBryM+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cdrXN0Z6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tDwBryM+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cdrXN0Z6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tDwBryM+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cdrXN0Z6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tDwBryM+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8D4481F805;
	Sun,  4 Feb 2024 11:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707047908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kStBnrjoQFabJh158uI5u7gUnAX8+5ga0oRIZ/a4jBw=;
	b=cdrXN0Z6A5nxa51FKEJ2yQJ+jP8gh9WYb3j7utsKhBin5iBWn+XWSLg/LYRRtnddjclu+4
	gTvA7DWyF32XFQzLPJXkakjV/E51IYI4QGj0iZuCz2LLeLBW5XgTlHz4cCrSlosXBwv/rI
	zNhbQvzC5KCUEt/sMsSLVhyI51HMVq0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707047908;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kStBnrjoQFabJh158uI5u7gUnAX8+5ga0oRIZ/a4jBw=;
	b=tDwBryM+KFucP5vDWxhLyav5V3FWKxEabIRbopS8vtz16OoCl5AnRY4bn5HUUBornWUVsz
	vCuIy5YyCQBRoSDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707047908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kStBnrjoQFabJh158uI5u7gUnAX8+5ga0oRIZ/a4jBw=;
	b=cdrXN0Z6A5nxa51FKEJ2yQJ+jP8gh9WYb3j7utsKhBin5iBWn+XWSLg/LYRRtnddjclu+4
	gTvA7DWyF32XFQzLPJXkakjV/E51IYI4QGj0iZuCz2LLeLBW5XgTlHz4cCrSlosXBwv/rI
	zNhbQvzC5KCUEt/sMsSLVhyI51HMVq0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707047908;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kStBnrjoQFabJh158uI5u7gUnAX8+5ga0oRIZ/a4jBw=;
	b=tDwBryM+KFucP5vDWxhLyav5V3FWKxEabIRbopS8vtz16OoCl5AnRY4bn5HUUBornWUVsz
	vCuIy5YyCQBRoSDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 361EC1338E;
	Sun,  4 Feb 2024 11:58:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6BcGNuB7v2WjIAAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 11:58:24 +0000
Message-ID: <47084a29-353c-4b1d-8a9a-59294bba35d7@suse.de>
Date: Sun, 4 Feb 2024 19:58:24 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/26] block: Introduce bio_straddle_zones() and
 bio_offset_from_zone_start()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-4-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spamd-Result: default: False [-1.21 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-1.12)[88.43%];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -1.21

On 2/2/24 15:30, Damien Le Moal wrote:
> Implement the inline helper functions bio_straddle_zones() and
> bio_offset_from_zone_start() to respectively test if a BIO crosses a
> zone boundary (the start sector and last sector belong to different
> zones) and to obtain the oofset from a zone starting sector of a BIO.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   include/linux/blkdev.h | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
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

