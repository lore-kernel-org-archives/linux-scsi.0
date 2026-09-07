Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B25348A2AA;
	Mon,  7 Sep 2026 12:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782554; cv=none; b=IPNYJs9JVCjUClfZAPS4f74kh/qtq/V0h67a3iBdqe0kNMNrhINpu++71bfAtixULc4wHiJtFiLOchJFTc/jX3msmrU+PKo7I9AIiGiTvy/sQ6jZG400uNhFtBdBd1gJAlvhREJsZ5Qt0ALgAq7Ae4S4ebWKlRbP6m55/Lxo5LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782554; c=relaxed/simple;
	bh=vfcVzDJehcyPz08v3fyD09iTaOqTmfi6wuh77jnV+RI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=F93BFWhga4V5kWiNoP2CCi4638pi/GZfMLaweGbdAICFPmQFDi+KkbEzAQ2BO51BUBDYORplxbhbcX+cdURvXQ26/I/z1H76mazYEjOT9zjdrKhOFGRI59/t8xs2TTaN+toUEXKpFzMdh2fnBujc6ZmTsKmkGNllIqG9HZt6viQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NTPYZG3K; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=asdeq4q0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=C1ZWCycp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=v5mhYcwq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NTPYZG3K";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="asdeq4q0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="C1ZWCycp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="v5mhYcwq"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3BF1621ABE;
	Mon,  7 Sep 2026 12:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788782547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0K9ehi8tgrnQvNyuvvwetNGIq7+kjbRK666pwexjptg=;
	b=NTPYZG3K12V5toBI6XH1SICp91JexSwy5qUmYouw0xBbyz1AWQccBvct1fIXo3PvbqV6l6
	SaqAksmft5kvVr/AeaTJNUGIm7hCVzi83E2Rn+tz9nu6MwZchTT3jy/kIaC6hlOCzAt3fk
	O5YAKmdExNkZBf22XRGJAP30jwSCVkE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788782547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0K9ehi8tgrnQvNyuvvwetNGIq7+kjbRK666pwexjptg=;
	b=asdeq4q0gR6kDdS6TBG+gAtyW91xJHR1Q5sBH99fSK1NrW83vUq9Qj+/jKINMKOTfOSb6y
	yPqAE7o+TSGsvRCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788782543; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0K9ehi8tgrnQvNyuvvwetNGIq7+kjbRK666pwexjptg=;
	b=C1ZWCycpI54N/sv+84N5u+/xtRs36BqrvuVLRbUw+1sIARcKdrrzXwjeMNjEMJsolASCqq
	yHs84jV0mfZTsRu4U4WArGAkeap/EaHsAxMODWkMZFWzShS41QxAF7LFjOvjE9t9ms6zWT
	/ib1tV0r5QhEJ5zY8C/Cyd2nWTwYhj4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788782543;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0K9ehi8tgrnQvNyuvvwetNGIq7+kjbRK666pwexjptg=;
	b=v5mhYcwqiGNcqHMQ+2NMTw5euRe1zRVnZfibIHzXGChbh0rhJa6b87hY7kbSh+Pwv42DYs
	R11l7KhkhCvqaRDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D7EC21339B;
	Mon,  7 Sep 2026 12:02:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bQaPM86nnmrjFAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:02:22 +0000
Message-ID: <038548a6-88f7-4d79-93d4-cb96d8d0e83a@suse.de>
Date: Mon, 7 Sep 2026 14:02:22 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/40] scsi: constants: use defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-3-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-3-dlemoal@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> The SENSE_CODE() macro is used for defining the array of struct error_info
> which associates a string description to an additional sense code and its
> combinations with additional sense code qualifiers. These are however
> hardcoded values.
> 
> Now that all 16-bits sense codes are defined as macros in
> include/scsi/scsi_sense.h, modify sense_codes.h to use the defined
> sense code macros. While doing this, 2 missing entries are added for the
> codes OVERLAPPING_ATOMIC_COMMAND_IN_PROGRESS and
> DEPOPULATION_RESTORATION_INTERRUPTED.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/sense_codes.h | 2496 +++++++++++++++++++++++-------------
>   1 file changed, 1631 insertions(+), 865 deletions(-)
> 
Would be nice if we could auto-generate that...

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
