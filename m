Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907015;
	b=JHB4XDpmV36DtmrpkoZTJDTsSJo6EDBZOowLuOVSdnIbLY742OFq3disXrSh+QneswYQ
	 TlIumaU4j0JSdTYOdfuHIgzK/6nIoIlw8GUTmeXrQZkW0rOU9pocV7pFEBtzrb4g4qfAU
	 Y3Lsq8TTXwFcGwmZWZkaLErx92s2OLAND/4vTngUGECa3ADj4eI9RlUNUiqQu8lYKDymj
	 z4Izm0pm2vBRaVlhRtf/WptjG83um6/y+OPIRjScnPHD/M8b1AA2zC3ljSB9xc5yAaQKV
	 Z8m0hv+iS4oL0UTov6p1OJx/9kPsECuudbOWY8aTO2uE2caE0KFh1L0O6yJqrPDgT3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907015;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7NQAKY8HY4DbdjDd6x8DZF/XgVJse33xFSaScTuQDsM=;
	b=oUekG3iZ2J1l2N/w23F2c1C7A5Wrmnsatut+HP7JUp5s8oEdxtN4Acn5LPl1dO0j0igz
	 bDPNiu1E609408sns6l3UvrmiC2i/G33D8i84W/X00/UIo5LR5B2AwYUMjbVbJ7ltmSe9
	 loNrsyDjB9P212ZkGrT+PQDvRVmyu0XYr0O97qr8h7ZwlHevVW8WSXQl7drgm9pSXn1kR
	 RYsoP/t1wfcbYPBVlVmWCcYxbHKK+6XdDdymKWRE3unFpp9PXH+VWDvHC8hFtnqRHQKi3
	 GP+CZcxxRmIpUPxSDZ3igUMk98V52NZzs6Gh8KnkjX6mVrDbsXh/ZiaRn7JgilmzCSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ej+uoOdy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D579606A6C8;
	Thu,  5 Nov 2026 19:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ej+uoOdy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F3A1F0093A;
	Thu,  5 Nov 2026 19:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907014;
	bh=7NQAKY8HY4DbdjDd6x8DZF/XgVJse33xFSaScTuQDsM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ej+uoOdyy0zraix1fQ7r25PJRrh/4Y9jENiNfRHcNQYKQbamB19zOZWAIYTZP936k
	 525AiogVEAMXoo8f3U/2wtiLHom345+woamQXZG812Wqw1iTBWxzB4lfrEhY0L2dNa
	 EJvLiN1GfSZ7KXDdLY1rJb97KQOIpQcpSkmrSySn132O264dcPg7eLs6XEwEHRR2Jx
	 kAAmy8CviFoouXet9NS4WJJqFN+2BooXsbNYrMheRfZVdZNv+l80ODw7nu/l90jVkJ
	 HWjhC78V1gjM0l/DaNa2Rbj7gbXnQcngNdr12ijFwDhs3Ny03+eY9pKEJ0LhfAJkZh
	 SgFF9W+xXiDtw==
Message-ID: <sashiko-outbox-199904@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 41/51] scsi: esas2r: bound the lengths of the
 HBA, SMP and firmware ioctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, tytso@mit.edu, dmitry.torokhov@gmail.com, "Petr
 Pavlu" <petr.pavlu@suse.com>, "Anna Schumaker" <anna@kernel.org>, yukuai@fygo.io, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-41-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-41-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:30:12 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: esas2r: double fetch of data_length in handle_hba_ioctl()
--

commit a2397b86d116881b0f288e71fe8885d678578a5f
Author: Christian Brauner <brauner@kernel.org>

scsi: esas2r: bound the lengths of the HBA, SMP and firmware ioctls

This commit bounds the lengths of the HBA, SMP, and firmware ioctls in
esas2r against the remaining room in struct atto_express_ioctl (or
sizeof(struct atto_ioctl) for read_hw()) to prevent out-of-bounds DMA buffer
reads and writes.

> diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esa=
s2r_ioctl.c
> index c93d9265e1008..80ae5b9d45db1 100644
> --- a/drivers/scsi/esas2r/esas2r_ioctl.c
> +++ b/drivers/scsi/esas2r/esas2r_ioctl.c

[ ... ]

> @@ -1221,11 +1231,16 @@ static void hba_ioctl_done_callback(struct esas2r=
_adapter *a,
>  	}
>  }
> =20
> +/* @room is the size of the buffer that starts with @ioctl_hba. */
>  u8 handle_hba_ioctl(struct esas2r_adapter *a,
> -		    struct atto_ioctl *ioctl_hba)
> +		    struct atto_ioctl *ioctl_hba, size_t room)
>  {
>  	struct esas2r_buffered_ioctl bi;
> =20
> +	/* The data follows @ioctl_hba in the same buffer. */
> +	if (ioctl_hba->data_length > room - sizeof(struct atto_ioctl))
> +		return IOCTL_INVALID_PARAM;
> +
>  	memset(&bi, 0, sizeof(bi));
> =20
>  	bi.a =3D a;
>  	bi.ioctl =3D ioctl_hba;
>  	bi.length =3D sizeof(struct atto_ioctl) + ioctl_hba->data_length;

[Severity: High]
As reported by Sashiko on RFC [1], in drivers/scsi/esas2r/esas2r_main.c,
read_hw() and write_hw() access the shared a->local_atto_ioctl buffer
(allocated as sizeof(struct atto_ioctl)) without any driver lock:

drivers/scsi/esas2r/esas2r_main.c:read_hw() {
	...
	if (handle_hba_ioctl(a, a->local_atto_ioctl,
			     sizeof(struct atto_ioctl)) !=3D IOCTL_SUCCESS)
		return -ENOMEM;
	...
}

drivers/scsi/esas2r/esas2r_main.c:write_hw() {
	...
	memset(a->local_atto_ioctl, 0, sizeof(struct atto_ioctl));
	memcpy(a->local_atto_ioctl, buf, length);
	...
}

Because kernfs only serializes sysfs bin_attribute operations per open file
description, concurrent read_hw() and write_hw() calls on two separate open
file descriptors for the sysfs hw attribute can race on a->local_atto_ioctl.

In handle_hba_ioctl(), ioctl_hba->data_length is read once for the bounds
check against room - sizeof(struct atto_ioctl) and read a second time when
computing bi.length. If a concurrent write_hw() overwrites
a->local_atto_ioctl->data_length from 0 to a non-zero value between those t=
wo
reads, wouldn't handle_buffered_ioctl() still read and write bi.length bytes
past the end of a->local_atto_ioctl?

[1] https://lore.kernel.org/r/sashiko-outbox-195500@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D41
