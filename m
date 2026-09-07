Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0136D485CE7;
	Mon,  7 Sep 2026 12:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782508; cv=none; b=iVPSPIf7XKVb+lJwzMoBYhmhgbIIybMUFI2nX+mX1S0qVThACA1MUay32byFvoKthpicBsMwoNw76TtNkjJtWupPPXFPP7rQWFJ22x8AcgSqsO+Qm3TIFu1kHQWZdNMTKxa1lepSmF8b2qO84sWuey/Fo2FgwhKbMgsf9Tv6/0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782508; c=relaxed/simple;
	bh=dMHnmjwu27crGzN/UzreDdArC2CWvVpmNlWflGYErtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=etoHy10EH/lMapg9UDs+HFI2r3DCmH/0CNKnHbDmiuSHHveRblfkK7C4gfU0G5T8319k6TF7Au5jVZg2DmAlH0VYLF3RrtUIwJLPWq1iGYtzZ/U1EVsX46UmhcP1fhZ68Z/a7jkdRrayWn1R9DfE2UThppSXQy5CKL3BMsyidm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=V+VWqBg7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uPvk18oY; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=b08zxQyM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mE1LxPcc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="V+VWqBg7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uPvk18oY";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b08zxQyM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mE1LxPcc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B2ECB1F456;
	Mon,  7 Sep 2026 12:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788782500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UElMWw7XB6EgXNG4BtTRuNwNiddbEoaGBASiod9R/zw=;
	b=V+VWqBg7L//f9zZK/ZEzZwLx5SzNUm/u45eBW2PTYs8mnJM+7/EBY9jYnofLfi7S99rThU
	KhXt1o9tcvjvpyLBWcvSYsgXwUAzh34bAqlDNIoPgZ/HzOAi07DLfWjBPfMUzZE8SIep9W
	ksGBX4YfKHdroUXdPciCJpfIwrKoasw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788782500;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UElMWw7XB6EgXNG4BtTRuNwNiddbEoaGBASiod9R/zw=;
	b=uPvk18oYIWlis1i6Zr2DYSOHaG21IeUM63ML/tD7sN8O2NBdtbBFPnmYR+yZScC29ERRtH
	bYEsVdW8Vvl1H5Bw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788782496; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UElMWw7XB6EgXNG4BtTRuNwNiddbEoaGBASiod9R/zw=;
	b=b08zxQyMuWIlh7tOaFctBFwbV5MIXVV69zAOhGdP4kpshCVvvNRp5IL6z0WIUBwDEi0uir
	T7CKWPlMcmkGvsMsfYjUzpzgY1npPY0c+2tH8dqDwzyVW6cRD+TMQAcJM9NA/ZfVn3pfz9
	fPKoica7UkDPd22TNjrRyZtNwkFfqpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788782496;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UElMWw7XB6EgXNG4BtTRuNwNiddbEoaGBASiod9R/zw=;
	b=mE1LxPccWGiSAL4Hku293BGSrk0nj20oJEg0X+QIyVzTkqkGkmv+hHHIk6VTDCfZZv90kI
	okbcaMP8V9glRWCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5BAB91339B;
	Mon,  7 Sep 2026 12:01:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oZU1FaCnnmopFAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:01:36 +0000
Message-ID: <d4b8f5e6-5291-4260-84be-21bcb546e7c1@suse.de>
Date: Mon, 7 Sep 2026 14:01:35 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/40] scsi: define all additional sense codes and
 their qualifiers
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-2-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Introduce the file include/scsi/scsi_sense.h to define all existing
> additional sense codes and their combinations with additional sense code
> qualifiers, according to the most current T10 list available at
> https://www.t10.org/lists/asc-num.txt.
> 
> Additional sense codes (ASCs) are individually defined as an 8-bit value
> with the ASC_ name prefix. The combination of all ASCs with T10 defined
> possible non-zero code qualifiers are defined as 16-bits values. The
> 16-bits value for ASCs with a zero ASCQ are defined together with the ASC
> 8-code using the ASC() macro.
> 
> The sense key macro definitions in include/scsi/scsi_proto.h are also
> moved into this new file and scsi_sense.h is included in scsi_proto.h. The
> helper function scsi_sense_code() is defined to facilitate generating a
> 16-bits sense code from 8-bits ASC and ASCQ. The accessors
> scsi_sense_code_asc() and scsi_sense_code_ascq() are defined for the
> reverse operation, that is, to respectively extract an ASC and an ASCQ
> from a 16-bits sense code.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   include/scsi/scsi_proto.h |  20 +-
>   include/scsi/scsi_sense.h | 943 ++++++++++++++++++++++++++++++++++++++
>   2 files changed, 944 insertions(+), 19 deletions(-)
>   create mode 100644 include/scsi/scsi_sense.h
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
