Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CB01C07D9;
	Thu,  1 May 2025 03:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746070831; cv=none; b=BM/9L8GJsTI3wBRsVnS84IzjC3tdnNqt+IwAJZNMv+yLrnthW3AwGbYqyKbMms7AuclJl91proKK5dYNpBt0Md3zHWLfP7OnirfzOoQ1VCfF4mVb4YrqdF4a1Q9Fv8CDdih8QlWqkt4VwAIeTPwh0bvUTh75zjYcyXFHLytT7yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746070831; c=relaxed/simple;
	bh=7uFcllgzTUQxor7F83JCzjug30R4Ls2v0BzVIJk1PF8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qd35PEeTIEmVI6B5eMT2YtivRVPX004Th3LpBXH6wZ7lbaN0TVuiLNfTvUd7AvuaJw91WCStemAhtwihTf8Rhb8Yz3yzh99EgNsIlYlPPGb8caWwhHgKX7SvZl0/PYr9R0MPBXpnUVPRixmbay5mN4Er8qtqQWn3d8MjVdnEBr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MkK0KTQu; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MkK0KTQu"
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 7987E2540260;
	Wed, 30 Apr 2025 23:40:26 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 30 Apr 2025 23:40:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1746070826; x=1746157226; bh=EaH0MRsYR+hlKGUDYxoFLcx6CQmQymVF16F
	zYelflkg=; b=MkK0KTQuNs2d91fSGoVR3XBpGhTTItkIUMQ/V1BFuEkv2yv9gdX
	vVHB5d0jO0Y8kqcH0V5qUesaMz1idI+SXCUQA9yFglPoEa63KMQQXyQhVaj4wFG7
	b8fEzhKT11tEsF2ywHfUapZ+Cq7xhDM7J6C2tOv/fpdx64THc5F3fER1Pi+VLry5
	7Li5IeAz2hZSXbY/YYh5R9SBoYcFTBKqn843K9/oNgyvcIqPfdY0ZSOjVN60LLFC
	6o8MxvRDXtRVGvNkkvggWDPG0FJIK94SkgQlxh8ubJcehysjVRh2zXAYwHfhN7Tq
	D7gXpBI9LPhT8/NbhAJN8Zt+Y28wEvlhRjA==
X-ME-Sender: <xms:KO0SaMcOLWQp6xQhQ_xRg8m96wZhZF9a3CgoJxiDAyZ6kkdxRbY1Sw>
    <xme:KO0SaOMw4JuTEmcTGUNDLRZr5EyAPU4NG5WxXwGyXlK346Sv9F68hl3egmNWiXeuK
    wWsN7tgKZbtLDpezTY>
X-ME-Received: <xmr:KO0SaNgaBa1tSR89BymW7TTMNQst5Jeq_eA3OkIo5B6HTvQSZOZAg3-yxxtwoinJK82aSWHjwdHypr7fFdKe4KNYXSmn_6l8STY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvieekhedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepfffhvfevufgjkfhfgggtsehttdertddttddv
    necuhfhrohhmpefhihhnnhcuvfhhrghinhcuoehfthhhrghinheslhhinhhugidqmheike
    hkrdhorhhgqeenucggtffrrghtthgvrhhnpeelueehleehkefgueevtdevteejkefhffek
    feffffdtgfejveekgeefvdeuheeuleenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgpdhn
    sggprhgtphhtthhopeelpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehrrghnug
    drshgvtgelieesghhmrghilhdrtghomhdprhgtphhtthhopehstghhmhhithiimhhitges
    ghhmrghilhdrtghomhdprhgtphhtthhopehjrghmvghsrdgsohhtthhomhhlvgihsehhrg
    hnshgvnhhprghrthhnvghrshhhihhprdgtohhmpdhrtghpthhtohepmhgrrhhtihhnrdhp
    vghtvghrshgvnhesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhinhhugidqshgtsh
    hisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhn
    vghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepuggvvggsrdhrrghnug
    estghonhhfihguvghnthdrrhhupdhrtghpthhtoheplhhvtgdqphhrohhjvggttheslhhi
    nhhugihtvghsthhinhhgrdhorhhgpdhrtghpthhtohepvhhoshhkrhgvshgvnhhskhhird
    hsthgrnhhishhlrghvsegtohhnfhhiuggvnhhtrdhruh
X-ME-Proxy: <xmx:Ke0SaB_qTZUeItuhifIXROseMvMBD3U9TZAhCWGCJNAJ0xTC7Uf9HQ>
    <xmx:Ke0SaItNXIUdPt05DgmWeaoDklV2AzYsHrNhWImMfnFOYaZyJRkSCw>
    <xmx:Ke0SaIGCAj0dJAG_P_2e1Y7iuK8OWuluo8C4TMcxDAG3LuRgk7-dtg>
    <xmx:Ke0SaHMI29qR3iRa6sErTzARmq1a93ocnSJ-XR15wfk3-54b4UsCZQ>
    <xmx:Ku0SaEOziThvWAwW0uosEdxOTNKsdLgeFZSjTfl8U1osSBUA0Pw4ftJA>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Apr 2025 23:40:22 -0400 (EDT)
Date: Thu, 1 May 2025 13:40:34 +1000 (AEST)
From: Finn Thain <fthain@linux-m68k.org>
To: Rand Deeb <rand.sec96@gmail.com>
cc: Michael Schmitz <schmitzmic@gmail.com>, 
    "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    "open list:NCR 5380 SCSI DRIVERS" <linux-scsi@vger.kernel.org>, 
    open list <linux-kernel@vger.kernel.org>, deeb.rand@confident.ru, 
    lvc-project@linuxtesting.org, voskresenski.stanislav@confident.ru
Subject: Re: [PATCH] scsi: NCR5380: Prevent potential out-of-bounds read in
 spi_print_msg()
In-Reply-To: <20250430115926.6335-1-rand.sec96@gmail.com>
Message-ID: <ab7a484c-64b6-9c4a-744e-a8ad181acd2a@linux-m68k.org>
References: <20250430115926.6335-1-rand.sec96@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii


On Wed, 30 Apr 2025, Rand Deeb wrote:

> spi_print_msg() assumes that the input buffer is large enough to
> contain the full SCSI message, including extended messages which may
> access msg[2], msg[3], msg[7], and beyond based on message type.
> 
> NCR5380_reselect() currently allocates a 3-byte buffer for 'msg'
> and reads only a single byte from the SCSI bus before passing it to
> spi_print_msg(), which can result in a potential out-of-bounds read
> if the message is malformed or declares a longer length.
> 
> This patch increases the buffer size to 16 bytes and reads up to
> 16 bytes from the SCSI bus. A length check is also added to ensure
> the message is well-formed before passing it to spi_print_msg().
> 
> This ensures safe handling of all valid SCSI messages and prevents
> undefined behavior due to malformed or malicious input.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 

I happen to agree with James that there is no value in trying to defend 
against hostile SPI controllers, buses and targets. But I see a lot of 
value in static checking so I'm not against removing theoretical issues 
from the code if it makes static checking easier.

AFAIK the error path in question doesn't get executed in practice, like 
James said. So you could drop the spi_print_msg() call in favour of this:

shost_printk(KERN_ERR, instance,
             "expecting IDENTIFY message, got 0x%02x\n", msg[0]);

But it's not clear to me that you can sidestep the API issue that way. Do 
the other callers of spi_print_msg() not have the same issue?
