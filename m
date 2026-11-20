Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795152968;
	b=fQKjE0t7HEmtKVsCDmqEwNgtg0OcwmBPrtRYhbdtV5xplrPxaAN0XecpQMXYcBJl7Cqa
	 mOrU5rn86UPwZvHiwIDaDj+psXYtZdh8/UmNBC22V1DHDKD3vSkFNzQF0f3e4u2pk4+Fi
	 UcbhHDaWmPxOlUV615fNiszqUIFXhq0NzpMORGrvg+OTk9HwPle+j58pe/a8EUSakG7K3
	 bKEeu4SpqDrYh4oFSber5BtZO1HiNcewdPE60IKfCudzsvq7h3EgT2XkWrfLkOLBfMzPn
	 7+egI2VwnukWsvDYExHTT/LQKqJizeohrQj4bjzfvL+p6O1oLjbrZUQYL3gqSwnyXMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795152968;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tqyp9zPjjrIezYjpSAwpdJah8XiLFf3uLh8Q8IRH3Y0=;
	b=AtE907VPzJHE0Sjm518TlplAqm0EFhiUgGhD0D2mAITRQSBtavuqIA7w77f7R6IiS+Y0
	 JK4VyHO4upqSxvhgBWoyq5gCuM1hB5g0ud68HQ7i6rvaGvpuTXxnwu/BFIHt0zhtNOPjl
	 pmPnabq4puz20qCsUxzDUBqRlpOueOQeMpmogODZQRZD7iAR4Ug/71GOnfirrDHscPgul
	 87aC+om0P8Ayv7jmReFkhyytSo5pqHdRrS5rcbGEtPB4A7KoIvwgQKNSmBEit2xplbpfm
	 F0cQygStJ0FkbO5zQ6dlieK20NwsbrRkE/ucFK4Q3dzVtC2V/0fahUuU2lfkS3S5ikw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eze1Mzwt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD58606A320;
	Fri, 20 Nov 2026 05:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eze1Mzwt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EBB1F000CF;
	Fri, 20 Nov 2026 05:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795152967;
	bh=tqyp9zPjjrIezYjpSAwpdJah8XiLFf3uLh8Q8IRH3Y0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eze1Mzwt1W+/jjpdnS4Mc6QQGi7FHo4IRG4Jao3lIte7M/tv9sgiqFgzFJgqdn1Wg
	 CMDoNFUjH0MKHAMwCYD/g6xavaGlisejHwL4hdvtHm5aASz1Z2O5amwKoGDupAO3Pg
	 IdEqIV9EyTe5Ck5P8UoEA4oJnX0znhaLzxBfrxFlP36lsgUFxdOFykApvtM9pKUMjo
	 L3EoiQUfJrOlHG4kOs2MsDsE1XDy8gKBjGRm/AASTcV2+72O/kvXJKm4/bXo2bihfP
	 31CDZ1VR4ONh2hBQe6FEep0/vD70MLSZVOEiI8zDuP09QLwQKmpmLnM8q+MaS+9kRg
	 X1V0IXqJoOkqQ==
Message-ID: <sashiko-outbox-224494@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/12] docs: ioctl-number: update sound entries
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
 Brost" <matthew.brost@intel.com>, =?utf-8?b?VGhvbWFzIEhlbGxzdHLDtm0=?= <thomas.hellstrom@linux.intel.com>, intel-xe@lists.freedesktop.org, "Takashi
 Sakamoto" <o-takashi@sakamocchi.jp>
In-Reply-To: <20261119053514.255348-3-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-3-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 05:36:04 +0000
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
- [Low] docs: ioctl-number: incomplete sequence range for
  sound/scarlett2.h
--

commit 93a4f635ed001735e939a3dc4a2526e8af9e9bd0
Author: Randy Dunlap <rdunlap@infradead.org>

docs: ioctl-number: update sound entries

This commit updates the ioctl-number documentation table with additional
sound subsystem files and sequence number ranges.

> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documen=
tation/userspace-api/ioctl/ioctl-number.rst
> index e1d56d5cccd14..f29d2c17ca7b9 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst

[ ... ]

> @@ -204,6 +209,9 @@ Code  Seq#    Include File                           =
                  Comments
>  'S'   80-81  scsi/scsi_ioctl.h                                         c=
onflict!
>  'S'   82-FF  scsi/scsi.h                                               c=
onflict!
>  'S'   00-7F  sound/asequencer.h                                        c=
onflict!
> +'S'   20-52  sound/core/seq/seq_compat.c                               c=
onflict!
> +'S'   60-63  sound/scarlett2.h                                         c=
onflict!

[Severity: Low]
Should the sequence range for sound/scarlett2.h be 60-64?
include/uapi/sound/scarlett2.h also defines
SCARLETT2_IOCTL_GET_ERASE_PROGRESS with sequence number 0x64:

include/uapi/sound/scarlett2.h:
#define SCARLETT2_IOCTL_GET_ERASE_PROGRESS \
	_IOR('S', 0x64, struct scarlett2_flash_segment_erase_progress)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119053514.2553=
48-1-rdunlap@infradead.org?part=3D2
