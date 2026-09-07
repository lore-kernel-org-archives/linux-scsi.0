Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67BB488231;
	Mon,  7 Sep 2026 13:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788787246; cv=none; b=SE16Nszd2Wx/PwYIKSfmF7ohRXToSQoedq9GUriWJFlpP9IoCt6OvbqLchtND749343E8a22dunMeRRnFZiqBpqqnECBybMg/lLbeAukWD0tWCoFdbIuXuxrU0XjWuXatl/3XxJS9nzhNsI0PCrzczu/vvBT9oFIrtRRmQkBMB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788787246; c=relaxed/simple;
	bh=PLPqCDkJDdB7MXyDVu5Jes5TOoY0B9+Pu8vOVwkl7m4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SkkI76r2B0ajiasfbW5LaAqSyNGlH+/9/NyCkGmMbwyA5oeHtftO7vxh5GFKlup7WnKaUJ4wVYvMKyq+MANIjUtfNplyDyjSU5hwqgJWWFCkEwV88BKGUY2k6YElXEs4gZ1xazyrMWc9BwRnd1+nXG5scN+p/tJVZUqwB1biDsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MsQm5xYe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FBRvBGBP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2MXykRkm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=64DfUAFR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MsQm5xYe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FBRvBGBP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2MXykRkm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="64DfUAFR"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A6EA0211FF;
	Mon,  7 Sep 2026 13:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788787235; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FAoGUwBP72piZr5Tje+egH3ZpscJR4GFUUhb7nCPmA=;
	b=MsQm5xYe1oH1Bn2wJ1biikkhXx0zKtgWPS9A57njfYvVk5oFLlI0RMod7HFzF/N9KZ1P8N
	813eYp8J5JwQLHxsS+iRZLZRA7aN/lsIB2T8zN7FFhuACNbxSKfJT8UKnuI0TEYoO7kLdz
	NmeNINBzOwbXvxWR77p8FRLpJtpIPxI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788787235;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FAoGUwBP72piZr5Tje+egH3ZpscJR4GFUUhb7nCPmA=;
	b=FBRvBGBP5TQRNR7Vd31MATaaSEhAUHj7JcQRRYDhau/X4uxFJQW7vzbgRKV65SQSJ1GGVu
	ydYkhaS681nMQmAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788787231; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FAoGUwBP72piZr5Tje+egH3ZpscJR4GFUUhb7nCPmA=;
	b=2MXykRkmRCnoRwM4CNFejcMkg7EUb+R5TFN0QtX18fZZwyeAodRpvef9g7tqxgDj7vw0su
	zl70e8YMbxJFh5nCazklTcGvDgbAXkExHsE6Xn8F5QpBK2i76GnPCn6bgLAH6QqoZ2dAad
	tkgdbxNF/StTznA+EZwG+a6UCHpDe3I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788787231;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FAoGUwBP72piZr5Tje+egH3ZpscJR4GFUUhb7nCPmA=;
	b=64DfUAFRx3hr2IwkIWYUX01Y4cqWtA6Y9lN28E/s136wqnXLkTUiEngyovGS6STjiejzJ6
	HoaOOmDCU/LZN3Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E36313432;
	Mon,  7 Sep 2026 13:20:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 507VER+6nmp1YgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 13:20:31 +0000
Message-ID: <7c093d2e-3f16-4e58-9f43-24db27bc2c28@suse.de>
Date: Mon, 7 Sep 2026 15:20:30 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 38/40] s390: scsi: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-39-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-39-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Use the 16-bits sense codes and replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined
> in include/scsi/scsi_sense.h. This helps with code clarity as the sense
> codes being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/s390/scsi/zfcp_scsi.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
