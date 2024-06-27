Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048CA7484;
	Thu, 27 Jun 2024 06:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719469872; cv=none; b=cxJZ9igqJ33I3BGtA7lZMLu9P/eOkoY2l1OApT9pgNkSlBtKNlrOa10bI5paV36dRjH3lejQ/3C5i1LH6Nxy2lrspgTTgWeL4gdfnOhYfXXdtRCLERq+jMB9HFDUqx2pHTLPBAWu/PKwrIqbGjj8pA59ihYMRfeOmaFfF60Ni7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719469872; c=relaxed/simple;
	bh=LgzR7SpWS0qQBdUANZO6WriR2XPb/hsSt+ywC0DOQjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R+J6xOpZoILNBjBOKKns0/IVBql/0dESQihVwz5nptKOAInvhVJSbqpfNBQdwHnOa1n+UCNxEsoAvklbFTA4mEmxGv5GnMtK/ViI8iKauyIetbyGSnIg71EUNDrILCSD3HGRtKXj8bvpNY2wS6eFmVEsgSTCT/moAW/TYpqAsk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=c/RjQyip; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RQxIg4PE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=S0dAhAFB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NDSXHQUR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="c/RjQyip";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RQxIg4PE";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="S0dAhAFB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NDSXHQUR"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4ABDC1FBA6;
	Thu, 27 Jun 2024 06:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719469869; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iX2rk+5tu0fIP8IxUAkyWBYi+ps3svy4Mq0LANgwRps=;
	b=c/RjQyip34ahkcFzyaaFIHHj7nU8efHEfphC0ZE9Hue0bqXvTZAi5DDfe0wEDhKLLx4jmP
	++Qfc38HTBJIYsjFguBqze/QbUj9n0s6iMfQ5ZCxOHvptDdZXuDcR3j50iXd8BTj35Evr9
	+kilbWCVOaPx+FGYy5sbeD7Q8c4hHcg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719469869;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iX2rk+5tu0fIP8IxUAkyWBYi+ps3svy4Mq0LANgwRps=;
	b=RQxIg4PEiTzQP0DGxoNtQ+WBDdZj8jP/OtKZG2+PIDGzw+g856U/vHabMuTUSzvatLJoDO
	2Rxs7vUSgL9iaLAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719469868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iX2rk+5tu0fIP8IxUAkyWBYi+ps3svy4Mq0LANgwRps=;
	b=S0dAhAFBMaP7CLfwtngxjJPzeX9W/AdCK6+vKkfNKhA4zC35rJ6RD6/brVS+5JkGA4Ok2L
	Lfl0KFxjkfGzfUepfMTxk2OKsc1NnR0cfp+SHGflpm6RSiMNjxx/paRoVHhv2E25eRaWFQ
	fd/6kAGH7YvWN3AbXho72YIp+NR9IoA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719469868;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iX2rk+5tu0fIP8IxUAkyWBYi+ps3svy4Mq0LANgwRps=;
	b=NDSXHQURgx5D0fpLCAYBKMhHaQyeuqUzDqt/U5tTcdkWWqvCnJGh3ycI3QtFyeMdwcF805
	uMPJwUu/fIjrOyBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8BA76137DF;
	Thu, 27 Jun 2024 06:31:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sH+cHysHfWa2aAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Jun 2024 06:31:07 +0000
Message-ID: <b8dc67f2-187d-4c92-99b6-509442b98488@suse.de>
Date: Thu, 27 Jun 2024 08:31:08 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/13] ata: libata: Remove unused function declaration
 for ata_scsi_detect()
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-21-cassel@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240626180031.4050226-21-cassel@kernel.org>
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
	RCPT_COUNT_SEVEN(0.00)[8];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]

On 6/26/24 20:00, Niklas Cassel wrote:
> Remove unsed function declaration for ata_scsi_detect().
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   include/linux/libata.h | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 586f0116d1d7..580971e11804 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1082,7 +1082,6 @@ extern int ata_host_activate(struct ata_host *host, int irq,
>   			     const struct scsi_host_template *sht);
>   extern void ata_host_detach(struct ata_host *host);
>   extern void ata_host_init(struct ata_host *, struct device *, struct ata_port_operations *);
> -extern int ata_scsi_detect(struct scsi_host_template *sht);
>   extern int ata_scsi_ioctl(struct scsi_device *dev, unsigned int cmd,
>   			  void __user *arg);
>   #ifdef CONFIG_COMPAT

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

