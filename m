Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794173287;
	b=wYawT+ymlklZSNHOr4gxyGROcCUJsblIEKfzMz8o70WqO/hTM9YN+Kh7tOTqaiERuJ38
	 fOas1wkurTpYhZ5AHpABEDVOJ/tq+Da27RBwJ0fhdYaLzNhse3/tj3wHQbp06KY54ZLvU
	 XNBzAwiuzoDeSY2mntqzUTEqL5363CpH3qvu6IynFkGeQ7F0vSN3u2xkMo4r3MiWpUHhS
	 vO2Tcr9oxsBwV9AEMzjrYp7vysbbiwddo/ArhCWJWwOBebcQMJvXXEwIyxT/GLJaXjJJ9
	 0m+c6bzzyI0ke5EJv18BKLswsqZ5DN4bRcc/BzPkLca7NAeRVFmSTjoN6z7LkaeDnSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794173287;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=E5pMI9aRdzG1jMHGQKjfhPH5Hs+3ONX21rBiT60hvnE=;
	b=c/JrusPsfPTubjp9pf9jqQxNN2/Oor0WRPUQI4SG0kXi7+vyGzCNLm/T7xxCJXQZTFtp
	 FvYOPmh8kcWMqeRaZLZ1YOrEtqZxfShM0FoROnyMoEF8XhdAHokqyLdsdFef8fRhk50+W
	 QGt3de/+MNBKDyc00IQnKgsp0jK4CX3PXI0mHmMwgF/xpQp05AM8H2+O0asggcRnWap6P
	 Bho7Ou4LjFYxHJat/QJzLgF3VLSHLmmQH0+qUdKphs/VOAMROJYGPYUR9GO11HNBQL1rK
	 J/yEDtweIdQFhHrbu+UbuwxViWEAtAqJnQL5St/t2q+aOAmSrIbuhD5VW68N2ajKiCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="S8/5i403";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFD5606A31C;
	Sun,  8 Nov 2026 21:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S8/5i403
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F061F0089F;
	Sun,  8 Nov 2026 21:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794173286;
	bh=E5pMI9aRdzG1jMHGQKjfhPH5Hs+3ONX21rBiT60hvnE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S8/5i403KKG8DLFHzJ0mWEm1BcPUtbvIM0gU8pl4BinDKS1VyI/stx083wZb2KU7Y
	 0dxB236TYlgXmKbi3/5y/MPTfx3PM6H652OB/ZVG50iIZXzRHDsA5+M5zViJs6By94
	 lyjF+RRCDbgdmsGh/yVY7VyjlMTyGj9Ylao46aqwUAUIBMoIlEh58VEaOTZ21hIuRN
	 MtFyjD1cgWFK9AW3CE1BFMdnFcjyE7oBqvDmIj1Cf8pP6MzNnIatZosDjjq/rRfVmP
	 27oK7ySaQ5ubxSOvRLRmd80vkeotBSwqGDX/pz8IeSl0nGxGNITXmr/ijD7NNCVNwV
	 TWHfTFN2le69A==
Message-ID: <sashiko-outbox-204075@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 21/29] scsi-multipath: add
 scsi_mpath_{start,end}_request()
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.garry@linux.dev>, james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de, michael.christie@oracle.com
In-Reply-To: <20261108204733.557995-22-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
 <20261108204733.557995-22-john.garry@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 21:28:05 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] scsi: multipath: premature bio completion in
  scsi_mpath_end_request()
- [Medium] scsi-multipath: mismatched bdev I/O accounting in
  scsi_mpath_end_request()
--

commit 29255340e39c30a34f5cb1da674871fdd2c627ea
Author: John Garry <john.garry@linux.dev>

scsi-multipath: add scsi_mpath_{start,end}_request()

