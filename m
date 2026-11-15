Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794774485;
	b=dNbBp/JqjtYTX1X9/rXtLBGrCdREHKsNZvvcjogiJR68jENngjbSaaGnzKoe03qafCdZ
	 efEpn1CUkPCJJS31X4HLZ4qf2zaAVXJo8f4Vg40l8bOHZDmzprXWt7yopr88VCez/hwOd
	 yTQYrkTeJwGLQGyWtNZVRTYO/7f1MnWagnYtTlgUFy7G+BuE/6RkdfiEJTV4gova68pqE
	 +8c5Pq+DQy8nQtLNUx5l3wX+4k5+jgIKZO2WNfKHRBlKt0TKgSodUfyzcdAhIgnGnLSNz
	 ru3Iq/Y/LxgZni8Kw8dJpu935dN35wclVVHXezC/DYcWsOax5NkCjDIBLmS3Qtv8q0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794774485;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iL9gs0hHi938yh2WI7Rig0yplwSjqvzkRGjQ5uPboKU=;
	b=FU216ENVWaqGMGvhcPG1VDyO6SZ4qqwtEprPU/0lQ5S7LG3I8nJQQlFujFvXSaU+sRi5
	 koCbJ5uS1lsi/9k+XC2shyhBvX10DZgHLMDaLIPOwS3clM91jxeTNSzSkn4vD+u9i/fKU
	 LF5Ia9r/bqHWIs3vJnDFh3tqpcfVThjTkC4JFCbDCxRijIv50OlRsoAxYiolstX3opBRI
	 WsFma+tv/VPNpMhI45zNiNJHL38tDnS90KUDitvCbuOWejs+Ye9KRePaSCRNpp54hL+/E
	 NhjIoqRIdxBTnActP194oUOtV82vPg4JRwA6QA8QKgETFw38u534CQJMcpQOQrXq7bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ETF5Z0WA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3818F606A336;
	Sun, 15 Nov 2026 20:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ETF5Z0WA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DCB1F000C4;
	Sun, 15 Nov 2026 20:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774484;
	bh=iL9gs0hHi938yh2WI7Rig0yplwSjqvzkRGjQ5uPboKU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ETF5Z0WAqh95BGpkVJKfpqGcs9JI8RAoRt4nI+73Jvpwec+3LLtpvx5oLIOpOfGsT
	 GOEPDW9rPmVNyvWKj75N4qe/uuqYO9Ct+c+rkqTJy8JuSRXz8Cd8ame+5r1JLvG/3A
	 reDElin5T7+X5Y7q3072wbnRv3MkRD1vWKJ66eWwdYKSqePxhpqdkT13QWNUnnpmGY
	 uWWkItczjTLp6aObld3Ovht8ffOQ/ZvRuyPp7S9k0+Fw6T0VXIdNJKdR58ItUCYtae
	 UkRrFmwjS4VMsil7spiRSB/64XxcHyS+/KBT36lH7fuE9R+NdOThy0hIAK8YBBEQQ1
	 KRVyv4dQidmtA==
Message-ID: <sashiko-outbox-215810@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/12] docs: ioctl-number: update FS entries
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
In-Reply-To: <20261114202653.3113381-11-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-11-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:27:54 +0000
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
- [Low] docs: ioctl-number: ext4 00-2F ioctl range points to
  fs/ext4/ext4.h instead of uapi/linux/ext4.h
--

commit 9072a8199d2be085dc5ab2567392180faf810c6d
Author: Randy Dunlap <rdunlap@infradead.org>

docs: ioctl-number: update FS entries

This commit updates the header file paths and sequence number ranges for
filesystem ioctls in Documentation/userspace-api/ioctl/ioctl-number.rst.

> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documen=
tation/userspace-api/ioctl/ioctl-number.rst
> index 87e547be9e2ac..abc89b6288ba3 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst

[ ... ]

> @@ -275,7 +276,7 @@ Code  Seq#    Include File                           =
                  Comments
>  'f'   00-1F  linux/ext2_fs.h                                           c=
onflict!
>  'f'   00-1F  linux/ext3_fs.h                                           c=
onflict!
>  'f'   00-0F  fs/jfs/jfs_dinode.h                                       c=
onflict!
> -'f'   00-0F  fs/ext4/ext4.h                                            c=
onflict!
> +'f'   00-2F  fs/ext4/ext4.h                                            c=
onflict!

[Severity: Low]
Should this entry point to uapi/linux/ext4.h (or both headers) instead of
only fs/ext4/ext4.h?

Commit 519fe1bae7e2 ("ext4: Add a uapi header for ext4 userspace APIs")
moved the EXT4_IOC_* definitions spanning 0x03 through 0x2E into
include/uapi/linux/ext4.h, leaving only the compat EXT4_IOC32_* definitions
(0x03 through 0x08) in fs/ext4/ext4.h.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114202653.3113=
381-1-rdunlap@infradead.org?part=3D10
