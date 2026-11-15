Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794774463;
	b=EOALlqihS/lnQheIcGIRZufO5RZ52ymvuN2zQVlsjFBXolJOW4/ED098mIX/pQL5lWwW
	 pNecXT6/qjdrUP3SKVk+2jAHOe7h2aZ9SySYPsPUKILRmVb3VgO4TdZyHtA8KgKIeV2UH
	 S0YlsbaSWUIf3N5j/I/WRcLNNLGkD5yCy6f3ff+K5VGs3pyCvfASXl+4TtdvhUk49ZMyb
	 5Kty+d9/d0gfB19OZOqUcfNNMBinSRENYg+4d9kRAsQElykGk0awVoAQiMw4MRFAOPCKp
	 bsbrsrTqSv3ohnviCgfK7HskdMO9r8czO/2gzmdVvRcfW7VwvCDbghO+J0ef/MQmfHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794774463;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=22XwY66KnSOtO1/d/kMDoLBAuqZ542YRW7O2pDyTx1w=;
	b=IjMHqd2xQ7D1P6DKdu2cRJn4gxe77JHfGnD3mmy7v1jR7G3nxG4vL6Iz2+leivckdoie
	 2wqzsZJhiCmnFnFOIsC3aLZPdkhg/1IwbgVhcg4tZKImevaZ6rJ39oeQeK2Y9QVYJKzvk
	 /SwS/FDri3v70FlgsTl8s8DmhOgsqrE6HxuW7CrJBCxsz1Wui/fdRHOyo4xz95rQ1xzlF
	 rWRtTd2wRYMKUkyAJ52RmqtE99GZ9NULsxIM420toY0Nwcb16WqRN6cmPOd8/DXroI/4B
	 fFQWWDdqUArqtyFi7JU4u9Yr2TemdTxMq5JWhE3TmOhFgNkMjntEufZAlVsolm49x+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9K+GxFc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE05606A8B0;
	Sun, 15 Nov 2026 20:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9K+GxFc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A52E1F000C4;
	Sun, 15 Nov 2026 20:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774462;
	bh=22XwY66KnSOtO1/d/kMDoLBAuqZ542YRW7O2pDyTx1w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R9K+GxFcxklLWxKNOJ5lRWC5zIQSWncnMMkh8TmdSlBzjVeCIYok3BI+LiZIT9Js/
	 wuRlKxXZ9tfeGHjVjLVPj4KVIC2OmTkytp5uIluoKYZYWdSYEniQPIj5QQyxgVWJ8a
	 /bOuIKw1JSpNOZ6GUsOkWzb/fPu5wkio1MAqhuM/AxZd79rmeJLPB6eZ+PNX5oxePa
	 I4OAq3pr+5s5YjD2xmNd79jVJ5yHrBZtLZEQ00vdL+E1kl4UHJOq+coEs+/Uz0nYt6
	 lORfbphZZ9QOpkOn8tneNfDGO1qbDVyF4Aocafhn88MzuNMXyI5Q4SQtGN+PraJ4cu
	 KIB9IJPamEnFA==
Message-ID: <sashiko-outbox-215802@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/12] docs: ioctl-number: update sound entries
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
In-Reply-To: <20261114202653.3113381-3-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-3-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:27:39 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [Low] docs: ioctl-number: wrong code, range, and conflict marker for
  scarlett2.h
- [Low] docs: ioctl-number: incomplete sequence range for sound/pcm.h
- [Low] docs: ioctl-number: incomplete range and tab char for
  sound/core/pcm_compat.c
- [Low] docs: ioctl-number: incomplete sequence range for
  sound/core/seq/seq_compat.c
- [Low] docs: ioctl-number: missing conflict! marker on switchtec.c
  under code 'W'
--

commit 0316dc2cd0f479a35471758d208f4335b8fbc617
Author: Randy Dunlap <rdunlap@infradead.org>

docs: ioctl-number: update sound entries

This commit updates the ioctl-number documentation table with additional
sound header and compat files and adjusts sequence number ranges for sound
ioctls.

> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documen=
tation/userspace-api/ioctl/ioctl-number.rst
> index e1d56d5cccd14..dac65f59d05e2 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -122,11 +122,14 @@ Code  Seq#    Include File                         =
                    Comments
>  'A'   00-0F  linux/agpgart.h,                                          c=
onflict!
>               drivers/char/agp/compat_ioctl.h
>  'A'   00-7F  sound/asound.h                                            c=
onflict!
> +'A'   20     sound/pcm.h                                               c=
onflict!

[Severity: Low]
Should the sequence range for sound/pcm.h be 20-24 instead of 20?  In
include/sound/pcm.h, SNDRV_PCM_IOCTL_STATUS_EXT64 and
SNDRV_PCM_IOCTL_STATUS_EXT32 also define ioctls using _IOWR('A', 0x24, ...).

> +'A'   20-53  sound/core/pcm_compat.c	                               conf=
lict!

[Severity: Low]
Should the sequence range for sound/core/pcm_compat.c start at 10 rather
than 20?  The compat ioctl enum in sound/core/pcm_compat.c starts with
SNDRV_PCM_IOCTL_HW_REFINE32 (_IOWR('A', 0x10, ...)),
SNDRV_PCM_IOCTL_HW_PARAMS32 (0x11), and SNDRV_PCM_IOCTL_SW_PARAMS32 (0x13).
Also, there is a literal tab character right after sound/core/pcm_compat.c
instead of spaces.

[ ... ]

> @@ -160,7 +164,9 @@ Code  Seq#    Include File                           =
                  Comments
>  'H'   10-1F  sound/hda_hwdep.h                                         c=
onflict!
>  'H'   40-4F  sound/hdspm.h                                             c=
onflict!
>  'H'   40-4F  sound/hdsp.h                                              c=
onflict!
> +'H'   60-63  sound/scarlett2.h

[Severity: Low]
Should sound/scarlett2.h be listed under code 'S' with range 60-64 and a
conflict! marker instead of 'H' 60-63?  In include/uapi/sound/scarlett2.h,
all ioctls use code 'S' from SCARLETT2_IOCTL_PVERSION (_IOR('S', 0x60, int))
through SCARLETT2_IOCTL_GET_ERASE_PROGRESS (_IOR('S', 0x64, ...)), which
overlaps with linux/cdrom.h, sound/asequencer.h, and sound/fcp.h.

[ ... ]

> @@ -204,6 +210,8 @@ Code  Seq#    Include File                           =
                  Comments
>  'S'   80-81  scsi/scsi_ioctl.h                                         c=
onflict!
>  'S'   82-FF  scsi/scsi.h                                               c=
onflict!
>  'S'   00-7F  sound/asequencer.h                                        c=
onflict!
> +'S'   21-23  sound/core/seq/seq_compat.c                               c=
onflict!

[Severity: Low]
Should the sequence range for sound/core/seq/seq_compat.c be 20-52 instead
of 21-23?  That file also defines SNDRV_SEQ_IOCTL_CREATE_PORT32
(_IOWR('S', 0x20, ...)) and SNDRV_SEQ_IOCTL_QUERY_NEXT_PORT32
(_IOWR('S', 0x52, ...)).

[ ... ]

> @@ -219,7 +227,7 @@ Code  Seq#    Include File                           =
                  Comments
>  'V'   C0     media/si4713.h                                            c=
onflict!
>  'W'   00-1F  linux/watchdog.h                                          c=
onflict!
>  'W'   00-1F  linux/wanrouter.h                                         c=
onflict! (pre 3.9)
> -'W'   00-3F  sound/asound.h                                            c=
onflict!
> +'W'   00-41  sound/asound.h                                            c=
onflict!
>  'W'   40-5F  drivers/pci/switch/switchtec.c

[Severity: Low]
Does the drivers/pci/switch/switchtec.c entry now need a conflict! marker
as well, since extending sound/asound.h to 00-41 causes the two ranges to
overlap on 40-41?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114202653.3113=
381-1-rdunlap@infradead.org?part=3D2
