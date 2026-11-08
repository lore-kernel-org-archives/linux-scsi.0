Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794172314;
	b=4iR5/zCT5PULSYL9TRKvHyq5UTjv4rrB5bu1YPB4SnxmCATVVDrqzXm9VDbqRTI/RMxI
	 l1DQL4lDmwGNnmFbgpQ/1TBOE2MxZMntn9fvGBJBeC+s6TpNs81ZnXGjviJZIjy4n8zST
	 Q5MueBNR9Tmk9/4X286O7a/th6zZ/BgS/Wt8uMH3t9XHR6b9vfiPTDvZQWIn1OEp9olJ8
	 pXpClYfz9R99o7ijA4HB8wUpNlWYXtAkP4gi3VcsFWpTXHuqfdTLKQmTr0zVAzsrNJAt6
	 XnzmNXpeUv/VO8kOLvCfdWXXqh0Bm19sru4XrRFL1CeNQ1Bv6xPj8hkHPY57kZ34i8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794172314;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Zuv0erDXALkLzPznE4ao0E8yImeI0bZ++ZtknNRLK60=;
	b=kiyKITaiu8yU2dsmTJI+O2k4xcj0kz0Y40m0HBagX8vtYkxtOpF7XE23DofqbxypE6My
	 PtEymdl1NdBRJXGqt20SFSuyg4dHb+/uFbZuBnkvnDv6EIcxjjARftiy45yYUruhDEOfW
	 g9LXPnaRHxMVzfFnpweQnroqvq+n5gUApJmcMjVNPGHzDoa/UxCYu5JKMmITe7LidAfnJ
	 Qj4ooAzQzPRXozbP1DB8m3Lvm/EU2D4Sui8KffHMPAtPC+ryEvlOqkZRD5fvk1nh70fIe
	 cB7/zY+53KLRA7kuwrr6OveBVq1dy1nDX7HDIMo8L2axN8/tzQpAxBa3dlUK57/plew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mPNAmcKZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52928606A31C;
	Sun,  8 Nov 2026 21:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mPNAmcKZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555391F0089F;
	Sun,  8 Nov 2026 21:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794172313;
	bh=Zuv0erDXALkLzPznE4ao0E8yImeI0bZ++ZtknNRLK60=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mPNAmcKZRb/FxXy1fWa8QBnyDEFjxAqDySj2ZHMQuzre2h8dBO1zySja6BA4J2Vs0
	 pLFRZJjuhxVzSxyK07QTxts84t+3m5zL6e7Smf3R/RmSgZFjfEHxi3fICOBwKP1k2N
	 a+1Z3ZLnjp+M1+NaQVElQERr6fqCq0EKzZpl0AicX3iarU9KoQTfpACsEfYwsGsPqG
	 8vbcWza3A4djnAYfO/Udaa22hhu4B2ZBpuBaAgJIcLPuHl8Jfid46SKPK2T2Yl8l30
	 ilDlWMs9eq2FET1JEhZLe5bOLHBymyyfosyEAbskLDtqGosOJD15sxfaPoh8Sroszb
	 +6QOYQR1AB4lw==
Message-ID: <sashiko-outbox-204065@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 07/29] libmultipath: Add delayed removal support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.garry@linux.dev>, james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de, michael.christie@oracle.com
In-Reply-To: <20261108204733.557995-8-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
 <20261108204733.557995-8-john.garry@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 21:11:52 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 6 potential
issues to consider:
- [High] libmultipath: race between mpath_add_device() and
  mpath_can_remove_head()
- [High] libmultipath: UAF from unsynchronized remove_work on head
  teardown
- [Medium] libmultipath: drv_module ref leak in mpath_can_remove_head()
- [Medium] libmultipath: missing requeue kick in
  mpath_delayed_removal_secs_store()
- [Medium] libmultipath: remove_work initialized in
  mpath_alloc_head_disk() instead of mpath_head_init()
- [Low] libmultipath: unchecked HZ overflow in
  mpath_delayed_removal_secs_store()
--

