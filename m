Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794219319;
	b=EgosQuZcCnnaisqGvU8pUn0YBpb5/W2oLNOwmSS/lg5o0GxwcwNJcSgUt/Ek7eJTaHq5
	 hcpIksRDEdhY5RleS39VbDhk35YT/ywWleh50ufFlBffbie/LeDx9vVtDDR3TBhnABF+i
	 4QnjQA9cljwFNql0yIfScG2exk/adTYpnGgA+DWoh+PngTU9RMEAmpGjx4G+Y3uM3pL06
	 s8EFO7APYmchbSEEF6+FKS6+sk6Bcknu3YIeE7XJ5Cv9p+uLxaqR/bcuLvBfS8l1I5mld
	 saXpeG1Fh1h2w/w32PdVrMFhflESqzQ+wwVdA03ii4AP6qEbFOKR/nSLIen6RbB742Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794219319;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eItYlQi70rbEh3Hw1fpXDIKwUujj8rGkN7Fd38u94nk=;
	b=aiuIFM1eSPnuQnjuzqA6hcQJJZFhcymhO8kc068OcXunZJqw9F96Lc3dKWu9xbAmW3bH
	 DXaSm/b6pf4MV6/6mm4xfon1z6nfSCJkk9gB8HBMPyGu31tr5Jnfe2ynRo3O0WUEiNMF9
	 B4N0k7XllPAsw9AEn+PeOas/36fPtVbt3HzNf3YDoijBh1B9dFUPFGaCFHwgPitJY0f4v
	 jlCfV9BU+801GecvplCDDIyWorLZJxHaiyTEEyjQYy4VODZL6e6IxrBjyG7/ZbJd2DAL1
	 VaSBjbIZaGNBMCGQSAXD4/cqrvSpC79sRDbtvq1nQ6uWqPH8JdNBQMDjJLA1WXzpRuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TqQPvkhM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B04606A321
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 10:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TqQPvkhM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68691F0089F;
	Mon,  9 Nov 2026 10:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794219319;
	bh=eItYlQi70rbEh3Hw1fpXDIKwUujj8rGkN7Fd38u94nk=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=TqQPvkhMSIHasEOaL0FiE7IWoTVijm5GUC+rvZIt40NYrYqbC2wl2dcXzDFoz1iv8
	 WjKwg7tbGHUfHTzxeUQtGGnI5ufrOg2Ji7l8Q6v+0XToSwLCKmpIhxUvLW1I8P/Uwh
	 A4tudY68d6rC9FXvYMZTZQJS5IHMSVHvDEVd1Bh8V274aMSzFhwh0oxGvFvvR7rasi
	 BqrFgTxk1w/hQUBvY9FURKXwNRWgaJqYEYq+Ck0+MpP3nTNosiWnOsRigEAWMeciSC
	 xGPtRpqBWKOxoqX814JzlvAelTjWGHO1FaNQMu08YJpdZ1KqoqUV7qtiefGHUZlWwB
	 tfW2v0nwH5Dbg==
Message-ID: <sashiko-outbox-204794@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 07/12] zloop: add storage element emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <20261109095144.819709-8-dlemoal@kernel.org>
References: <20261109095144.819709-1-dlemoal@kernel.org>
 <20261109095144.819709-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 10:15:18 +0000
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
- [Medium] zloop: zloop_update_seq_zone() fails zone reports and reads
  when !zloop_zone_is_ok()
- [Medium] zloop: inconsistent zone conditions and element accounting in
  restore and remove paths
- [Medium] zloop: missing deletion check after msleep() in element
  remove and restore
- [Low] zloop: 1-zone device with multiple storage elements in
  zloop_ctl_add()
--

commit 20458ce8408d80d52134d64889b748a6d50aa2b4
Author: Damien Le Moal <dlemoal@kernel.org>

zloop: add storage element emulation

This commit adds emulation of SMR storage element depopulation and
restoration to the zloop driver via the stor_elements option and
blk_se_ops callbacks.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index e1ad7513fea9b..164f21f15158f 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c

[ ... ]

> @@ -289,22 +315,64 @@ static bool zloop_do_open_zone(struct zloop_device =
*zlo,
>  	}
>  }
> =20

[ ... ]

> +static bool zloop_zone_is_ok(struct zloop_device *zlo, struct zloop_zone=
 *zone)
