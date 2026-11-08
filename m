Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794172094;
	b=tJXjpW8zJxaTbpR0Xqx4AER1kYrE2WAvZ0OF/1vGt3WpsYimk9Ezaav+13z6/C5tECeh
	 ZeTe8lF/ZdDRHjTU1YTf0xHN5kASA3kPHqhpXoXtK6gtrQYiLaYTPGE7wc2gECgqzPEJQ
	 YdGg8jm2zrVEtVgf9Mw+YX5lZ1LnpzHNTLegw3Pl/HcM23MnPU0f8Uu7QOTtPs9Jw23v5
	 MWt4rJH51SS6a5veIwlJiP1TxjYsfTpDN3ebsGR9MHtDf1K9OOCm5sJUEmgPmkhB7A1/r
	 vXomYcb4KDxXruKGIpaOZ2N0nvOIeBXZg51ektu6eQZEmpTKDqkSF3t86FQXYOfwcWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794172094;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=R2GKokw2/sTju46GRiRayxuymaLOEX9DEa0q5Mrg9Kw=;
	b=qScxGGDvzXPgwZ3J5oDbHnm/fL1nXjG8yBMycVCfPewf6hDfLERW2+ct+go5bHl+uSmk
	 BpqIWOBaCfUxPCaclVwzYSRxfbgRVawSj/WQGn13TLs8e1cQ+OtPnUgJ0L90odI7l+g34
	 s2Zq0j8q5TyK8bgMn2Ah2OhV+WwMjodB8t7vPup2V6q/amQKbkHIt4HMo3uo7JtsDsVwx
	 Q/RBB3GcKG0dBij41vudnOW8CcWpuHEw0F2W78eTVlQATWQJtZ7PLzeX3fABzBgay47wz
	 vR0PsRCXTpDNLoe6FEWkpuyHhx2ijVfGcMp0yBhowaZEUndQIaTMqJESdnyLFQrCYSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hJyl5NRj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795B8606A323;
	Sun,  8 Nov 2026 21:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hJyl5NRj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400481F008A2;
	Sun,  8 Nov 2026 21:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794172093;
	bh=R2GKokw2/sTju46GRiRayxuymaLOEX9DEa0q5Mrg9Kw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hJyl5NRjR/8Xuo/JHYw+/GRyx7a4n7HJDK70gVSfeRUv2yl2c15A5r2RIdQRcDYnt
	 m+x4xnHPMcobXVWp3kJIUPBK4ItwZa+BFRAL1a5wyEZQqFqdUJx9INUstGcAb30B9A
	 eF7TiT4f4XwxPdS4TduOrZFmawm/z/yftz6Iguk58Mhr71++ZQzubGA4H8YXOxWkXi
	 vSqKrin1LpdFSPA85tGkKHwwzOIgRWA0+QAEp/NFPdHdN9GiQrOHk1KZO4l5DevTpO
	 PqoaqrmZjk4d7zwWo4grum7kIDbpbs56B+ElomgUcphRw9KgGgvlcCE4vZq1pOaNoD
	 Eak76oNYHrwCg==
Message-ID: <sashiko-outbox-204059@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 18/29] scsi-multipath: revalidate paths upon device
 unblock
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.garry@linux.dev>, james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de, michael.christie@oracle.com
In-Reply-To: <20261108204733.557995-19-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
 <20261108204733.557995-19-john.garry@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 21:08:12 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] scsi: multipath: race in scsi_internal_device_unblock() on
  scsi_mpath_head
- [High] scsi: multipath: use-after-free in
  scsi_mpath_revalidate_paths() requeue_work
- [Medium] scsi: multipath: race in scsi_device_block() accessing
  scsi_mpath_head
- [Medium] scsi: multipath: premature scsi_mpath_dev publish in
  scsi_mpath_dev_alloc()
--

commit ed012aa632cd8957f54296618fde6fa312555b38
Author: John Garry <john.garry@linux.dev>

scsi-multipath: revalidate paths upon device unblock

This commit adds scsi_mpath_revalidate_paths() and calls it from
scsi_internal_device_unblock() to clear paths and requeue bios when a
multipath SCSI device is unblocked.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 1950034f580f4..4dbd01484b4a5 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3121,6 +3121,8 @@ static int scsi_internal_device_unblock(struct scsi=
_device *sdev,
>  	mutex_lock(&sdev->state_mutex);
>  	ret =3D scsi_internal_device_unblock_nowait(sdev, new_state);
>  	mutex_unlock(&sdev->state_mutex);
> +	if ((ret =3D=3D 0) && sdev->scsi_mpath_dev)
> +		scsi_mpath_revalidate_paths(sdev->scsi_mpath_dev);
> =20
>  	return ret;
>  }

[Severity: High]
Can scsi_internal_device_unblock() race with __scsi_remove_device() and
dereference a NULL or freed scsi_mpath_head?

