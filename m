Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC50433B5;
	Tue,  5 Nov 2024 22:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845790; cv=none; b=qxfkRZZDrjnmjPr+Wl524OWUlOTXf7vm16IJC16rtHNShCvrKskPDARp/5JkE0il7fT6iD/gXu7Vo0u1DSzClKnzhXmfBVotszUvbqFeAUqB5omK4NTeRMbrpD9paeZuYLhyM2NNP9lHy4/0k5jUl9vg6sX58G/AFbHK2zZylgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845790; c=relaxed/simple;
	bh=H96l46GrZfWZS7U2zOinPMjRYU0vgiJDbvfDEUp4lH0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=uo1o2j1UgWzZft+X7hROZqDECRMuXZ/s2u1EamNlD0TdoSGyGjgCkblzmHrQaq/wnK40JzWh6vuAyBROZ6kIRYj+HLmjhMMUsCSApxtplC35O8o+OpUQhrO79lUzzGDnFm99WxHj8Q67aXTqimVmBQwqydXpyx/bq37UC78u3q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CC93+cw3; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CC93+cw3"
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id F15FD13806D1;
	Tue,  5 Nov 2024 17:29:46 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Tue, 05 Nov 2024 17:29:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1730845786; x=1730932186; bh=lOb/8z914WaDgPGjtVDrUXtAmtK0swTt0Cu
	6mmB2M1k=; b=CC93+cw3KOrk4skRjGjQn9ODFw/HhQbJG0a2pyJikhTPZVrVlnI
	mXrVDWbIRy8Ey+ghaJ+4ESEPlIYmBTeECqGP0d1WlJjowPwfvH1MjuQIG9/oULBI
	4IAtCtYuPGDL7PpX3ZDhfex9DRArAeJm4sEX7Xlf/WIUeAHjZKDZSfZHi0GeTDVr
	lJuf4HMs3MwO9H3ZuN6JPWlcatchCP3VMdvcudtGAiZGZcewGw3AxgDKcVz6tekl
	GeHskI2q3xhGjSQ9xiNgXPYPvDKPrRYT1TIUnlAtXXYksr5jdsfsLYrCoIsgoPIS
	ja/MmyDr/xXOBFxcx1f8Oe/AeyI2InroEZw==
X-ME-Sender: <xms:WpwqZ0Xjdeg8BhggMV_NV5knxHgx3N-QMaJGmvs7cnP17hSGrUHO2w>
    <xme:WpwqZ4ne84U2_8eewcySmJXJsVjUQULD-oKT6nHO4oH6FaVwPevp2uSczvX_a7jin
    bcr8iBH9SmWf1-Wl9Q>
X-ME-Received: <xmr:WpwqZ4YucQ5XPfF4ERKTiCPQY13XByVyhU9MNs4-D-FAS8LaUzN2uim-N1_2t8jyMM1Gdma6k1qvie2B45x85fpEjPcWREs584U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrtddtgddufedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevufgjkfhfgggtsehttdertddttddvnecu
    hfhrohhmpefhihhnnhcuvfhhrghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrd
    horhhgqeenucggtffrrghtthgvrhhnpeelueehleehkefgueevtdevteejkefhffekfeff
    ffdtgfejveekgeefvdeuheeuleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgpdhnsggp
    rhgtphhtthhopeekpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehgvggvrhhtse
    hlihhnuhigqdhmieekkhdrohhrghdprhgtphhtthhopehstghhmhhithiimhhitgesghhm
    rghilhdrtghomhdprhgtphhtthhopehjrghmvghsrdgsohhtthhomhhlvgihsehhrghnsh
    gvnhhprghrthhnvghrshhhihhprdgtohhmpdhrtghpthhtohepmhgrrhhtihhnrdhpvght
    vghrshgvnhesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepshgrmhhmhiesshgrmhhmhi
    drnhgvthdprhgtphhtthhopehukhhlvghinhgvkheskhgvrhhnvghlrdhorhhgpdhrtghp
    thhtoheplhhinhhugidqshgtshhisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhinhhugidqmheikehksehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:WpwqZzWfaDL9VDPw3Th91gzmbDkpZ9lJiSl-osOJBQJD3_KueJG52Q>
    <xmx:WpwqZ-krtWw8yC7TEskkq3mf1XweOD-mZJgD8cysDr8g4hAXuhZBEg>
    <xmx:WpwqZ4ekSRisFlibopD1idKIyaQjWh6p-XAeHw4SBV7ikUx2n8tnYA>
    <xmx:WpwqZwHpPbLsEUoZF7ipQ4nj_uKdlf2AkvSaiLNstdylaO1tkbxqww>
    <xmx:WpwqZwUdJhNx7cCb2ba_r4rdXVLylzd9ijsawrCQ8BGoMrQcNCodiCut>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 Nov 2024 17:29:43 -0500 (EST)
Date: Wed, 6 Nov 2024 09:29:55 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Michael Schmitz <schmitzmic@gmail.com>, 
    "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
    "Martin K . Petersen" <martin.petersen@oracle.com>, 
    Sam Creasey <sammy@sammy.net>, 
    =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@kernel.org>, 
    linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] scsi: sun3: Mark driver struct with __refdata to prevent
 section mismatch
In-Reply-To: <b2c56fa3556505befe9b4cb9a830d9e2a962e72c.1730831769.git.geert@linux-m68k.org>
Message-ID: <64864901-771c-8964-64e4-f4665c857bc0@linux-m68k.org>
References: <b2c56fa3556505befe9b4cb9a830d9e2a962e72c.1730831769.git.geert@linux-m68k.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Tue, 5 Nov 2024, Geert Uytterhoeven wrote:

> As described in the added code comment, a reference to .exit.text is ok
> for drivers registered via module_platform_driver_probe().  Make this
> explicit to prevent the following section mismatch warnings
> 
>     WARNING: modpost: drivers/scsi/sun3_scsi: section mismatch in reference: sun3_scsi_driver+0x4 (section: .data) -> sun3_scsi_remove (section: .exit.text)
>     WARNING: modpost: drivers/scsi/sun3_scsi_vme: section mismatch in reference: sun3_scsi_driver+0x4 (section: .data) -> sun3_scsi_remove (section: .exit.text)
> 
> that trigger on a Sun 3 allmodconfig build.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Finn Thain <fthain@linux-m68k.org>

Thanks, Geert.

> ---
>  drivers/scsi/sun3_scsi.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
> index fffc0fa525940cee..1bd1c3f87ff7dd42 100644
> --- a/drivers/scsi/sun3_scsi.c
> +++ b/drivers/scsi/sun3_scsi.c
> @@ -656,7 +656,13 @@ static void __exit sun3_scsi_remove(struct platform_device *pdev)
>  	iounmap(ioaddr);
>  }
>  
> -static struct platform_driver sun3_scsi_driver = {
> +/*
> + * sun3_scsi_remove() lives in .exit.text. For drivers registered via
> + * module_platform_driver_probe() this is ok because they cannot get unbound at
> + * runtime. So mark the driver struct with __refdata to prevent modpost
> + * triggering a section mismatch warning.
> + */
> +static struct platform_driver sun3_scsi_driver __refdata = {
>  	.remove_new = __exit_p(sun3_scsi_remove),
>  	.driver = {
>  		.name	= DRV_MODULE_NAME,
> 