> +{
> +	bool ret;
> +
> +	spin_lock(&zone->wp_lock);
> +
> +	ret =3D zloop_zone_element_is_ok(zlo, zone, true);
> +	if (ret)
> +		ret =3D zone->cond !=3D BLK_ZONE_COND_OFFLINE &&
> +			zone->cond !=3D BLK_ZONE_COND_READONLY;
> +
> +	spin_unlock(&zone->wp_lock);
> +
> +	return ret;
>  }
> =20
>  static int zloop_update_seq_zone(struct zloop_device *zlo, unsigned int =
zone_no)
> @@ -316,6 +384,15 @@ static int zloop_update_seq_zone(struct zloop_device=
 *zlo, unsigned int zone_no)
> =20
>  	lockdep_assert_held(&zone->lock);
> =20
> +	/*
> +	 * If the zone is served by an element that is not in a good state, fail
> +	 * the operation.
> +	 */
> +	if (!zloop_zone_is_ok(zlo, zone)) {
> +		set_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
> +		return -EIO;
> +	}
> +
>  	ret =3D vfs_getattr(&zone->file->f_path, &stat, STATX_SIZE, 0);

[Severity: Medium]
Can checking zloop_zone_is_ok() in zloop_update_seq_zone() permanently
break zone reporting and reject valid reads on read-only zones?

If vfs_truncate() fails in zloop_restore_zone(), ZLOOP_ZONE_SEQ_ERROR is
set while the zone stays in BLK_ZONE_COND_OFFLINE or
BLK_ZONE_COND_READONLY and the element enters BLK_SE_STS_RESTORE_ERROR.
When bdev_restore_storage_elements() or BLKREPORTZONE then calls
zloop_report_zones(), test_and_clear_bit(ZLOOP_ZONE_SEQ_ERROR, ...)
triggers zloop_update_seq_zone(), which sees !zloop_zone_is_ok(), re-sets
ZLOOP_ZONE_SEQ_ERROR, and returns -EIO on every subsequent zone report:

drivers/block/zloop.c:zloop_report_zones() {
    ...
		if (test_and_clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags)) {
			ret =3D zloop_update_seq_zone(zlo, zone_no);
			if (ret) {
				mutex_unlock(&zone->lock);
				return ret;
			}
		}
    ...
}

In addition, because zloop_zone_is_ok() checks the write element
(for_write =3D true) and rejects BLK_ZONE_COND_READONLY, a REQ_OP_READ to a
zone with ZLOOP_ZONE_SEQ_ERROR set whose write element is removed or
being removed in ZLOOP_STOR_ELEMENTS_PAIRS mode passes zloop_prep_rq()
(which checks the read element), but then fails with -EIO in
zloop_rw() -> zloop_update_seq_zone().

[ ... ]

> @@ -1012,6 +1167,331 @@ static int zloop_report_zones(struct gendisk *dis=
k, sector_t sector,
>  	return nr_zones;
>  }
> =20

[ ... ]

