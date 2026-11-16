Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794865483;
	b=vgj20zgQAHwIfQo6jBIoEJyZEi6LDACvRzTFOOeh/VNVAg/zaALbTbckyE1RJubU3Lgq
	 16dmkLhaVg/46Fl2dXDgALm4h83NrEPFQmbAXClmKRI7aasi9tm/FdfVS6oHOiwR6ooiP
	 h5i1vB+0cJ9STfi+Z+FwFEvu6OvwJj1+aaorM6c7QMk/WN7f92Ng6QHReGVFsyCKIa6fO
	 FsyRXE6sGjIXS4rvBqKIfyKdF2N6z86BsZfmUfj1ZqqNxklUU6WtZVhJ6f0C3rjs1kgdN
	 cUgJTQryj+x+CanSrwEA8Yb/APwUJeJxGp7JIzsqYvxXwB1QDXpoj3tKlnmgJJp9byw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794865483;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8iDcSXxrYYUxAGmIG3xajDZME7ryCHi3xR8vOOhXGTo=;
	b=o8ab/3pEGVBUpKn7afpAJPbe7kgdIkBFwnQ8vZq4cIVwgJjowyIi4+wmdqpOULAZuaCm
	 cd+qg4PccBAbSeg+B2FO2CbT7an/WxxYukWQdDjmV9milxLEcMWKS//5LT73kS62pf51T
	 XLwJcouf/7rqy4aJEm/jZX0cTYFcw+kyAarPkc4VkHCSL+D7FEbZqJMgVwsZPftnhbxvr
	 dLaiBHBOdl6H0YvZs3izvHWTP6ggOIANWy/Rvwrz3bzL1OjAmhGxOziC5qFc1dYX+IIaz
	 Sicbx+VaaEPRsqxpwaPcI6j6lfzxl7pFz/C9R6fsn3eBwouz/AokwnWrgiPzhMXit4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J4ouqZi9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6918D606A31C
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 21:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J4ouqZi9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBD11F000C4;
	Mon, 16 Nov 2026 21:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794865483;
	bh=8iDcSXxrYYUxAGmIG3xajDZME7ryCHi3xR8vOOhXGTo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=J4ouqZi9TOhskw2qn1gZlUIP0TRch6vlJKkpegtDBGTJxXO8mCg51xpQ4tvadUg+R
	 rJsVS+o7r77P0Imb3kqTDXSo9Kt0Q/p9g32ZhDibn/Y4UmGXEDC95vnf/pDqfqQw8z
	 mXpfgMqZKm1sufblFGpXOBfHY73oTA3ASDc1lyo9dFLsuL6N8p81f47IOwfGXHYSWI
	 6sQe8xco2VtKB3z8rPR6gL45EUGk1Wi3k4dTfIEcDtDSLl+5v4zy37PsQo+GVr2ezo
	 G2UlOz5j4Ja6AvVA5/UEgqOnp95KJggC7woP5SMKnlQDkvF8BYZVMm9uFAOYgcz9vD
	 VqFf3CCJIeXkw==
Message-ID: <sashiko-outbox-217750@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 09/13] zloop: add degrade_element control command
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <20261116213702.225970-10-dlemoal@kernel.org>
References: <20261116213702.225970-1-dlemoal@kernel.org>
 <20261116213702.225970-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 21:44:42 +0000
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
- [High] zloop: zloop_rw() fails to set -EIO when zloop_zone_rw_is_ok()
  fails
--

commit c96e6d1fd4da5400dd5befd118994f57ffa77920
Author: Damien Le Moal <dlemoal@kernel.org>

zloop: add degrade_element control command

This commit adds the "degrade_element" control command to mark a zloop
storage element as degraded so that reads or writes to zones served by it
fail.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index a7806a73d7148..dcfcd100b7baa 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
[ ... ]
> @@ -1173,6 +1177,31 @@ static int zloop_report_elements(struct gendisk *d=
isk,
>  	return 0;
>  }
> =20
> +static int zloop_degrade_element(struct zloop_device *zlo,
> +				 unsigned int element_id)
> +{
> +	struct blk_se *se;
> +	int ret =3D 0;
> +
> +	if (zlo->stor_elements =3D=3D ZLOOP_STOR_ELEMENTS_NONE)
> +		return -EOPNOTSUPP;
> +
> +	if (!element_id || element_id > zlo->nr_elements)
> +		return -EINVAL;
> +
> +	mutex_lock(&zlo->stor_elements_lock);
> +
> +	se =3D &zlo->elements[element_id - 1];
> +	if (READ_ONCE(se->status) <=3D BLK_SE_STS_DEGRADED)
> +		WRITE_ONCE(se->status, BLK_SE_STS_DEGRADED);
> +	else
> +		ret =3D -EINVAL;
> +
> +	mutex_unlock(&zlo->stor_elements_lock);
> +
> +	return ret;
> +}

[Severity: High]
Can a read to a sequential zone on a degraded element complete with
cmd->ret =3D=3D 0 instead of -EIO after a failed write?

When a write to a sequential zone fails (including when rejected by a
degraded element), zloop_complete_rq() sets ZLOOP_ZONE_SEQ_ERROR.  On the
next I/O to that zone, zloop_rw() clears ZLOOP_ZONE_SEQ_ERROR and calls
zloop_update_seq_zone(), which succeeds and overwrites ret with 0 before
zloop_zone_rw_is_ok() checks the element status:

drivers/block/zloop.c:zloop_rw() {
    ...
	if (test_and_clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags)) {
		mutex_lock(&zone->lock);
		ret =3D zloop_update_seq_zone(zlo, zone_no);
		mutex_unlock(&zone->lock);
		if (ret)
			goto out;
	}

	/*
	 * Check if we can accept read or write commands based on the
	 * health state of the storage element serving the target zone.
	 */
	if (!zloop_zone_rw_is_ok(zlo, zone, op_is_write(req_op(rq))))
		goto out;
    ...
out:
	if (ret !=3D -EIOCBQUEUED)
		zloop_rw_complete(&cmd->iocb, ret);
    ...
}

When zloop_zone_rw_is_ok() returns false and jumps to out, ret is still 0.
For a read request, zloop_complete_rq() treats cmd->ret =3D=3D 0 as a short
read, zeroes the request buffer via zloop_fill_zero_rq(), and completes the
request with BLK_STS_OK instead of failing it.

Setting ret =3D -EIO before jumping to out when zloop_zone_rw_is_ok() fails
(or running zloop_zone_rw_is_ok() before the ZLOOP_ZONE_SEQ_ERROR check)
would avoid this.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116213702.2259=
70-1-dlemoal@kernel.org?part=3D9
