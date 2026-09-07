Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251A948823A;
	Mon,  7 Sep 2026 12:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788783068; cv=none; b=TD732MaPpkljw+C2E5Otun5hNdhtH3ILDUsrZiHGYZH9gjoK9cgE+NdmRN7nREqCaSUNw9WlW02lrSjWqO27thYIC73zGOEU6hjEnu+s/Kh8xRH7yGpugb8sVRh9/vM4D+2xCAL4o/qY6JdGWYRJPC8clrxMzgW69dw7mBqOJHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788783068; c=relaxed/simple;
	bh=z0srhFhnhCzKvHk52yfbss4F64271/EiMNC1osZtxEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=N7CyoapUl8d2gQWnPRcsnmFO2ePvtrQr4uoUUucdl9BloRUJ9XeH/7EIHM93rH2F2nwrGHoOH+GvF6gcdYc+K07HG+95JiXMysRsReHn5IOJXGf0LaQwGlms9UeF260++cX/XukVYqNrBJEWspEGFfHQGQB95AQbl7gTtrr+SlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=efKbcJo+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Qlzx/ElI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cdBoWHvh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=U8XlSHHi; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="efKbcJo+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Qlzx/ElI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cdBoWHvh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="U8XlSHHi"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E6FAD219C2;
	Mon,  7 Sep 2026 12:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788783061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuO925TticfZXvC4A8yZlRmQvCeXjsFi1hJFxCn5Q94=;
	b=efKbcJo+z0Q+gvfoxG8gjEpyqZ6JdPqpgwQWg0FGOn7ChANb47Cjr8FC8Atk1KglCR/Riq
	1XmdQt4L4v19We3KLk95H97mAcXd+4+UI4NAYamexzLAzJRNux2CtPSqBOOQaW63zCl0HH
	Q5yfqCbZWFwnKym2gRKnV4ePNv+M2hw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788783061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuO925TticfZXvC4A8yZlRmQvCeXjsFi1hJFxCn5Q94=;
	b=Qlzx/ElIPe32gfGtYsojqxD90pSvcP1Mg7ngr8fCSoJ0e8q3kMmjA3tz+4zNVvnS8kjB7f
	VYoxMlNuc8MkeYAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788783056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuO925TticfZXvC4A8yZlRmQvCeXjsFi1hJFxCn5Q94=;
	b=cdBoWHvhYBmBG31/fSNu7KcgFKTW+BQqWZyD8icqQLVE/8OLh16It6ppp6jfjLSCKmp7LS
	K8no75GtEo0LaHLctWpAI2BB5XyI2zju68mv3QBj4SMHDvUpZeBMThXJokEq3Tnpc4qg/u
	yRKG2Zs9rceQQWvEMsXkZgq2rqmtHP0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788783056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuO925TticfZXvC4A8yZlRmQvCeXjsFi1hJFxCn5Q94=;
	b=U8XlSHHiai1xmDgiUhUDl4j65u04F1YUbGB1ikQkzySvYaGIv6ss6aH2tXEYDat4XF4FOM
	WAzTOOagzChoBjAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 969BB1339B;
	Mon,  7 Sep 2026 12:10:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6B6AI9CpnmrbHQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:10:56 +0000
Message-ID: <2554fab5-d531-45ad-b5cc-80c9713f137f@suse.de>
Date: Mon, 7 Sep 2026 14:10:56 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/40] scsi: rename sense field of struct scsi_failure
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-5-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Rename the sense field of struct scsi_failure to sense_key. This makes
> it clear that this field stores the sense key, and also unifies this
> structure field names with the names used in struct scsi_sense_hdr.
> 
> To be consistent with this change, the macro SCMD_FAILURE_SENSE_ANY is
> renamed SCMD_FAILURE_SENSE_KEY_ANY.
> 
> Of note is that the definition of the array any_sense_failure_defs in
> scsi_lib_test_any_sense() is modified to change the initialization of the
> result field to use SCMD_FAILURE_RESULT_ANY and add the .sense_key field
> initialization to SCMD_FAILURE_SENSE_KEY_ANY to match the test target
> case.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/ch.c                           |  2 +-
>   drivers/scsi/device_handler/scsi_dh_hp_sw.c |  4 ++--
>   drivers/scsi/device_handler/scsi_dh_rdac.c  | 10 ++++-----
>   drivers/scsi/scsi_lib.c                     |  6 ++---
>   drivers/scsi/scsi_lib_test.c                | 25 +++++++++++----------
>   drivers/scsi/scsi_scan.c                    |  8 +++----
>   drivers/scsi/scsi_transport_spi.c           |  2 +-
>   drivers/scsi/sd.c                           | 20 ++++++++---------
>   drivers/scsi/ses.c                          |  8 +++----
>   include/scsi/scsi_device.h                  | 12 +++++-----
>   10 files changed, 49 insertions(+), 48 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
