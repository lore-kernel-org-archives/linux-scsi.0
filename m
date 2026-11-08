Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794171943;
	b=UPOqx5zzNQAXPL189mLBufoDjubBYnAK0mqpYYiuHR0hggtiP9pAPhTdE08Nl3beUytA
	 MFFT0vmlqWkV6ZEOcylBAiyaDYdFkiFMhyfpi0IH2bqTHjtoxTYOM5sG1Y0lWmLhiVYwN
	 WOKlVqW6baIgG3iiaDBfRvhAO5pFlIPzN7khH/Bflc1axVZ4ad4LfdotSIky54gXeoLi9
	 cfnJnQ7eJrfExOb1OFxwSMpPPWbV5tDhriWyD3E36AcLxIu3gIfUnYiNzWoGiJxxdHaD3
	 YB984l5CLpwE4Zy8kCKlCGJ2p4YJfz14/QotndIv7JRlxljfZZS5qU3MAjBxmFr9eFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794171943;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZS/+9RoeC/5ysy9/4XL0GzlvzEZI1ShMbYQDvBVHstM=;
	b=OZMHjfBTgE+qckI2cyEAe4QjkX8zsKNM9ItbA7lzGeKrIgpF+xR7GxcU4RkpdiXLtBRz
	 i1Ve8aE5E4IHoqlp5Qd2NZJsHD330aHORC6a2LkzbOgqk9RFAtf9Lc015OT0MKIYdPCnT
	 NqOHUCkbeFS0VOIqRMnMbE0jJIEMzw1qsMlVEYAhjIpc5pVCVRYnK4HcLqdPksuY9YO6Y
	 73/h7lY/GGZih8iG33keuYH1APgMk8TIAsE0hsO2wfElsVt1bOfbWcw/JlAsooEe16492
	 FaMA2EF/6+NyEIIyokqhruCkyAlqltS/9rnzbwEjAtJZkjasEkwaKJu3hiNfIAzQR+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YfjmgAZc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4450606A32A;
	Sun,  8 Nov 2026 21:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YfjmgAZc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E061D1F0089F;
	Sun,  8 Nov 2026 21:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794171942;
	bh=ZS/+9RoeC/5ysy9/4XL0GzlvzEZI1ShMbYQDvBVHstM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YfjmgAZcN+KTHtaJb+IOc4fpE2cEcSNRbs+lXm0dyiKNSvElj8xbcRZ9BpGKuZVGU
	 I66byZGB+n6Q78sn0EEh/dnAmIpFSiHjU7ihfKb2yw7Fn0LVCoWWsl+5dG0DW9S1LV
	 nL6nKV/0TDijp06VZYnFRVXMl7kj+ozBQ4tpdswEU6t+iqSaSIGcE+RMxLkyphXmtY
	 FiixpQLdo1jqY3PTS72Y+BTtMgOundtsZZjurmFW9ZUkBoqQyOS4pLG8Lk9qLCbgww
	 8fBunvLUzmbrf5+ygTyhGvJTokKL+VfgG82VKCFELbq2iuCKvVz5l8+5kwJose9F3+
	 /eIeR7GTLgU2A==
Message-ID: <sashiko-outbox-204050@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 20/29] scsi-multipath: provide callbacks for path
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.garry@linux.dev>, james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de, michael.christie@oracle.com
In-Reply-To: <20261108204733.557995-21-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
 <20261108204733.557995-21-john.garry@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 21:05:41 +0000
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
- [High] scsi: scsi_multipath: scsi_mpath_available_path() ignores
  sdev->access_state
- [Medium] scsi: scsi_multipath: mpath_device access_state never updated
--

commit 6f83cc4eccb483172140b55837b87755b4421b91
Author: John Garry <john.garry@linux.dev>

scsi-multipath: provide callbacks for path state

This commit implements the .is_disabled, .is_optimized, and .available_path
multipath callbacks for SCSI multipath devices using sdev_state and
access_state.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 4c965650c2bd3..2f47c39d82936 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -298,7 +298,56 @@ static struct bio *scsi_mpath_clone_bio(struct bio *=
bio)
>  	return clone;
>  }
> =20
> +static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =3D
> +				to_scsi_mpath_device(mpath_device);
> +	struct scsi_device *sdev =3D scsi_mpath_dev->sdev;
> +	unsigned char access_state =3D READ_ONCE(sdev->access_state) &
> +					SCSI_ACCESS_STATE_MASK;
> +
> +	if (READ_ONCE(sdev->sdev_state) !=3D SDEV_RUNNING)
> +		return true;
> +
> +	if (access_state =3D=3D SCSI_ACCESS_STATE_OPTIMAL ||
> +	    access_state =3D=3D SCSI_ACCESS_STATE_ACTIVE)
> +		return false;
> +
> +	return true;
> +}
> +
> +static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =3D
> +				to_scsi_mpath_device(mpath_device);
> +	struct scsi_device *sdev =3D scsi_mpath_dev->sdev;
> +	unsigned char access_state =3D READ_ONCE(sdev->access_state) &
> +					SCSI_ACCESS_STATE_MASK;
> +
> +	if (READ_ONCE(sdev->sdev_state) !=3D SDEV_RUNNING)
> +		return false;
> +
> +	return access_state =3D=3D SCSI_ACCESS_STATE_OPTIMAL;
> +}

[Severity: Medium]
Does scsi_mpath_is_optimized() disagree with mpath_device->access_state for
active/non-optimized paths?

scsi_multipath_sdev_init() initializes mpath_device->access_state to
MPATH_STATE_OPTIMIZED, and nothing updates it when sdev->access_state
changes:

lib/multipath.c:__mpath_find_path() {
	...
		switch(mpath_device->access_state) {
		case MPATH_STATE_OPTIMIZED:
		    if (distance < found_distance) {
			    found_distance =3D distance;
			    found =3D mpath_device;
		    }
		    break;
		case MPATH_STATE_NONOPTIMIZED:
	...
}

Because __mpath_find_path(), mpath_round_robin_path(), and
mpath_queue_depth_path() select paths using mpath_device->access_state
rather than mpdt->is_optimized(), an active/non-optimized path is still
treated as optimized during path selection.  Under the NUMA policy,
mpath_numa_path() then checks scsi_mpath_is_optimized() on every bio, sees
false, and calls __mpath_find_path() to rescan dev_list and pick the same
non-optimized path again on every I/O.

> +
> +static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =3D
> +				to_scsi_mpath_device(mpath_device);
> +	struct scsi_device *sdev =3D scsi_mpath_dev->sdev;
> +	enum scsi_device_state sdev_state =3D READ_ONCE(sdev->sdev_state);
> +
> +	if (sdev_state =3D=3D SDEV_RUNNING || sdev_state =3D=3D SDEV_QUIESCE ||
> +	    sdev_state =3D=3D SDEV_BLOCK || sdev_state =3D=3D SDEV_CREATED_BLOC=
K)
> +		return true;
> +
> +	return false;
> +}

[Severity: High]
Should scsi_mpath_available_path() also check sdev->access_state?

When all paths are in SDEV_RUNNING with an unusable ALUA state such as
standby, unavailable, or offline, scsi_mpath_is_disabled() returns true for
every path and mpath_find_path() returns NULL.  Because
scsi_mpath_available_path() still returns true for any SDEV_RUNNING device,
mpath_bdev_submit_bio() queues bios onto mpath_head->requeue_list instead
of failing them with bio_io_error(), leaving I/O stuck on requeue_list.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108204733.5579=
95-1-john.garry@linux.dev?part=3D20
