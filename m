Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795142080;
	b=PQzLLDlxAhZqV+HhRI1hYRCsc9U/iw+sVrZBZ0k3srL/M4JY7zg7+TMx199ZItz4vSYU
	 HCqFrSFXLfxnX4t7A9dS/UpW5KsLNMJ76JrLqreoCTkwvcegZ4lCwFNcv9YiwbrzfSsyg
	 kwpspLH4gX36hLMyxz2un8/RuCS43WOQI9xCFeUTd53TRYUTRvq5bjoTqu7tWmMXDtBeH
	 bCVvCMTJhfs9XkhpRhe5pknnBJ7tcjwpkHFF529g52+Ubo9091MQ42zfT3fqlczwM0AqL
	 ibGckpfF57AFJE07HN2yHhgICUqQQUov+z4XIn4FdqezGgUv/7M647n1QceMiG/ddVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795142080;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=yLxaIFgMgiNdJ6EvHj90KmNsd7UyUa4rOHQt8MkQ4o8=;
	b=Y2eziJjix+rCJmotITUC1fd/QYZTQ0IPR3HxWU/SkBAx69PjfNqbggHSkujxK75DYJqk
	 XIAeWuf8iFDDejIceS8bsk2lRgP87R0p/VgDA0PbvMoR+tOxUCI2MHJUe7nuSfMcFwXql
	 gp72gmKfdHupZ8Vy9tnigaMrCHreEAfPGLAAocP/jUSpXc77A/FN3gUTwvOKWTgABDGhS
	 c+TQEgsP/AMSI7pX/mquwQ9BC9JuvtkeNzeJpMTVOKAgtEw01lFo6+oY6ZYMtzptKoqUW
	 HlplGEim1q2R29baUQrH4xrDNRYu2sevvJuzPve0aV6uJKntg/UIwuW8IQN6eb/0J9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dq2Owl4T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E23606A320;
	Fri, 20 Nov 2026 02:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dq2Owl4T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6D31F000C6;
	Fri, 20 Nov 2026 02:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795142079;
	bh=yLxaIFgMgiNdJ6EvHj90KmNsd7UyUa4rOHQt8MkQ4o8=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=dq2Owl4TQH5i1O8lPJeqrs/bhVJe74UawaV8WZGOjcpXryG9VX5bBPEuofmjMl6C8
	 KEMZUEWUmofCrIT9kL1mF9sqs29c0Cyil2oxP83BwPsBQxJM3XbOQHwaj2x7OkBm3R
	 Ubt4udGPNHycSNftWKTVPyy9zKiSLnNOhFSlFIOPsiCL9/KFgmw/r+jfOmYYUs/VC/
	 SAI+QguGa/5ffH3iaZeehgrULZs3TCS3y0wcIRBQ7+1cYjuY8NOZbiPkIC9OoceHPS
	 +R5fZniZZazVx2uAAw4qgmr08ft+ySZxWB+NNVSP3BxvosYlgijyZSgy8PCf4WR5j7
	 gqEvBh4+Qs7GQ==
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org,  Jonathan Corbet <corbet@lwn.net>,  Shuah
 Khan <skhan@linuxfoundation.org>,  linux-doc@vger.kernel.org,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Gunthorpe <jgg@nvidia.com>,  Leon
 Romanovsky <leonro@nvidia.com>,  linux-mm@kvack.org,  Jaroslav Kysela
 <perex@perex.cz>,  Takashi Iwai <tiwai@suse.com>,
  linux-sound@vger.kernel.org,  Jens Axboe <axboe@kernel.dk>,
  linux-block@vger.kernel.org,  Marcel Holtmann <marcel@holtmann.org>,
  Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
  linux-bluetooth@vger.kernel.org,  Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>,  Jason Wang <jasowangio@gmail.com>,
  David Heidelberg <david@ixit.cz>,  oe-linux-nfc@lists.linux.dev,  Chas
 Williams <3chas3@gmail.com>,  "David S. Miller" <davem@davemloft.net>,
  Eric Dumazet <edumazet@kernel.org>,  Jakub Kicinski <kuba@kernel.org>,
  Paolo Abeni <pabeni@redhat.com>,  netdev@vger.kernel.org,  Helge Deller
 <deller@gmx.de>,  linux-fbdev@vger.kernel.org,
  dri-devel@lists.freedesktop.org,  MPT-FusionLinux.pdl@broadcom.com,
  "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin
 K. Petersen" <mkp@kernel.org>,  linux-scsi@vger.kernel.org,  Miquel Raynal
 <miquel.raynal@bootlin.com>,  Richard Weinberger <richard@nod.at>,
  Vignesh Raghavendra <vigneshr@ti.com>,  Zhihao Cheng
 <chengzhihao1@huawei.com>,  linux-mtd@lists.infradead.org,  Neill Kapron
 <nkapron@google.com>,  Andrey Konovalov <andreyknvl@gmail.com>,  Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>,  linux-usb@vger.kernel.org,
  Juergen Gross <jgross@suse.com>,  Stefano Stabellini
 <sstabellini@kernel.org>,  xen-devel@lists.xenproject.org,  Hans de Goede
 <hansg@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,  "Michael S. Tsirkin"
 <mst@redhat.com>,  Eugenio =?utf-8?Q?P=C3=A9rez?= <eperezma@redhat.com>,
  Sean
 Christopherson <seanjc@google.com>,  Paolo Bonzini <pbonzini@redhat.com>,
  kvm@vger.kernel.org,  virtualization@lists.linux.dev,  Jan Kara
 <jack@suse.cz>,  linux-fsdevel@vger.kernel.org,  "Theodore Ts'o"
 <tytso@mit.edu>,  linux-ext4@vger.kernel.org,  Mike Marshall
 <hubcap@omnibond.com>,  devel@lists.orangefs.org,  Paulo Alcantara
 <pc@manguebit.org>,  Namjae Jeon <linkinjeon@kernel.org>,
  linux-cifs@vger.kernel.org,  Jaegeuk Kim <jaegeuk@kernel.org>,  Chao Yu
 <chao@kernel.org>,  linux-f2fs-devel@lists.sourceforge.net,  Florian
 Fainelli <florian.fainelli@broadcom.com>,  Broadcom internal kernel review
 list <bcm-kernel-feedback-list@broadcom.com>,  Tzung-Bi Shih
 <tzungbi@kernel.org>,  Benson Leung <bleung@chromium.org>,  David Airlie
 <airlied@gmail.com>,  Simona Vetter <simona@ffwll.ch>,  Alex Deucher
 <alexander.deucher@amd.com>,  Christian =?utf-8?Q?K=C3=B6nig?=
 <christian.koenig@amd.com>,
  amd-gfx@lists.freedesktop.org,  Jani Nikula
 <jani.nikula@linux.intel.com>,  Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>,  Rodrigo Vivi <rodrigo.vivi@intel.com>,
  Tvrtko Ursulin <tursulin@ursulin.net>,  intel-gfx@lists.freedesktop.org,
  Matthew Brost <matthew.brost@intel.com>,  Thomas =?utf-8?Q?Hellstr=C3=B6?=
 =?utf-8?Q?m?=
 <thomas.hellstrom@linux.intel.com>,  intel-xe@lists.freedesktop.org
Subject: Re: [PATCH v2 06/12] docs: ioctl-number: update SCSI entries
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261119053514.255348-7-rdunlap@infradead.org>
Message-ID: <yq1eccgqlhr.fsf@mail.kernel.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
	<20261119053514.255348-7-rdunlap@infradead.org>
Date: Thu, 19 Nov 2026 21:34:38 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Randy,

> Update the list of files where SCSI ioctls are defined and update the
> ranges of function numbers that are used.

Reviewed-by: Martin K. Petersen (Oracle) <mkp@kernel.org>

-- 
Martin K. Petersen