commit ac55fad5ec89b5f2112b89a2a217ff2d12ec50d8
Author: John Garry <john.garry@linux.dev>

libmultipath: Add delayed removal support

This commit adds delayed head removal support to libmultipath, keeping the
multipath disk present and requeuing I/O for a configurable duration when a=
ll
paths are lost.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index fd78218244472..cdf8fbc5105b3 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -67,6 +67,9 @@ int mpath_add_device(struct mpath_device *mpath_device,=
 struct gendisk *disk,
>  	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
>  	mutex_unlock(&mpath_head->lock);
> =20
> +	if (cancel_delayed_work(&mpath_head->remove_work))
> +		module_put(mpath_head->drv_module);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(mpath_add_device);

[ ... ]

> @@ -482,6 +494,39 @@ static void mpath_requeue_work(struct work_struct *w=
ork)
>  	}
>  }
> =20
> +bool mpath_can_remove_head(struct mpath_head *mpath_head)
> +{
> +	unsigned long delay;
> +	bool remove =3D false;
> +
> +	mutex_lock(&mpath_head->lock);
> +	/*
> +	 * Ensure that no one could remove this module while the head
> +	 * remove work is pending.
> +	 */
> +	if (mpath_head_queue_if_no_path(mpath_head) &&
> +	    !check_mul_overflow(mpath_head->delayed_removal_secs, HZ, &delay) &&
> +	    try_module_get(mpath_head->drv_module)) {
> +		mod_delayed_work(mpath_wq, &mpath_head->remove_work, delay);

[Severity: Medium]
Does this leak a reference on mpath_head->drv_module if
mpath_head->remove_work is already pending?

try_module_get() increments the module refcount before mod_delayed_work() is
called.  When remove_work is already pending, mod_delayed_work() updates the
existing timer in place and returns true, but neither mpath_remove_head_wor=
k()
nor cancel_delayed_work() in mpath_add_device() will run more than once to
drop the extra reference, preventing the driver module from unloading.

> +	} else {
> +		remove =3D true;
> +	}
> +
> +	mutex_unlock(&mpath_head->lock);
> +	return remove;
> +}
> +EXPORT_SYMBOL_GPL(mpath_can_remove_head);

[Severity: High]
Can a race between mpath_add_device() and mpath_can_remove_head() remove an
active mpath_head while paths are present on dev_list, or cancel remove_work
after dev_list becomes empty?

mpath_delete_device() drops mpath_head->lock before calling
mpath_synchronize() and before the caller invokes mpath_can_remove_head(),
and neither mpath_can_remove_head() nor mpath_remove_head_work() rechecks
list_empty(&mpath_head->dev_list) under mpath_head->lock:

CPU0                                  CPU1
mpath_delete_device()
  mutex_lock(&mpath_head->lock)
  list_del_rcu(&dev1->siblings)
  last_path =3D true
  mutex_unlock(&mpath_head->lock)
                                      mpath_add_device()
                                        mutex_lock(&mpath_head->lock)
                                        list_add_tail_rcu(&dev2->siblings,
                                                          &mpath_head->dev_=
list)
                                        mutex_unlock(&mpath_head->lock)
                                        cancel_delayed_work(&remove_work)
  mpath_synchronize()
mpath_can_remove_head()
  mutex_lock(&mpath_head->lock)
  remove =3D true (or queues remove_work)
  mutex_unlock(&mpath_head->lock)
  --> removes head with dev2 on dev_list

Conversely, because mpath_add_device() calls cancel_delayed_work() after
releasing mpath_head->lock, if dev2 is deleted on another CPU and
mpath_can_remove_head() queues remove_work before CPU1 runs
cancel_delayed_work(), CPU1 cancels the newly armed remove_work even though
dev_list is now empty.

> +
> +static void mpath_remove_head_work(struct work_struct *work)
> +{
> +	struct mpath_head *mpath_head =3D container_of(to_delayed_work(work),
> +			struct mpath_head, remove_work);
> +	struct module *drv_module =3D mpath_head->drv_module;
> +
> +	mpath_head->mpdt->remove_head(mpath_head);
> +	module_put(drv_module);
> +}

