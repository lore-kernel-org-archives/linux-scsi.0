Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794336085;
	b=ngtEwaQGWQl10d/z4L7SNbnkJd1XhyF3PKYT/QjejgECJQ6gWkMuEQzYtFMrKd9uyp8N
	 8ATo0dGhaOlhIXOgySaoRRAHIQCdR0KoA8/0s7fflAeQqBiC9+jpmXH53GWfwmt5wSr0g
	 WAw98N5JZhnPMomHPNad5NxREzZCwIJ2TdA3c/oYhoT1OF5VUM+L93mgrcLO3y/1hIP0B
	 a77yNYMsluxmltGgDxoh1iLFyVQeuswn6Jt6vlka03mFUXeRG1QOBJuYR8n8okFhM0own
	 KthW7BNEHPH5Gy4Hv89oXpR03+JJhJ9UCXfygJcPq85Ljn8yrOYFhl0ZIii9vEuYCrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336085;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7xSEW5uWr9UnIv5TGOgrVSYOU9dUgA1c9jabSiDAXV4=;
	b=31Z5tI7UrFzgMDyiiDH01HcMKLtY09yuwFihXlNNf79AgxAxFKH8Jnh2x/Ug0cJg77sb
	 hZ+PWSQrAcvfOrBsb0h+B5I5WSQsCPAKcCKCJakAfnxQkdXawlo2qpu2v7J+8eMT/Ey2o
	 mnhCYUzhcXftMnZPPMLtkE9CpYJhgQB+1YBwnrvD2YFjABDb5C5+Am4iDYsBZaoWJ3fME
	 lYTiDwJ7djJFNpqeEYKiDhYU3NsXZXOkQnppWkQbrfT+jBiAGyAIlRzH9nTNyacFxQAAr
	 IdV3y/XoZDKsqJeB+ELEwgbWjLWIpjoe9ohyU3a5JQxJasbLaNa8t25Ou8HiMnOpdqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LzdXvnzP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0B2606C6C1
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LzdXvnzP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A5C1F008A1;
	Tue, 10 Nov 2026 18:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794336084;
	bh=7xSEW5uWr9UnIv5TGOgrVSYOU9dUgA1c9jabSiDAXV4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LzdXvnzP8C5QJ7mHYYMSi93UQnekQHMQo9kPjB1Zgw/kGv0v+fq9QQj6nSjlQQTAy
	 2OwEaPYq+KpBws+VjcCBldpYmejs2KeQ0AhMUVy40r0f8HvfO15/yIFtt/dsEb7Fzv
	 YijdZe9P7MyG25mKHBYY9Nl8bdHF/21GseOfhqJE0EBJ+V9X2a5u17VEnLbLZt5jn3
	 vW8tIptYB4OB/f62lys8K9PWfzxyzmFxRGU4iv2hZr0MRaZPyx0sqSUQ/OBwW53j+Y
	 Fg9UgUN+Z1FGWRdxfZkYZ1aQj/IdNXkL/BZGnUiXDYDbIo2OCfQ/8t/W0unLypG54v
	 DBKYSPmxvrCaQ==
Message-ID: <sashiko-outbox-207599@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: scsi_debug: generate protection information
 for writes without it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tal Zussman" <tz2294@columbia.edu>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261110-scsi-debug-pi-v1-2-539829902b3a@columbia.edu>
References: <20261110-scsi-debug-pi-v1-0-539829902b3a@columbia.edu>
 <20261110-scsi-debug-pi-v1-2-539829902b3a@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 18:41:24 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 2 related pre-existing issues it does not
introduce:
- [Critical] scsi: scsi_debug: LBP and protection state corruption on
  partial writes [1]
- [Critical] scsi: scsi_debug: write protection bypass in
  resp_comp_write() [2]
--

commit 6d076bfd0f944479df3df26a58ea22111f72afc1
Author: Tal Zussman <tz2294@columbia.edu>

scsi: scsi_debug: generate protection information for writes without it

This commit generates T10 protection information in scsi_debug for write
commands submitted without protection scatterlists, and extends the metadata
write lock in write handlers to cover DIX updates.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 7d50650396377..2c7afdd2846b1 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
[ ... ]
> @@ -5195,6 +5221,9 @@ static int __resp_write_dt0(struct scsi_cmnd *scp,
>  	ret =3D do_device_access(sip, scp, 0, lba, num, group, true, atomic);
>  	if (ret < 0)
>  		*scsi_status =3D DID_ERROR << 16;
> +	else if (!scsi_prot_sg_count(scp))
> +		dif_generate(sip, lba, DIV_ROUND_UP(ret, sdebug_sector_size),
> +			     false);
> =20
>  	if (unlikely(lbp))
>  		map_region(sip, lba, num);

[Severity: Critical]
This problem wasn't introduced by this patch, but can a failed or short
write in __resp_write_dt0() and resp_write_scat() corrupt the LBP and DIX
metadata [1]?

While dif_generate() uses the actual byte count returned by
do_device_access(), map_region() right below it (and __resp_write_dt0_dix()
or prot_verify_write() before the transfer) still operates on the full
requested sector count num.  If do_device_access() fails or transfers fewer
bytes than requested, unwritten sectors are marked as mapped in
sip->map_storep and have their protection tags overwritten in
sip->dif_storep, desynchronizing the metadata from the backing store and
causing subsequent reads of those sectors to fail verification.

[ ... ]
> @@ -5753,6 +5786,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
>  		retval =3D check_condition_result;
>  		goto cleanup_unlock;
>  	}
> +	dif_generate(sip, lba, num, false);
> =20
>  	/* Cover sip->map_storep (which map_region() sets) with the meta lock */
>  	if (scsi_debug_lbp())

[Severity: Critical]
This problem wasn't introduced by this patch, but does resp_comp_write()
bypass device write protection by passing false for the write argument to
check_device_access_params() [2]?

drivers/scsi/scsi_debug.c:resp_comp_write() {
	...
	ret =3D check_device_access_params(scp, lba, num, false);
	if (ret)
		return ret;
	...
}

Because write is false, check_device_access_params() skips the sdebug_wp
check, allowing COMPARE AND WRITE to modify data and protection metadata on
a write-protected device.

[1] https://sashiko.dev/#/bug/linux-5ff253b7-5155-4709-ae8b-55ff4a1eb98f
[2] https://sashiko.dev/#/bug/linux-0b24b1f8-28c0-4efa-915b-66147893a0f1

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-scsi-debug=
-pi-v1-0-539829902b3a@columbia.edu?part=3D2
