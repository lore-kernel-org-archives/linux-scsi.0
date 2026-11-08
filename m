Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794171991;
	b=LVCCwC6WKSv/nf6galqilacVhIzmYq6Eymvz6yt2PiNPqYH2po40w5+VqwB1x0wRAIFc
	 c0I5uu7q4oNgeyzEhsIN1oVymfXiy95g9ll5ooit8fXSB70/n/zXiJYd+nTv9cQybZpWI
	 22d+rEJuMHd+RedqyHaJzHcfoIUL4ywajcUtF3ZofjEys+RLUab50NF6fpLZkTN2JDuJL
	 8jWlaY7bjdgui8jaWEeLCT9u5XbM2pXsU0uGv/NxJWlgN3WJZauWs/++9/06II2YiqlMS
	 t7UWjj0HE8VcvtJjfPe7OP3iD42W5LJ5YUoF3FF9yXYG3XZEB854vtCF5iNySLSjs0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794171991;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Nx8NbrxCZOch5TiFRdnylBkuk4A6CeRjyr0fvH0GKvc=;
	b=2odSs6sxBmoMapkRVNVR7zl753UiZefxmUxL6uhbeW/FthuA4PACBZ1X2y9FbhHXcld7
	 xeHP4Pa1Kj8OONHLcX26ITWDybPw9gq/Iqo98Me6rxyNqzMD8S5ZZ2iM//iEq2erqz+h6
	 4FnLKoTpZe9DAJMU17rZNJvlyEA5O7uwg2XtrR0bYYxUdQ6MYf9s6LK/rbhC5/X9XA+vj
	 EuvLPpBamt9SirVSBXWK2FmgpS0++zeIocNqtKXqxOuO84nHB5kUMP5di7d8siqAvasCr
	 65jj98XFEDqpLCe7Rb9Uh4pZ8w5P0YX/pBcr3qe9p6Gldo5j9DIYG4FaECkJWHJpJNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="I++kCRa/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FFB606A320;
	Sun,  8 Nov 2026 21:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I++kCRa/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FF11F0089F;
	Sun,  8 Nov 2026 21:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794171990;
	bh=Nx8NbrxCZOch5TiFRdnylBkuk4A6CeRjyr0fvH0GKvc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I++kCRa/bVOn81OGy5QqhKx6oH7GMCaJAG9ji53gMP6iYeuL2OsrG/2o8uxUvopNj
	 ZdE6IHHv+tD3E2S8EGx3iqguu1LFFH1vAEwCwwzCpIblM1Afkdasptx1xFh44tc7m2
	 r4F5/AcmFdUASdI0I+eS2bmTlmhJp7bDFp5S5AVUH+LP5cRB+vxp09ujWrTDw1TJ4P
	 2vhgXGMGppHSTzMW9LSZjBiAmVGh89qSID3ciWrC21dujQORWyA/CUN1S7ZkRXlPPn
	 iZkutQ6m+wsEjXHKR6rT3FMPoACDuiak/6+9vLWOa/VS3qFKfYvQ8YUCwtWg1g7/zy
	 4D1KEbNnkQjxg==
Message-ID: <sashiko-outbox-204054@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 17/29] scsi-multipath: clear path when device is
 blocked
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.garry@linux.dev>, james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de, michael.christie@oracle.com
In-Reply-To: <20261108204733.557995-18-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
 <20261108204733.557995-18-john.garry@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 21:06:28 +0000
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
- [High] scsi: multipath: UAF and NULL deref in scsi_device_block() on
  removal race
- [High] scsi: multipath: NULL deref and UAF in scsi_device_block()
  during LUN scan
--

commit 6f23ec119648804e57ce4572c175483a5109ea7a
Author: John Garry <john.garry@linux.dev>

scsi-multipath: clear path when device is blocked

This commit introduces scsi_mpath_dev_clear_path() and calls it from
scsi_device_block() to clear the active multipath device path when a SCSI
device is blocked.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 36bc995e4e250..1950034f580f4 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
[ ... ]
> @@ -3037,6 +3038,8 @@ static void scsi_device_block(struct scsi_device *s=
dev, void *data)
>  		scsi_stop_queue(sdev);
> =20
>  	mutex_unlock(&sdev->state_mutex);
> +	if ((err =3D=3D 0) && sdev->scsi_mpath_dev)
> +		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
> =20
>  	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
>  		  __func__, dev_name(&sdev->sdev_gendev), state);