[Severity: High]
Can mpath_remove_head_work() cause a use-after-free on mpath_head during he=
ad
teardown or path flapping?

Unlike requeue_work and partition_scan_work, neither mpath_put_disk() nor
mpath_head_uninit() cancels or flushes mpath_head->remove_work, and
mpath_add_device() uses non-synchronous cancel_delayed_work():

CPU0 (mpath_wq)                       CPU1
mpath_remove_head_work()
  [work dequeued; PENDING cleared]
                                      mpath_add_device()
                                        cancel_delayed_work(&remove_work)
                                          --> returns false
                                      mpath_delete_device()
                                      mpath_can_remove_head()
                                        --> returns true (or re-arms timer)
                                      remove_head() frees mpath_head
  mpath_head->mpdt->remove_head()  <-- use-after-free

Similarly, if remove_work is armed and a subsequent path probe fails and te=
ars
down the head before reaching mpath_add_device(), mpath_head can be freed
while remove_work is still pending in the timer wheel.

>  void mpath_remove_disk(struct mpath_head *mpath_head)
>  {
>  	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
> @@ -529,6 +574,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_he=
ad,
>  	mpath_head->disk->private_data =3D mpath_head;
>  	mpath_head->disk->fops =3D &mpath_ops;
> =20
> +	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
> +	mpath_head->delayed_removal_secs =3D 0;
> +
>  	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
> =20
>  	return 0;

[Severity: Medium]
Should remove_work and delayed_removal_secs be initialized in
mpath_head_init() instead of mpath_alloc_head_disk()?

If mpath_alloc_head_disk() is called again on an existing mpath_head after
mpath_put_disk(), resetting delayed_removal_secs to 0 here without clearing
MPATH_HEAD_QUEUE_IF_NO_PATH leaves the flag out of sync with
delayed_removal_secs.  mpath_available_path() then continues returning true
when no paths exist, causing mpath_bdev_submit_bio() to requeue I/O
indefinitely even though delayed_removal_secs is 0.  Initializing remove_wo=
rk
in mpath_head_init() alongside requeue_work and partition_scan_work also
ensures remove_work is initialized before mpath_add_device() can touch it.

[ ... ]

> +ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
> +			const char *buf, size_t count)
> +{
> +	unsigned int sec;
> +	ssize_t ret;
> +
> +	ret =3D kstrtouint(buf, 0, &sec);
> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_lock(&mpath_head->lock);
> +	mpath_head->delayed_removal_secs =3D sec;
> +	if (sec)
> +		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
> +	else
> +		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
> +	mutex_unlock(&mpath_head->lock);

[Severity: Low]
On 32-bit architectures, can storing a large sec value set
MPATH_HEAD_QUEUE_IF_NO_PATH while mpath_can_remove_head() immediately remov=
es
the head?

mpath_delayed_removal_secs_store() accepts any unsigned int and sets
MPATH_HEAD_QUEUE_IF_NO_PATH without checking whether sec * HZ overflows
unsigned long.  When sec > ULONG_MAX / HZ on 32-bit systems, I/O is requeued
on path loss, but check_mul_overflow() in mpath_can_remove_head() fails and
falls back to immediate head removal with zero delay.

> +
> +	/*
> +	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
> +	 * by its reader.
> +	 */
> +	mpath_synchronize(mpath_head);
> +
> +	return count;
> +}

[Severity: Medium]
When delayed_removal_secs is set to 0, does this leave previously queued BI=
Os
stalled on mpath_head->requeue_list?

Clearing MPATH_HEAD_QUEUE_IF_NO_PATH stops new BIOs from being queued when =
no
paths are available, but without calling
mpath_schedule_requeue_work(mpath_head) after mpath_synchronize(), BIOs that
were already added to requeue_list while MPATH_HEAD_QUEUE_IF_NO_PATH was set
are not kicked to fail.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108204733.5579=
95-1-john.garry@linux.dev?part=3D7
