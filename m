Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795124206;
	b=nar7m78OyeEY8hEC/yr3G+YGVyD0Dtv/HY8TK/SlBnWULOZegRsSIrRBB5pqO8p0nXpW
	 hZJN919gRIy2OJAZyIyqI20j/kDiCqOKa+DHyNDugoIdnE3fLe0RyLWZEow6vVJCcrA6Z
	 qPvUJW9em1kh/i8Auf0pt9saKOEOIBp1eWaEVowuzYDo8ODJez68PdiTx1iGWpGV9PInW
	 FxaFMvXJXqhL/VYNSROMk0ZIP/PfeNWo8Wu3+p8/2jnWwqlGgDXW1b8JiCt8lbOvDLzpj
	 NRX1g5VbGoYelETb3tO6iAUr0jNif4PhT/2IWz5tdrJzRo2hH/7HxT0i5BTmCCbLOPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795124206;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=/Nnjeweui3avycZQATZWVLsZTORv/zwe44xpEAn0znc=;
	b=b+wYchUVyHbd5S4FYSJ2H/pHhofGErAURETNeNYe8OE24WYqHvFU0UuqA5catRtpKXVh
	 s9NPNZS8pBK8DwBMo5x1P9OiYNWlmFpLHBUWuzt38JTc8n3EvGO/x71Aw/lAoIsjNxZPo
	 hwdjdGMSkZJTntwPspO9BdP+o7u/aXlFrkWIlg/p5R4BYAcjb9n8nEGkm8lrsGu9ha1f6
	 ulCYOaEn4O5eiDnmn/jXXn7mMH2L2hxT/mbIlvkUH/B4vIgcvfax7WT9CFRIMuChCO1v8
	 0qk/dij2NSmcHAda8dt/iXQ6gDenixWsFHtILX3ixVm+ZSMKSoYzblrg4D6PP7tYqqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=rNdFJ6Av;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1AD606A320;
	Thu, 19 Nov 2026 21:36:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F1AD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=rNdFJ6Av
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jVsHK64z0z1XLwXN;
	Thu, 19 Nov 2026 21:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1795124203; x=1797716204; bh=/Nnjeweui3avycZQATZWVLsZ
	TORv/zwe44xpEAn0znc=; b=rNdFJ6Av0UYbHfMOpTLM2vWe/2mKEdDbr/YqbYj/
	ys++HzPFEBFY1PzInAe4gbHeErPe7sAo/Ic/GNfyJwjdAcKJ8UekjeQngFWtHwWy
	IXlA4zfm5761nMhXR10YutLpeJlQqMCptuSLmoGzVvVlK2th8exH/7L1A+INJ9Ob
	YVz7hlSSs6oolUd4J7voH2M2HYY7mZH4MrT8mjsfsfrzip9121KekfLCH+2QOo3l
	X2Ldp61kQuuA6k11TYJTfGI2oRx2pL5BaAeFSjMwHMbPOkoU20zFy+o8TN0qfkHm
	dYubb+HP14KieCRGcB5SPHELudjjodRbGVRDdB91ISgRgg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZUPXLgBYtz6e; Thu, 19 Nov 2026 21:36:43 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:3bd4:4c06:4b28:5d89] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jVsHH2y95z1XM6J6;
	Thu, 19 Nov 2026 21:36:43 +0000 (UTC)
Message-ID: <68585ebd-db20-4277-9c45-3ee44ab2302d@acm.org>
Date: Thu, 19 Nov 2026 13:36:42 -0800
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
Subject: Re: [PATCH v4 2/4] scsi: core: release legacy ioctl request before
 user copyback
To: Yingjie Wang <x-professor@outlook.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton <jthoughton@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1794990780.git.x-professor@outlook.com>
 <26e7d8d4f0648e572e6042c0ae14c1c36a83e850.1794990780.git.x-professor@outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <26e7d8d4f0648e572e6042c0ae14c1c36a83e850.1794990780.git.x-professor@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 12:33 AM, Yingjie Wang wrote:
 > +	blk_mq_free_request(rq);
 >
 > -		if (!copy_to_user(hdr->sbp, scmd->sense_buffer, len))
 > -			hdr->sb_len_wr = len;
 > +	if (sense_len) {
 > +		if (!copy_to_user(hdr->sbp, sense_buffer, sense_len))
 > +			hdr->sb_len_wr = sense_len;
 >   		else
 >   			ret = -EFAULT;
 >   	}

[ ... ]

 > -	ret = scsi_complete_sghdr_rq(rq, hdr, bio);
 > +	return scsi_complete_sghdr_rq(rq, hdr, bio);
 >
 >   out_put_request:
 >   	blk_mq_free_request(rq);

With this patch applied scsi_complete_sghdr_rq() frees the request that
has been allocated by its caller. Nothing in the name of that function
nor in the code of sg_io() makes that clear. Please either add a comment
above scsi_complete_sghdr_rq() that explains that it frees @rq or keep
the blk_mq_free_request() call in sg_io(), e.g. by splitting
scsi_complete_sghdr_rq() into a function that saves the request state
and a function that copies that state to user space.

Thanks,

Bart.
