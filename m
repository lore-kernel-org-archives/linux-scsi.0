Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA87F2F361F;
	Fri,  6 Mar 2026 22:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837540; cv=none; b=HUodMXuYswUbRbhb2Qtvhb4nPbcZB023fQVOOQB8hJD3qzP+Vum/JawKbc8x2Utz8nJQK5A+/ix9FgEwjSxAru2ZsQAN7ceaQ1z4nRoa4/TDfTiqW1YHFN8wbzocoetnEVz0apKiVHDX3AXXxy6I0l6VBQX16QUTOoABBQsHMIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837540; c=relaxed/simple;
	bh=ueSxhuFfXVTZmPnCypuDKPfsx1ObPB34vjdrZQoDXxk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=EXPIbhy5WMdPJDUx7cuy5V1H7HJcN9SV8o1LTlqIZOxzAEIPh+6F6UoT0jgVvWXb+XmIsRfnTsH+tlcXGGKDzl0KGcx7qEfLkRMW0uvdS/6qDTfq8/qt+m/sS/sYxcxUz/89zujegEBGqB4s5kvM+NqfpnEiOQnGG/CrqoWy65s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=s3iJX0ga; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="s3iJX0ga"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id DC1141400224;
	Fri,  6 Mar 2026 17:52:17 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 06 Mar 2026 17:52:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1772837537; x=1772923937; bh=J4ttQBQyxcdE0l/xLJs1ENyVImrG4/R+VQV
	++FoX8vo=; b=s3iJX0gavR5LVGKHXLmuHj2Se8Saiw/6Yb186QPPeb2Cq1jnkGj
	kyy6q6nNKd1c6kr7oei9AQHRSykN4WDGvoqixauPt3UfcF94c0l9QHD+FaswUS1i
	XBapyiLRHE8hORWz+E8BaN/UWk/6OXQlcbPt3MwrBkzxgTvM0LcVInxfpSmMBYst
	B2Vs7rr1sYzFUeTtBwopnDY6zaBZxn5KDObCXk54zkcONKEB4rzJVp1VBS4Avmcn
	iPeXAW+YZKMQgeuQogbGdX0V3x9FvV/H+n+EE1muQfHcUbfBJ/82ikOQgZr25A6i
	0iZv6A65miGWVTtBCtb0PbG7o8iQdzQI1Ng==
X-ME-Sender: <xms:oVqraSuSlG0YT_bjtA2sNtXWW-R9aWWDOYkM_3F9m5dyhAB1mLzhhA>
    <xme:oVqraTWxHSTp6gz34wYzvpPTWqi-FuzMQbzmdDTUIyBD1ixqDaMrp3lTRH969CVZ0
    VyRRONGkhAMeZohzeu3STnBluuSV5HhGLYghgbhdViNOg6J1gT1J5o>
X-ME-Received: <xmr:oVqraawsgTA_hj93kK50uYkEuDZMCyecHvBO1sXDTnB2r6D7b6IDE0rSeqvM9rJ3ezG07J2L54jecYCOZ6wYUrTSyKmTrbqBTEI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvjedtheehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcuvfhh
    rghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtth
    gvrhhnpeelueehleehkefgueevtdevteejkefhffekfeffffdtgfejveekgeefvdeuheeu
    leenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehfth
    hhrghinheslhhinhhugidqmheikehkrdhorhhgpdhnsggprhgtphhtthhopeduuddpmhho
    uggvpehsmhhtphhouhhtpdhrtghpthhtohepghgvvghrtheslhhinhhugidqmheikehkrd
    horhhgpdhrtghpthhtohepnhhjrghvrghlihesmhgrrhhvvghllhdrtghomhdprhgtphht
    thhopehgrhdqqhhlohhgihgtqdhsthhorhgrghgvqdhuphhsthhrvggrmhesmhgrrhhvvg
    hllhdrtghomhdprhgtphhtthhopehjrghmvghsrdgsohhtthhomhhlvgihsehhrghnshgv
    nhhprghrthhnvghrshhhihhprdgtohhmpdhrtghpthhtohepmhgrrhhtihhnrdhpvghtvg
    hrshgvnhesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepthhonhihsgestgihsggvrhhn
    vghtihgtshdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrth
    hiohhnrdhorhhgpdhrtghpthhtoheprghrnhgusegrrhhnuggsrdguvgdprhgtphhtthho
    pehlihhnuhigqdhmieekkheslhhishhtshdrlhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:oVqraSH448iEHqSLMaQUvp_F9TnYyp7UnYKbBnrHNnv-X-hMum5dJA>
    <xmx:oVqraXuFu34XmM7oS1cQ77GWRF83E-_mWhM2Ry5d6abYOtqFfoJoWg>
    <xmx:oVqraaCU1ln99CPhpFMNNvgD9-YxYIn9tQA0deLwpk6Syqb9h_g53Q>
    <xmx:oVqraaCe7xOb4oOWAuDw0XD4r5RBpmhRIg5PG3w9l3OOm-CXrFQElw>
    <xmx:oVqraR07JqqvTYolFQX84YEWz3EiwFdGoGNRQpQyI5ZnZ5G1sHM1Fg-J>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Mar 2026 17:52:14 -0500 (EST)
