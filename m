Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDF6290DBB;
	Thu,  4 Jun 2026 21:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780607855; cv=none; b=MoPZzR6PrJeop6iGULlokpRZ5EjwiSaXZTtiK1q5a8XO2SkeuOi3MrDN2onPgEARv9yk/s/q2HtbCXfnWzsVi5gO8SsW354KY2tLSJflWQJOUIEt64YxMpd75cBd63ksPjxrQ0qAPOweFwsFBJmcgUpuCClHgopOqWTwhuJR3g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780607855; c=relaxed/simple;
	bh=KAfQ7xAXqal0HebQHX2AJv1NTkbivpLwUQtmbGAY2mM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y4zQyOoIhCzzfKhO9So/sjTojzJRwA9DpyknQKuB+K0mPq7Bhj66yLWjqC0tf+U8flcNdCuUiebOsOc+UrnxLFjWbIn11+fP05l6vao9FJjh+5dFJcarLrEIOqMI0yOIkaDrHLN/JjtMJgzHpYw3VucVKviAouD2DAWKoomIvCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CptyadUw; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CptyadUw"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gWcpj1s8Rzlgtd3;
	Thu,  4 Jun 2026 21:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1780607843; x=1783199844; bh=xb19kbWiqrpSFbyUlwb6WaMy
	4XfoRK0lb/vr/qLyz9c=; b=CptyadUwIPy8kaG7jLQ+DM8ZF1tvdDQR49aNulrh
	biH5o5y8+awSGeH7xaIZj701xjLsC1bHmc42FVzVlpTIh2OS3Peu/J3qE2vTgqUj
	WJfPQ8IiwOfAoJTyGBKQby/pVQ+vc0RAWGKj17HfYY0rgOM0PJ1HGGwVZsdk0pKH
	meGPJvZL7KzYbTsEN/KB/WvbFufh6zwd9oG3uVsF4x7VmHPXxVgH//3XfzkGvOKc
	2Sr4BitSc4ofZicGR45Q6f13yrmVZ9DqpsIJg7pLZzntbpDTtkAf5IZYA/2iU6Qa
	JRodaXwS6v4/BTVYf2M7DcaY3SHOb9/dTVQCz5Rq0puSqg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2cgALRHoL-Mr; Thu,  4 Jun 2026 21:17:23 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gWcpQ0CxzzlgtdF;
	Thu,  4 Jun 2026 21:17:17 +0000 (UTC)
Message-ID: <99f038f8-04a9-40a0-9520-8df3dd1e609b@acm.org>
Date: Thu, 4 Jun 2026 14:17:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] Remove remaining references to the pktcdvd driver
To: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Rich Felker <dalias@libc.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, Yoshinori Sato <ysato@users.sourceforge.jp>,
 linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260530-remove-pktcdvd-references-v1-1-aa56941d4315@gmail.com>
 <20260604-remove-pktcdvd-references-v3-0-e2f06fb4eef4@gmail.com>
 <96a48e65-6ee2-4b81-91f8-821a2de707db@acm.org> <aiHbj0zn4y9X6qV2@toolbx>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aiHbj0zn4y9X6qV2@toolbx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 6/4/26 1:59 PM, Catalin Iacob wrote:
> For learning purposes, do you mind quickly sharing your rationale for
> combining 1 and 2? To me they are in the same area but still separate
> things: one removes dead code, the other increases encapsulation. Each
> is a small but worthwhile cleanup, they can be applied in any order and
> each can be applied without the other. It's true that, while patch 2
> without patch 1 works, it would increase confusion but I find that an
> argument to order 2 after 1, not to say they are one thing.
> 
> I'd also find it hard to describe what that combined patch does except
> by calling out two things: "remove dead code and move the declaration".
> Your suggested "unexport" seems more confusing than clarifying, I'd
> argue that today the symbol is not exported since that ifdef always
> compiles the export out.

"Unexport" is commonly used terminology in the Linux kernel for removing
EXPORT_SYMBOL*().

I proposed to combine patches 1 and 2 because it is normal that the
declaration of a function is moved from a public to a private header
file if it is unexported.

If patches 1 and 2 are combined, the most important change is removal
of EXPORT_SYMBOL_GPL(). So I think that "Unexport
scsi_device_from_queue()" would still be an appropriate description for
such a patch.

Thanks,

Bart.
