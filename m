Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794774473;
	b=jhgX0lwqPEuqXjvbO+66YCjH9ckA49rB9aL6QCQ6TWt7lpM13fRYCrGJs6Lqs0u9lUOD
	 y49uVBzE+3IGDjS7PGYWe0nyM0ASO6FVl7KCoaCPs3/jKZdtBFcgMJcS9YThptyf12PZg
	 QduxQkcnW/5efb7yJRQPtAGyC/ct0cq4Bdy5HzheouA3v1OznZxKNbxwYhvClEiKZtXFM
	 PJ0RWI+LeZkUV8T7VYmgYsVPsiljMVR67kH0PH4XkaGau6fSKfkWqj9F0Pg+rPjlzFgx0
	 ws7foXaN0X98AcqhWEaFFNRYqeGwOqrc3qmHmgPmxEHRh9R98rDubB1+SZdYAChaQGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794774473;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VdczhNN3rVTkdzSKO/1FEF2ObIEkmXp6tYC01E0w0n0=;
	b=sJfmBRxGb3Ey24wcoHLujSZSDpzWhA5DTxtu3TGEWLdtdpTE5Te3AnQGiw7XbnYjIwyW
	 Q9RPz4C3+FI+nFRtQbOiE6CrU5F40B4z4I8NXXgQ1vYXDLm8jHXLkF1VwFSFc7sfDAQeE
	 N+7XGLUKcL8uwPjTB5IvcuXfh6PCe4NBBhMXutBOZrzb8CNjtbMzG0FrnDgTRiZLm1/k2
	 ZL9AIY/QW3FHl8IRGq8xX8oqms5TikMQ/tA7AOtm/jrqFGRJZTSW0R7PqkeLPyL+BO+OJ
	 GiefpwAXXw+NgwQuxi/zR2CfZsVmmNsJMIDB3AfRTkxFn70VdXfi5jmGdIsDIv+U5Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ImwEBJaq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4F0606A32F;
	Sun, 15 Nov 2026 20:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ImwEBJaq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4081F000C6;
	Sun, 15 Nov 2026 20:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774472;
	bh=VdczhNN3rVTkdzSKO/1FEF2ObIEkmXp6tYC01E0w0n0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ImwEBJaq0nehyC/JF9/iqbjz5qT+awTRS1rhu59kzLmGMo98Mvzh4P4MxHjn3QEhd
	 LdruBaWqwycsIv9VzmTkygHkWfaHareFtghbZyuL728hNd+MhXMD1btY8h5c5JgNTA
	 F3f+HW+jOq2DAS+9cBjKYIqx/caWoQhZgT3lwtzPSlDGSljTPoOw4VoK3PwtvM2sy0
	 Jt/bs3s21iolxS8OtIFa1DXW89RWjNpR5VoGh40DxeLKfozQXUEhwhUhLyFiUHn9cQ
	 4Nc4NypjRd3VCQqb43rzmgdLn24tDFN2pZW14vSWhtim/Oa3QBHVPBQA7hCv0vA5Xk
	 RQuCq+oeh2NOw==
Message-ID: <sashiko-outbox-215807@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/12] docs: ioctl-number: update MTD entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Jason
 Gunthorpe" <jgg@nvidia.com>, "Leon Romanovsky" <leonro@nvidia.com>, linux-mm@kvack.org, "Jaroslav
 Kysela" <perex@perex.cz>, "Takashi Iwai" <tiwai@suse.com>, linux-sound@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, "Marcel Holtmann" <marcel@holtmann.org>, "Luiz
 Augusto von Dentz" <luiz.dentz@gmail.com>, "Willem de Bruijn" <willemdebruijn.kernel@gmail.com>, "Jason
 Wang" <jasowangio@gmail.com>, "David Heidelberg" <david@ixit.cz>, "Chas
 Williams" <3chas3@gmail.com>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Helge Deller" <deller@gmx.de>, dri-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, "Miquel Raynal" <miquel.raynal@bootlin.com>, "Richard
 Weinberger" <richard@nod.at>, "Vignesh Raghavendra" <vigneshr@ti.com>, "Zhihao
 Cheng" <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org, "Neill
 Kapron" <nkapron@google.com>, "Andrey Konovalov" <andreyknvl@gmail.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, "Juergen
 Gross" <jgross@suse.com>, "Stefano Stabellini" <sstabellini@kernel.org>, "Hans
 de Goede" <hansg@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>, "Michael S.
 Tsirkin" <mst@redhat.com>, =?utf-8?b?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, "Jan
 Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, linux-ext4@vger.kernel.org, "Mike
 Marshall" <hubcap@omnibond.com>, devel@lists.orangefs.org, "Paulo Alcantara" <pc@manguebit.org>, "Namjae
 Jeon" <linkinjeon@kernel.org>, "Jaegeuk Kim" <jaegeuk@kernel.org>, "Chao Yu" <chao@kernel.org>, "Florian
 Fainelli" <florian.fainelli@broadcom.com>, "Broadcom internal kernel review
 list" <bcm-kernel-feedback-list@broadcom.com>, "Tzung-Bi Shih" <tzungbi@kernel.org>, "Benson
 Leung" <bleung@chromium.org>, "David Airlie" <airlied@gmail.com>, "Simona
 Vetter" <simona@ffwll.ch>, "Alex Deucher" <alexander.deucher@amd.com>,
 =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, amd-gfx@lists.freedesktop.org, "Jani
 Nikula" <jani.nikula@linux.intel.com>, "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>, "Rodrigo
 Vivi" <rodrigo.vivi@intel.com>, "Tvrtko Ursulin" <tursulin@ursulin.net>, intel-gfx@lists.freedesktop.org, "Matthew
 Brost" <matthew.brost@intel.com>, =?utf-8?b?VGhvbWFzIEhlbGxzdHLDtm0=?= <thomas.hellstrom@linux.intel.com>, intel-xe@lists.freedesktop.org
In-Reply-To: <20261114202653.3113381-8-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-8-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:27:49 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] docs: ioctl-number: missing update of 'O' range for
  mtd/ubi-user.h to 00-08
--

commit ccf1b77b46484d55fbc7ee02d93a71ebab16f010
Author: Randy Dunlap <rdunlap@infradead.org>

docs: ioctl-number: update MTD entries

This commit updates the sequence number ranges and file entries for MTD
and UBI ioctls in Documentation/userspace-api/ioctl/ioctl-number.rst.

> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documen=
tation/userspace-api/ioctl/ioctl-number.rst
> index d47f817335666..1ff4fd4bf9b5c 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst

[ ... ]

> @@ -306,7 +306,7 @@ Code  Seq#    Include File                           =
                  Comments
>  'n'   E0-FF  linux/matroxfb.h                                          m=
atroxfb
>  'n'   F8-FA  video/sisfb.h                                             s=
isfb
>  'o'   00-1F  fs/ocfs2/ocfs2_fs.h                                       O=
CFS2
> -'o'   00-03  mtd/ubi-user.h                                            c=
onflict! (OCFS2 and UBI overlaps)
> +'o'   00-06  mtd/ubi-user.h                                            c=
onflict! (OCFS2 and UBI overlap)

[Severity: Low]
Should the 'O' entry for mtd/ubi-user.h also be updated from 00-06 to
00-08?  include/uapi/mtd/ubi-user.h defines UBI_VOL_IOC_MAGIC ('O')
ioctls up to 8 (UBI_IOCVOLCRBLK at 7 and UBI_IOCVOLRMBLK at 8).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114202653.3113=
381-1-rdunlap@infradead.org?part=3D7
