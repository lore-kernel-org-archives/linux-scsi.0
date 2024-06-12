Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16241649A8;
	Wed, 12 Jun 2024 06:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718175453; cv=none; b=IVZ3N+rjP1XIX14upqglymnCGzNhz6xsJz9ciU6Dv7huPH3x4toliGi990DpeO6sOiPSIn7v8er2sQjg3HRHUQMpTcq0t9LfAwJ5f1wyUilxNLXsW1Wflq3nfoX65WgMhzhatMWE97pIFysQja9YBHYm6r/mnXneWA8UHzklJHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718175453; c=relaxed/simple;
	bh=PuRF5uL5gkel7TuOzm4BKjwimavIPSTHOtuBU3/JB1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VMwFgsOgsLWhnFsN31mI9b+JJwTnsDjhSN5IcA8jqP688aacKPtFYgEVs6KUwud02SwY4yoFvWkl7OO4Debr5jkKpEiCDGc9kW61qyK07ZBBcrjmgzee+BPI2/pHRZ7OPYFMA7PliktpMb+9HPb6TlZ3d2ln8S91483UsPd8jJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IbHQKHwZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vW+wRif2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Xc0xvbdW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Gqx4kh3O; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IbHQKHwZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vW+wRif2";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Xc0xvbdW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Gqx4kh3O"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ED2EC33FAD;
	Wed, 12 Jun 2024 06:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718175449; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ys6yrvEFJNjiCngEJoyTvh6mPLPjtXpIrnMnP0tED8=;
	b=IbHQKHwZZNARoZ4mIBZd37JAqx/SG9h+L6uGf8q8jrL4PQNil9kIp0QNEg3WkJbzT8YiTr
	3RbYVPRJJuPL80uT3jV8jDITqzfCSdMMA3IyR1wvwWJAdMFz68gfTGE3gcXBp7/y45Zzug
	fODSGbDN6Ztwc0LNjYZBcDqEkP2BRXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718175449;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ys6yrvEFJNjiCngEJoyTvh6mPLPjtXpIrnMnP0tED8=;
	b=vW+wRif2fwRXFrtNMPJElHiLkiMQPyfgDeewIjTTvLeeOSvhnT6VZo/oWaZ9740sn3vuod
	dkinC6zc256rUuBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718175448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ys6yrvEFJNjiCngEJoyTvh6mPLPjtXpIrnMnP0tED8=;
	b=Xc0xvbdWejA09lEJdutnxliBxPYWFNnRzeyMil2QQqjsNCg97CqK2FhThCu8zEF4eVkUFm
	noHxf7i3fGd1eXBHyn8wulo+lmYF3+ADQ3bqR568zq8wPK0vSHUBgmg43xZDrIlzCkZkTy
	SBn56YU/n/OGPcnStRYUNatXVicdpJo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718175448;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ys6yrvEFJNjiCngEJoyTvh6mPLPjtXpIrnMnP0tED8=;
	b=Gqx4kh3OCq71J8ahfziiEJARHt8oZgkaYWtB2xtRoEiXGZMSajSmibqGrSSSR6CpHXea5o
	4pJ2t2rllFozN5Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90604137DF;
	Wed, 12 Jun 2024 06:57:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id L5OSIdhGaWarQQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 12 Jun 2024 06:57:28 +0000
Message-ID: <f992c0f2-8f70-4dc0-b679-e522e3fd6101@suse.de>
Date: Wed, 12 Jun 2024 08:57:28 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/14] scsi: fnic: Add functionality in fnic to support
 FDLS
Content-Language: en-US
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-9-kartilak@cisco.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240610215100.673158-9-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo,cisco.com:email]
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 

On 6/10/24 23:50, Karan Tilak Kumar wrote:
> Add interfaces in fnic to use FDLS services.
> Modify link up and link down functionality to use FDLS.
> Replace existing interfaces to handle new functionality
> provided by FDLS.
> Modify data types of some data members to handle new
> functionality.
> Add processing of tports and handling of tports.
> 
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
>   drivers/scsi/fnic/fdls_disc.c |  74 +++++
>   drivers/scsi/fnic/fip.c       |  27 +-
>   drivers/scsi/fnic/fnic.h      |  20 +-
>   drivers/scsi/fnic/fnic_fcs.c  | 498 ++++++++++++++++++++++++----------
>   drivers/scsi/fnic/fnic_main.c |  10 +-
>   drivers/scsi/fnic/fnic_scsi.c | 127 +++++++--
>   6 files changed, 587 insertions(+), 169 deletions(-)
> 
This seems to not just _add_ the functionality to use FDLS, but rather 
_replace_ the existing functionality with FDLS.
IE it seems that after this change the driver will always do FDLS, 
causing a possible service interruption with existing setups.
Hmm?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

