Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794787131;
	b=0262kFXWjp/48RROzLfKoqA7Z6Lr+ocMKxPpMNr9DyEtTBRZFUaQpy7+MZ3d8CxHSLFZ
	 CfdDgK5W3EpsVLwP2DLKEtpXokyX3PtJ/296yWnpGiV0HN6ofrlcvsJDFtVapjzp6ghgg
	 4prd1DuoEPCUFx+aBcFif5gHyG/BsgB42wOKchzNC+cxV5GhhGO0niD8HpqWN+YW8t+JY
	 W7wsM+kLt/U7ntbb6UsgJvXYuVqdActGud9w35xyoqwGiirGz0TQ/hUTaEMnl5Kn/EGSB
	 sy6CsECOdZPAdyo2u4aoEkUrZzyDEt/bL0RisBzR81kL2bXKwzhLFRUnyvQJQ7FZYJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794787131;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wRRqm8Z93PGVZ5FlwCW3D6lXIvFQd15je90FR/NhyjE=;
	b=yk9VHKn15tXzIK1UmJVfL56Ynb65gTBj6aXS/lzv5/yoYbzI48xPw/68t5NEw37jPMMt
	 7SJeIMooWKze8hX4TcDHTOzIK0th2wFZxb02p2cGH5gpwzTMQcZo8bAC1xLCvf54GMNF/
	 p6Th5L1eBJTiPzaYibkTH8awW7sEdbbcZQ4RL48Tznsxe5Lio5J9tp0LBWkftSr3frGF8
	 CXNPAbNejbkKzCSsnZHLRBOPOK6QnOSqpmrOg/K/Bg2/q/40M3BslKEFk+rM3vCM27kfw
	 YKsKgHUVC0w2pekeB+bm+ZIRnNwJCsMh59AhWzhKzK7XIdIl1LqT7s3lVXXxBykpQRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dwj+3CGv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0215606A32C
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 23:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dwj+3CGv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675D51F000C5;
	Sun, 15 Nov 2026 23:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794787130;
	bh=wRRqm8Z93PGVZ5FlwCW3D6lXIvFQd15je90FR/NhyjE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=dwj+3CGv75KJVx5Gg8MU/2TCbT+pcnBfFuRPyEpbkKfhOA6aYET/V5WNNcp6wnf5C
	 NAA4ghV9mLKZlRseLl1yFTBT68DeF5GYHBkoN8AaY4OnVE8+qdArCvAHIvZYwx9epQ
	 deDIshu5k6rp35DS9ViA6KTD94dsD5xzhDg0HZUVyochq8LPYgzBtYpGlhlPoyIqRA
	 3HRYWSaQuh7X6ho/6W1tCiN4qkLX2aRxb26tuvO9JiH31LeNiLcwPYZt5s6hD/q1do
	 pcREcpVXtXauUBDdFttqSjVjtT+8xcNfLa2Gk5oKvV0drMOFKHNGMk2g3FL006d4Om
	 saPhAO/2Ekslg==
Message-ID: <sashiko-outbox-215934@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 08/13] zloop: add storage element emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <20261115233327.941586-9-dlemoal@kernel.org>
References: <20261115233327.941586-1-dlemoal@kernel.org>
 <20261115233327.941586-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 23:58:49 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] zloop: stale zone state on partial failure in
  zloop_execute_restore_elements()
- [Medium] zloop: zloop_rdwr_is_ok() blocks ZLOOP_ZONE_SEQ_ERROR
  recovery on full zones
- [Medium] zloop: race between storage element ops and
  zloop_ctl_remove()
--

commit 8e8c9e4aeea297b926b2b865b9d40a12a001bcbe
Author: Damien Le Moal <dlemoal@kernel.org>

zloop: add storage element emulation

This commit adds storage element depopulation emulation to the zloop
driver, controlled via the new stor_elements option and implemented
through zloop_se_ops.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index eb51c8e1cc189..26018e9e567c6 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c

[ ... ]

