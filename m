Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68E43C0625;
	Mon,  7 Sep 2026 12:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784395; cv=none; b=dGXLPpil8HYM3Sy8KFitA7dmGTVuIW6IUYPlBXiePo4b729BX4uCOVVNHdULM8wemQQzjr0nCEvWroP+yk7kp0+sbFTOz1cAw+EMBopq7ep729zT3R2LxCw76nFbtY0mGgGQvW/ixXvYxuCwlvIy+CIEI+2Vpw602N1yfRns4Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784395; c=relaxed/simple;
	bh=5fu19hlmu5T7Ej8Bl0gTUb03o2IrCh7kvPFcBnp2Twc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sVpL1lnGh90c6cSbBdtGASRrMEC3KoPnjZJAQON7qFnfovQI6Mac9OXJv7uT1g2/FR0TdWpUMjnMxcMKaFtw2fDyIyYT8ILt/vVu0mtAcRKkdlrEF58QBMUfspOV/99f3xG5SW7lWbxr8HOj+3iXYcypIw+SCiYrZXuyaO6Q4bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CYyW/Ja6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nN11a1Yr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=d17gPvhF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=B+pJbwYI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CYyW/Ja6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nN11a1Yr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="d17gPvhF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="B+pJbwYI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8A90A1F788;
	Mon,  7 Sep 2026 12:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dNNq+P+/J/YLoHINTxLtVswwbj7I5WcKVyHR0hnTZYc=;
	b=CYyW/Ja6MCzmlkTIKWDQ+ygwp/K8LPK3eLREtoozJ8tmStv+DAjSeSGQr/AXyzftSWb+iT
	0buUHCYlaxlW4fpSN/SONbVc1y6ZgmsuzrcIHdvOvJZqtoxL+ODvWEvKyyAdOJ6V7AomU3
	eqVVOInvWfqJsauivmB7OMoIpG0TKQI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dNNq+P+/J/YLoHINTxLtVswwbj7I5WcKVyHR0hnTZYc=;
	b=nN11a1YrMzGUXKUEP8oiTv1wkF65mxiHIILleDtigro33S8g8/PmSDsvPK+goKIz1jWZ+N
	1iEi7V69OoDIdrBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784383; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dNNq+P+/J/YLoHINTxLtVswwbj7I5WcKVyHR0hnTZYc=;
	b=d17gPvhFq5Pmte3cEQbuY4PsNeAPxq7aFs1wlc80+DXHxMN+klKA/CGaNz+Fo89HzRQoNu
	GvvspzEVdR9gJpZ2zC3MOUud8mNsmaJRv3PyxLCuptvG8X9jYFdQln93uJm52/kcTrCxcG
	As5h7Bv7gdVTtfAlMFtDj3ilITemzVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784383;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dNNq+P+/J/YLoHINTxLtVswwbj7I5WcKVyHR0hnTZYc=;
	b=B+pJbwYIcm2u3tTjcB3W8z2NehCCT8gYuC0Z/o+sR2MzORxy+fOfNBt2Mqliolpwz/y8Pi
	5ASDdvDORKlfNkAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32F5F1339B;
	Mon,  7 Sep 2026 12:33:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eyy8Cf+unmpWMwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:33:03 +0000
Message-ID: <28117e6b-3aa2-4e25-ac9e-6640542fe85b@suse.de>
Date: Mon, 7 Sep 2026 14:33:02 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 21/40] scsi: megaraid: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-22-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-22-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the megaraid driver to use the scsi_set_sense() function and
> replace all hard-coded additional sense codes and additional sense code
> qualifiers with the enum values defined in include/scsi/scsi_sense.h. This
> helps with code clarity as the sense codes being processed are easier to
> test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/megaraid.c               |  8 +++++---
>   drivers/scsi/megaraid/mega_common.h   |  2 --
>   drivers/scsi/megaraid/megaraid_mbox.c | 12 +++++++-----
>   3 files changed, 12 insertions(+), 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
