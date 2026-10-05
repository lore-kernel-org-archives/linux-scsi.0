Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDE941A563;
	Mon,  5 Oct 2026 10:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791197121; cv=none; b=fDyhHqkI6Zt2Glm9iLGHHT+kavP5kfotvkcQri/xOk7ug4UA48V39ZNKw+FfUjqv3QUlQWaAd/dfBjkTE4gLXyJX4Eh+z8HWx7la3/5Bygw0YcpixmRxa3m3MFHt2kVfLjWgDzaX+nplvseomVaohA9dunfAgu7wj9vkagJNAP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791197121; c=relaxed/simple;
	bh=hqrVZ7eLDvyJ+APK7sQ+UC7k/AAA0TqCmgXNBjyJtgQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ngW4zoeUACy2uwNuXuO0RCON1vL9YEoN1GDJ7oQ1ssouuM78LspHbSJVgGOYWsxuKZ1ZK8S05nCew6/BbgWVBauQC10++LfGxwhMrcq6uUWzDlM/x0GyyOjdeA+REDuD3Ue2M02knLcpPIxQLr/I13rhLRufOBWHgHlUcfTJ8w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a1NURU+U; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Rgomq2F8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=i3f8xTK/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ISHBS8Hx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a1NURU+U";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Rgomq2F8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="i3f8xTK/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ISHBS8Hx"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DF0C51F786;
	Mon,  5 Oct 2026 10:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791197113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AQL23iedUfQmZWx1bXu3AepEqpmnYcVTLikcXH2ufTU=;
	b=a1NURU+UQliLJHHpDxXiqikkO95HPAB5atzw2xKbrE6kxTGq9J2kceRvgGXGWoBDMG8kQh
	6w18J09n8p1jm8NxBK88oGW6iOQomrNbO0XWQbqxXdunXfgLOOFp/w2zjYSP4THcHH1YEb
	3si75igcXzqX7WNvYuXk0h2voTFW+/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791197113;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AQL23iedUfQmZWx1bXu3AepEqpmnYcVTLikcXH2ufTU=;
	b=Rgomq2F8IXWjPCmiPZx0g0pQKUBrllBahv3h1AJa0RScPnILPUF+nwPTbCCBvptvN5zdgW
	9DUDEkKo5Yx1M2Bw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791197108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AQL23iedUfQmZWx1bXu3AepEqpmnYcVTLikcXH2ufTU=;
	b=i3f8xTK/t1BWdA5xAlGX+P125WXXTrG6w+4PvWVmJGGhoguCn5QcfpgVH9tJ1ODWJCAHWS
	bAN4aJwAVfVuD/zCUlxWeAQXgLYdx2Lz7jf+pXeZO8ShPnu1Ws/Xwd+VDdH2yBvPceTs6b
	Rg0nHRTqqOZRAEPYOipSlFI+znwt/TI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791197108;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AQL23iedUfQmZWx1bXu3AepEqpmnYcVTLikcXH2ufTU=;
	b=ISHBS8HxFtOtcC72He7MOu84xyUBtKJkqU6MF2UMd4SWTQm1wpVTvZXSRmBCLBlA+joUJH
	US5gD3T9RTDxQPDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B0172132D3;
	Mon,  5 Oct 2026 10:45:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IRqfHLR/w2rDOAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 05 Oct 2026 10:45:08 +0000
Message-ID: <9eb2eec7-f465-4227-aebf-527f89fc735d@suse.de>
Date: Mon, 5 Oct 2026 12:45:08 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] block: fail reads to offline zones early
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261005094632.580753-1-dlemoal@kernel.org>
 <20261005094632.580753-2-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261005094632.580753-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 10/5/26 11:46 AM, Damien Le Moal wrote:
> Any BIO targeting an offline zone of a zoned block device will fail,
> including read commands. So there is no point in issuing read BIOs.
> Fail these early if we ever see one, and be quiet about the error.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-core.c  |  5 +++++
>   block/blk-zoned.c | 18 ++++++++++++++++++
>   block/blk.h       |  6 ++++++
>   3 files changed, 29 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
