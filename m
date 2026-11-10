Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794346585;
	b=qUbPVcttIaf/3a8vY63m0bw8VmEK/zRyWr5LIhPACgeMHFqExs8b8go9uTV68quJMOFx
	 KilW4tSnDjIWBcs7VlD08ADwty04qqxQrdWvQy+5o6EtxBluoLhZt6MfBho0IyR9+/jPC
	 2KmiCOYe2l5xbplLqF5wHK8GvzEBLT6or20yaZsBe6qSlgPEEz4OmKU3W6iMJEHZlIm8a
	 hjaJZmjwEvQzzm9U+5/LWRso79CgkMRU9lXmDmRpShE8/iALQSMt7VvK8j2KReD2Y/dHb
	 CjsAKEqS2nLrLHLN7gz+BUqnAIsj5aAHHCEclXBBAUzRSzTYee2FoGhN6nnajkw0PMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794346585;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Gb4pVxRyq1FY6eMZso1l64hf79xL7qEopdEwkYxVoEw=;
	b=tTUtgrflB53rw+UnSgWTSB8PYOkzN92mwuN4WVm49f8M1YmIPhFQzvOgaxkfHf/GaF7r
	 qpKtAePaqOnYWT2yJML95GQ7Ansm2FWKfQjVk+KxmHiV5cZwmKgb2llLCGPeWO+hB21Wa
	 Whx+toKi7OiXq8ApGu3ZLyDBZrq1pTYhqN2b5TDTb7U7Q/xGe+nAfi0Tds+i0VY7P3dzp
	 HJr8SLjBmAj9v6yrF2IkuWukLZHeu4i4J71uFbYUWhsa6vyTIzV3JsVdjdzguoWh+t4MI
	 +Ddknrej8DAQjcJeMIsHMuRb6d62Iuf6Xs1bmbQgtPzH6en0sgJVh33sZEnImcX6j4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="LGUl+h/f";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3553606A321
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 21:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LGUl+h/f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955E81F0089F;
	Tue, 10 Nov 2026 21:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794346584;
	bh=Gb4pVxRyq1FY6eMZso1l64hf79xL7qEopdEwkYxVoEw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LGUl+h/fw4FFVBvX+yNAqxQEliVemBH/malLcqBohlWp6T9fhKyjGO6INb/mwfAu4
	 OOQtU8R4ILXDHtBmZ4X42YfvDN+pGhsNf6OT/tBjLmnJHL4pa/vmph8Qf6YZF0rV/R
	 eedYgXs3MQvZu2mj8UkSesap54WSstLwFOAb1l5vo0tF66Wvf0AjZ/eT6Vj1/VPY/a
	 zKu0anVpiN4iTHbejYy8mu0QtaOUv7hHVCzt04R//NvLH6GrHSZqHb46qSiVxQcu3J
	 K6vYb2OF5QWXZ1SQIf6UxxBcXyuqrp2PncR70sypXvNtlSHF5jNIv9LjDQmE065mtK
	 oiQegb0VxKziQ==
Message-ID: <sashiko-outbox-207774@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: scsi_debug: wrap around the store when
 zeroing a reset zone
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tal Zussman" <tz2294@columbia.edu>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261110-scsi-debug-zone-reset-v1-1-28cb9184b5ea@columbia.edu>
References: <20261110-scsi-debug-zone-reset-v1-0-28cb9184b5ea@columbia.edu>
 <20261110-scsi-debug-zone-reset-v1-1-28cb9184b5ea@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 21:36:24 +0000
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
- [Low] scsi: scsi_debug: Fixes trailer cites f0d1cf9378bd instead of
  2d62253eb1b6
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] scsi: scsi_debug: out-of-bounds read in map_state() [1]
--

commit fffdafa6f420e79758f4780228f5ace2090a7a92
Author: Tal Zussman <tz2294@columbia.edu>

> scsi: scsi_debug: wrap around the store when zeroing a reset zone
>
> zbc_rwp_zone() zeroes the blocks of a zone that is reset, using the
> start of the zone as an offset into the store. With virtual_gb set, the
> device and its zones can extend past the end of the store, which is
> only dev_size_mb in size. Writes wrap around in do_device_access(), but
> the memset() doesn't, so resetting a zone that has been written to can
> write past the end of the store.
>
> On a device whose fifth zone starts exactly at the end of the store,
> write to that zone and reset it:
>
>   # modprobe scsi_debug zbc=3Dmanaged sector_size=3D4096 dev_size_mb=3D16=
 \