Date: Sat, 7 Mar 2026 09:53:16 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Nilesh Javali <njavali@marvell.com>, 
    GR-QLogic-Storage-Upstream@marvell.com, 
    "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    Tony Battersby <tonyb@cybernetics.com>, 
    Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, 
    linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Remove problematic BUILD_BUG_ON()
 assertion
In-Reply-To: <CAMuHMdV4=t5G8fz1ARO7oKA86RwZP6T6yNXm5D7JgVtdaq5Rqg@mail.gmail.com>
Message-ID: <90212eb8-434a-1b04-02c1-03410b483e1c@linux-m68k.org>
References: <550e7d7bb8c2620ca4f6c9e809a4f853bdfa4c67.1772751689.git.fthain@linux-m68k.org> <CAMuHMdV4=t5G8fz1ARO7oKA86RwZP6T6yNXm5D7JgVtdaq5Rqg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii


On Fri, 6 Mar 2026, Geert Uytterhoeven wrote:

> > I don't know of a good way to encode an invariant like "the last 
> > member of struct qla_tgt_sess_op is named atio" such that it might be 
> > statically checked. But perhaps there is a good way to do that (?)
> 
> Keeping the BUILD_BUG_ON(), but adding "__aligned(8);" to the ratio 
> member, as suggested by Arnd, would do that?
> 

No, that would merely limit the possibilities for tail padding in the 
future. Again, the tail padding is harmless. The assertion is bogus, not 
the struct layout.

Like I said to Arnd in that thread, the kind of twisted logic that would 
add an alignment rule here requires a comment to explain it (there is an 
example of this elsewhere in the same driver).

So now we're writing comments to explain code that exists solely to 
support a spurious assertion, which itself exists solely to allow an 
inadequate checker to prevent accidents that were already prevented by the 
warning in the comments. Why? Fear of regression.

It's true what they say -- "fear is the mind killer".

> > There's no Fixes tag here because there's no need to backport.
> > The BUILD_BUG_ON() comes from commit 091719c21d5a ("scsi: qla2xxx: target:
> > Fix invalid memory access with big CDBs") which appeared in v6.19-rc1.
> > The build failure first appeared in v7.0-rc1 with commit e428b013d9df
> > ("atomic: specify alignment for atomic_t and atomic64_t").
> 
> I would add both in Fixes, just in case anyone ever wants to backport
> e428b013d9df (which looks like a valid bugfix to me).
> 

Good point. I will add both.

> > --- a/drivers/scsi/qla2xxx/qla_target.c
> > +++ b/drivers/scsi/qla2xxx/qla_target.c
> > @@ -213,7 +213,6 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
> >         unsigned int add_cdb_len = 0;
> >
> >         /* atio must be the last member of qla_tgt_sess_op for add_cdb_len */
> > -       BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) != sizeof(*u));
> 
> Iff you remove the BUILD_BUG_ON(), you should remove the comment, too.
> 

Again, the comment refers to an assertion about the name of the last 
member. The BUILD_BUG_ON is an assertion about the size of the struct. 
These are not the same thing. If they were, I could agree with you: 
"remove both or neither".

Thanks for your review.
