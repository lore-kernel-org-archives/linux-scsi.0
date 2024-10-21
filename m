Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3FD194C6C;
	Mon, 21 Oct 2024 06:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729492462; cv=none; b=j1b8h1GEhUKA35t6MljtQnZmHVYTAZU2LLS2z+UGHhvyAQOqvaATV1PXKgBd6PdexRGEY9hJ5XB2H5YWu2AywyBGFqGgkHTNR4gLUtAyvw33GPnC8f5VQ2mGrNHor/I8ZClicmxQXIOTYOT2X3mBfHOOGzGyVMXXEB6iEVLq9y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729492462; c=relaxed/simple;
	bh=brfUo5wcoKOdcUDi80rEvq2yn4BVTWOdi0xSv18cfMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BF4YtnBHdzdenZyBIzrVILof8tEURSMPOkNrFdpgEl3jeaGsfqSdQ17Bvaq6KtRUH/n0hsQRkUwtYKIzKNAKWvGvDGfmqQH78lY6RedbZJ6ogGROyFtrtE/wTqCf3Uu0glP9bPAtDadmXfQbLrmTfcI21ONtOYLi/OP3tVJNHPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qwk/UH0B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qNOHya5C; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qwk/UH0B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qNOHya5C; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qwk/UH0B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qNOHya5C";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qwk/UH0B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qNOHya5C"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 207B51FE90;
	Mon, 21 Oct 2024 06:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729492459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YT1wKTaII3dSon4kvGuJdKFQbr4VhIMVmZ3bBqO/H5c=;
	b=qwk/UH0ByY5xl95WPxS/CY915xwj4KB27EKk/6g9IjNeYxoGpB4zsCTdKqqu13W+4IGfws
	vjOko7nZVLTVCj7ToUwcv1Xm2Mzh/noaX79REiDY+dCF2cWNyve6kOjerwCnIT67gJuEPc
	dipltDJc2a4jXQpFiIdG10BWTmZQnKw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729492459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YT1wKTaII3dSon4kvGuJdKFQbr4VhIMVmZ3bBqO/H5c=;
	b=qNOHya5Cqhjp/ytZObpBWYd34GrB5xNQJC1e3NivJ4ECpGkYB1erz2IYG2GzrA07Ijwmof
	Le9p/RcIfZ2PZ2Dw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729492459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YT1wKTaII3dSon4kvGuJdKFQbr4VhIMVmZ3bBqO/H5c=;
	b=qwk/UH0ByY5xl95WPxS/CY915xwj4KB27EKk/6g9IjNeYxoGpB4zsCTdKqqu13W+4IGfws
	vjOko7nZVLTVCj7ToUwcv1Xm2Mzh/noaX79REiDY+dCF2cWNyve6kOjerwCnIT67gJuEPc
	dipltDJc2a4jXQpFiIdG10BWTmZQnKw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729492459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YT1wKTaII3dSon4kvGuJdKFQbr4VhIMVmZ3bBqO/H5c=;
	b=qNOHya5Cqhjp/ytZObpBWYd34GrB5xNQJC1e3NivJ4ECpGkYB1erz2IYG2GzrA07Ijwmof
	Le9p/RcIfZ2PZ2Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE078136DC;
	Mon, 21 Oct 2024 06:34:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PJa2KOr1FWdVQAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 21 Oct 2024 06:34:18 +0000
Message-ID: <f6ecfef4-a880-493a-92a7-9be2d02555c8@suse.de>
Date: Mon, 21 Oct 2024 08:34:18 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/14] scsi: fnic: Replace shost_printk with
 dev_info/dev_err
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20241018161409.4442-1-kartilak@cisco.com>
 <20241018161409.4442-2-kartilak@cisco.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241018161409.4442-2-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 10/18/24 18:13, Karan Tilak Kumar wrote:
> Sending host information to shost_printk
> prior to host initialization in fnic is unnecessary.
> Replace shost_printk and a printk prior to this
> initialization with dev_info and dev_err accordingly.
> 
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
