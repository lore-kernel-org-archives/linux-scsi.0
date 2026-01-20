Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF5542EEBE;
	Tue, 20 Jan 2026 23:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768952586; cv=none; b=Sw6Z8foLofBIIjlRjvngyedcyb1cax0Eibtf1PZJ0CUGO0B4S8IIF4ij33uWclIJ61Ri0T9QApQUq67rAWxEY1G0pgn9u6ewp4grmG1vypx48DLSb8CdCxVVielRp0QYF6/SDPmSUl3KTGlI2RLV9P3NrocTbCIelTZf+RnMzdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768952586; c=relaxed/simple;
	bh=GlmGzcHtSZQcUld1gw1PgJqVjGbhFI8NTtkR2ZBQA+U=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=bujUlK9PT1/lPaI8ht7LXxB3H0lBFkLJMk0LvtGDvKqdQrb2FfCKcvn3pjwfK5p/0NWS1OmSuU6ftfGUnUE4Wl9xEOPOk+yDFuOrjkr5UaMLHapGmZlDnKFjw38cC7A47/hVdt5XD4HwPJ2glPBed8damseCsBkYQleQFxi7yJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Fz+FdU0X; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Fz+FdU0X"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 938141400089;
	Tue, 20 Jan 2026 18:43:01 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 20 Jan 2026 18:43:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1768952581; x=1769038981; bh=tEMTHC1soLZBaO2RIp8cTgHdEtg+JbVI4Go
	yHb0029M=; b=Fz+FdU0XJXGQmeZQZ/rRHLCizG02GM0oElXKzS21JQIpWKGr2De
	h1meO10Jo9aT4Yuyj9BjuXKNKklQ63Sdr7LWdIc/ZwinB98X1ZBS2oxl/puB7gXp
	jODQkXr7CQDNh3nNZkyslMCPjE/mlsCP05dWRzWXCZ4tupyXwrJs+a8Ynx+siqfO
	dcVDd+aRDsQeiUSo87NE5eJh1uQyM0zDps6DAzBpH8HJopETrP/mUmxSKXNnnaxy
	7sF8JOQ+n+tNpOo1GB7O8FmEt6XeNF9dXxXjGl3zBlVfhz9MxXjNWpRHfEC6PBP9
	TzGvBoH1ESPi+p8MpLY77PUjY8ItX47XFuA==
X-ME-Sender: <xms:BRNwaZqOtjtJdRZrdmerm0meIFeoAKD0cgwveJC21Iuc26NyxIqxXw>
    <xme:BRNwaWkyAQKNJ7v33P7bZyN7Bmnd04ki1Mz9t01sSsdJAEku5YZeM2_EpZssrZBNv
    ZKiBKfxqHmq2S5dJLb0IrWEq93zb0biZYMVRzDm2vJRWs-NkpeRwQU>
X-ME-Received: <xmr:BRNwaVNDoYIztTqXEa-Slg4ikBakMRG4CoLgtNH590OdPDbHLag-tErUGagTh3OtgCfObLjp1iL8C_rdaPny31blN3kqbHjqdbI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugedujeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcuvfhh
    rghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtth
    gvrhhnpeelueehleehkefgueevtdevteejkefhffekfeffffdtgfejveekgeefvdeuheeu
    leenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehfth
    hhrghinheslhhinhhugidqmheikehkrdhorhhgpdhnsggprhgtphhtthhopeeipdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopehjrghmvghsrdgsohhtthhomhhlvgihsehhrg
    hnshgvnhhprghrthhnvghrshhhihhprdgtohhmpdhrtghpthhtohepughgheejfeekgeej
    geejgeesghhmrghilhdrtghomhdprhgtphhtthhopehmrghrthhinhdrphgvthgvrhhsvg
    hnsehorhgrtghlvgdrtghomhdprhgtphhtthhopehjihhnphhurdifrghnghestghlohhu
    ugdrihhonhhoshdrtghomhdprhgtphhtthhopehlihhnuhigqdhstghsihesvhhgvghrrd
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghr
    rdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:BRNwaaNAeIql5YYjYU0zWQkPSW98YQGr_ZK1Cc-aigOujyqHg_6AkA>
    <xmx:BRNwaWjTzdr1vsn5sB1R1JoQLDadzsOdNj3bMxMpUaUTPZzflLKI3A>
    <xmx:BRNwaXvhIbg6AHp71nyrOZ4W5tz3kZ0IFXabzi1x7BToIwy4HvGCpQ>
    <xmx:BRNwacRXGqaJ5yV6FI9Cc7HdFZKcAhAT8JU7yIc-8asd9TJz1uVrlg>
    <xmx:BRNwaRnJq7aZWKRqptoMoI2pGZgN0XszsAJ-0GiW56MNiiraJd3XWOdS>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Jan 2026 18:42:58 -0500 (EST)
Date: Wed, 21 Jan 2026 10:43:12 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Chengfeng Ye <dg573847474@gmail.com>, 
    "Martin K . Petersen" <martin.petersen@oracle.com>, 
    Jack Wang <jinpu.wang@cloud.ionos.com>, linux-scsi@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: pm8001: Fix potential TOCTOU race in
 pm8001_find_tag
In-Reply-To: <b03e802fce29c90bbc4342e7254c3adb9f48bbf7.camel@HansenPartnership.com>
Message-ID: <2f7c49e3-302c-30d5-63ac-29412f3c6ed5@linux-m68k.org>
References: <20260117101948.297411-1-dg573847474@gmail.com>  <ae5cae8b3c4e71cf23b6f48453797ac48bea5914.camel@HansenPartnership.com>  <CAAo+4rUkmuOruVVVNYePyfqu5OgxUxWupEBwvJg7Aus3g7WDqA@mail.gmail.com>  <d7040eecadcc3557c04c27f0c74ce40b2885c311.camel@HansenPartnership.com>
  <CAAo+4rX8HT_3zKEQ3vULN-B8StnwsT-7DQPoFCOedZLrMngASQ@mail.gmail.com> <b03e802fce29c90bbc4342e7254c3adb9f48bbf7.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii


On Tue, 20 Jan 2026, James Bottomley wrote:

> 
> But this too is a problem: fixes aren't free.  In fact a portion of the 
> patches sold as a bug fix eventually turn out to introduce a bug ... and 
> that new bug is one we didn't have before. This is just a sad 
> consequence of the fact that all code produced by humans contains bugs.

Yes. And if the shiny new tool has agency inasmuchas it tests patches in 
emulators, then the code produced by the new tool will also contain bugs.

Perhaps there are cycle-accurate, hardware-bug-compatible emulators for a 
few hardware designs. But asserting the correctness (hardware-equivalence) 
of such emulators runs into the very same problem.

So, unless tested on suitable hardware, one might expect driver patch 
submissions to be rejected with little or no review.
