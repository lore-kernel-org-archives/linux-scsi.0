Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB9632ED54;
	Thu,  5 Feb 2026 22:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770332240; cv=none; b=sqEgUc8u4Naq3FJUNyp09sPpYVnn398Z0YCG1Rc6Y02RuPy2M1686wNUGihbXXRwJXxxAaz19aP6BWJJyozleWePGhGj+FcAoK4k4ytvACaUY2hdtQDqT18mjInwsFHOtHEx+fjd32MIPjZ9zCefxApAcKG5vIaDy/NACKMXrKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770332240; c=relaxed/simple;
	bh=d9bp1ikN52eEN3gqbz0i2yHkpYNz+4/CnYjt7c1XNms=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jOPfqPspJQBoOe2twLaIu1MBO1T1ZgAQrvWZwqh2E2IE9wIcidzdM8xb+jqNRwjQVtL0QUDQ0OcYJo1CCWGt6y8FoPAF7Hu9vTp6v+49KhPkedIylzf9YemtRpzRcKmvvntS95EJ//tGw3O6YfMycSTzYNanbm1PVlK1idnYJ64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RSNTgkp6; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RSNTgkp6"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D666B1400162;
	Thu,  5 Feb 2026 17:57:18 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 05 Feb 2026 17:57:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1770332238; x=1770418638; bh=HTm+GqWsDSfAvIZD/lYU0B4LngQeZOitLql
	Cn5GpbaU=; b=RSNTgkp6eVn/mYMIx4SB64YdyDYeEcMEiSLCT5SHfUhiLwl3ZKR
	yE8Ro5IC71bwfb9Mh2nkTuvmvxKMJdJ1+3yrg9QaA+VcupSxGKU/wpQUqg7dNK7J
	EUYewwXPqPNsbyYDiAuy07FqT24wzxe9L7xzLQcuYD191ccQ5NTgJAk3EezTAxGr
	yqsxinmeKOjxON77PWn1e1gSRXy+ZA3ArB1gX53+IbYYtH+N77y4GXDEhBdScv67
	7D2Du1weJXKOWUhNNfdjefWx2Y6zKQy4RcJpyt0fS6SHiA8WOuAskCXAlmO6jtmA
	q2M8Yml+YFUAkAmLwDVcIQ/NzSLnPrF95RA==
X-ME-Sender: <xms:TiCFaUNwu28XQCTnEwNre1Uh-9NVVW4K6jCPoj4rnFKpBSPTYbQciQ>
    <xme:TiCFaWZMBeB8Guhps0nW3g6wzcj-NrZ0tRgUKUbtsYyPNGIKcslEuiQpG_4lpxDES
    X-FR6XV4tVu92mMOPRkELTF5ERiAXdzRJQfMiMpnJHU0bQHbDFYqQw>
X-ME-Received: <xmr:TiCFaew-2I66vrufLjcOJd7KnCjKCY36S73XpPpg_qOeiIVbj4-grXFqOHMTsKhlkfOLXmwR5Vz0eCSfgBdwcqqil4HvD5TB4-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeeiheehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcuvfhh
    rghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtth
    gvrhhnpeelueehleehkefgueevtdevteejkefhffekfeffffdtgfejveekgeefvdeuheeu
    leenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehfth
    hhrghinheslhhinhhugidqmheikehkrdhorhhgpdhnsggprhgtphhtthhopeegpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopehjrghmvghsrdgsohhtthhomhhlvgihsehhrg
    hnshgvnhhprghrthhnvghrshhhihhprdgtohhmpdhrtghpthhtoheplhhinhhugidqshgt
    shhisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqsghloh
    gtkhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfshgu
    vghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:TiCFaRK5V98SURLQQNIXMEHWywHUomzcYxPivs6SZ5Y2jT8nLiBIBA>
    <xmx:TiCFaYqLSsRvZFnFB0m21g6w5UKindXfyTAtz2W6cE6FP1XXGHmIXQ>
    <xmx:TiCFaQKQ9GFFUVSb93GLQ-W3F4nGRIAGC_mDUg15zf4QLI3geCOiAQ>
    <xmx:TiCFadTZcCH9CYJe21ztBLGTHPaopk3pirlI4-kf-E5i0Lo7jTab8Q>
    <xmx:TiCFaepZGf_VmfMtTCNYGN_iCCh9Odl4cYQaP9xPrdWf5QiWxNTEN9Ur>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Feb 2026 17:57:16 -0500 (EST)
Date: Fri, 6 Feb 2026 09:57:45 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
    "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
    linux-fsdevel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Documenting the correct pushback on AI inspired
 (and other) fixes in older drivers
In-Reply-To: <32e620691c0ecf76f469a21bffaba396f207ccb9.camel@HansenPartnership.com>
Message-ID: <5938441c-aaa9-c405-a78a-a66f387a5370@linux-m68k.org>
References: <32e620691c0ecf76f469a21bffaba396f207ccb9.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii


On Thu, 5 Feb 2026, James Bottomley wrote:

> To set the stage, we in SCSI have seen an uptick in patches to older
> drivers mostly fixing missing free (data leak) and data race problems.
> I'm not even sure they're all AI found, but we don't really need to
> know that. 

If I may predict the next scene, by extrapolating only a little, we are 
approaching the point where it will be feasible to request that an AI 
simply generate a new driver, based on chip datasheets plus all of the 
open source drivers available for training, rather than patch the bugs in 
an existing driver.

At that point, what use is a maintainer? I think we can still add value if 
we are able to leverage our ability and experience in validating such code 
i.e. prove its correctness somehow. If we can do that, then the codebase 
we presently call Linux might continue to grow because it would remain 
superior than some AI-generated alternative codebase.

Documentation that would raise the bar for patch submissions seems like a 
band-aid. The basic complaint seems to be that minor fixes have become 
cheaper and easier to produce, overwhelming reviewers. The solution has to 
be, make code review cheaper and more effective i.e. fight fire with fire.
