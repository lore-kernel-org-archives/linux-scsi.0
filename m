Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794173033;
	b=ip/LB0kBL+p4tlOh+cKKjJF8z0+eH5lT1QsjWkusDdATiKtNDxHozt0aLRznahnzSFKT
	 o96Z9BOivvoU8kD1timn5a4CdvIXAGGZzyBjVs9LQKb0xxLnJ4vswdkIILyGQCmE04BlZ
	 UVSwV21LkG2/7k72LTymij0sxEnQGsliOTkjZGS7028YOJAuK5cU+D3V6riJbUL/XwBit
	 bA2iTpjTllgoa0nOipJOJ6bxssdmSYte8GzxJZYsOGoQjyQn1cs0/lAmHtPJS/hFe2AkO
	 zuoEFE3KX+c7rnSSBCoy/Q7utWxYvJqyAbr98imjRwE5IVuxWC7AG/NFcOXtIkY8c3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794173033;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pWwOmeK3PXo6B9Tmxse2yeN85/eb9g3Ti1gMqbxCDIw=;
	b=WjcmnuCutJvcPv50BWCoIR8bcw+/09q1QX/ijg0vjRbwbVSE/Dxu3rfAnGxvIS+GsIZb
	 iSqsv+pCtfHib07/vDe0TbhGaBgGMqgRxGq2LDHtD1QkiPevsCv3uV4+Lc7/lkYSEIh+/
	 eg/ZtdyawIWZCRy+AjuVl3yPFKU34NG9mgtbujbeCRnwYmG0bbVPVg2SEvwd2OWAD7ldh
	 b9HKrUB2+CwZd53FGBAzzpwVxP9+3byG/aQfijairdNTA03VpoFJdejh1Nc7tu0yTH6ak
	 PuWNf9FBHJqeff40/GmO2iwYcFLyjtaApUa4F+ZcPG/9a2Que0D82EacGHrb6i18ukA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SrlZAI7s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A19D606A31C;
	Sun,  8 Nov 2026 21:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SrlZAI7s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802291F0089F;
	Sun,  8 Nov 2026 21:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794173032;
	bh=pWwOmeK3PXo6B9Tmxse2yeN85/eb9g3Ti1gMqbxCDIw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SrlZAI7spGtAkDtz7usy9Il3tyx0v3uQU26ibxapBTTS+X0rlk0/nJZNpDhWljOyf
	 uyKlotHwpii35SJEG4EFAA6pqehfYwKeNI3wU6DtlyT+cuPTLv0cBbQExOZUk4ZG7L
	 0Rkcx8GD/OYb9CSG6JvEqESEq3e6hAl9JhzIcS5NZQ1s4cnfOytdZjpZJZKI4CcR/N
	 kHlzgfz1uP5MEY2ZVtkFdkzdgmsVEQA5ttRKEHQHOJUkUd3v+odX/VutN8N4AtQiJd
	 xTxygCvOqo/L/ZbLonln/wWAXOasFfuLGZxlz/bBdjBNTGcTOlk7CX/ZJYMA6kXQI8
	 dD6EYYOmyiowA==
Message-ID: <sashiko-outbox-204072@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 26/29] scsi: sd: support multipath disk
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.garry@linux.dev>, james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de, michael.christie@oracle.com
In-Reply-To: <20261108204733.557995-27-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
 <20261108204733.557995-27-john.garry@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 21:23:51 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 7 potential
issues to consider:
- [High] scsi: sd: premature sd_mpath_remove() before del_gendisk() in
  sd_remove()
- [High] scsi: sd: broken revalidation and state sync in
  sd_mpath_revalidate_head()
- [Medium] scsi: sd: clear current_path after mpath_delete_device() in
  sd_mpath_remove()
- [Medium] scsi: sd: premature sd_mpath_disk list unlink races with
  sd_mpath_probe()
- [Medium] scsi: sd: uncancelled remove_work in sd_mpath_fail_probe()
  causes UAF