This commit adds scsi_mpath_start_request() and scsi_mpath_end_request()
to track per-host active multipath requests for the queue-depth I/O policy
and perform block device I/O accounting on multipath requests.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 2f47c39d82936..93a4545f1dbf7 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -545,6 +545,75 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scs=
i_mpath_head)
>  }
>  EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
> =20
> +void scsi_mpath_start_request(struct request *req)
> +{
> +	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(req);
> +	struct scsi_device *sdev =3D scmd->device;
> +	struct scsi_mpath_device *scsi_mpath_dev =3D sdev->scsi_mpath_dev;
> +	struct scsi_mpath_head *scsi_mpath_head =3D
> +				scsi_mpath_dev->scsi_mpath_head;
> +	struct bio *clone =3D req->bio, *master;
> +	struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +	struct gendisk *disk =3D mpath_head->disk;
> +
> +	if (mpath_qd_iopolicy(&scsi_mpath_head->iopolicy) &&
> +	    !(scmd->flags & SCMD_MPATH_CNT_ACTIVE)) {
> +		struct Scsi_Host *shost =3D sdev->host;
> +
> +		atomic_inc(&shost->mpath_nr_active);
> +		scmd->flags |=3D SCMD_MPATH_CNT_ACTIVE;
> +	}
> +
> +	if (blk_rq_is_passthrough(req) || !blk_queue_io_stat(disk->queue))
> +		return;
> +
> +	if (!clone) {
> +		scmd->flags &=3D ~SCMD_MPATH_IO_STATS;
> +		return;
> +	}
> +
> +	if (scmd->flags & SCMD_MPATH_IO_STATS)
> +		return;
> +
> +	master =3D clone->bi_private;
> +
> +	scmd->flags |=3D SCMD_MPATH_IO_STATS;
> +	scmd->start_time =3D bdev_start_io_acct(master->bi_bdev, req_op(req),
> +				jiffies);
> +	scmd->start_bytes =3D blk_rq_bytes(req);
> +}
> +
> +bool scsi_mpath_end_request(struct request *req, blk_status_t error,
> +				unsigned int nr_bytes)
> +{
> +	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(req);
> +	struct scsi_device *sdev =3D scmd->device;
> +	struct block_device *bi_bdev =3D NULL;
> +
> +	if (scmd->flags & SCMD_MPATH_IO_STATS) {
> +		struct bio *clone =3D req->bio, *master =3D clone->bi_private;
> +
> +		bi_bdev =3D master->bi_bdev;
> +	}

[Severity: Medium]
Can scsi_mpath_start_request() and scsi_mpath_end_request() account I/O
against different block_device structures when a merged request completes
partially?

scsi_mpath_clone_bio() directs all clone bios to the underlying path
disk's part0 while storing the original bio in clone->bi_private.
Contiguous clone bios from adjacent partitions on mpath_head->disk can
therefore be merged into a single request on sdev->request_queue.

When that request starts, scsi_mpath_start_request() calls
bdev_start_io_acct() on the first bio's master->bi_bdev and sets
SCMD_MPATH_IO_STATS.  If a partial completion advances req->bio past the
first bio (returning true from blk_update_request()), the final call to
scsi_mpath_end_request() re-derives bi_bdev from the remaining bio's
master->bi_bdev and calls bdev_end_io_acct() on the second partition,
leaking in_flight on the first partition and underflowing it on the
second.

Accounting against mpath_head->disk->part0 in both functions (or saving
the accounted block_device) would keep the start and end calls paired.

> +
> +	if (blk_update_request(req, error, nr_bytes))
> +		return true;
> +
> +	if (scmd->flags & SCMD_MPATH_CNT_ACTIVE) {
> +		struct Scsi_Host *shost =3D sdev->host;
> +
> +		atomic_dec_if_positive(&shost->mpath_nr_active);
> +	}
> +
> +	if (!(scmd->flags & SCMD_MPATH_IO_STATS))
> +		return false;
> +	bdev_end_io_acct(bi_bdev, req_op(req),
> +			 scmd->start_bytes >> SECTOR_SHIFT,
> +			 scmd->start_time);
> +
> +	return false;
> +}

[Severity: Medium]
Does calling blk_update_request() before updating shost->mpath_nr_active
and calling bdev_end_io_acct() complete master_bio too early?

blk_update_request() runs bio_endio(clone) -> scsi_mpath_clone_end_io(),
which either schedules mpath_head->requeue_work on a path error or calls
bio_endio(master_bio).  Because mpath_head->disk is bio-based,
__submit_bio() drops its queue reference as soon as
mpath_bdev_submit_bio() returns, so nothing pins bi_bdev once master_bio
completes:

CPU0                                  CPU1
scsi_mpath_end_request()
  blk_update_request()
    ...
      scsi_mpath_clone_end_io()
        bio_endio(master_bio)
                                      blkdev_put()
                                      bdev_del_partition()
                                        ...
                                        bdev_free_inode()
                                          free_percpu(bdev->bd_stats)
  bdev_end_io_acct(bi_bdev, ...)
    <-- use-after-free on bi_bdev

In addition, when scsi_mpath_clone_end_io() triggers failover or a
caller immediately submits dependent I/O under MPATH_IOPOLICY_QD,
mpath_queue_depth_path() reads shost->mpath_nr_active before this request
has decremented it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108204733.5579=
95-1-john.garry@linux.dev?part=3D21
