Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793703903;
	b=dkn6HLWdudX1cxoZDKsZ+D2t6d2IeYh8cy20yyykX3IZYOOZ/H7m5X+uYCgvPkiCHI3X
	 2ULsiMPh/02XYaz9dxv771QqIw4ZTO69pOlkTcAo0OHQiV4pWMmgOwbNS9DqSzunGV20S
	 piIQR65ChC0WUxfrfTwgeQ9LmdKIcuSQwVvh/Jk4oLgwZ1glmfF3QaBSzrVi2AqUErnvZ
	 57V/+U/FpxdQOdsDrZPM7cLe2d027Fu/H7Y76NCuRmUTRTjmlA5MVr/Sg5XrXvLcbgcZa
	 7L2aKT6/jJRyKoR4WtOvQ2cuAow+odwv650FcsZdzK2UVf496iPh+svw25k5dsL8Z5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793703903;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=O+2nZjXC87Cs1Gz2L1fg07NHLBSrbbXZ8RUjySKAElc=;
	b=hkCrSPb0c9GdHEDnsc+igpP1UZs7AYcOAOet9tSbAdTYBMrHH1+E8s2WLoq7IjHIU2Av
	 HD/FyHo8KCQxpcmZtt0UAg/3tR43VXVn529VaKWFC8DOLj92+s3u2GUfPp2Dt488ZbFaw
	 8UEpX0RIDQZqWn1G5VrZRopgCcrqmaOcMcG0HNqK4OXqqrmf9lh8LePI4T+rPYZf8HINO
	 H9KJi1LT+zFNXRJj9nd8Nqb0LLptQdtyuvStUzLri6o9QDMLOTMZl22jqB6wEN3m4b0nh
	 K4OhGgHwonCgDnPqbUb30NRScNEtRDFOcwYf1U2M342AMIslP2XVqelIXr9UMNLYM+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="gBJe/jmh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775E1606C57D
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 11:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gBJe/jmh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205531F00A24;
	Tue,  3 Nov 2026 11:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793703903;
	bh=O+2nZjXC87Cs1Gz2L1fg07NHLBSrbbXZ8RUjySKAElc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=gBJe/jmhFMrU5IqdB6tKAfBiJ8iZaj2sx8VxbnZRAVx1aAuyCyfDr03Dx4lqsJxS2
	 GRzXGzop7dKr/B0fb6EDwrnKrfjrKU9xjPPRm/BPlbSmjIEwz/eWbYRpixYyqK+s2d
	 5e2IMoM0B+i7ldVefoAatkeId849N0tSiJhvL51cu/w8zWaY501a862knEwg4S22Yu
	 BsQ3swKVFv546iwukAfVLfjGaK/yDHZvcpQosdpIqJrP9GDIctIgbnXShHxhUD4Wlb
	 u7+XsISFBCp0Ny4U8m0GG+gT/5GzqvjK2uV2L0IYaBlJgJtlN3UrETu3nJ62FaVp6P
	 nWEX/LZeJ3KRA==
Message-ID: <sashiko-outbox-195103@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: core: reject short REPORT LUNS responses
Reply-To: sashiko-reviews@lists.linux.dev
To: shao.mingyin@zte.com.cn, linux-scsi@vger.kernel.org
In-Reply-To: <2026110318534911091Mvzh5diLU9SKNWyne2p@zte.com.cn>
References: <2026110318534911091Mvzh5diLU9SKNWyne2p@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:05:02 +0000
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
- [Medium] scsi: core: incomplete short-transfer validation in scsi_report_=
lun_scan()
--

commit d5b77af2d901c3158f427e5d31d0271faf51bd28
Author: shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>

scsi: core: reject short REPORT LUNS responses

This commit requests the transfer residual from scsi_execute_cmd() in
scsi_report_lun_scan() and aborts the REPORT LUNS scan when fewer than
sizeof(struct scsi_lun) bytes were transferred.

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 52f3b525d2fda..abbcf529bdc4c 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1475,10 +1475,11 @@ static int scsi_report_lun_scan(struct Scsi_Host =
*shost,
>  		.total_allowed =3D 3,
>  		.failure_definitions =3D failure_defs,
>  	};
> +	int ret =3D 0, resid =3D 0;
>  	const struct scsi_exec_args exec_args =3D {
> +		.resid =3D &resid,
>  		.failures =3D &failures,
>  	};
> -	int ret =3D 0;
> =20
>  	/*
>  	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
> @@ -1567,6 +1568,12 @@ static int scsi_report_lun_scan(struct Scsi_Host *=
shost,
>  		goto out_err;
>  	}
> =20
> +	if (resid > length - sizeof(struct scsi_lun)) {
> +		/* Short transfer: the LUN list header was not filled in. */
> +		ret =3D 1;
> +		goto out_err;
> +	}

[Severity: Medium]
What happens if a target transfers the 8-byte LUN list header reporting a
non-zero LUN list length, but truncates the transfer before sending all of
the reported LUN descriptors?

In drivers/scsi/scsi_scan.c:scsi_report_lun_scan(), after this check passes,
length and num_luns are computed solely from the header value without
verifying that the transferred byte count (length - resid) covers the full
reported list:

	if (get_unaligned_be32(lun_data->scsi_lun) +
	    sizeof(struct scsi_lun) > length) {
		length =3D get_unaligned_be32(lun_data->scsi_lun) +
			 sizeof(struct scsi_lun);
		kfree(lun_data);
		goto retry;
	}
	length =3D get_unaligned_be32(lun_data->scsi_lun);

	num_luns =3D (length / sizeof(struct scsi_lun));

Because drivers/scsi/scsi_lib.c:scsi_execute_cmd() zeroes the residual tail
of the buffer:

	if (unlikely(scmd->resid_len > 0 && scmd->resid_len <=3D bufflen))
		memset(buffer + bufflen - scmd->resid_len, 0, scmd->resid_len);

	if (args->resid)
		*args->resid =3D scmd->resid_len;

wouldn't a truncated payload cause the scan loop to decode a partially
zeroed descriptor at the truncation boundary into a corrupted LUN number and
repeatedly probe LUN 0 for all remaining untransferred entries, instead of
rejecting the short transfer or clamping to the transferred bytes?

Also, the commit message states:

> scsi_report_lun_scan() allocates the REPORT LUNS buffer with kmalloc()
> and does not ask scsi_execute_cmd() for the residual count.  A device that
> completes the command successfully after transferring fewer than the eight
> bytes of the LUN list header leaves the header uninitialized; the bogus
> length read from it can trigger a multi-gigabyte kmalloc() retry or probe
> LUNs that do not exist.

Since scsi_execute_cmd() already zeroes scmd->resid_len bytes at the end of
the buffer whenever 0 < scmd->resid_len <=3D bufflen regardless of whether
args->resid is set, a reported residual does not leave lun_data
uninitialized. Conversely, if a host adapter driver does not report a
residual on a short transfer (leaving scmd->resid_len =3D=3D 0), resid is 0=
 and
lun_data allocated with kmalloc() remains uninitialized. Should lun_data be
allocated with kzalloc() and the commit message updated to reflect how
scsi_execute_cmd() handles residuals?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/2026110318534911091=
Mvzh5diLU9SKNWyne2p@zte.com.cn?part=3D1
