Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755499;
	b=dneMywkP1etdAUcoVoVJY1x3sZEgWUd5fXqRTR/22OFFzfkWAKY3EjYb4OgQM78hBht3
	 mrJWHp7q9Ls8S8DFZ5WIUVyqVdKdnISvQCD34cKB2aQjRGOT2sn7A84P8uSgJDWTPI/s6
	 rPGIJAPvGUl6I/MILsp/rD3RlFWdTO/nuEzE0EW5aS35O62YXsXnxL/ECJUtgGPxSgSYv
	 IMSDNs//+oOIvSw2y6YAaxkb4fF9SHt2uFjdHDDSTG04XEG5jdB6r/FLqOrcTBvjULj7u
	 fv3JgAEWWaDHXmapjS5Rm6+/r2x2U+uStDEwsaxZ6HAjnQdOcxJf+LzF1Rx7Sk0YSIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755499;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=aeySnVCHRXp0bo5gZYzsrQfuO9C0T53k2iVn5ohH3Dw=;
	b=YGP5ZsmdVZNIDfzb1b5/R8a6piEmnLwwCTOuhVNvL4BaWEgG7V61dFbWhv/DvXTY5xdb
	 BCKX6imNHAkF2eefuNgyur9fgote9VIoENCwWnMXvjtnIu6KN0LHFUWiz68kziS4/zlaN
	 MbMuaQ0JOYCBOIayv6XOZIcU7uAtm6SzXdp+wCst46kxLVE0DcDkULQaZ3lEooz5mFVe+
	 1FBr7jukf7xPUbjS7U//0ZSPZxrrv1TI+6kj90ndFPO3JFvKRRQndbY20Wm4Tw4Yesx91
	 i5TKD0n9KGy/F8Xbu2IY0fXKuqBAHh36Kw+TtQlZpfrgGrffBLJQMY8Q973e1tT2Ezg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SbronYTx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36750606A31D
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 15:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SbronYTx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E751D1F000C5;
	Sun, 15 Nov 2026 15:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755499;
	bh=aeySnVCHRXp0bo5gZYzsrQfuO9C0T53k2iVn5ohH3Dw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=SbronYTxAI1bmBxGwyiBvEE/8rijvobzJt/2YgrhHPCOxHuv4b3SxIJpTDqIjyLD6
	 D0iSMZb8BhTgMH72gJUt8vX4AK6A7dVgHifemv2Ii83Zl2Xernx3yfbKhvtFlmKCEz
	 PlrUgDCnEb1+YQvdfY61BkXMIs2bORjqRBpnuHjkRAvOhJKw4R4v3RXyWiIyBDZh4O
	 YEwXZE3bLubSWKRWRytoU3h4njPE0zM4V+clQ/lF9JCVGm/7fNVd078CPr/Z8J5XCL
	 yRCzf7Im7QEmIeL9SzLXhSfL+yLA1uoXhNy2HBQRKSXDhaNohUScf1CDsstw3jOvuF
	 rrDLFRqtJzOIg==
Message-ID: <sashiko-outbox-215613@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 08/13] zloop: add storage element emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <20261115145015.938426-9-dlemoal@kernel.org>
References: <20261115145015.938426-1-dlemoal@kernel.org>
 <20261115145015.938426-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 15:11:38 +0000
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
- [High] zloop: inverted zone check and missing unlock in
  zloop_restore_zone_file()
- [Medium] zloop: bool return type on zloop_prep_rq() corrupts
  blk_status_t error codes
- [Medium] zloop: broken write element removal check and zone cond
  transition
- [Low] zloop: wrong enum blk_se_status return type on
  zloop_zone_element_is_ok()
--

commit add2167f11ea8b6280aa470bbfffca31f313cf06
Author: Damien Le Moal <dlemoal@kernel.org>

zloop: add storage element emulation

This commit adds storage element depopulation and restoration emulation to
the zloop driver, controlled via the new stor_elements option and exposed
through zloop_se_ops.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 99b9efef98741..8274dae7664bf 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c

[ ... ]

