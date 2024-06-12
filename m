Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038646F077;
	Wed, 12 Jun 2024 07:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718176738; cv=none; b=KxUTiOVa+/Es/kqROkwOxUdTjd+TtrEvJPsK+HWHl8gkZBt+VTAydFSvJZJRxrKHc10ffwOx5AOV3XLNYft95ztswqv5HH8qzDmY8Dy5jcQc28qYjtpnIKkdDioZiU30tAhkNsyU59ZJT7VU0bRbc9qqPEpS3vZ7fBAjfVSDF38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718176738; c=relaxed/simple;
	bh=KwNgimE294iB6otsiEvXsbXHCC2yLiVNNG7IpeDVq+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t3GopCpHdiCug37AbggeGUIdqpzBFCCBMqtIoOFi7Hzlo+GiV4fh1+YpiL0vG+8rFJ8E8sfbq393U3LAsvERzwX89TOHysMd7sEGVMaKg51nEWp9qLHANGE6MfDuEkFe+s/Q1EZ16Dcu3MCkRvmrVC+rA1HcyYMdZyC8W0cXjmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Rld9zix5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vO4VaIEn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lMiRGPgu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eHGR4jeF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Rld9zix5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vO4VaIEn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lMiRGPgu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eHGR4jeF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F15375BD1C;
	Wed, 12 Jun 2024 07:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718176734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XCRwjfh3efFojbLfiXjXPTbdsMU5jxmIYn1xogazkBw=;
	b=Rld9zix5HWJpEfkVqVwKtN2bFSRJWLK2V+hI13ilyK1rh9BvO5DaEnJl5aVXFg2daPPuyF
	6QmTgEr0NumeOz2gont4zLBVQNRDAmeLf5PBx2Rzi4DccgPTzl6hMIZueJhl/XPpHHwkfK
	D/3iW97Qaeykclcsqc50//Ezw6t1wYQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718176734;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XCRwjfh3efFojbLfiXjXPTbdsMU5jxmIYn1xogazkBw=;
	b=vO4VaIEnm92U/xadIv1O5ZfeJNWU/FzvNBf0QlVPDPIzep/ksRM3h5yuKnmOnOkM6D6+ol
	wluUN/WBIkJDw5AQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718176733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XCRwjfh3efFojbLfiXjXPTbdsMU5jxmIYn1xogazkBw=;
	b=lMiRGPguZb+xKoVEyNONKkkS+GRcU+IS21+SA8Gxn502mv2VcJyyFFMFCxbEOXBfAt6Toj
	lbYCZX62m23iYKXuvURLuLC2BcxD7tAiq6bFDY9//6lKYFUG7khJFhva7sGiW60hbaX2ue
	fXmQjyTvvhFs/2+ad6+elB4XIM0/kSs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718176733;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XCRwjfh3efFojbLfiXjXPTbdsMU5jxmIYn1xogazkBw=;
	b=eHGR4jeFqTVG2euIiZ8dzLLgB59CyPyhVHjiFAqAYgCti50lqdfdEwWQ9ludaZCeGX21Zw
	cPX0aFq78+p7vmCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7DE24137DF;
	Wed, 12 Jun 2024 07:18:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8tk+G91LaWa5RwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 12 Jun 2024 07:18:53 +0000
Message-ID: <b1ab1878-cdf3-4f8c-8268-bc6b5f6b905e@suse.de>
Date: Wed, 12 Jun 2024 09:18:52 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/14] scsi: fnic: Modify IO path to use FDLS
Content-Language: en-US
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-10-kartilak@cisco.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240610215100.673158-10-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,cisco.com:email,imap1.dmz-prg2.suse.org:helo]

On 6/10/24 23:50, Karan Tilak Kumar wrote:
> Modify IO path to use FDLS.
> Add helper functions to process IOs.
> Remove unused template functions.
> Cleanup obsolete code.
> Refactor old function definitions.
> 
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
>   drivers/scsi/fnic/fnic.h       |   20 +-
>   drivers/scsi/fnic/fnic_io.h    |    3 +
>   drivers/scsi/fnic/fnic_main.c  |    5 +-
>   drivers/scsi/fnic/fnic_scsi.c  | 1107 +++++++++++++++++++-------------
>   drivers/scsi/fnic/fnic_stats.h |    2 -
>   5 files changed, 680 insertions(+), 457 deletions(-)
> 

Well. This patch reverts bascially all changes I did to the fnic driver
in converting it to use tagset iterators.

Please update it to stay with tagset iterators.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