> @@ -876,6 +988,43 @@ static void zloop_complete_rq(struct request *rq)
>  	blk_mq_end_request(rq, sts);
>  }
> =20
> +static bool zloop_rdwr_is_ok(struct zloop_device *zlo, struct request *r=
q)
> +{
> +	struct zloop_zone *zone =3D &zlo->zones[rq_zone_no(rq)];
> +	bool is_write =3D op_is_write(req_op(rq));
> +	enum blk_se_status sts =3D zloop_zone_element_status(zlo, zone, is_writ=
e);
> +	bool ret;
> +
> +	/*
> +	 * Fail read and write operations if the storage element serving the
> +	 * target zone is not healthy.
> +	 */
> +	if (sts >=3D BLK_SE_STS_DEGRADED)
> +		return false;
> +
> +	/*
> +	 * Check the zone condition: do not allow any read and write operations
> +	 * to offline zones, and allow only read operations to full and
> +	 * read-only zones.
> +	 */
> +	spin_lock(&zone->wp_lock);
> +	switch (zone->cond) {
> +	case BLK_ZONE_COND_OFFLINE:
> +		ret =3D false;
> +		break;
> +	case BLK_ZONE_COND_FULL:
> +	case BLK_ZONE_COND_READONLY:
> +		ret =3D !is_write;
> +		break;
> +	default:
> +		ret =3D true;
> +		break;
> +	}
> +	spin_unlock(&zone->wp_lock);
> +
> +	return ret;
> +}
> +
>  static blk_status_t zloop_queue_rq(struct blk_mq_hw_ctx *hctx,
>  				   const struct blk_mq_queue_data *bd)
>  {
> @@ -889,6 +1038,30 @@ static blk_status_t zloop_queue_rq(struct blk_mq_hw=
_ctx *hctx,
>  		return BLK_STS_IOERR;
>  	}
> =20
> +	if (zlo->nr_elements) {
> +		/*
> +		 * Do not allow commands while the restoration of storage
> +		 * elements is in progress.
> +		 */
> +		if (READ_ONCE(zlo->restore_in_progress))
> +			return BLK_STS_IOERR;
> +
> +		/*
> +		 * Check if we can accept data access commands based on the
> +		 * health state of the storage element serving the target zone.
> +		 */
> +		switch (req_op(rq)) {
> +		case REQ_OP_READ:
> +		case REQ_OP_WRITE:
> +		case REQ_OP_ZONE_APPEND:
> +			if (!zloop_rdwr_is_ok(zlo, rq))
> +				return BLK_STS_IOERR;
> +			break;
> +		default:
> +			break;
> +		}
> +	}

[Severity: Medium]
Does rejecting writes to BLK_ZONE_COND_FULL zones in zloop_rdwr_is_ok()
prevent ZLOOP_ZONE_SEQ_ERROR recovery?

zloop_seq_write_prep() advances zone->wp and calls zloop_set_zone_full()
when zone->wp reaches zone_end before zloop_do_rw() writes to the backing
file.  If that write fails, zloop_complete_rq() sets ZLOOP_ZONE_SEQ_ERROR
so the next I/O will resynchronize zone->wp and zone->cond from the file
size in zloop_rw() -> zloop_update_seq_zone().  When zlo->nr_elements is
non-zero, however, zloop_queue_rq() calls zloop_rdwr_is_ok() before
queueing cmd->work, so subsequent writes or zone appends to that zone fail
immediately with BLK_STS_IOERR and never reach zloop_rw().

[ ... ]

> +static int zloop_execute_restore_elements(struct zloop_device *zlo)
> +{
> +	struct gendisk *disk =3D zlo->disk;
> +	struct zloop_zone *zone;
> +	struct blk_se *se;
> +	enum blk_se_status sts;
> +	unsigned int memflags, i;
> +	int ret =3D 0;
> +
> +	/* Wait for all IOs to complete. */
> +	memflags =3D blk_mq_freeze_queue(disk->queue);
> +	blk_mq_unfreeze_queue(disk->queue, memflags);
> +
> +	/* First, truncate all files for sequential zones. */
> +	for (i =3D 0, zone =3D zlo->zones; i < zlo->nr_zones; i++, zone++) {
> +		ret =3D zloop_restore_zone_file(zlo, zone);
> +		if (ret) {
> +			pr_err("zloop%d: restore zone %u file failed %d\n",
> +			       zlo->id, i, ret);
> +			break;
> +		}
> +	}
> +
> +	/*
> +	 * Now, resetore the condition of all zones, unless we failed to
> +	 * truncate all files, in which case we report a restoration error
> +	 * without changing the zone conditions.
> +	 */
> +	if (!ret) {
> +		for (i =3D 0, zone =3D zlo->zones; i < zlo->nr_zones; i++, zone++)
> +			zloop_restore_zone_cond(zlo, zone);
> +		sts =3D BLK_SE_STS_OK;
> +	} else {
> +		sts =3D BLK_SE_STS_RESTORE_ERROR;
> +	}

[Severity: Medium]
If zloop_restore_zone_file() fails on zone i, do sequential zones before i
keep stale in-memory zone conditions and write pointers?

Those earlier sequential zones have already had their backing files
truncated to 0 bytes by vfs_truncate(), but zloop_restore_zone_cond() is
skipped when ret is non-zero and ZLOOP_ZONE_SEQ_ERROR is only set on the
zone that failed.  Earlier non-empty zones are left with 0-byte backing
files while retaining their old zone->cond, non-zero zone->wp, and
open_zones_lru_list accounting, which zloop_report_zones() will then
report as-is.

> +
> +	/*
> +	 * Update the status of all elements being restored based on the zone
> +	 * restoration result.
> +	 */
> +	for (i =3D 0, se =3D zlo->elements; i < zlo->nr_elements; i++, se++) {
> +		if (READ_ONCE(se->status) =3D=3D BLK_SE_STS_RESTORE_IN_PROGRESS)
> +			WRITE_ONCE(se->status, sts);
> +	}
> +
> +	return ret;
> +}
> +
> +static int zloop_restore_elements(struct gendisk *disk)
> +{

[ ... ]

> +	msleep(5000);
> +
> +	mutex_lock(&zlo->stor_elements_lock);
> +
> +	/*
> +	 * Re-check the device as its removal may have been initiated
> +	 * while we were sleeping.
> +	 */
> +	if (test_bit(GD_DEAD, &disk->state) ||
> +	    data_race(READ_ONCE(zlo->state)) =3D=3D Zlo_deleting) {
> +		ret =3D -ENODEV;
> +		goto clear_restore;
> +	}
> +
> +	/* Restore the elements. */
> +	ret =3D zloop_execute_restore_elements(zlo);

[Severity: Medium]
Can zloop_restore_elements() and zloop_remove_element() race with
zloop_ctl_remove() right after the post-sleep check?

zloop_ctl_remove() sets zlo->state to Zlo_deleting under zloop_ctl_mutex
without synchronizing with zlo->stor_elements_lock:

CPU0                                  CPU1
zloop_restore_elements()
  mutex_lock(&zlo->stor_elements_lock)
  /* checks GD_DEAD and zlo->state */
                                      zloop_ctl_remove()
                                        mutex_lock_killable(&zloop_ctl_mute=
x)
                                        WRITE_ONCE(zlo->state, Zlo_deleting)
                                        mutex_unlock(&zloop_ctl_mutex)
                                        del_gendisk(zlo->disk)
  zloop_execute_restore_elements()
    zloop_restore_zone_file()
      vfs_truncate(..., 0)
                                        zloop_forget_cache()
                                          /* sees active zone->cond / wp */
                                          vfs_truncate(..., old_wp - start)
    zloop_restore_zone_cond()

Because zloop_execute_restore_elements() truncates all sequential zone
files to 0 in a first pass before resetting zone->cond and zone->wp in a
second pass, a concurrent zloop_forget_cache() still sees active zone
conditions and extends the truncated zone files back to old_wp.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115233327.9415=
86-1-dlemoal@kernel.org?part=3D8
