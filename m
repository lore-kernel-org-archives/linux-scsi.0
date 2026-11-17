Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932446;
	b=ylSvHpqSZiQO7kla5ia4VwTRBdO37k6xX+ucRIGva7OxjKAIz4zPdPhHGteZ5c/AVbvn
	 Ip6emIMy3iN+kTHFq5wF1xN4WlGwa5ahM5D6M3c2xBYVBk1MmnxtCtHQE5GffO3sJnTfH
	 UToS9Sznk1lSxX7ECWh39yfPvguN4NQndjXsKVgcYD1h6ioVUoj6KbvN0IEVVzEdJKgb/
	 zPRgswYKZQdoJplPOncLvyHK1YrzQeC7quv3kzhS9qVP5kFLm4vkv/+DXQVHXn+5cSBup
	 FEaxQDJkQr8b/nDmuZMQUUEy3LyG63BoTL7W9+ViMHrFeQlpscuG4uhWONJfG8yqZag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932446;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OFUeUW/IJn00Ly8M9lqyTGyBs7kJjV1mZKpzhgZy8Xs=;
	b=qSRXs6gEL/8+YzmQhw9+/9Y60x/lsnHFAFvC6zLMkv+p7ZZqlOAULVO/Igc+vNVRSmKp
	 +22m84cEN8IX6b1VHSKp4IegP6FKoZEgTShj3QhVLUKfvEIqqbS0yYcT7j6mExg2re51W
	 PcvRYXpu6bCH96p0SH/RiS22HvIG02h+e0s1YOad4hWwX9RT6WVI3jOWYnpP/tZYJvpOL
	 N0C54Cu5lFuiB+VUyk/3dzz36YnANTDg2OHBFBDyWCU5lSD2Pd+8MzRHks3/6h5hizPoX
	 MMcwqjRMr4QYredu4o3SVa4KfwhbxB6KzmKvOFLFmCdBDAX+HsmvngaDhhd1I+ZQXRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O2aR0Gnh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA193606A32A
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 16:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O2aR0Gnh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7050F1F000C4;
	Tue, 17 Nov 2026 16:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794932446;
	bh=OFUeUW/IJn00Ly8M9lqyTGyBs7kJjV1mZKpzhgZy8Xs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=O2aR0Gnh81URH7WYxeNP+hiS/dR5AgS+Aro2zaDPVu8kdBkKPd/wnvAHH/WBwGMXZ
	 dVV8bHLsUhWnocnvabhKly19pMo/64Z3ldeWacFbpSxsopY1C+09/VTqFx8+FVXy5D
	 o8Oi9/YaXKYMlpGwP2dchq2MpHU9ZVO3Ia/FZm1eYpiARsnKP2lsvrUiNOUPcMVd98
	 +jrrTYlUB0M3BqLsEuQ5nRsezdLYJOyTgM5YcnbKjinSDvps0pjZwfh2fO5E7TpqwE
	 D/4jnyYtQVTLHBvfIq60JHzlyzgOruOEro5n8P8iZVQdjZmZyhUly8cp+RlDdjaWoL
	 jqQibglOqAZ6w==
Message-ID: <sashiko-outbox-219155@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 08/13] zloop: add storage element emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <20261117155739.304506-9-dlemoal@kernel.org>
References: <20261117155739.304506-1-dlemoal@kernel.org>
 <20261117155739.304506-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 16:20:45 +0000
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
- [Medium] zloop: serialize zloop_ctl_remove() with storage element ops
--

commit b2e9213b7a22038d3fa09a4110dd9d6ac106045b
Author: Damien Le Moal <dlemoal@kernel.org>

zloop: add storage element emulation

This commit adds storage element depopulation and restoration emulation to =
the
zloop driver, controlled via a new stor_elements option and exposed through
zloop_se_ops.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 6bb68022ab30e..a4536e6240c0b 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c

[ ... ]

> @@ -1388,6 +2022,12 @@ static void zloop_forget_cache(struct zloop_device=
 *zlo)
> =20
>  	pr_info("%pg: discarding volatile write cache\n", zlo->disk->part0);
> =20
> +	/*
> +	 * Serialize with storage element removal or restoration that may be
> +	 * finishing running during device removal.
> +	 */
> +	mutex_lock(&zlo->stor_elements_lock);
> +
>  	for (i =3D 0; i < zlo->nr_zones; i++) {
>  		struct zloop_zone *zone =3D &zlo->zones[i];
>  		struct file *file =3D zone->file;
> @@ -1418,6 +2058,8 @@ static void zloop_forget_cache(struct zloop_device =
*zlo)
>  		vfs_truncate(&file->f_path,
>  			(old_wp - zone->start) << SECTOR_SHIFT);
>  	}
> +
> +	mutex_unlock(&zlo->stor_elements_lock);
>  }

[Severity: Medium]
Can zloop_ctl_remove() finish and return to userspace while
zloop_execute_restore_elements() is still truncating zone backing files when
discard_write_cache is disabled?

zloop_forget_cache() is only called from zloop_ctl_remove() when
zlo->discard_write_cache is set:

drivers/block/zloop.c:zloop_ctl_remove() {
    ...
	del_gendisk(zlo->disk);

	if (zlo->discard_write_cache)
		zloop_forget_cache(zlo);

	put_disk(zlo->disk);
    ...
}

When discard_write_cache is false (the default), nothing in zloop_ctl_remov=
e()
acquires zlo->stor_elements_lock to wait for an in-flight storage element
operation that passed the Zlo_deleting check just before removal started:

CPU0                                    CPU1
zloop_restore_elements()
  msleep(5000)
  mutex_lock(&zlo->stor_elements_lock)
  /* zlo->state !=3D Zlo_deleting */
                                        zloop_ctl_remove()
                                          idr_remove(&zloop_index_idr, ...)
                                          WRITE_ONCE(zlo->state, Zlo_deleti=
ng)
                                          del_gendisk(zlo->disk)
                                          put_disk(zlo->disk)
                                          return 0;
  zloop_execute_restore_elements()
    zloop_restore_zone()
      vfs_truncate(...)  <-- runs after device removal completed

If userspace re-adds the device with the same ID or accesses base_dir after
remove returns, the ongoing truncations from the old instance race with the
new accesses and corrupt the zone files.  Acquiring zlo->stor_elements_lock=
 in
zloop_ctl_remove() after del_gendisk() would serialize removal regardless of
discard_write_cache.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117155739.3045=
06-1-dlemoal@kernel.org?part=3D8
