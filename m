Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794218773;
	b=jHlMTl1rbNtgM9bdiz/2xn6TZlIXuzf5QdwXzPW3dkqTbNXL6a9iWs5PXaww5ZBf8zKA
	 rjWP+xBJy/6pOAZvhdu5RekKminE4I3BRxuu5ulnHVW2BP59rdKqSHONk6c/GUvtWCq1M
	 cWkT4eKbS/Uu2UplbcyvATXoQ5ikSCukS4DX4CXOhNaSsTqNZKOztjl8v+hU5pObPFRtt
	 FDaS6uGSdzaVCe1Ocuwsxlw98HOZjzvbMChvqlHA9X1/Ln1YgvjXIe0pfjcVgPws2FZ3P
	 YunHjGDFxDHbf/P/dq5eCZ2dNK97aLxefiwEf1K5EEL91qStLe94i3qOZP3bH1hWo7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794218773;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NcMTns+zJ37xkTa0NXqKAjXY83qckhqrV+Yz1hwi/7g=;
	b=ILK7nTOXa3J4hhxooIMV07DXRTeLlyBygbsL1NGyFd6GcQduCPBCRHF0vhvdiLsjAPrH
	 WjZM3RTFBfXgDSZSPfShJwdf9J5FCkhn9tbS4OdpRAdcFOx0XXJZdPoqqjfzZyRb5xLtn
	 jJuA+rM1NJAGRwDL1jh0zrGgiUraUHwYW3dZUnQuSAsxJkN9RvUVgf4NI34zQt51lrmPd
	 qiQacTj3mN7j0LWnb0Eg0D43CQmvAa8auFPJQVWvvv5yk72OD7QIZBhihHJU0HfZtti26
	 gQVTlCgJMpLmmoAvum+RabW3qi6K7f0f71H6T/yE+NbXYrSpaOsle0/o0i2PluOpNiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OLopamen;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D054606A321
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 10:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OLopamen
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBED41F0089F;
	Mon,  9 Nov 2026 10:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794218772;
	bh=NcMTns+zJ37xkTa0NXqKAjXY83qckhqrV+Yz1hwi/7g=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=OLopamenc9tKppSONTXNtDivwrlo2hJAOb/TAQT0um58dKc5bwxB6JDUYKaUOnNVn
	 NRV6Vw/BOvfjmGzxohG7PeJEecfjx6+Pda1R2Wtq8o2huLfU11sr/w3ftShem8lhOy
	 LjTzM6rU8fl2XzQnG1Kvgv/nmynhHbr+B6LHjPPpz1DLLjnJlYYLsWI9SKWzcQ98Y5
	 Ng3V3CPTSceiXxoxizZajvfeNuNXulFWOIQnYEq076/JPzcuVZA0bZk+p5byyT4BOt
	 SY18+GY10sRmAbPYPj4mv6CZkDglfG3Dbfig3rvZnXtInH61Ue2CbKLZYNL+vEg+FK
	 lWTNgAfTwzVFg==
Message-ID: <sashiko-outbox-204780@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 06/12] zloop: fix zone reporting consistency
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <20261109095144.819709-7-dlemoal@kernel.org>
References: <20261109095144.819709-1-dlemoal@kernel.org>
 <20261109095144.819709-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 10:06:12 +0000
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
- [Medium] zloop: inconsistent empty zone report in zloop_report_zones()
--

commit 2a1f79e0caf4e50f76c7d14b20ef44343010c188
Author: Damien Le Moal <dlemoal@kernel.org>

zloop: fix zone reporting consistency

This commit moves the read of zone->cond inside zone->wp_lock in
zloop_report_zones() so that blkz.wp and blkz.cond are populated while
holding the same spinlock.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 65634a39b0bfc..e1ad7513fea9b 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
> @@ -992,8 +992,8 @@ static int zloop_report_zones(struct gendisk *disk, s=
ector_t sector,
>  		blkz.len =3D zlo->zone_size;
>  		spin_lock(&zone->wp_lock);
>  		blkz.wp =3D zone->wp;
> -		spin_unlock(&zone->wp_lock);
>  		blkz.cond =3D zone->cond;
> +		spin_unlock(&zone->wp_lock);
>  		if (test_bit(ZLOOP_ZONE_CONV, &zone->flags)) {
>  			blkz.type =3D BLK_ZONE_TYPE_CONVENTIONAL;
>  			blkz.capacity =3D zlo->zone_size;

[Severity: Medium]
Can zloop_report_zones() still report blkz.cond =3D=3D BLK_ZONE_COND_EMPTY
with blkz.wp > blkz.start when ordered_zone_append is enabled?

When a zone append to an empty zone does not fill the zone,
zloop_set_zone_append_sector() advances zone->wp under zone->wp_lock,
while transitioning zone->cond to BLK_ZONE_COND_IMP_OPEN via
zloop_do_open_zone() only happens later in the workqueue:

drivers/block/zloop.c:zloop_set_zone_append_sector() {
	...
	rq->__sector =3D zone->wp;
	zone->wp +=3D blk_rq_sectors(rq);
	if (zone->wp >=3D zone_end)
		zloop_mark_full(zlo, zone);

	spin_unlock(&zone->wp_lock);
	...
}

CPU0                              CPU1 (kworker)
zloop_queue_rq()
  zloop_set_zone_append_sector()
    spin_lock(&zone->wp_lock)
    zone->wp +=3D blk_rq_sectors(rq)
    spin_unlock(&zone->wp_lock)
  queue_work(..., &cmd->work)
zloop_report_zones()
  mutex_lock(&zone->lock)
  spin_lock(&zone->wp_lock)
  blkz.wp =3D zone->wp;
  blkz.cond =3D zone->cond;  <-- still BLK_ZONE_COND_EMPTY
  spin_unlock(&zone->wp_lock)
                                  zloop_rw()
                                    zloop_seq_write_prep()
                                      mutex_lock(&zone->lock)
                                      zloop_do_open_zone()

Reporting BLK_ZONE_COND_EMPTY with an advanced write pointer causes
disk_report_zone() -> disk_zone_wplug_sync_state() ->
blk_zone_wp_offset() to treat the write pointer offset as 0 instead of
blkz.wp - blkz.start.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109095144.8197=
09-1-dlemoal@kernel.org?part=3D6