>         virtual_gb=3D1 zone_size_mb=3D4
>   # dd if=3D/dev/urandom of=3D/dev/sda bs=3D1M count=3D1 seek=3D16 oflag=
=3Ddirect
>   # blkzone reset -o 32768 -c 1 /dev/sda
>
> The memset() starts at the first byte past the store, in the guard page
> after the vmalloc'ed area, for the 1 MiB that was written:
>
> BUG: unable to handle page fault for address: ffffc90002c00000
> Oops: Oops: 0002 [#1] SMP KASAN NOPTI
> RIP: 0010:memset_orig+0x33/0xb0
> RDX: 0000000000100000 RSI: 0000000000000000 RDI: ffffc90002c00000
> Call Trace:
>  zbc_rwp_zone+0x1a7/0x2a0 [scsi_debug]
>  resp_rwp_zone+0x19c/0x450 [scsi_debug]
>  schedule_resp+0x2dd/0xbc0 [scsi_debug]
>  scsi_debug_queuecommand+0x1286/0x2950 [scsi_debug]
>  scsi_queue_rq+0x1d74/0x3200
>  blk_mq_dispatch_rq_list+0x3ad/0x23c0
>
> The command never completes, so the reset returns EIO to userspace and
> the device is unusable afterwards.
>
> Zero the blocks in a helper that wraps around at the end of the store,
> and that stops after one pass over it for a zone that is larger than
> the store.
>
> Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

[Severity: Low]
In commit f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands"),
zbc_rwp_zone() only reset z_wp and z_cond without touching sip->storep.
The non-wrapping memset() was added later by commit 2d62253eb1b6 ("scsi:
scsi_debug: Zero clear zones at reset write pointer"), so should the Fixes
tag point there instead?

  Fixes: 2d62253eb1b6 ("scsi: scsi_debug: Zero clear zones at reset write p=
ointer")

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index a922c8318a2fb..1c27ea0f9b694 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6612,6 +6612,29 @@ static int resp_finish_zone(struct scsi_cmnd *scp,
>  	return res;
>  }
> =20
> +/*
> + * Zero the blocks of a zone that is being reset. The store can be small=
er
> + * than the device, so wrap around at its end like do_device_access() do=
es.
> + */
> +static void zbc_zero_blocks(struct sdeb_store_info *sip, sector_t lba,
> +			    sector_t num)
> +{
> +	/* One pass over the store zeroes all of it */
> +	num =3D min_t(sector_t, num, sdebug_store_sectors);
> +
> +	while (num) {
> +		sector_t block =3D lba;
> +		u32 n;
> +
> +		block =3D sector_div(block, sdebug_store_sectors);
> +		n =3D min_t(sector_t, num, sdebug_store_sectors - block);
> +		memset(sip->storep + block * sdebug_sector_size, 0,
> +		       (size_t)n * sdebug_sector_size);
> +		lba +=3D n;
> +		num -=3D n;
> +	}
> +}
> +
>  static void zbc_rwp_zone(struct sdebug_dev_info *devip,
>  			 struct sdeb_zone_state *zsp)
>  {
> @@ -6629,8 +6652,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *de=
vip,
>  		devip->nr_closed--;
> =20
>  	if (zsp->z_wp > zsp->z_start)
> -		memset(sip->storep + zsp->z_start * sdebug_sector_size, 0,
> -		       (zsp->z_wp - zsp->z_start) * sdebug_sector_size);
> +		zbc_zero_blocks(sip, zsp->z_start, zsp->z_wp - zsp->z_start);
> =20
>  	zsp->z_non_seq_resource =3D false;
>  	zsp->z_wp =3D zsp->z_start;

[Severity: Critical]
This problem wasn't introduced by this patch, but can map_state() read past
the end of sip->map_storep when virtual_gb is set [1]?

drivers/scsi/scsi_debug.c:map_state() {
    ...
	index =3D lba_to_map_index(lba);
	mapped =3D test_bit(index, sip->map_storep);
    ...
}

sip->map_storep is sized for sdebug_store_sectors (map_size), whereas
resp_get_lba_status() validates the LBA against the larger virtual
sdebug_capacity before calling map_state().  A GET LBA STATUS command for
an LBA above sdebug_store_sectors produces an index past map_size, causing
test_bit() to read out of bounds of the vcalloc-allocated bitmap and
potentially panic or disclose kernel memory.

[1] https://sashiko.dev/#/bug/linux-be69a5e8-c8ca-4d89-b06c-a23fccc84744

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-scsi-debug=
-zone-reset-v1-0-28cb9184b5ea@columbia.edu?part=3D1
