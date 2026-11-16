Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794866373;
	b=j5DrdZgqRSZtxFaXnyZjPr/txauytCoDdCLqnVfjIxQbhPLwkbr1nnQ5YgUqgQ/w1uJK
	 FCpWzZ0XGUC0tkqYQRjO73+hFaJt7hQ1gKx9UjUjZijGfOdkMfIw039e3Hfk1kLDWJLaQ
	 Qqg/dOT51ovqiHW+UAMaHNgrWODlQy22n/g0in2kMAbi74CL9uVEYQtL/SVIJ049f8MnI
	 qE3uTworogQUQ6xXeHOmR2e3ni5bDQp3Yvt+JGdMuPfn4+RvcPy4/4O2yuw+CkqhIZJa1
	 54sjeImuktsySiylbJePWI1+yycLf7hltKVW7gfTQs6lf8XXj6T+84OMi1BJhhmX5aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794866373;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ira6kvhi1C/R77igXXhd2AScrEmLHIqdEZwiyzYqsRQ=;
	b=VVNkAh3yJ4HSasNfmfsrh3S9nrQRYWceiUIAdzuK/8ONmuKO8YQp0PI6AGPlOo7xsy+/
	 Ww9zDRdqmwNGO+6c9bJaG5o+sNlEfbDty4zN/wHDNLP3aq7/rZYZsT7O6sZHZwMhtft/z
	 bUPirvj9r9iMucMTGUl5xQeudcQ+2PSIf54NwytdL8dUOblB4yj1CiQz5rTydLxaKGh8Q
	 BmmiNeIUL443lXBb0QRKtGJqpWblkWQygbrG5B0inFVE5sw73Kj5RYj0S2yVk2QiN0MBK
	 B+rzZ6Y/C3U5HVD67P3ZKeTl00QsoluOPh/vyu8SXBw6w8+l+AKkxUSVWnz1IM8cv3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vsnbuvvz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BC0606A332
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 21:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vsnbuvvz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705EE1F000C4;
	Mon, 16 Nov 2026 21:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794866372;
	bh=Ira6kvhi1C/R77igXXhd2AScrEmLHIqdEZwiyzYqsRQ=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=VsnbuvvzgmPAhjAmPtznq+Wyr6t/b0IsQgac/QkBNp1OYiRq5D09fVlGg6y1eZmf9
	 wHW9wMXm0txHGs/fpuaJpnMoYKAbcMcXcy/oYeNUwFkRsr1pKNvuV6eJnuckVz0Bbt
	 5s7HQUwlwhyTNMhQV+oy2q+LA1R2j1Nnn8uaeyLiQSHd76lMyJumgX9UrMzUuSWcCt
	 /f3cTB45EaZ1s6+OpgZmva2bKvgEHszjKLyhED5MdI1C058YPrQSbgxGFVv629+11B
	 yS9foM7BO3Bf4jWY2NIR4B+yT65zOdUhs6SS508MvFkFO8e4Wg7x5NVygxw43jm6IM
	 sBhR/lXwWjaTQ==
Message-ID: <sashiko-outbox-217769@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 08/13] zloop: add storage element emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <20261116213702.225970-9-dlemoal@kernel.org>
References: <20261116213702.225970-1-dlemoal@kernel.org>
 <20261116213702.225970-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 21:59:31 +0000
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
- [High] zloop: unreset ret =3D=3D 0 in zloop_rw() when
  zloop_zone_rw_is_ok() fails
--

commit a3e7202e262b13b2a09d14b2d67deaa658ca4af4
Author: Damien Le Moal <dlemoal@kernel.org>

zloop: add storage element emulation

This commit adds storage element depopulation emulation to the zloop
driver, controlled by the new stor_elements option and implemented via
struct blk_se_ops callbacks.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index ae7a0b0281884..a7806a73d7148 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c

[ ... ]

> @@ -671,6 +819,13 @@ static void zloop_rw(struct zloop_cmd *cmd)
>  			goto out;
>  	}
> =20
> +	/*
> +	 * Check if we can accept read or write commands based on the
> +	 * health state of the storage element serving the target zone.
> +	 */
> +	if (!zloop_zone_rw_is_ok(zlo, zone, op_is_write(req_op(rq))))
> +		goto out;

[Severity: High]
Can zloop_rw() jump to out with ret =3D=3D 0 when zloop_zone_rw_is_ok()
rejects a command?

Right above this check, if ZLOOP_ZONE_SEQ_ERROR is set (for example,
after an earlier failed write to a sequential zone), zloop_rw() calls
ret =3D zloop_update_seq_zone(zlo, zone_no), which overwrites ret =3D -EIO
with 0 on success:

drivers/block/zloop.c:zloop_rw() {
    ...
	if (test_and_clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags)) {
		mutex_lock(&zone->lock);
		ret =3D zloop_update_seq_zone(zlo, zone_no);
		mutex_unlock(&zone->lock);
		if (ret)
			goto out;
	}
    ...
}

When zloop_zone_rw_is_ok() then returns false and jumps to out,
zloop_rw_complete() sets cmd->ret =3D 0 instead of -EIO.  In
zloop_complete_rq(), a rejected REQ_OP_READ with cmd->ret =3D=3D 0 is treat=
ed
as a 0-byte short read, zeroing the caller's read buffer via
zloop_fill_zero_rq(rq, 0) and completing with BLK_STS_OK instead of
BLK_STS_IOERR.  A rejected write hits the partial-write check, logs a
spurious 0-byte partial write error, and re-sets ZLOOP_ZONE_SEQ_ERROR.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116213702.2259=
70-1-dlemoal@kernel.org?part=3D8
