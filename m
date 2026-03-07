Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C062BD587;
	Sat,  7 Mar 2026 22:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772921902; cv=none; b=oDrXhh2LfscYTzkSZA4vIdd3ovSIt0VK1hUDGWAxLDuN+LzD5LvIko7YAnO8ThtmTcr6psj8gDmtg7XMHWsSGS39nhrBzfur/UAI794aTN2uDlnx5uHrmPUNhu/6JicFgvjNDErU+Ew3F/yo+rwQ1XP0+t5dC6y56ufSgS1bZoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772921902; c=relaxed/simple;
	bh=N1iN1b73eEJmuAAWqOh9rcizcZPEyC7oz4gdD4/uYLc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Z9VJU6Vtu0wBeXawPkpqzdXpzZIq9g5JdUPi96Q0Lzr67+8axfK5Wy05EGfSbKdabD5k/YxYWU6z5a923fEgdROqD6wRbJj72n46zzO2D3fxQnpr3he+uHxc3Sv37uRaZJ7WyiMbwFKSEojepylDA9IErza5c+jaRu6sHKuXqxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=clgVc1oo; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="clgVc1oo"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id D2255EC0309;
	Sat,  7 Mar 2026 17:18:19 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sat, 07 Mar 2026 17:18:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1772921899; x=1773008299; bh=UlgrbKyC1NBDc3meOlQuDQoylX7BYmLPKxP
	VlZmPh2k=; b=clgVc1ooOrFp6Vk7xZ8Irm0vOsiounXC0dE7XmB05AjrOoqGQG0
	WdgDlDl7XjObNEyKV7D+Q+WHduT9QGRzqby7jdFdwrrcFDBsBQoOmte8oc7FaplP
	eU0HFKBhvIZQO/ByNfGVzgNP1n6tuA6OA0guKlT+6agLN3/rT4pJcXDh5gVnP0+7
	jveVHwCvISzyaSfsZqCPYQpfK0OAgxTCgjKUa15xItaAEBJ9987jDh3d7MIeVNFL
	MQb2eAoYvOvC84dVLJX/tU35ENs0zZ9L9brSf6xAMY0yX7nHn3HxykJb90O6YZ7f
	EFf4KVqf2N6yYcnWHVWV9T+8aPClhBwf2Lg==
X-ME-Sender: <xms:KqSsaTyWkjfOGF77loTemq1znrKOc4vThHORBLbZ604P_7lTLEGqdA>
    <xme:KqSsaXKymNo1kd4xS7qT1Ola8URUhAJ4fjRGhvouqLGnt8snxqYPj9YbELQnau-je
    iEu9mY4SY4HVK6HCYeFQVfzQUNDapPjezslMo5UpYxnLDTth5D6OPGh>
X-ME-Received: <xmr:KqSsaaWBOXDZjLSpQDoCRhHuSaBy8kshAaD6lAoo_CpMPaeMimqM9wYETphf>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvjeefgeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcuvfhh
    rghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtth
    gvrhhnpeelueehleehkefgueevtdevteejkefhffekfeffffdtgfejveekgeefvdeuheeu
    leenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehfth
    hhrghinheslhhinhhugidqmheikehkrdhorhhgpdhnsggprhgtphhtthhopeduuddpmhho
    uggvpehsmhhtphhouhhtpdhrtghpthhtohepthhonhihsgestgihsggvrhhnvghtihgtsh
    drtghomhdprhgtphhtthhopehnjhgrvhgrlhhisehmrghrvhgvlhhlrdgtohhmpdhrtghp
    thhtohepghhrqdhqlhhoghhitgdqshhtohhrrghgvgdquhhpshhtrhgvrghmsehmrghrvh
    gvlhhlrdgtohhmpdhrtghpthhtohepjhgrmhgvshdrsghothhtohhmlhgvhieshhgrnhhs
    vghnphgrrhhtnhgvrhhshhhiphdrtghomhdprhgtphhtthhopehmrghrthhinhdrphgvth
    gvrhhsvghnsehorhgrtghlvgdrtghomhdprhgtphhtthhopehgvggvrhhtsehlihhnuhig
    qdhmieekkhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrth
    hiohhnrdhorhhgpdhrtghpthhtoheprghrnhgusegrrhhnuggsrdguvgdprhgtphhtthho
    pehlihhnuhigqdhmieekkheslhhishhtshdrlhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:KqSsaSbcQ8qK6ekuowURYYqGhkWYm5GtkgMp2vcR5Q0diSYdhMuwGg>
    <xmx:KqSsaZwZCMbPOUZImzzBAA9c95abPKl8nfT-gdJZ2ROfHJ2fKPRv0Q>
    <xmx:KqSsaa1M867SiJpZBJ6DIW6pH9ce1Y78cXHRVYBNObY_rj-AjqwiOw>
    <xmx:KqSsaSmqgRBC8HMSIRFAPz9isYjJw9ua-3J4zKdQu-17QQEnPlGn-A>
    <xmx:K6Ssae5TtkLJd3pfQAhl8a2bpstDvwI26HiLs3xXl0WuVCLcNDJWqqs1>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Mar 2026 17:18:16 -0500 (EST)
Date: Sun, 8 Mar 2026 09:19:18 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: Tony Battersby <tonyb@cybernetics.com>
cc: Nilesh Javali <njavali@marvell.com>, 
    GR-QLogic-Storage-Upstream@marvell.com, 
    "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    Geert Uytterhoeven <geert@linux-m68k.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, 
    linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Remove problematic BUILD_BUG_ON()
 assertion
In-Reply-To: <ac99d3b6-0537-49c2-826b-118694056b93@cybernetics.com>
Message-ID: <974841cd-3c50-fc6f-4bd8-b1cb163bc05e@linux-m68k.org>
References: <550e7d7bb8c2620ca4f6c9e809a4f853bdfa4c67.1772751689.git.fthain@linux-m68k.org> <ac99d3b6-0537-49c2-826b-118694056b93@cybernetics.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii


On Fri, 6 Mar 2026, Tony Battersby wrote:

> On 3/5/26 18:01, Finn Thain wrote:
> ...
> > I don't know of a good way to encode an invariant like "the last 
> > member of struct qla_tgt_sess_op is named atio" such that it might be 
> > statically checked. But perhaps there is a good way to do that (?)
> 
> It might work better to add a flex array:
> 
> struct qla_tgt_sess_op {
> 	...
> 
> 	struct atio_from_isp atio;
> 	/*
> 	atio.u.isp24.fcp_cmnd.add_cdb may extend past end of atio;
> 	DO NOT DELETE; DO NOT ADD ANYTHING ELSE HERE.
> 	*/
> 	uint8_t atio_isp24_fcp_cmnd_add_cdb[];
> };
> 
> /* atio_isp24_fcp_cmnd_add_cdb must come immediately after atio */
> BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) +
>              sizeof(struct atio_from_isp) !=
>              offsetof(struct qla_tgt_sess_op, atio_isp24_fcp_cmnd_add_cdb));
> 

I think that makes sense because the flex array member reflects what the 
algorithm actually does (whereas artificial struct padding would not).

And it works better than the present code, because the compiler prohibits 
any new member at the end of the struct.

It is more complex than the patch I sent but maintainers may still prefer 
it, so I will put it into a formal patch submission.

BTW, I thought it would make more sense to add a flex array in struct 
isp24 (in struct atio_from_isp) but it doesn't work because the compiler 
doesn't prohibit aggregation:

struct s1 {
        int i;
        int a[];
};

struct s2 {
        struct s1 s;
        int x;        /* this is not prohibited */
};