> +static int zloop_execute_remove_element(struct zloop_device *zlo)
> +{
> +	struct gendisk *disk =3D zlo->disk;
> +	struct blk_se *se, *paired_se =3D NULL;
> +	enum blk_zone_cond cond;
> +	struct zloop_zone *zone;
> +	unsigned int memflags, i;
> +	int ret =3D 0;
> +
> +	/* Wait for all IOs to complete. */
> +	memflags =3D blk_mq_freeze_queue(disk->queue);
> +	blk_mq_unfreeze_queue(disk->queue, memflags);
> +
> +	/*
> +	 * If the element to remove is a read element, zones must go offline and
> +	 * the associated write element is also removed.
> +	 */
> +	se =3D &zlo->elements[zlo->remove_element_id - 1];
> +	switch (se->type) {
> +	case BLK_SE_TYPE_RDWR:
> +		cond =3D BLK_ZONE_COND_OFFLINE;
> +		break;
> +	case BLK_SE_TYPE_READ:
> +		cond =3D BLK_ZONE_COND_OFFLINE;
> +		paired_se =3D &zlo->elements[se->paired_id - 1];
> +		break;
> +	case BLK_SE_TYPE_WRITE:
> +		cond =3D BLK_ZONE_COND_READONLY;
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Change the condition of the zones owned by the (pair of) elements
> +	 * being removed and mark the elements removed.
> +	 */
> +	for (i =3D 0, zone =3D zlo->zones; i < zlo->nr_zones; i++, zone++) {
> +		if (zone->wr_se_id !=3D se->id && zone->rd_se_id !=3D se->id)
> +			continue;
> +		mutex_lock(&zone->lock);
> +		spin_lock(&zone->wp_lock);
> +		zloop_set_zone_cond(zlo, zone, cond);
> +		clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
> +		spin_unlock(&zone->wp_lock);
> +		mutex_unlock(&zone->lock);
> +	}
> +
> +	WRITE_ONCE(se->status, BLK_SE_STS_REMOVED);
> +	zlo->nr_removed_elements++;
> +	if (paired_se && READ_ONCE(paired_se->status) !=3D BLK_SE_STS_REMOVED) {
> +		WRITE_ONCE(paired_se->status, BLK_SE_STS_REMOVED);
> +		zlo->nr_removed_elements++;
> +	}
> +
> +	return ret;
> +}
> +
> +static int zloop_remove_element(struct gendisk *disk, unsigned int eleme=
nt_id)
> +{
> +	struct zloop_device *zlo =3D disk->private_data;
> +	struct blk_se *se, *paired_se =3D NULL;
> +	unsigned int nr_remove =3D 1;
> +	int ret =3D 0;
> +
> +	if (test_bit(GD_DEAD, &disk->state) ||
> +	    data_race(READ_ONCE(zlo->state)) =3D=3D Zlo_deleting)
> +		return -ENODEV;
> +
> +	if (zlo->stor_elements =3D=3D ZLOOP_STOR_ELEMENTS_NONE)
> +		return -EOPNOTSUPP;
> +
> +	if (!element_id || element_id > zlo->nr_elements)
> +		return -EINVAL;
> +
> +	mutex_lock(&zlo->stor_elements_lock);
> +
> +	/* If a remove or restore operation is already in progress, bail out. */
> +	if (zlo->remove_element_id || READ_ONCE(zlo->restore_in_progress)) {
> +		ret =3D -EBUSY;
> +		goto unlock;
> +	}
> +
> +	/*
> +	 * Get the element to remove. If it is already removed, we have nothing
> +	 * to do.
> +	 */
> +	se =3D &zlo->elements[element_id - 1];
> +	if (READ_ONCE(se->status) =3D=3D BLK_SE_STS_REMOVED)
> +		goto unlock;
> +
> +	/*
> +	 * If the element to remove is a read element, the associated write
> +	 * element must also be removed.
> +	 */
> +	if (se->type =3D=3D BLK_SE_TYPE_READ) {
> +		paired_se =3D &zlo->elements[se->paired_id - 1];
> +		if (READ_ONCE(paired_se->status) !=3D BLK_SE_STS_REMOVED)
> +			nr_remove =3D 2;
> +	}
> +
> +	/*
> +	 * Make sure we do not allow removing all storage elements as that does
> +	 * not make any sense. This is consistent with the device advertized
> +	 * limit of SCSI and ATA devices supporting the storage element
> +	 * depopulation feature.
> +	 */
> +	if (zlo->nr_removed_elements + nr_remove >=3D zlo->nr_elements) {
> +		ret =3D -EINVAL;
> +		goto unlock;
> +	}
> +
> +	/*
> +	 * Change the elements to be removed to the remove in progress state so
> +	 * that concurrent report elements can see the operation on-going.
> +	 */
> +	WRITE_ONCE(se->status, BLK_SE_STS_REMOVE_IN_PROGRESS);
> +	if (paired_se && READ_ONCE(paired_se->status) !=3D BLK_SE_STS_REMOVED)
> +		WRITE_ONCE(paired_se->status, BLK_SE_STS_REMOVE_IN_PROGRESS);
> +	zlo->remove_element_id =3D element_id;
> +
> +	mutex_unlock(&zlo->stor_elements_lock);
> +
> +	/*
> +	 * Wait a little so that this looks like a real device taking time to
> +	 * operate.
> +	 */
> +	msleep(2000);
> +
> +	mutex_lock(&zlo->stor_elements_lock);
> +
> +	/* Remove the element(s). */
> +	ret =3D zloop_execute_remove_element(zlo);
> +	zlo->remove_element_id =3D 0;
> +
> +unlock:
> +	mutex_unlock(&zlo->stor_elements_lock);
> +
> +	return ret;
> +}
> +
> +static int zloop_restore_zone(struct zloop_device *zlo,
> +			      struct zloop_zone *zone)
> +{
> +	int ret =3D 0;
> +
> +	mutex_lock(&zone->lock);
> +
> +	if (!test_bit(ZLOOP_ZONE_CONV, &zone->flags)) {
> +		ret =3D vfs_truncate(&zone->file->f_path, 0);
> +		if (ret) {
> +			set_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
> +			ret =3D -EIO;
> +			goto unlock;
> +		}
> +	}
> +
> +	spin_lock(&zone->wp_lock);
> +	if (test_bit(ZLOOP_ZONE_CONV, &zone->flags)) {
> +		zloop_set_zone_cond(zlo, zone, BLK_ZONE_COND_NOT_WP);
> +	} else {
> +		zloop_set_zone_empty(zlo, zone);
> +		clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
> +	}
> +	spin_unlock(&zone->wp_lock);
> +
> +unlock:
> +	mutex_unlock(&zone->lock);
> +
> +	return ret;
> +}
> +
> +static int zloop_execute_restore_elements(struct zloop_device *zlo)
> +{
> +	struct gendisk *disk =3D zlo->disk;
> +	struct zloop_zone *zone;
> +	struct blk_se *se;
> +	enum blk_se_status sts =3D BLK_SE_STS_OK;
> +	unsigned int memflags, i;
> +	int ret =3D 0;
> +
> +	/* Wait for all IOs to complete. */
> +	memflags =3D blk_mq_freeze_queue(disk->queue);
> +	blk_mq_unfreeze_queue(disk->queue, memflags);
> +
> +	/*
> +	 * Truncate all files for sequential zones and restore the condition of
> +	 * all zones. If this fails, we will propagate the failure as a
> +	 * restoration error.
> +	 */
> +	for (i =3D 0, zone =3D zlo->zones; i < zlo->nr_zones; i++, zone++) {
> +		ret =3D zloop_restore_zone(zlo, zone);
> +		if (ret) {
> +			pr_err("zloop%d: restore zone %u failed %d\n",
> +			       zlo->id, i, ret);
> +			sts =3D BLK_SE_STS_RESTORE_ERROR;
> +			break;
> +		}
> +	}
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
> +	/*
> +	 * Clear the counter of removed elements so that even if we had an error
> +	 * and set the elements health to BLK_SE_STS_RESTORE_ERROR, then can be
> +	 * removed again.
> +	 */
> +	zlo->nr_removed_elements =3D 0;
> +
> +	return ret;
> +}

[Severity: Medium]
Can zloop_execute_restore_elements() and zloop_remove_element() leave
zone conditions out of sync with element states or allow depopulating all
remaining usable elements?

If zloop_restore_zone() fails on sequential zone i in
zloop_execute_restore_elements(), the loop breaks and sets all restoring
elements to BLK_SE_STS_RESTORE_ERROR.  However, zones before i (including
conventional zones) belonging to those failed elements were already set
to BLK_ZONE_COND_NOT_WP or BLK_ZONE_COND_EMPTY, so they report as online
and writable even though zloop_prep_rq() rejects I/O to them.

Resetting zlo->nr_removed_elements to 0 on restore error also lets
zloop_remove_element() pass the zlo->nr_removed_elements + nr_remove >=3D
zlo->nr_elements check while those elements are still in
BLK_SE_STS_RESTORE_ERROR, allowing the caller to remove all remaining
BLK_SE_STS_OK elements.

In ZLOOP_STOR_ELEMENTS_PAIRS mode, removing a BLK_SE_TYPE_WRITE element
whose paired read element is in BLK_SE_STS_RESTORE_ERROR unconditionally
sets the zones to BLK_ZONE_COND_READONLY even though reads cannot be
served.  In addition, comparing zlo->nr_removed_elements + nr_remove
against zlo->nr_elements in paired mode allows removing every
BLK_SE_TYPE_WRITE element on the device, leaving zero writable zones.

> +
> +static int zloop_restore_elements(struct gendisk *disk)
> +{
> +	struct zloop_device *zlo =3D disk->private_data;
> +	struct blk_se *se;
> +	unsigned int i, n =3D 0;
> +	int ret =3D 0;
> +
> +	if (test_bit(GD_DEAD, &disk->state) ||
> +	    data_race(READ_ONCE(zlo->state)) =3D=3D Zlo_deleting)
> +		return -ENODEV;

[ ... ]

> +	WRITE_ONCE(zlo->restore_in_progress, true);
> +	mutex_unlock(&zlo->stor_elements_lock);
> +
> +	/*
> +	 * Wait a little so that this looks like a real device taking time to
> +	 * operate.
> +	 */
> +	msleep(5000);
> +
> +	mutex_lock(&zlo->stor_elements_lock);
> +
> +	/* Restore the elements. */
> +	ret =3D zloop_execute_restore_elements(zlo);
> +
> +	WRITE_ONCE(zlo->restore_in_progress, false);
> +
> +unlock:
> +	mutex_unlock(&zlo->stor_elements_lock);
> +
> +	return ret;
> +}

[Severity: Medium]
What happens if the zloop device is removed via /dev/zloop-control while
zloop_remove_element() or zloop_restore_elements() is sleeping in
msleep()?

CPU0                              CPU1
zloop_restore_elements()
  /* checks GD_DEAD / Zlo_deleting */
  mutex_unlock(&zlo->stor_elements_lock)
  msleep(5000)
                                  zloop_ctl_remove()
                                    WRITE_ONCE(zlo->state, Zlo_deleting)
                                    del_gendisk(zlo->disk)
                                    zloop_forget_cache(zlo)
  mutex_lock(&zlo->stor_elements_lock)
  zloop_execute_restore_elements()
    blk_mq_freeze_queue(disk->queue)
    zloop_restore_zone()
      vfs_truncate(..., 0)        <-- truncates files on deleted device

Neither zloop_remove_element() nor zloop_restore_elements() re-checks
GD_DEAD or Zlo_deleting after reacquiring zlo->stor_elements_lock.  If
zloop_ctl_remove() runs during the sleep, the waking thread freezes a
queue already torn down by del_gendisk() and truncates all sequential
zone backing files to 0, destroying persisted zone data or corrupting a
newly re-added device reusing the same ID.

[ ... ]

> @@ -1188,6 +1695,69 @@ static int zloop_init_zone(struct zloop_device *zl=
o, struct zloop_options *opts,
>  	return ret;
>  }
> =20
> +#define ZLOOP_MIN_STOR_ELEMENTS			2
> +#define ZLOOP_MAX_STOR_ELEMENTS			32
> +#define ZLOOP_MIN_ZONES_PER_STOR_ELEMENTS	32
> +
> +static int zloop_create_storage_elements(struct zloop_device *zlo)
> +{
> +	struct blk_se *se, *paired_se;
> +	unsigned int i, nr_elems, nr_elements;
> +
> +	/*
> +	 * Calculate the number of storage elements we are going to emulate.
> +	 * To achieve a somewhat realistic emulation, we want at least 2 storage
> +	 * elements, and no more than 32, targeting at least 32 zones per
> +	 * element.
> +	 */
> +	if (zlo->nr_zones <=3D 64)
> +		nr_elements =3D ZLOOP_MIN_STOR_ELEMENTS;
> +	else
> +		nr_elements =3D
> +			min(ZLOOP_MAX_STOR_ELEMENTS,
> +			    zlo->nr_zones / ZLOOP_MIN_ZONES_PER_STOR_ELEMENTS);

[Severity: Low]
Can zloop_create_storage_elements() create storage elements with
nr_zones =3D=3D 0 when a device has only 1 zone?

In zloop_parse_options(), opts->capacity <=3D opts->zone_size passes when
capacity_mb is strictly between zone_size_mb and 2 * zone_size_mb (for
example capacity_mb=3D257, zone_size_mb=3D256), and in zloop_ctl_add(),
nr_zones =3D opts->capacity >> ilog2(opts->zone_size) truncates to 1, which
passes opts->nr_conv_zones >=3D nr_zones when conv_zones=3D0.
zloop_create_storage_elements() then creates 2 elements (or 2 pairs),
leaving the second element (or pair) with nr_zones =3D=3D 0 and allowing
zloop_remove_element() on element 1 to offline the only zone on the
device.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109095144.8197=
09-1-dlemoal@kernel.org?part=3D7
