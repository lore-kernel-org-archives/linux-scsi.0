Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.143
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794705613;
	b=PW29pCeadtXiIWbw+ZB2d+hNshLeYSTVuLpzfpyXZv8WtnTM4k0rEbVGaPIi2/f3FJPs
	 sGqhZRd2ti5w+LeigD3K4hmMxPGoz+XaXfkeOc5+XK5OGnHz4fjcYF2jrJSGzkMoQ5mZ6
	 8XBroXwkDIw9pgDWs5fj/taPnDbNz/O5ZqIYhFXpqmZoH5tuOM98So/Iuz8b4X5wfP22z
	 DmgTAXrNaJCHQN+v67pvzOzrHUe3NI4N/hRM/h7/vGCzkuPmwa2C3bfVY518wTkXgnqsD
	 Kwg6wSoBcipYWN+QguKPakHaLuvdIrBGY0BvuyHV/irZeQZQGD7yaawBIPf6GEgFGBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794705613;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:Mail-Followup-To:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=QIES4zNTDxRjCnYHiHcWq6p6uX7fK/EWYh7I/zXroHQ=;
	b=YC7xtwMqZjS1DOXC0mlhqKHJq9FBXtBiibBFmUpmWMo8JrMuiuJ/l+p8OwkSlIc0ZiVi
	 uDr161DwyboqKe6XAyIwrTvRfD9gxm09TB2F4Dc8aorWaveeXs3Kq1Q3BHDZG0O46sY8x
	 MtK8JgEcE9LBpBGMarZ5KPcsFiu4G89K7zyiODy0dV0X1GtEkAL+hBY66j8DMVCk7jB08
	 tTV81VL7mhyd0gExiY1Jfqsqp3eofiJ48xdTwelQSH402/+8hjm4UEcdrzeyVjpYz+5H3
	 BjQHArNWx/ZZw3UX/TWWqFr+8GgOu21qOFab8kwB2RUm3N+g5n+/atDFK1iHo5YXh4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=sakamocchi.jp;
	spf=pass smtp.mailfrom=sakamocchi.jp;
	dkim=pass header.d=sakamocchi.jp header.i=@sakamocchi.jp header.a=rsa-sha256 header.s=fm3 header.b="pjuVmr/L";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=syy3aDEc;
	arc=none smtp.remote-ip=103.168.172.143
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822BC606A894
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 01:20:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 822BC606A894
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sakamocchi.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sakamocchi.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sakamocchi.jp header.i=@sakamocchi.jp header.a=rsa-sha256 header.s=fm3 header.b=pjuVmr/L;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=syy3aDEc
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id A16EB1381D09
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 20:20:09 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Sat, 14 Nov 2026 20:20:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794705609; x=
	1794712809; bh=QIES4zNTDxRjCnYHiHcWq6p6uX7fK/EWYh7I/zXroHQ=; b=p
	juVmr/LC7nCJ0SQ2rWUhRQGDMnlVGg/71zflyfizaeCefqOj8Wyp1bv5cUdTgRb8
	7XUxKSQFA4h5chwE1lADu0vrwg8OhHP6GoQHRhO7+gqlPzaI30gfxszAJ8iBZnAq
	w6LhtavpJKSJHCgIMJ9jaiAQhtgloSfAXiebl32YH12R4n49k4Dhf+Y8W3pLV4v+
	Lk6DFTk8SpQ9jSXzpScexBSvyhdEJDbrQwMC0927YExgznJjfLZe0flh8fHQL7IO
	vj78LH6slSiU2T+/dLzxP/iDcsVNxx1fb6S0NI/BKneEKfRIjGfp58LmRDVhLSom
	qjpjx4Q11TfgHJQJAHUUA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794705609; x=1794712809; bh=QIES4zNTDxRjCnYHiHcWq6p6uX7fK/EWYh7
	I/zXroHQ=; b=syy3aDEccFqwMWi7OqQgN+5WtM3ZAfMLRFvK6Ty6zA65HPirgvN
	ilcYb0Q1wBWUsxvkCfegkY1pzVtpHUOC6WAP6pTtbZPWcSU2JRmZq5bj3XtaI5mJ
	5KZK4MCZjfikGyCw8udPD79DzKX657SNeo8VKm+NBs1zDN72HR3ZemlLBm38jus1
	WDdVI20E7k3nTziG5v/jPkof/xTKUHTBh7LLvCto0jlE2c4pmQs/fxRRAq0SyBeZ
	lruY2Ddh8f3CbRk7/EsENeVrGkeN2qYTfTHHssLqQwRRARUN/edAoqWV9ygwuEYm
	jIS3U35+DcIoM5H/MAq31DLvDAGEUQlNvVA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=sakamocchi.jp a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794705609; d=sakamocchi.jp;
	mf=PG8tdGFrYXNoaUBzYWthbW9jY2hpLmpwPg==;
	rt=PGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:LZDCDV1PYUdmCEt10FMP427aGbDJA2hjQ9nAYh1cp1ruNR7
	N4I9lK1yAlCyyDVe0v3xwUWpSNvuzjUVU/mN53oLi/bjrgPCXCcYWequftqSlyJc
	gEhQtR04/d99MR5JipNNE2ZeYp4IhU0dvQE9e1CNayOqgV+ekKaD+yKf84hSjPZ/
	PJ3+XopXIyNjlsswRzys6w0urtlIuSi3cqPTEG35uLzdK6NA/r7Exn1FqOoGzo0v
	JJi8Btiy/qkacYxSoO9DJYCS2h086fjQ4TYDaQQ0jZ8or5xs/M5wwbp0pwSBXMYq
	+5nyF7NbVlaTOPI5rWriwm3nIdKzjAjn/ZWbj9A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,mail-followup-to,message-id,mime-version,references,
	subject,to;
