Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795677827;
	b=jnlCUCTacoBw1PtSTBPYFR+hGrMKdj7FyrGqTdc87VQL+Qqj3891RcUy8RACtwp3/3N4
	 uSSR65rx6T765e20xDEu2H+UzrCCEqM89JYYiE+qdrJlQ+FGkQnyaDyjfq4NSq+iek5MN
	 VIxQrdtQAsGwGsBClLhtOxBaTuIN/mGbQCYGnBLzntDfngLVuH00ZuXIo7pmzk+hOtewd
	 ukrYGq0Nzbgx0os8ITKAeiEbKIueT7H39d1fXQs3QysdSjrPgWOYMikFLYX0r7PG3dNY6
	 qHq5hSgoQum2SPhjMpEn11z4uAGeeDDykTnfVMfQhUdfz7HooDBRvhWQSvmSzPHq2kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795677827;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=FnIv6zO8AKSebatR7MIAQFTrAPkbi7dRfDEicXhzfg8=;
	b=iT6I3F024LsmMt2Z4LX1ZhSLSY8EpIUHjRMRQhwzmoJgf12iT4eEhB8e33THGvglF97i
	 LZC2fLtlAEbpiMhJv1EfC2Op1ywn3Rkkm5DQH/j/CsZaAmKhQ+VhXnxRfvfq8A0aGO1gd
	 u4aEdcw+a6TDEP75ICt0nQfeeCuEATqREzLpFJV9ft05OyCDz0WDulOda0pL0GUxMKZKW
	 5mcrFqmIZJwp6+vHeOelUNbumsK2NucADQPrVUnfX7hAjrJDHHJPa00/lK8XRBA11il+D
	 /vsDUOC3PPLM1SJIJjEUEgXQoAeZo7/ymLngaAFAsd71/oa5q2GTyOhikh3X5NhsVDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=XPNuPDQA;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AnxRiOSn;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=XPNuPDQA;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AnxRiOSn;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABBE606A31C;
	Thu, 26 Nov 2026 07:23:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2ABBE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=XPNuPDQA;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AnxRiOSn;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=XPNuPDQA;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AnxRiOSn
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 548782261C;
	Thu, 26 Nov 2026 07:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795677825; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FnIv6zO8AKSebatR7MIAQFTrAPkbi7dRfDEicXhzfg8=;
	b=XPNuPDQAw37v0M9hCgTlyx8/MCCnoEDV9aZ9/AlZYh61JLrkhtx0LI4AwPsznUvNXkMIDC
	7a+rJJ9l2Oxlu3L9yOFM7Va57xABu5/5RFE+MR8dRL5fTDl0P2WYs+IWgZfSvUUdfX1c/i
	JlFV1PD6fyiQ6xvOfuglYtEkpBFsjJc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795677825;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FnIv6zO8AKSebatR7MIAQFTrAPkbi7dRfDEicXhzfg8=;
	b=AnxRiOSnvnRfk+vSbW8S8kzEDj51+b7Nfrh2Xxm1jq8xorV7xC3hb2aWldRqOnY7K9o3SS
	jJjEYH44mcFnpGBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795677825; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FnIv6zO8AKSebatR7MIAQFTrAPkbi7dRfDEicXhzfg8=;
	b=XPNuPDQAw37v0M9hCgTlyx8/MCCnoEDV9aZ9/AlZYh61JLrkhtx0LI4AwPsznUvNXkMIDC
	7a+rJJ9l2Oxlu3L9yOFM7Va57xABu5/5RFE+MR8dRL5fTDl0P2WYs+IWgZfSvUUdfX1c/i
	JlFV1PD6fyiQ6xvOfuglYtEkpBFsjJc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795677825;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FnIv6zO8AKSebatR7MIAQFTrAPkbi7dRfDEicXhzfg8=;
	b=AnxRiOSnvnRfk+vSbW8S8kzEDj51+b7Nfrh2Xxm1jq8xorV7xC3hb2aWldRqOnY7K9o3SS
	jJjEYH44mcFnpGBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D85D6134C3;
	Thu, 26 Nov 2026 07:23:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sSpCJ4DeB2uaZAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 26 Nov 2026 07:23:44 +0000
Message-ID: <9544b932-3154-4185-98b5-4aa7004c2ca2@suse.de>
Date: Thu, 26 Nov 2026 08:23:44 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: fcoe: Fix use-after-free after pskb_may_pull() in
 fcoe_rcv()
To: Elkin Cruz <elkin@google.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, irogers@google.com, stable@vger.kernel.org
References: <20261125221921.1425747-1-elkin@google.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261125221921.1425747-1-elkin@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.998];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -13.29
X-Spam-Level: 
X-Spam-Flag: NO

On 11/25/26 11:19 PM, Elkin Cruz wrote:
> In fcoe_rcv(), eh = eth_hdr(skb) is cached before pskb_may_pull(). If
> pskb_may_pull() reallocates skb->head, eh is left pointing to freed
> memory when validating eh->h_dest against the FC frame header.
> 
> Re-evaluate eh = eth_hdr(skb) after pskb_may_pull() succeeds.
> 
> Fixes: 0ee31cb5df4b ("[SCSI] fcoe: Fix broken NPIV with correction to MAC validation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Elkin Cruz <elkin@google.com>
> ---
> 
> I am trying out new Clang static analysis checks for kernel bug
> classes, and they flagged this code as possibly buggy. The findings
> were triaged/fixed and commit descriptions were drafted with help of AI,
> then checked against linux-next (not runtime-tested on hardware).
> 
> Thanks,
> Elkin
> 
>   drivers/scsi/fcoe/fcoe.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index a2cf65fac297..23d6b9893793 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -1365,6 +1365,8 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
>   		     !pskb_may_pull(skb, FCOE_HEADER_LEN)))
>   		goto err;
>   
> +	eh = eth_hdr(skb);
> +
>   	skb_set_transport_header(skb, sizeof(struct fcoe_hdr));
>   	fh = (struct fc_frame_header *) skb_transport_header(skb);
>   

Please move that two lines down, just before
	if (ntoh24(&eh->h_dest[3]) != ntoh24(fh->fh_d_id))

that'll make the patch easier to read. And please add a comment
that the skb->head might have been reallocated.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
