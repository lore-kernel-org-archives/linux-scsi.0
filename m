Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793893927;
	b=f1xeVbSFPK+qGQE0PRAqru2V0jL76UNRWTgpCHBk6lt21MBztG4XOJA6W1PYS6Qc1+yK
	 axScAEb7xS2pAsZQ2BGOWoN9+9bBKv7Cb+YOv13EDQH6C0Eqi4B9+JWPsOHUWGWDfyNt/
	 OLV/2Eyl0c6RyQHoKCCFQT0qMHF1LOoeZ4Oby1Hy+scPFkuKgEVS+Fp9ThjDKyERRYynY
	 lbeVZIfTdtHwY8Wc++ey64bL2b2V/pcKZyUCscK2W4V9ETSjt6QucJ8PEyiZW56kuM79m
	 e3z17bh92JICY7YSLdvr7rqVPhlBweTFEVOKUzzcWmW45mbzCiwl5dHU2wFUduXOjXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793893927;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hW9HS+EEWkHNCPj+p4Gl3a6W3rV7V3ETg7/nPVbyL8U=;
	b=2wsjbUULPrmsGQ8/1yL8G4qQKLX62t9DnFPEhFfloZn0O88s4W4ib2OYdivMGuTQTifG
	 dxJMDK+qCGhZrAayhQVkfI0cxsPMfHvUsCX434NOZcBxOVoOBzOFu/rP+qFpEBd0L9YkT
	 tjdmaa+CrM5nLPs6LuZv9xCSES05D2haE6jVTWAPCDfwIMZglnmdw3S9Hf/oj0JgrRmWc
	 XHkTsezD2cAhqctFPnI0f7D8UpMeowRrcwDrI2X/ZssmchhOzsbtii00ql5q7YhqZYqCp
	 pHZnsK5vsMEDLAJ+PofJ3bsFwcleGTebqYPTVtXI2hyik1x65pWTpSCuSPS/Vid9Jig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UpmKmfTp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983CD606A333
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 15:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UpmKmfTp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED73B1F00919;
	Thu,  5 Nov 2026 15:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793893927;
	bh=hW9HS+EEWkHNCPj+p4Gl3a6W3rV7V3ETg7/nPVbyL8U=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=UpmKmfTp5mCF45LHzfIrbqH8LX/vULHOhJKIL+DWApo+kfgTys9//OHtmxwwdQXL/
	 xZbs+i68s9bRQaTDX0nJJB3JWtPDuvl6N2dIBWY6z5HYgKW9aRim4yfIwe0vJLsuSu
	 mYsFUIQ+PmSHxBcoBZ6Ciyl0wgqIYfwVnEK29DORduB4MzMiKB814jBXgwKl2rit2L
	 SpEWtImI3Fu60uI6TvjLbqBQ1NUJzNhSYPtE2DrhdOy9XH/oGD/97D0fPw53bBIjYz
	 vO9EnQOgMgMBxA1HvMTjp3W8Qpu8KkhYPNooQ4dQrs+AxhpIKdE4yIvAWTSj8R5Sg4
	 RiGR8W5cNicHA==
Message-ID: <sashiko-outbox-199356@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: core: reject short REPORT LUNS responses
Reply-To: sashiko-reviews@lists.linux.dev
To: shao.mingyin@zte.com.cn, linux-scsi@vger.kernel.org
In-Reply-To: <20261103235610554mYM6cfXrrF3RpQowmPUzD@zte.com.cn>
References: <20261103235610554mYM6cfXrrF3RpQowmPUzD@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 15:52:06 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: core: length wrap check in scsi_report_lun_scan() fails on 3=
2-bit
- [Medium] scsi: core: scsi_report_lun_scan() ignores resid for LUN list pa=
yload
--

commit 2885be16f82e8adaba8635ec48148cc769b349f4
Author: shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>

scsi: core: reject short REPORT LUNS responses

