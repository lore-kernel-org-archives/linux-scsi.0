Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794828661;
	b=2fCn4S6efwRwY0LCv6SSFVukcykz+U9+LbkSSQIMK4YOmutaVqh+xydwiGl1fADxt7Ty
	 qAwjOzUpqu3fhRIegC/FTUaOy5GK1r0p0YT/Bw9/DIfgu4dUG6RKNJqh9JMzulynN3Lf6
	 2JvNWGSM2aAyamaIliyDDFmSSGe4CXnI35rSaQ+K5dssHrON8u61jnFxInkHIrwtVzLop
	 /+xdBkIrfJ8YbNvLYanuB+Sv6CqyM7L9VOcGIEM/bp+cWqWRO2m/67HjUBq1QtkwaYQce
	 thRRmdx3oaUlZat31gsFnNgJiddpsN6nt416/gUJ2+LEc9OXoulg6PSNMAnNED+TnEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794828661;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1tC3N1qqBX7/u0OnGs3h9tXT815w695looNGw4xVvNg=;
	b=AdGw5EJUUL+32o+7hZXmFjiwiFI5qJSxDNMuIK6cS8APjgu+R79khYBBZhiLZ9nEpiza
	 IRyn2mRbnVdIt/EntKC5TOAYX0nRoC9aBR5pNHzoNAdITbl1TInycqdDHd610U22tWgHf
	 JWdThR7MG5FBVzd/LlfIIlBiKNfBHgzpaea/OxeMN+tIDRjf1aMEKK837vpZMiB8yDzI9
	 g06a1ZE+l7oMpzIj5hrenAwhQe05uSezqFE58KsGdhxdNwA9LqTtAeLqXoK541eOOdZm2
	 SR3c3BKyVXFZmFV580UZmhkj9POtYNQ592DSaY0wxp7DI0fv1YYkfsIH5KqFDkl1nQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KdHQpj8j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF83B606A323;
	Mon, 16 Nov 2026 11:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KdHQpj8j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302171F000C4;
	Mon, 16 Nov 2026 11:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794828660;
	bh=1tC3N1qqBX7/u0OnGs3h9tXT815w695looNGw4xVvNg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KdHQpj8jQM055I9TqpxYRHE0W+D1Ta5O5ntgrbWtgfFYXmuv8ggC7UFRpB6kvrp8q
	 MnzgKU48J1wciEkisugsFYjWBmStEIEztGbaS/eE4CNyTdT6PPt7JSFkzKfd+tSbsI
	 VN5o2jmqQE05/+1sqVTaa3m/7O327/auMjgwDYcxTfTn4hGRRONhM4cT86olGNTrmW
	 u3JTVDrIXNEZYcayaMMIb7K11ofGjIf+bFwkrx2anN5XJmjyMfsq51mi6ZG5aGQJNs
	 75beAv9KUANxHlEItGRJukLPVS0lh01EMQsaoVV0HziYc0IZ+u1DJYrLUHHqzpTubI
	 rBRBsuk6UI7UA==
Message-ID: <sashiko-outbox-216937@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/17] fs: add kiocb_write_iter() and
 kiocb_end_write_iter()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bpf@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20261116-work-fs-frozen_writes-v2-2-ecc4a2aac40e@kernel.org>
References: <20261116-work-fs-frozen_writes-v2-0-ecc4a2aac40e@kernel.org>
 <20261116-work-fs-frozen_writes-v2-2-ecc4a2aac40e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 11:30:59 +0000
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
- [Medium] fs: unconditional freeze protection on non-regular files in
  kiocb_write_iter()
--

commit c4bb9dc6398af3c2e2efc447c0b1b29d081b55ab
Author: Christian Brauner <brauner@kernel.org>

fs: add kiocb_write_iter() and kiocb_end_write_iter()

This commit adds kiocb_write_iter() and kiocb_end_write_iter() helpers to
manage superblock freeze protection across ->write_iter() calls.

> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index eefc2c9d4af19..0b66a09fb686a 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2840,6 +2840,54 @@ static inline void kiocb_end_write(struct kiocb *i=
ocb)
[ ... ]
> +static inline ssize_t kiocb_write_iter(struct kiocb *iocb,
> +				       struct iov_iter *iter)
> +{
> +	ssize_t ret;
> +
> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> +		if (!kiocb_start_write_trylock(iocb))
> +			return -EAGAIN;
> +	} else {
> +		kiocb_start_write(iocb);
> +	}
> +	iocb->ki_flags |=3D IOCB_WRITE;

[Severity: Medium]
Should kiocb_write_iter() check S_ISREG(file_inode(iocb->ki_filp)->i_mode)
before taking freeze protection and setting IOCB_WRITE, the way
file_start_write(), aio_write() and io_kiocb_start_write() do?

Callers such as loop and target_core_file accept S_ISBLK backing files.
Opening a block device node leaves file_inode(file)->i_sb pointing at the
filesystem hosting the device node rather than the block device.  Without
an S_ISREG() check, writes to a block device node whose hosting filesystem
is frozen will block in sb_start_write() (or fail with -EAGAIN for
IOCB_NOWAIT), and will deadlock if that filesystem is mounted on or
flushing through the virtual block device during freeze_super().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116-work-fs-fr=
ozen_writes-v2-0-ecc4a2aac40e@kernel.org?part=3D2