Callers such as scsi_target_unblock() and scsi_host_unblock() iterate
devices with shost_for_each_device(), which pins sdev->sdev_gendev (deferri=
ng
scsi_device_dev_release() where sdev->scsi_mpath_dev is freed) without
holding shost->scan_mutex.  Because sdev->state_mutex is dropped before
calling scsi_mpath_revalidate_paths() (and
scsi_internal_device_unblock_nowait() also returns 0 in SDEV_CANCEL),
__scsi_remove_device() can tear down scsi_mpath_dev->scsi_mpath_head
concurrently:

CPU0                                  CPU1
scsi_target_unblock()
  scsi_internal_device_unblock()
    mutex_lock(&sdev->state_mutex)
    scsi_internal_device_unblock_nowait()
    mutex_unlock(&sdev->state_mutex)
                                      __scsi_remove_device()
                                        ...
                                        scsi_mpath_remove_device()
                                          scsi_mpath_remove_head()
                                            scsi_mpath_put_head()
                                            scsi_mpath_dev->scsi_mpath_head=
 =3D NULL
    scsi_mpath_revalidate_paths()
      mpath_revalidate_paths(mpath_head)  <-- NULL deref or use-after-free

In scsi_mpath_revalidate_paths(), &scsi_mpath_head->mpath_head is at offset
0, so mpath_clear_paths() and mpath_schedule_requeue_work() dereference a
NULL or freed mpath_head.

[Severity: Medium]
Can scsi_internal_device_unblock() also observe a partially initialized or
freed sdev->scsi_mpath_dev during LUN scanning?

In scsi_add_lun(), sdev is already on shost->__devices and starget->devices
and set to SDEV_RUNNING or SDEV_BLOCK before scsi_mpath_dev_alloc() runs:

CPU0                                  CPU1
scsi_add_lun()
  scsi_mpath_dev_alloc()
    scsi_multipath_sdev_init()
      sdev->scsi_mpath_dev =3D scsi_mpath_dev
                                      scsi_target_unblock()
                                        scsi_internal_device_unblock()
                                          if (ret =3D=3D 0 && sdev->scsi_mp=
ath_dev)
                                            scsi_mpath_revalidate_paths()
                                              mpath_revalidate_paths(NULL)
                                              <-- NULL pointer dereference
    scsi_mpath_unique_lun_id()
    ...
    sdev->scsi_mpath_dev->scsi_mpath_head =3D ...

If scsi_mpath_dev_alloc() fails later at out_uninit,
scsi_multipath_sdev_uninit() also frees sdev->scsi_mpath_dev before clearing
the pointer, allowing a concurrent unblock to hit a use-after-free.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 67e9010d54782..008bcafe73ad2 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -240,6 +240,14 @@ static int scsi_multipath_sdev_init(struct scsi_devi=
ce *sdev)
>  	return 0;
>  }
> =20
> +void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_de=
v)
> +{
> +       struct scsi_mpath_head *scsi_mpath_head =3D scsi_mpath_dev->scsi_=
mpath_head;
> +       struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +
> +       mpath_revalidate_paths(mpath_head);
> +}

[Severity: High]
Can mpath_head->requeue_work queued by scsi_mpath_revalidate_paths() run
after scsi_mpath_head is freed?

Transport target teardown paths such as fc_starget_delete(),
iscsi_remove_session(), and rport_dev_loss_timedout() call
scsi_target_unblock(..., SDEV_TRANSPORT_OFFLINE) immediately followed by
scsi_remove_target():

CPU0                                  kworker
fc_starget_delete()
  scsi_target_unblock()
    scsi_internal_device_unblock()
      scsi_mpath_revalidate_paths()
        mpath_revalidate_paths()
          mpath_schedule_requeue_work()
  scsi_remove_target()
    ...
      scsi_mpath_remove_device()
        scsi_mpath_put_head()
          scsi_mpath_head_release()
            kfree(scsi_mpath_head)
                                      mpath_requeue_work()
                                        spin_lock_irq(&mpath_head->requeue_=
lock)
                                        <-- use-after-free

Unlike scsi_mpath_device_iopolicy_store(), which calls
flush_work(&mpath_head->requeue_work) with a comment noting that
requeue_work could otherwise run after mpath_head is gone, neither
scsi_mpath_revalidate_paths() nor scsi_mpath_head_release() /
mpath_head_uninit() flushes or cancels mpath_head->requeue_work.

> +
>  void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
>  {
>         struct mpath_device *mpath_device =3D &scsi_mpath_dev->mpath_devi=
ce;

[Severity: Medium]
Can scsi_device_block() hit the same race against __scsi_remove_device() or
scsi_mpath_dev_alloc() when calling scsi_mpath_dev_clear_path()?

drivers/scsi/scsi_lib.c:scsi_device_block() {
    ...
	mutex_unlock(&sdev->state_mutex);
	if ((err =3D=3D 0) && sdev->scsi_mpath_dev)
		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
    ...
}

Once scsi_device_block() drops sdev->state_mutex, __scsi_remove_device() can
transition sdev from SDEV_BLOCK directly to SDEV_DEL and run
scsi_mpath_remove_device(), freeing scsi_mpath_head and clearing
scsi_mpath_dev->scsi_mpath_head before scsi_mpath_dev_clear_path()
dereferences it in mpath_synchronize().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108204733.5579=
95-1-john.garry@linux.dev?part=3D18