Message-Instance: m=1; h=sha256:ntV32t7KOIfGMot6swX3CNi9IkfeqivW9U6qBDwCqc8=:4RP5xhIBVdE4nHZvdVXdOxDGDwEwdGMsIHWUj8/gqfI=;
X-ME-Sender: <xms:xQj5aiop4gg9dsJ6_Vn6u45zXMYueatHm6sTqNkrPjF6p_uliIn0fA>
    <xme:xQj5ao-c0CruU-TGxTE7NFYZSaEuQncLSSmM997vVUnXnDFfvxt3Mt5vMRNmSfmhf
    34fKN--fbmH87piFvayMBFAxnjq6WHAkHe46t3SFxeylFtFg6aPnx9A>
X-ME-Received: <xmr:xQj5atXGMWjP8faJlCtXj9RrVZeBW-gqDucCpC0ZXa191cT5jnWReGYw_Z8rYiOMsAtlcaNqIM8bDcRsKH9aHiPzWCfQ_w>
X-ME-Proxy-Cause: dmFkZTGQstm6GOmXFdPQXDqZqAYG7aQouPeZUHJ4IBXrRYWFH6lFNnMWIuGsSOCFSsBuXW
    LbDJxfVrfV3cl+wc1JM2qA4EvGILGxXqZILW7GfZPYDe6vWDeehuWas6PsFLq2rp3ZCMLK
    vb2ZkQs61G65smsTsr3W8fx/U8N5II0Wva1plTCgHg5UpMnhi5PWu1EQKVr47yDlfh1UvS
    LYKjU/U9x7MTbsMHbdhB5rWUTX8pbvj9eAIRg5DGXYvFzZokg4/nvH5yq0IUoDc8xEYNrb
    hSXdXqov4GW1obuCd3P9CA8Y5vszeSouSKwogVvelkFQGttmZKq/NF5ipA4vDPXyrU1Xrm
    Zrz3WElYlhVCDcPNRnAGrD/gNAj1b7M9bHXUiJrCqgmTebsAx0cfPWnZGZ3/j9Ea2UWcPj
    qqJZ67js4v5NriJFPwSb5fBisbBQrZL2hM4YjWQCJ9uoloExIgLFI0L7sZA853RBWP4ncp
    DBuj0o8Fkgdi7cJEPrTBBMdPRnMErqVngCb+aWeUA0zKt+uaR6UB1bg9ZicNV0ayYa37yt
    I8T18lqRGBzHHbPK9Mrtu/1JSrYmpYKqgKJaY1owBZ4nprZ++3QPl5fwcLNIPsiGvSmzop
    Zbr1xrRPLyP5mMh+v5LgBzIwywaOGj2L4LIDZM+0lWqxfhjtWj2WgxvXglrg