> @@ -289,22 +314,80 @@ static bool zloop_do_open_zone(struct zloop_device =
*zlo,

[ ... ]

> +static enum blk_se_status zloop_zone_element_is_ok(struct zloop_device *=
zlo,
> +						   struct zloop_zone *zone,
> +						   bool for_write)
> +{
> +	enum blk_se_status sts =3D
> +		zloop_zone_element_status(zlo, zone, for_write);
> +
> +	return sts < BLK_SE_STS_DEGRADED;
> +}

[Severity: Low]
Should zloop_zone_element_is_ok() have a return type of bool instead of
enum blk_se_status, since it returns a boolean comparison result?

[ ... ]

> @@ -885,34 +1007,65 @@ static void zloop_complete_rq(struct request *rq)

[ ... ]

> +static bool zloop_prep_rq(struct zloop_device *zlo, struct request *rq)
> +{
> +	struct zloop_zone *zone =3D &zlo->zones[rq_zone_no(rq)];
> +	bool is_write =3D op_is_write(req_op(rq));
> +	blk_status_t ret =3D BLK_STS_OK;
> +
> +	if (!zlo->nr_elements &&
> +	    (!zlo->ordered_zone_append || req_op(rq) !=3D REQ_OP_ZONE_APPEND))
> +		return BLK_STS_OK;
> +
> +	spin_lock(&zone->wp_lock);
> +
> +	/*
> +	 * If storage element emulation is enabled, check the health state of
> +	 * the storage element serving the zone and the zone condition: do not
> +	 * allow any operation to zones served by an unusable storage element,
> +	 * operations to offline zones, and allow only read operations to
> +	 * read-only zones.
> +	 */
> +	if (zlo->nr_elements) {
> +		if (!zloop_zone_element_is_ok(zlo, zone, is_write) ||
> +		    zone->cond =3D=3D BLK_ZONE_COND_OFFLINE ||
> +		    (zone->cond =3D=3D BLK_ZONE_COND_READONLY && is_write)) {
> +			ret =3D BLK_STS_IOERR;
> +			goto unlock;
> +		}
> +	}
> +
> +	/*
> +	 * If we need to strongly order zone append operations, set the request
> +	 * sector to the zone write pointer location now instead of when the
> +	 * command work runs.
> +	 */
> +	if (zlo->ordered_zone_append && req_op(rq) =3D=3D REQ_OP_ZONE_APPEND)
> +		ret =3D zloop_set_zone_append_sector(zlo, zone, rq);
> +
> +unlock:
> +	spin_unlock(&zone->wp_lock);
> +
> +	return ret;
>  }

[Severity: Medium]
Does the bool return type of zloop_prep_rq() turn non-zero blk_status_t
values into 1 (BLK_STS_NOTSUPP)?  When zloop_prep_rq() fails with
BLK_STS_IOERR or BLK_STS_ZONE_OPEN_RESOURCE, zloop_queue_rq() returns
BLK_STS_NOTSUPP (-EOPNOTSUPP) to blk-mq instead.

[ ... ]

> @@ -1021,6 +1188,354 @@ static int zloop_report_zones(struct gendisk *dis=
k, sector_t sector,

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
> +	if (paired_se && READ_ONCE(paired_se->status) !=3D BLK_SE_STS_REMOVED)
> +		WRITE_ONCE(paired_se->status, BLK_SE_STS_REMOVED);
> +
> +	return ret;
> +}
> +
> +static int zloop_remove_element(struct gendisk *disk, unsigned int eleme=
nt_id)
> +{
> +	struct zloop_device *zlo =3D disk->private_data;
> +	struct blk_se *se, *rse, *rpse =3D NULL;
> +	unsigned int i, nr_se_remaining =3D 0;
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
> +	 * Get the element to remove. If it is a read element, the associated
> +	 * write element must also be removed.
> +	 */
> +	rse =3D &zlo->elements[element_id - 1];
> +	if (rse->type =3D=3D BLK_SE_TYPE_READ)
> +		rpse =3D &zlo->elements[rse->paired_id - 1];
> +
> +	/* If the element is already removed, we have nothing to do. */
> +	if (READ_ONCE(rse->status) =3D=3D BLK_SE_STS_REMOVED)
> +		goto unlock;
> +
> +	/*
> +	 * Make sure we do not allow removing all storage elements as that does
> +	 * not make any sense. This is consistent with the device advertized
> +	 * limit of SCSI and ATA devices supporting the storage element
> +	 * depopulation feature.
> +	 */
> +	for (i =3D 0, se =3D zlo->elements; i < zlo->nr_elements; i++, se++) {
> +		if (se =3D=3D rse || se =3D=3D rpse)
> +			continue;
> +		if (READ_ONCE(se->status) <=3D BLK_SE_STS_DEGRADED)
> +			nr_se_remaining++;
> +	}
> +	if (!nr_se_remaining) {
> +		ret =3D -EINVAL;
> +		goto unlock;
> +	}

[Severity: Medium]
Can zloop_remove_element() allow removing every write element in
ZLOOP_STOR_ELEMENTS_PAIRS mode?  When removing a BLK_SE_TYPE_WRITE element,
rpse is NULL and the paired BLK_SE_TYPE_READ elements remain in
BLK_SE_STS_OK and are counted in nr_se_remaining, so nr_se_remaining is
always non-zero and all write elements on the device can be removed.
Counting BLK_SE_STS_DEGRADED elements in nr_se_remaining also allows
removing the last healthy element when zloop_zone_element_is_ok() rejects
I/O to degraded elements (sts < BLK_SE_STS_DEGRADED).

In addition, if a removed read+write element pair fails restoration
(leaving both elements in BLK_SE_STS_RESTORE_ERROR and their zones in
BLK_ZONE_COND_OFFLINE), removing the BLK_SE_TYPE_WRITE element in
zloop_execute_remove_element() unconditionally sets those zones to
BLK_ZONE_COND_READONLY even though the paired read element cannot serve
reads.

[ ... ]

> +static int zloop_restore_zone_file(struct zloop_device *zlo,
> +				   struct zloop_zone *zone)
> +{
> +	int ret =3D 0;
> +
> +	if (!test_bit(ZLOOP_ZONE_CONV, &zone->flags))
> +		return 0;
> +
> +	mutex_lock(&zone->lock);
> +
> +	ret =3D vfs_truncate(&zone->file->f_path, 0);
> +	if (ret)
> +		set_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
> +
> +	return ret;
> +}
> +
> +static void zloop_restore_zone_cond(struct zloop_device *zlo,
> +				    struct zloop_zone *zone)
> +{
> +	mutex_lock(&zone->lock);
> +	spin_lock(&zone->wp_lock);

[Severity: High]
Is the ZLOOP_ZONE_CONV check in zloop_restore_zone_file() inverted, and is
mutex_unlock(&zone->lock) missing before return?

As written, zloop_restore_zone_file() skips sequential zones, truncates
conventional zone backing files to 0 bytes, and returns with zone->lock
held, which immediately deadlocks when zloop_execute_restore_elements()
calls zloop_restore_zone_cond() on the same zone.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115145015.9384=
26-1-dlemoal@kernel.org?part=3D8
