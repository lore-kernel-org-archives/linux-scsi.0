Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805CF1E9064
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 17:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728495787; cv=none; b=jH76Uhk1djGN5TvKXBknJCOp+ZwecCHLayHM4h4DI+Bz0on1g3Z7EaGnqHE8A2bTZ41sPdWZhTA7Bp+HW42LtxHdojE5Na5D5hxS9bY+QTpT6aUD2x1cAi707EWP45R3spsm1prkbwUsCInl4PG0/0l7N3uFgDWxSmOgBCy9BdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728495787; c=relaxed/simple;
	bh=U2yyoalUu8rOrtDccrCEkGHvACiRmCf+ujnFW1bLbxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b7IHILE0o7n0aZVutOSJPNQV54NoHeiU25gtENLGdLEDJ0OHX7Ot0GQQInQsbYyAdZ+pdR19y/MTpyOs66iLzzgiimWKYZOMbw2A2+HFschReWXY6HLZaxySSklm2VblQGVk4TlQNmXCHn245PSx6r1VkI90YJCrAecaHq2WBgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jegslMUC; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jegslMUC"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XP0bR0ZwfzlgTWK;
	Wed,  9 Oct 2024 17:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1728495777; x=1731087778; bh=U2yyoalUu8rOrtDccrCEkGHv
	ACiRmCf+ujnFW1bLbxU=; b=jegslMUCW4DMYaLUvXGsoS4oGcCABlu4Q80K9XQK
	Bqpcise29w7QeHf81TsNw0IIvMCE5rOXI7rIoHKsbvdvZFiD9nnBabZIYo33jQ67
	kz+oLU7eT5otpB3jgKJmlp5d7a5pOi4kPqmWphvyhBKqUduPKVBz+HtPdczagsao
	ncCs4QYaNahg0zF3Mqp47gGlIFjUpFZLjtYxqBrYv80u4GW0aFlH4ydiO6/UkvJh
	Pi6a10INVGfdqOlBqRkH2C2h2H2eoqe4HNAyt2gg20TlX0DnvovofsISs7CHRmmW
	qTKbnfHPLBwa4EXiptqmJH8cFBrB7LBewzERhEQr2piE1g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wkJjr9qFhKZY; Wed,  9 Oct 2024 17:42:57 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XP0bN3RpLzlgTWG;
	Wed,  9 Oct 2024 17:42:56 +0000 (UTC)
Message-ID: <167555a7-060b-414c-82f9-d847f7caf1d4@acm.org>
Date: Wed, 9 Oct 2024 10:42:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] scsi: core: Rename .slave_alloc() and
 .slave_destroy() in the documentation
To: Damien Le Moal <dlemoal@kernel.org>, Randy Dunlap
 <rdunlap@infradead.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
References: <20241008205139.3743722-1-bvanassche@acm.org>
 <20241008205139.3743722-3-bvanassche@acm.org>
 <ba58a12b-9745-4fb0-8be0-199bd8827201@infradead.org>
 <a07e83ae-bec7-4738-8c79-328492dbce79@acm.org>
 <ac20fa78-4837-49ed-90c2-49bc3cde9b47@infradead.org>
 <65d71369-aed3-4ffa-837b-b845fcf94e2b@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <65d71369-aed3-4ffa-837b-b845fcf94e2b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/24 4:51 PM, Damien Le Moal wrote:
> Please always send the full series of patches, including the cover letter for
> context.

Hi Damien,

I will try to remember to cc all reviewers on the cover letter for the
future.

Thanks,

Bart.