X-ME-Proxy: <xmx:xQj5avAwgflb4ksIG5XRwHT6xxt96MMxRO3omUvuEt-3k_ppqJzgYw>
    <xmx:xQj5aka9rFrx7_oeihBM0qdilVdSsLFNvKaV60FpVwOaq7EoVM3bNQ>
    <xmx:xQj5ak3AzNFqwOx2mTfPhYibu1bQ_UDkW9NgFtUhfBWBcyXvs0uL4A>
    <xmx:xQj5aoGo_8KYcqvEjpNAxM_sotiXZsyQPcuJ_BoRuwGjdfls4pLNfg>
    <xmx:yQj5amBDENmX5NhRabHbZy5mqP0Iv6_jzPBpOZyadDNP-V1uD_qCKZw->
Feedback-ID: ie8e14432:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 14 Nov 2026 20:19:47 -0500 (EST)
Date: Sun, 15 Nov 2026 10:19:45 +0900
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, linux-mm@kvack.org,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	linux-sound@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	linux-bluetooth@vger.kernel.org,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowangio@gmail.com>, David Heidelberg <david@ixit.cz>,
	oe-linux-nfc@lists.linux.dev, Chas Williams <3chas3@gmail.com>,
	linux-atm-general@lists.sourceforge.net,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	MPT-FusionLinux.pdl@broadcom.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	linux-mtd@lists.infradead.org, Neill Kapron <nkapron@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	xen-devel@lists.xenproject.org, Hans de Goede <hansg@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
	devel@lists.orangefs.org, Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	intel-gfx@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	intel-xe@lists.freedesktop.org
Subject: Re: [PATCH 02/12] docs: ioctl-number: update sound entries
Message-ID: <20261115011945.GA238787@sakamocchi.jp>
Mail-Followup-To: Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, linux-mm@kvack.org,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	linux-sound@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	linux-bluetooth@vger.kernel.org,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowangio@gmail.com>, David Heidelberg <david@ixit.cz>,
	oe-linux-nfc@lists.linux.dev, Chas Williams <3chas3@gmail.com>,
	linux-atm-general@lists.sourceforge.net,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	MPT-FusionLinux.pdl@broadcom.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	linux-mtd@lists.infradead.org, Neill Kapron <nkapron@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	xen-devel@lists.xenproject.org, Hans de Goede <hansg@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
	devel@lists.orangefs.org, Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	intel-gfx@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	intel-xe@lists.freedesktop.org
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-3-rdunlap@infradead.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114202653.3113381-3-rdunlap@infradead.org>

Hi,

On Sat, Nov 14, 2026 at 12:26:40PM -0800, Randy Dunlap wrote:
> Update the list of files where sound ioctls are defined and update
> the ranges of function numbers that are used.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> [Since having multiple maintainers trying to merge these would
> cause some conflicts, it would be more manageable for Jon to
> take all of these through the docs-next tree.]
> 
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: linux-doc@vger.kernel.org
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Takashi Iwai <tiwai@suse.com>
> Cc: linux-sound@vger.kernel.org
> 
>  Documentation/userspace-api/ioctl/ioctl-number.rst |   12 +++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> --- linux-next-20261111.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ linux-next-20261111/Documentation/userspace-api/ioctl/ioctl-number.rst
> ...(snip)...
> @@ -168,7 +174,7 @@ Code  Seq#    Include File
>  'H'   C0-DF  net/bluetooth/cmtp/cmtp.h                                 conflict!
>  'H'   C0-DF  net/bluetooth/bnep/bnep.h                                 conflict!
>  'H'   F1     linux/hid-roccat.h                                        <mailto:erazor_de@users.sourceforge.net>
> -'H'   F8-FA  sound/firewire.h
> +'H'   F8-FE  sound/firewire.h                                          conflict!
> ...(snip)...

I overlooked this entry when inserting the additional ioctl commands in
the following commits:

* 90e8ac5c9d446 ("ALSA: firewire-tascam: add new hwdep ioctl command to get state image")
* 58b62ab702591 ("ALSA: firewire-motu: add ioctl command to read cached hardware meter")
* ca15a09ccc5bd ("ALSA: firewire-motu: add ioctl command to read cached parameters in register DSP model")

Thank you for catching and correcting this.

Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>


Thanks

Takashi Sakamoto
