Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794172171;
	b=aSK3b0sty4F/Gq3FsjlRZku0E331rGtpKb66PeJ7na0L/cnf8TWkCkX0tlKvgSkRuMaI
	 rskgi0B1VSYcxE6ylvdM+Xz9B2fVBI7c/GI26d3Y7e3+kSY6cXdqvNKqppXBw60C9tfsw
	 5qYGHAnZE1jSuJg45Lp7WNwDfBejGiKAu1QEiZMJd9lC9DEaQdcCcu4YvMjhOggjd0f2H
	 I5QrvQSZb63ipRFxSRF6DXAfiLaadKwMhYqZDZ0muLeZMpDjlNZIH4JY8TPnBph5mEMGh
	 BXd0WT65qvl610B55qtenHqbnVMPeK8YHCdD8+4dreS3qz7dgTqyLainjVCapvMFxng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794172171;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ptv3snd7osWdb/GUMVwBQi3loT0ZYBbR+FGOHyT/vqE=;
	b=ruBQ+mSZM6fdfRK7ygz7TANghqsJbrhZsz+kmZHu9xFiW4pzdiFiqw5wMr+JxYIjnFBm
	 WjAwE9BAQRcVQ4pyHzdYyfiA/LSZGUKJJ5YdVZ3tnX99yFcEpg4R1lhOnm8JGgeYNYzCo
	 6FliVaS3APvkWBG+8Dgylhym7zyTUESdJpkgd1oe89HrtKVcsGXg83OWzhHTAxYf6zSYj
	 Ixy5jE0rZ+onkA6xjELhrzGlfTiKKH6UMSoTbLSDUh9fOTCudX8Y0pwRgJZ8PN62sdCMV
	 8euEwCYc6AQxKBP7OlTk2zsFzF8SJqnPLdhtHfrtGaqF/0UAvCgmVTCOAbna3Ap1BsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gdvdNww7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958E7606A320;
	Sun,  8 Nov 2026 21:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gdvdNww7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C901F0089F;
	Sun,  8 Nov 2026 21:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794172171;
	bh=Ptv3snd7osWdb/GUMVwBQi3loT0ZYBbR+FGOHyT/vqE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gdvdNww7Jg00rBKlZY4qbolfgkaKXIjYcswZ8j3VDlNe1Pw1JvIgXv6kIWvLn2LZG
	 vZWdaKDkP1VFLl9LcT1AWhWSTq5fH1Qcbn/SD8kcimQpc3E3/9uxvHzb274HsXxI/b
	 Po+RM2X0y75TfKJDHsJk/119tZxtPHb0ZS8sDcEhCPrsJK+rHaJp2Arh4y+Y2ZXnH6
	 q67Gi4+sDkUDynJtzvFIJK83z57EGUspl8GW+eOgvbuGxediMk8ocaJu3o0MIuBoqr
	 lppvGeUVxgtM6f0GDSLsvmW+qsTO310kCRkCiJR02J5K0zKN2Kb3bunr7QbzVFbPOe
	 sV5jsGa171ACw==
Message-ID: <sashiko-outbox-204063@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 09/29] libmultipath: Add support for block device
 IOCTL
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.garry@linux.dev>, james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de, michael.christie@oracle.com
In-Reply-To: <20261108204733.557995-10-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
 <20261108204733.557995-10-john.garry@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 21:09:30 +0000
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
- [High] libmultipath: deadlock in mpath_bdev_ioctl() holding SRCU lock
  across ioctl
--

commit df75a2df3968a2931d7f98024b2fce55905a7703
Author: John Garry <john.garry@linux.dev>

libmultipath: Add support for block device IOCTL

This commit adds mpath_bdev_ioctl() and wires up .ioctl and .compat_ioctl
in mpath_ops to forward block device ioctls to an active path's gendisk.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index ae5a73d570b33..d59d7ba81087f 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -455,11 +455,53 @@ static void mpath_bdev_release(struct gendisk *disk)
>  	mpath_put_head(mpath_head);
>  }
> =20
> +static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
> +		    unsigned int cmd, unsigned long arg)
> +{
> +	struct gendisk *disk =3D bdev->bd_disk;
> +	struct mpath_head *mpath_head =3D mpath_gendisk_to_head(disk);
> +	struct mpath_device *mpath_device;
> +	int srcu_idx, err;
> +
> +	/*
> +	 * This check is duplicated from sd_ioctl() as we don't pass the
> +	 * partition bdev to fops->ioctl. That is not yet possible as the
> +	 * per-path disk is hidden and, as such, does not have partitions
> +	 * scanned.
> +	 */
> +	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO))
> +		return -ENOIOCTLCMD;
> +
> +	srcu_idx =3D srcu_read_lock(&mpath_head->srcu);
> +	mpath_device =3D mpath_find_path(mpath_head);
> +	if (!mpath_device) {
> +		err =3D -EWOULDBLOCK;
> +		goto out_unlock;
> +	}
> +
> +	if (!mpath_device->disk->fops->ioctl) {
> +		err =3D -ENOTTY;
> +		goto out_unlock;
> +	}
> +
> +	err =3D mpath_device->disk->fops->ioctl(
> +			mpath_device->disk->part0, mode, cmd, arg);
> +out_unlock:
> +	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
> +	return err;
> +}

[Severity: High]
Can holding mpath_head->srcu across fops->ioctl() self-deadlock when the
underlying ioctl synchronously blocks or removes the path?

For example, when fops->ioctl() dispatches to sd_ioctl() -> scsi_ioctl(), a
host reset ioctl (SG_SCSI_RESET) on ib_srp or a host rescan ioctl on
pqi/hpsa can synchronously block or remove the SCSI device in the same
task:

mpath_bdev_ioctl()
  srcu_read_lock(&mpath_head->srcu)
  sd_ioctl()
    scsi_ioctl()
      scsi_ioctl_reset()
        ...
          srp_reset_host()
            srp_reconnect_rport()
              scsi_block_targets()
                ...
                  scsi_device_block()
                    scsi_mpath_dev_clear_path()
                      mpath_synchronize()
                        synchronize_srcu(&mpath_head->srcu)  <-- deadlocks

Waiting for the mpath_head->srcu grace period while the same task holds
srcu_read_lock(&mpath_head->srcu) hangs the caller in uninterruptible sleep
and blocks subsequent path removals and state transitions on mpath_head.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108204733.5579=
95-1-john.garry@linux.dev?part=3D9
