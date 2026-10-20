Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792527786;
	b=eBAQCUSCu6SESXXPGz1ApM2P7eJPQnL3bBBMw3CLdL04pbhK0SJTgWe1UUOJrbmw76M2
	 sH+SDJt4X/Bcf5PAUT1phNcWzDpuUKY6d43ufcMCbxxaIdwaTsbWj0CGi051OMMmjNZRk
	 rH8z2ngw+46po3kw1dw18He66CcJaPJtw9an2vjR7RsRvCAekg+4ftuMDdsCUTOKDkk8M
	 YdoZWkAOGEA0jzp+WKJ/qdS5TazVH8HAqUm0UAcSjmzZjFiTEQJ/k9Zw1aQVjNYoCc8I+
	 c3HC8M8mSZo1YkGAuCdGejPLlKlxscsbAGqBUUPjo6AhDel6tG1Aejp702Z3QEKbYkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792527786;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:From:To:Cc:
	 References:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=n5elWTo4Gr/AcWLbIXuiNBGXz1a8BX2Xbm0Ac3PsmY0=;
	b=SfL78w6yJa7oqG88lHNbeNRLYPIwo7k3NzwNoTjft6LwaQbDG5fM6zCPNaPc7DT54CA1
	 UqupQVOJ/cgzG4fH/CdVFDWLerymxldlqSr6npY8jAQctpNxXyYimtdetYg5ut2lTi5qv
	 kKFjzXC5HhbgbaxCQMgwXvaobKqPCVda1K6WoLjLBpFAFyY82iZa9q8KwR42rEF0ImHyN
	 +LKZp+f+fMPqh8T//r+bLWqJZL66KoSUD0HokiBywcky+4dDEX9gLskXErqbsJKsb79rI
	 o2rXZt0ACifWqHSKsWl1fLY680XiI+sIe3BaOv2vLCgYkVRruP/7rFGrx80GP1TKGgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b="Cr2/0DOi";
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF86606A319;
	Tue, 20 Oct 2026 20:23:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFF86606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Cr2/0DOi
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j8P493Hllz1XM4Tn;
	Tue, 20 Oct 2026 20:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:content-language:references:from:from:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792527781; x=1795119782; bh=n5elWTo4Gr/AcWLbIXuiNBGX
	z1a8BX2Xbm0Ac3PsmY0=; b=Cr2/0DOicVJ/BYpViOxIU2LO8ew6AILP2+Evy+71
	+GEYbayeHOBwJJCUdVlQc/X+JHgBlQOXIxmkpJpCnvr8j6MxCBnc3zQCDuOjxfvX
	zwo9PaqYVK694DasVGetBuArMZ8q6LPGMbVQ4wMuthaSO5cifKt1+Rl4CHUsa3eM
	xdzaujo2o1bmiYe4ru04z9WujfjKuJ07ENaPWC3hZdDcnbPUJnv0zeh22IgslFex
	lT4nrPC+1xMQargEymrfd61kefUU4VL9GKvSKGkI3rZv7tHrmjgjye6ZRRldfhwj
	xbsnVcvbwduyMyWW74eSim1dA5KEJJMaLXUmh0l3G3yXMg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1KcBPbR2dg_8; Tue, 20 Oct 2026 20:23:01 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j8P4405Hpz1XM4Tl;
	Tue, 20 Oct 2026 20:22:59 +0000 (UTC)
Message-ID: <12223e71-cf78-41ac-bddd-f7efabc5aed1@acm.org>
Date: Tue, 20 Oct 2026 13:22:59 -0700
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
Subject: Re: [PATCH v2 0/4] scsi: ufs: core: Factor hba->outstanding_reqs
 helper and fix double completion
From: Bart Van Assche <bvanassche@acm.org>
To: Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@iokpp.de>,
 Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen" <mkp@kernel.org>,
 linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261017084403.875420-1-stanleyjhu@google.com>
 <2e042211ca0ebc974ad5ec4c0de9f3f93b3c75c0.camel@iokpp.de>
 <2060a8da-581b-46d1-a510-779f4df716cd@acm.org>
 <78888420b7c60d2d5177cbf76f5efba04fab5d7b.camel@mediatek.com>
 <c2de51a1-cfbd-4f96-ab02-f6d55c563ec7@acm.org>
Content-Language: en-US
In-Reply-To: <c2de51a1-cfbd-4f96-ab02-f6d55c563ec7@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/20/26 9:46 AM, Bart Van Assche wrote:
> On 10/19/26 8:16 PM, Peter Wang wrote:
>> So, should we remove the call to __ufshcd_transfer_req_compl from
>> ufshcd_abort, which was added by commit=E2=80=AF
>> 64180742605f (=E2=80=9Cscsi: ufs: Fix the SCSI abort handler=E2=80=9D)=
?
 >
> Removing the __ufshcd_transfer_req_compl() call from ufshcd_abort()
> sounds good to me.
(replying to my above email)

Please ignore what I wrote - the __ufshcd_transfer_req_compl() call
should be retained in ufshcd_abort().

Bart.
