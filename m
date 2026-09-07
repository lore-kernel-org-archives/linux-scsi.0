Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7584229BA;
	Mon,  7 Sep 2026 13:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788979; cv=none; b=LsRO3/SDAkv/lT2+BpAFcQo75e3NIGHe2TCovy4VzEBvFhBpIyQnXZ8xzLBMaSVchKRFNN67dYpyEWDcRmVDB2Y97NVRLXguGS9MYprxhIY+LD/0GK9i39lrVdIjWkOA5Q3RknvLCrtOyIQhsW3bxeeFuqjLukhzwOSzrp9n0DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788979; c=relaxed/simple;
	bh=9h1vIc28SYyt2TgAFEy/J3+K6H2aQtjyKp6c2qvZKcc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=V2TKUfpYWHK3yPJZ4ziw554omyOpILle5gYaqAzy//l48LF174aZOBCmxCisml1kyPQfdUTWL9Hs6aqfqX1AAcsgFqhyAuGxZOm7b10MfAbm41DEULj4yHWjjVzWVzeMl0l+UZqopoyxAcMeu6Dc9DCaHmaqlBP4+jZpR8/t1vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a1dN2W9i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fclW961K; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a1WS/odt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=d1VdUQv+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a1dN2W9i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fclW961K";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a1WS/odt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="d1VdUQv+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6426D21ABC;
	Mon,  7 Sep 2026 13:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788788972; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=696T2yE5Wk1Q5fLgNHshSUuuO6yv03hkqC0+QO1iFkM=;
	b=a1dN2W9i/qR1VYKA0HQ/s7dQIhQ6vl7eFEnNHt03Be3jzV7YV/pmxvvmtmuQ0buSs0qsuA
	M79AQ1UafJesw0E06vpSNKLW7nQm9j3atf6wr6x85OqpgHu+b4BVVpJZVXba+Ek5KsjxCv
	MGHXZIHZuh7M+TkTDhTXCHmUnMJzsD8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788788972;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=696T2yE5Wk1Q5fLgNHshSUuuO6yv03hkqC0+QO1iFkM=;
	b=fclW961KMPkAyVjkmZXVSeOFGy16zjR8HnJQirxWYxB/6HAsmyYf/gOd2ZqM/DjJkwXNT0
	sPVw0ABAjr94ixAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788788968; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=696T2yE5Wk1Q5fLgNHshSUuuO6yv03hkqC0+QO1iFkM=;
	b=a1WS/odtM5gC7rr/InIJbul+JfyHjv8LGoW36LNscKaswrlvN2HrxKWXhhMw6qtrtFzlLA
	nDtLx1rQztSVxd9FDTY+28nyP+USQGjRqZ31YhNsWH7WpDl5+9zqdbVj2ZB8nOGXLZb1th
	hYcQUZJzFrm1XrTJxuMxFDV91lQDjrs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788788968;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=696T2yE5Wk1Q5fLgNHshSUuuO6yv03hkqC0+QO1iFkM=;
	b=d1VdUQv+RjIciY9yv33nFktyWpr44IdcQFG103LielG5R1JR4TtMoRtZRN6iAFg9uZ6I4w
	WWAMelnZQIhHY2DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EFE5C13432;
	Mon,  7 Sep 2026 13:49:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3KuCOefAnmqdfwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 13:49:27 +0000
Message-ID: <24aaceb7-4959-4417-85f2-eaf9213899c7@suse.de>
Date: Mon, 7 Sep 2026 15:49:27 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/40] scsi: device_handlers: rdac: use 16-bits defined
 sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-15-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-15-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the NetApp E-Series RDAC SCSI device handler driver to use the
> 16-bits sense_code field of struct scsi_sense_hdr and struct scsi_failure
> and replace all hard-coded additional sense codes and additional sense
> code qualifiers with the enum values defined in include/scsi/scsi_sense.h.
> This helps with code clarity as the sense codes being processed are easier
> to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/device_handler/scsi_dh_rdac.c | 45 ++++++++++------------
>   1 file changed, 21 insertions(+), 24 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