[Severity: High]
Can calling scsi_mpath_dev_clear_path() after dropping sdev->state_mutex
race with __scsi_remove_device() and cause a use-after-free or NULL
pointer dereference on the multipath head?

scsi_block_targets() iterates target devices via starget_for_each_device()
without holding shost->scan_mutex.  Once scsi_device_block() unlocks
sdev->state_mutex, __scsi_remove_device() can transition sdev->sdev_state
from SDEV_BLOCK to SDEV_DEL and tear down the multipath head while
starget_for_each_device() still holds a reference to sdev:

CPU0                                  CPU1
scsi_device_block()
  mutex_lock(&sdev->state_mutex)
  __scsi_internal_device_block_nowait()
  mutex_unlock(&sdev->state_mutex)
                                      __scsi_remove_device()
                                        mutex_lock(&sdev->state_mutex)
                                        sdev->sdev_state =3D SDEV_DEL
                                        mutex_unlock(&sdev->state_mutex)
                                        ...
                                        scsi_mpath_remove_device()
                                          scsi_mpath_remove_head()
                                            scsi_mpath_put_head()
                                            scsi_mpath_dev->scsi_mpath_head=
 =3D NULL
  scsi_mpath_dev_clear_path()
    mpath_clear_current_path()        <-- use-after-free on mpath_head
    mpath_synchronize(mpath_head)     <-- NULL deref or use-after-free

Because scsi_mpath_remove_head() drops the reference on scsi_mpath_head
and sets scsi_mpath_dev->scsi_mpath_head to NULL while leaving
mpath_device.mpath_head dangling, mpath_clear_current_path() reads the
freed mpath_device->mpath_head and mpath_synchronize() dereferences a NULL
or freed mpath_head.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 8e229357e62c5..67e9010d54782 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -240,6 +240,16 @@ static int scsi_multipath_sdev_init(struct scsi_devi=
ce *sdev)
>  	return 0;
>  }
> =20
> +void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
> +{
> +       struct mpath_device *mpath_device =3D &scsi_mpath_dev->mpath_devi=
ce;
> +       struct scsi_mpath_head *scsi_mpath_head =3D scsi_mpath_dev->scsi_=
mpath_head;
> +       struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +
> +       if (mpath_clear_current_path(mpath_device))
> +               mpath_synchronize(mpath_head);
> +}
> +
>  static void scsi_mpath_clone_end_io(struct bio *clone)
>  {
>  	struct bio *master_bio =3D clone->bi_private;

[Severity: High]
What prevents scsi_device_block() from calling scsi_mpath_dev_clear_path()
while scsi_mpath_dev_alloc() is still initializing or freeing
sdev->scsi_mpath_dev during LUN scanning?

sdev is already linked onto starget->devices and set to SDEV_RUNNING in
scsi_add_lun() before scsi_mpath_dev_alloc() runs.  Inside
scsi_mpath_dev_alloc(), scsi_multipath_sdev_init() publishes
sdev->scsi_mpath_dev before scsi_mpath_head and mpath_device.mpath_head
are populated, and the error path in scsi_multipath_sdev_uninit() frees
sdev->scsi_mpath_dev before clearing the pointer:

CPU0                                  CPU1
scsi_add_lun()
  scsi_mpath_dev_alloc()
    scsi_multipath_sdev_init()
      sdev->scsi_mpath_dev =3D ...
                                      scsi_block_targets()
                                        ...
                                        scsi_device_block()
                                          scsi_mpath_dev_clear_path()
                                            mpath_clear_current_path()
                                              mpath_head->current_path[node]
                                              <-- NULL pointer dereference
    ...
    sdev->scsi_mpath_dev->mpath_device.mpath_head =3D ...

If scsi_mpath_dev_alloc() fails (for example when a LUN has no VPD page 83
device ID) and calls scsi_multipath_sdev_uninit(), a concurrent
scsi_device_block() also risks a use-after-free on sdev->scsi_mpath_dev.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108204733.5579=
95-1-john.garry@linux.dev?part=3D17
