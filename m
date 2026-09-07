Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4361B4B1B3D;
	Mon,  7 Sep 2026 13:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788493; cv=none; b=JtgXpibCPGIbEWEg9RbBD0wFhMdE/uSnZDctIuH5CcwS+/uNKgiVvM/I3yiUtTQ72oCtPX8zLKArue/fSmZMNYZDogqVxVcOWaKXOO2P5Jz6itQYvJXmdhodC5LMPhKmoAVHnBQne3WrhZgZHJ41p3K2ECUCnzoPxdWUAP3Xhc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788493; c=relaxed/simple;
	bh=RoX0qbCGFXI8LwBnxfEF8+o6ighp+bpsD0J70Qe1q2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=u1oVAepdSSYNSSl3gLl8JuHX0w0V2FVsy7N729JmXd0n411zcsVAX4F8wHj1yiv7jOuWFWOUJgqncmWs5CvCoa01GPn1St5AHoTwsdy3NHSZ1ddwctvt/cutyBj6ujxzL3RKjyrStlRUblhe8DMcvfKrsCArKoHVBsM7l5liOhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=edkVC91/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PGv9a4ea; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z4QhEkD+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YW1kluFd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="edkVC91/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PGv9a4ea";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z4QhEkD+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YW1kluFd"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EBC231F796;
	Mon,  7 Sep 2026 13:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788788486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7dlNbyQ1NrVztoz0vVPYYSSzwuZXAcGM4daj6vdghpc=;
	b=edkVC91/N0mV6Fh92xfgMGD3bawZ0qmkVG2HMnBC+gH2Ttw9hJioOaYMmqPvb/5+xDta5Z
	1sRyfy2TlJzHbVKIgR0BPsXxQJRlmzWxEj0tkPEkwErxle/2Hudvnc2/xMwuKFhg1fBglT
	AfNafqdc+0h2xh0E1rgdI/CLVZEzSdU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788788486;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7dlNbyQ1NrVztoz0vVPYYSSzwuZXAcGM4daj6vdghpc=;
	b=PGv9a4eam7IiybUF9D3ONQoZfRVYMoku/46+1IM1xVU21sE3uKQR1/CNDSwCpb6+HhbI9+
	teKxdtkForOEqLAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788788481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7dlNbyQ1NrVztoz0vVPYYSSzwuZXAcGM4daj6vdghpc=;
	b=z4QhEkD+7kX9BhORLxt13OZfSikS/VhWfrITovlDeGYGjmw69zqx20UDMMUIDvDkQNBadQ
	aex9kahkZBkS17zqnF9AYVoWWayCEzY9URRo98xcZpA5V0D1rI0K9iyLybqmLLe2D8w4Kc
	EzPJU7YHGqLUsubrPRvRFuYfONZhFXM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788788481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7dlNbyQ1NrVztoz0vVPYYSSzwuZXAcGM4daj6vdghpc=;
	b=YW1kluFd2IMr7K+Tuiji+wj/zk76Niz99lmEN6oOHrB95HYk4glE92212e3rWk64G+NjTq
	IT4Wntx/M50j5hCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 852C313432;
	Mon,  7 Sep 2026 13:41:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qp45HwG/nmpDdwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 13:41:21 +0000
Message-ID: <4fdffeac-7a1c-45fc-8d71-8ca79999d27f@suse.de>
Date: Mon, 7 Sep 2026 15:41:20 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 39/40] scsi: cleanup scsi_proto.h
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-40-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-40-dlemoal@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]

On 9/3/26 5:42 AM, Damien Le Moal wrote:
> Now that all users of SCSI sense codes have been modified to use macro
> definitions and the 16-bits sense code instead of separate 8-bits ASC and
> ASCQ, remove the now unused asc and ascq fields of struct scsi_failure and
> struct scsi_sense_hdr, and the old (and incomplete) definitions of SCSI
> additional sense codes and sense code qualifiers in scsi_proto.h.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   include/scsi/scsi_common.h | 13 +---------
>   include/scsi/scsi_device.h | 13 +---------
>   include/scsi/scsi_proto.h  | 51 --------------------------------------
>   3 files changed, 2 insertions(+), 75 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