- [Medium] scsi: sd: parent sd_mpath_disk->dev deleted before child
  mpath_head->disk
- [Low] scsi: sd: unsigned sdkp->index makes >=3D 0 check always true
--

commit a00d9c64612f4369c0c2dd5d2bf64b95ed52be50
Author: John Garry <john.garry@linux.dev>

scsi: sd: support multipath disk

This commit adds support for attaching and managing SCSI multipath disks in
the sd driver, creating a multipath head gendisk while keeping per-path
gendisks hidden.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index fb87b1663ad62..ab4ce6c2a8dd2 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c

[ ... ]

> @@ -817,7 +835,8 @@ static void scsi_disk_release(struct device *dev)
>  {
>  	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
> =20
> -	ida_free(&sd_index_ida, sdkp->index);
> +	if (sdkp->index >=3D 0)
> +		ida_free(&sd_index_ida, sdkp->index);
>  	put_device(&sdkp->device->sdev_gendev);
>  	free_opal_dev(sdkp->opal_dev);
> =20
> @@ -4021,6 +4040,90 @@ static int sd_format_disk_name(char *prefix, int i=
ndex, char *buf, int buflen)

[Severity: Low]
Is sdkp->index >=3D 0 always true here?

struct scsi_disk declares index as u32 in drivers/scsi/sd.h, while
sd_mpath_probe() sets sdkp->index =3D -1.  This triggers a -Wtype-limits
warning under W=3D1 and still calls ida_free(&sd_index_ida, 0xffffffffU) on
multipath per-path disks.  Changing struct scsi_disk::index to int matches
sd_mpath_disk::disk_index and local index in sd_probe().

>  	return 0;
>  }
> =20
> +#ifdef CONFIG_SCSI_MULTIPATH
> +static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
> +{
> +	struct sd_mpath_disk *sd_mpath_disk =3D sdkp->sd_mpath_disk;
> +	struct scsi_mpath_head *scsi_mpath_head =3D sd_mpath_disk->scsi_mpath_h=
ead;
> +	struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +	struct gendisk *disk =3D mpath_head->disk;
> +	struct queue_limits *sdkp_lim =3D &sdkp->disk->queue->limits;
> +	struct queue_limits lim;
> +	unsigned int memflags;
> +	int ret;
> +
> +	lim =3D queue_limits_start_update(disk->queue);
> +	memflags =3D blk_mq_freeze_queue(disk->queue);
> +
> +	lim.logical_block_size =3D sdkp_lim->logical_block_size;
> +	lim.physical_block_size =3D sdkp_lim->physical_block_size;
> +	lim.io_min =3D sdkp_lim->io_min;
> +	lim.io_opt =3D sdkp_lim->io_opt;
> +
> +	queue_limits_stack_bdev(&lim, sdkp->disk->part0, 0,
> +					disk->disk_name);
> +
> +	/* TODO: setup integrity and zoned limits */
> +	lim.max_write_streams =3D sdkp_lim->max_write_streams;
> +	lim.write_stream_granularity =3D sdkp_lim->write_stream_granularity;
> +	ret =3D queue_limits_commit_update(disk->queue, &lim);
> +
> +	set_capacity_and_notify(disk, get_capacity(sdkp->disk));
> +
> +	mpath_revalidate_paths(mpath_head);
> +
> +	blk_mq_unfreeze_queue(disk->queue, memflags);
> +
> +	return ret;
> +}

[Severity: High]
Can probing a standby ALUA path overwrite the multipath head disk capacity
with 0?

On ALUA arrays, standby or unavailable paths succeed INQUIRY VPD page 0x83
and attach to scsi_mpath_head, but fail READ CAPACITY in
sd_revalidate_disk(), leaving get_capacity(sdkp->disk) at 0.  Calling
sd_mpath_revalidate_head() unconditionally from sd_probe() sets the live
mpath_head->disk capacity to 0, causing subsequent I/O on the multipath disk
to fail bio_check_eod() with -EIO.