This commit allocates the REPORT LUNS buffer in scsi_report_lun_scan() with
kzalloc() instead of kmalloc() and checks the transfer residual and buffer
length so that responses shorter than the eight-byte LUN list header are
rejected.

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 52f3b525d2fda..e6aac73105375 100644
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
> @@ -1516,7 +1517,7 @@ static int scsi_report_lun_scan(struct Scsi_Host *s=
host,
>  	 */
>  	length =3D (511 + 1) * sizeof(struct scsi_lun);
>  retry:
> -	lun_data =3D kmalloc(length, GFP_KERNEL);
> +	lun_data =3D kzalloc(length, GFP_KERNEL);
>  	if (!lun_data) {
>  		printk(ALLOC_FAILURE_MSG, __func__);
>  		goto out;
> @@ -1567,6 +1568,19 @@ static int scsi_report_lun_scan(struct Scsi_Host *=
shost,
>  		goto out_err;
>  	}
> =20
> +	/*
> +	 * Reject a transfer that did not fill in the whole LUN list header.
> +	 * Also reject a length that cannot even hold the header: the retry
> +	 * path computes it from the device-reported value with an addition
> +	 * that can wrap below sizeof(struct scsi_lun), in which case the
> +	 * residual comparison below would underflow.
> +	 */
> +	if (length < sizeof(struct scsi_lun) ||
> +	    resid > length - sizeof(struct scsi_lun)) {
> +		ret =3D 1;
> +		goto out_err;
> +	}

[Severity: High]
Does the length < sizeof(struct scsi_lun) check in scsi_report_lun_scan()
in drivers/scsi/scsi_scan.c work on 32-bit architectures, or happen early
enough on 64-bit architectures, when the device-reported LUN list length is
in the range 0xfffffff8..0xffffffff?

Immediately after this check, scsi_report_lun_scan() inspects the reported
length and decides whether to retry:

	if (get_unaligned_be32(lun_data->scsi_lun) +
	    sizeof(struct scsi_lun) > length) {
		length =3D get_unaligned_be32(lun_data->scsi_lun) +
			 sizeof(struct scsi_lun);
		kfree(lun_data);
		goto retry;
	}
	length =3D get_unaligned_be32(lun_data->scsi_lun);

	num_luns =3D (length / sizeof(struct scsi_lun));
	...
	for (lunp =3D &lun_data[1]; lunp <=3D &lun_data[num_luns]; lunp++) {

On 32-bit architectures, get_unaligned_be32(lun_data->scsi_lun) (u32),
sizeof(struct scsi_lun) (size_t, 8), and length (unsigned int) are all
32-bit unsigned values. If a target responds to the initial 4096-byte
REPORT LUNS command with a LUN list length in 0xfffffff8..0xffffffff, the
addition in the if condition wraps modulo 2^32 to 0..7. Since 0..7 > 4096
is false, the retry branch is not taken and the length < sizeof(struct
scsi_lun) check is never reached. Execution falls through with length set
to 0xfffffff8..0xffffffff and num_luns set to 0x1fffffff, causing the scan
loop to read far past the end of the 4096-byte lun_data buffer.

On 64-bit architectures, sizeof(struct scsi_lun) is a 64-bit size_t, so the
if condition evaluates to true without wrapping, but assigning the sum to
the 32-bit unsigned int length truncates it to 0..7 before jumping to
retry. Because the length < sizeof(struct scsi_lun) check is placed after
kzalloc() and scsi_execute_cmd(), the retry pass calls kzalloc(0..7,
GFP_KERNEL) (returning ZERO_SIZE_PTR when length is 0) and sends a bogus
0..7 byte REPORT LUNS command to the target before rejecting length.

Would it be better to check for overflow when adding sizeof(struct
scsi_lun) to get_unaligned_be32(lun_data->scsi_lun) (for example via
check_add_overflow()) before comparing against length and jumping to retry?

[Severity: Medium]
As reported by Sashiko on v1 [1], what happens in scsi_report_lun_scan() in
drivers/scsi/scsi_scan.c when a target transfers the full 8-byte LUN list
header (so resid <=3D length - sizeof(struct scsi_lun)), but stops
transferring before sending all of the LUN descriptors reported in that
header?

After the header residual check and retry check pass, scsi_report_lun_scan()
computes num_luns directly from the header value without checking or
bounding against the number of payload bytes actually transferred (length -
resid - sizeof(struct scsi_lun)):

	length =3D get_unaligned_be32(lun_data->scsi_lun);

	num_luns =3D (length / sizeof(struct scsi_lun));

If the transfer stopped mid-descriptor or before the end of the reported
list, the untransferred tail is zeroed by kzalloc() and scsi_execute_cmd().
Doesn't the scan loop then decode a partially transferred descriptor with
zeroed trailing bytes into a corrupted LUN number via scsilun_to_int(), and
decode all remaining untransferred descriptors as LUN 0?

[1] https://lore.kernel.org/r/sashiko-outbox-195103@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103235610554mY=
M6cfXrrF3RpQowmPUzD@zte.com.cn?part=3D1