In addition, sd_mpath_revalidate_head() has several other state sync issues:
- It is only called from sd_probe() and never from sd_revalidate_disk() or
  sd_rescan(), so LUN resizes or standby-to-active transitions do not update
  mpath_head->disk.
- It never calls set_disk_ro(disk, sdkp->write_prot), leaving write-protect=
ed
  multipath disks openable for writes via mpath_ops.
- When queue_limits_commit_update() fails, sd_mpath_revalidate_head() still
  updates capacity and paths, and sd_probe() only logs a warning before
  calling sd_mpath_add_disk(sdkp) with uncommitted queue limits.
- For TYPE_ZBC disks, queue_limits_stack_bdev() inherits BLK_FEAT_ZONED onto
  mpath_head->disk->queue even though zoned multipath support is not set up.

[ ... ]

> @@ -4050,13 +4153,260 @@ static const struct attribute_group sd_mpath_dis=
k_attr_group =3D {

[ ... ]

> +static void sd_mpath_remove(struct scsi_disk *sdkp)
> +{
> +	struct sd_mpath_disk *sd_mpath_disk =3D sdkp->sd_mpath_disk;
> +	struct scsi_device *sdp =3D sdkp->device;
> +	struct scsi_mpath_device *scsi_mpath_dev =3D sdp->scsi_mpath_dev;
> +	struct mpath_device *mpath_device =3D &scsi_mpath_dev->mpath_device;
> +	struct scsi_mpath_head *scsi_mpath_head =3D sd_mpath_disk->scsi_mpath_h=
ead;
> +	struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +	bool remove =3D false;
> +
> +	mpath_synchronize(mpath_head);
> +
> +	if (mpath_clear_current_path(mpath_device))
> +		mpath_synchronize(mpath_head);
> +
> +	mpath_delete_device(mpath_device);

[Severity: Medium]
Can mpath_device be re-cached into mpath_head->current_path[node] when
mpath_clear_current_path() runs before mpath_delete_device()?

When sd_remove() is triggered by driver unbind or module unload,
sdev->sdev_state remains SDEV_RUNNING, so scsi_mpath_is_disabled() returns
false.  Because mpath_device is still on mpath_head->dev_list until
mpath_delete_device() unlinks it, a concurrent path lookup can repopulate
current_path[node]:

CPU0                                  CPU1
sd_mpath_remove()
  mpath_clear_current_path(mpath_device)
                                      mpath_bdev_submit_bio()
                                        mpath_find_path()
                                          __mpath_find_path()
                                            rcu_assign_pointer(
                                              current_path[node],
                                              mpath_device)
  mpath_delete_device(mpath_device)
  ...
  mpath_device->disk =3D NULL;
                                      mpath_bdev_submit_bio()
                                        mpath_find_path()
                                          /* returns cached mpath_device */
                                        mpath_device->disk->part0
                                          <-- NULL pointer dereference

Calling mpath_delete_device(mpath_device) before mpath_clear_current_path()
prevents __mpath_find_path() from finding mpath_device on dev_list after
current_path is cleared.

> +
> +	mutex_lock(&sd_mpath_disks_lock);
> +	sd_mpath_disk->disk_count--;
> +	if (!sd_mpath_disk->disk_count && mpath_can_remove_head(mpath_head)) {
> +		list_del_init(&sd_mpath_disk->entry);
> +		remove =3D true;
> +	}
> +	mutex_unlock(&sd_mpath_disks_lock);

[Severity: Medium]
Can unlinking sd_mpath_disk and dropping sd_mpath_disks_lock before teardown
completes race with a concurrent sd_mpath_probe() for the same
scsi_mpath_head?

In sd_mpath_remove(), sd_mpath_remove_head(), and sd_mpath_fail_probe(),
sd_mpath_disk is removed from sd_mpath_disks_list and sd_mpath_disks_lock is
released before device_del(), mpath_remove_disk(), and sd_mpath_put_disk()
finish tearing down the shared mpath_head:

CPU0                                  CPU1
sd_mpath_remove()
  mutex_lock(&sd_mpath_disks_lock)
  list_del_init(&sd_mpath_disk->entry)
  mutex_unlock(&sd_mpath_disks_lock)
                                      sd_mpath_probe()
                                        mutex_lock(&sd_mpath_disks_lock)
                                        sd_mpath_find_disk() -> NULL
                                        mpath_alloc_head_disk(mpath_head)
                                          /* fails with -EINVAL, or races
                                           * with old sd_mpath_disk_release=
()
                                           * calling mpath_put_disk() */
  device_del(&sd_mpath_disk->dev)
  mpath_remove_disk(mpath_head)
  sd_mpath_put_disk(sd_mpath_disk)

Depending on timing, mpath_alloc_head_disk() fails with -EINVAL because
mpath_head->disk is still non-NULL, device_add() fails with -EEXIST on the
duplicate "scsi_mpath_disk%d" name, or a delayed sd_mpath_disk_release()
calls mpath_put_disk(mpath_head) after the new probe has allocated a new
mpath_head->disk.

> +	mpath_remove_sysfs_link(mpath_device);
> +	mpath_device->disk =3D NULL;
> +
> +	if (remove) {
> +		device_del(&sd_mpath_disk->dev);
> +		mpath_remove_disk(mpath_head);
> +	}
> +	sd_mpath_put_disk(sd_mpath_disk);
> +}

[Severity: Medium]
Does calling device_del(&sd_mpath_disk->dev) before
mpath_remove_disk(mpath_head) delete the parent device before its child
gendisk?

sd_mpath_probe() sets mpath_head->parent =3D &sd_mpath_disk->dev, and
mpath_device_set_live() registers mpath_head->disk as a child of that
device.  In sd_mpath_remove(), sd_mpath_remove_head(), and
sd_mpath_fail_probe(), calling device_del(&sd_mpath_disk->dev) first clears
sd_mpath_disk->dev.kobj.parent and tears down the parent sysfs directory
while mpath_head->disk is still registered, causing del_gendisk() inside
mpath_remove_disk() to emit child KOBJ_REMOVE uevents with truncated
DEVPATHs.  Also, in sd_mpath_remove(), mpath_remove_sysfs_link(mpath_device)
runs after dropping sd_mpath_disks_lock, so a concurrent last-path removal
or sd_mpath_remove_head() can remove mpath_head->disk while
mpath_remove_sysfs_link() is still accessing disk_to_dev(mpath_head->disk).

[ ... ]

> +static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
> +{
> +	struct sd_mpath_disk *sd_mpath_disk =3D sdkp->sd_mpath_disk;
> +	struct scsi_mpath_device *scsi_mpath_dev;
> +	struct mpath_device *mpath_device;
> +	struct scsi_device *sdp =3D sdkp->device;
> +	struct scsi_mpath_head *scsi_mpath_head;
> +	struct mpath_head *mpath_head;
> +	bool remove =3D false;
> +
> +	if (!sd_mpath_disk)
> +		return;
> +
> +	scsi_mpath_dev =3D sdp->scsi_mpath_dev;
> +	mpath_device =3D &scsi_mpath_dev->mpath_device;
> +	scsi_mpath_head =3D sd_mpath_disk->scsi_mpath_head;
> +	mpath_head =3D &scsi_mpath_head->mpath_head;
> +
> +	mutex_lock(&sd_mpath_disks_lock);
> +	sd_mpath_disk->disk_count--;
> +	if (!sd_mpath_disk->disk_count) {
> +		list_del_init(&sd_mpath_disk->entry);
> +		remove =3D true;
> +	}
> +	mutex_unlock(&sd_mpath_disks_lock);
> +	mpath_device->disk =3D NULL;
> +
> +	if (remove) {
> +		device_del(&sd_mpath_disk->dev);
> +		mpath_remove_disk(mpath_head);
> +	}
> +	sd_mpath_put_disk(sd_mpath_disk);
> +}

[Severity: Medium]
Can sd_mpath_fail_probe() free scsi_mpath_head while mpath_head->remove_work
is still pending?

When delayed_removal_secs > 0 and the last path is removed in
sd_mpath_remove(), mpath_can_remove_head() schedules mpath_head->remove_work
and leaves sd_mpath_disk on sd_mpath_disks_list with disk_count =3D=3D 0.  =
If a
new path starts probing before remove_work fires, sd_mpath_probe() incremen=
ts
disk_count to 1, but remove_work is not cancelled until mpath_add_device() =
in
sd_mpath_add_disk().  If sd_probe() fails earlier and calls
sd_mpath_fail_probe(), sd_mpath_disk is torn down without cancelling
remove_work:

CPU0                                  kworker
sd_mpath_remove() (last path)
  mpath_can_remove_head()
    mod_delayed_work(...,
      &mpath_head->remove_work, ...)
sd_probe() (new path)
  sd_mpath_probe()
    sd_mpath_disk->disk_count++
  device_add_disk() -> fails
  sd_mpath_fail_probe()
    sd_mpath_put_disk()
      scsi_mpath_put_head()
scsi_mpath_remove_device()
  scsi_mpath_put_head()
    kfree(scsi_mpath_head)
                                      mpath_remove_head_work()
                                        sd_mpath_remove_head()
                                          <-- use-after-free

[ ... ]

> @@ -4348,6 +4728,9 @@ static void sd_remove(struct scsi_device *sdp)
>  	if (scsi_autopm_get_device(sdkp->device) < 0)
>  		blk_mark_disk_dead(sdkp->disk);
> =20
> +	if (sdp->scsi_mpath_dev)
> +		sd_mpath_remove(sdkp);
> +
>  	device_del(&sdkp->disk_dev);
>  	del_gendisk(sdkp->disk);
>  	if (!sdkp->suspended)

[Severity: High]
Can calling sd_mpath_remove() before del_gendisk(sdkp->disk) cause a NULL
pointer dereference or use-after-free while REQ_MPATH requests are still
queued on sdkp->disk->queue?

Cloned multipath bios submitted to sdkp->disk->part0 remain queued or in
flight on sdkp->disk->queue until del_gendisk(sdkp->disk) freezes and drains
that queue.  When the last path is removed, sd_mpath_remove() drops the last
reference to sd_mpath_disk->dev, and sd_mpath_disk_release() calls
mpath_put_disk(mpath_head) (setting mpath_head->disk =3D NULL) and frees
sd_mpath_disk before del_gendisk(sdkp->disk) runs:

CPU0                                  CPU1
sd_remove()
  sd_mpath_remove(sdkp)
    mpath_remove_disk(mpath_head)
    sd_mpath_put_disk(sd_mpath_disk)
      sd_mpath_disk_release()
        mpath_put_disk(mpath_head)
          mpath_head->disk =3D NULL;
        kfree(sd_mpath_disk)
                                      sd_init_command()
                                        scsi_mpath_start_request(req)
                                          disk =3D mpath_head->disk;
                                          blk_queue_io_stat(disk->queue)
                                            <-- NULL pointer dereference
  del_gendisk(sdkp->disk)

Completing REQ_MPATH requests in scsi_mpath_end_request() or
scsi_mpath_clone_end_io() also access the released mpath_head->disk or
requeue work after mpath_put_disk() has already flushed it.  Furthermore,
because __scsi_remove_device() still holds sdev->scsi_mpath_dev's reference
on scsi_mpath_head until after sd_remove() returns, scsi_mpath_put_head() in
sd_mpath_disk_release() does not wait in mpath_head_uninit() when the
multipath disk is still open, freeing sd_mpath_disk while mpath_head->parent
still points to &sd_mpath_disk->dev (used by dev_warn_ratelimited() in
mpath_bdev_submit_bio()).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108204733.5579=
95-1-john.garry@linux.dev?part=3D26
