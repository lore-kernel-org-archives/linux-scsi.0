Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794172038;
	b=DR7Q1vYhTnTdABxF2nwo6ITt14j6Vx0wjufIrXMoHRpfVGwCNarUIhMtbxPq3VzaSWf0
	 sgo/k0bJuHDh8moiMASaKmGI9/dY04ZS22LO5i4GvMGb6cnFIziBfR8CNRPnuFrGSdzWv
	 HpU4hfO0PVpdQgwbiBFGoU1sMSwVcCnM3iwSwhHg5adDYe/622LydWRfDklnq8M2bfoCf
	 Sya05M2lsIzWLdW4ffw2AwiCo4z5SYCgLnTswx9adO+Pf4QIh5UlC0Vap2j8294qcxZhs
	 6ISTjeqP99RhLKCyuTvGhmuexfsP3KF6Z8U9o75mv+gLPNtiE5rPtDBbjHnpOdddImA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794172038;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xJqdmXaMRLuUjZRj45HBi9m9/SkDdkLEvmT6c6aPy9w=;
	b=3OzOQUURUqbqvTFp+9dIvr2U9wIh6haq21ZQyagIST/rIwPf1au55qlFHvJNMzd943we
	 jtd8rp+RahvghwoKSxtx1D9qR7M1iOhJag2lesWZhPcmza+orngpDuudz8o755fc7y51g
	 7P03e4zWiwMhqDaS8XxB+abIQ1hkFfWUjMO9M1V2BgJHfYW9hmUl84K9QT8QdwnmuNRrO
	 nvFjaom6uaVWSeQ7dt9IMgzbqWGf/OHTk/bTmFvNAzOOlU5Dj57+RmiK6mlPvjagpHD/P
	 y3UgAy6cgYge4HV5ImQJgEhpXzR4h9M5rt1iWjpPZ3ovKSvWcbnw5yWjU6+1sxD4MgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="RayU/r54";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0164606A31C;
	Sun,  8 Nov 2026 21:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RayU/r54
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF7D1F0089F;
	Sun,  8 Nov 2026 21:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794172037;
	bh=xJqdmXaMRLuUjZRj45HBi9m9/SkDdkLEvmT6c6aPy9w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RayU/r54hcHrtIb/LaB6KZUh6/la7UfvH1tQYPSm3jKo7t3baamW2wIQR7iusgJQI
	 F3DyeDuW+X32zheseMBpmnVsPeCpVaIr2RIrafK9nSWgWr9JmOU0NSACRGYMKnX3Fh
	 Ery6a32On+7vFfEjCsXo2+ICLgsvHNvm4UVARFSD11wv0McMxt3YI9Xwb0OIiuSsrw
	 KTG1MSCIqTz3k2fSVG4hIfDCEXMBZfRSkMFRHfxOqXigJUQADzuM36W14VJ0qrjWv7
	 XBgHy01C+4PQn3TAl56YD5lAn72fcHChMQmh2aiZ4+/jnXqnqVL8sRtuxQRq8GJNq8
	 G5NaYjN31PVLA==
Message-ID: <sashiko-outbox-204058@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 04/29] libmultipath: Add path selection support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.garry@linux.dev>, james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de, michael.christie@oracle.com
In-Reply-To: <20261108204733.557995-5-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
 <20261108204733.557995-5-john.garry@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 21:07:16 +0000
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
- [Medium] libmultipath: inconsistent path optimization check between
  is_optimized() and access_state
--

commit 5d198416c184ad80e962a53ac50fbd829ed2c691
Author: John Garry <john.garry@linux.dev>

libmultipath: Add path selection support

This commit adds multipath path selection support for NUMA, round-robin,
and queue-depth I/O policies along with path access state abstractions.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 93c0ca8b390b1..b8ea8478037ef 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -8,8 +8,245 @@
>  #include <linux/multipath.h>
>  #include <linux/wait_bit.h>
> =20
> +static struct mpath_device *mpath_find_path(struct mpath_head *mpath_hea=
d);
> +
[ ... ]
> +static struct mpath_device *__mpath_find_path(struct mpath_head *mpath_h=
ead,
> +					int node)
> +{
> +	int found_distance =3D INT_MAX, fallback_distance =3D INT_MAX, distance;
> +	struct mpath_device *found =3D NULL, *fallback =3D NULL, *mpath_device;
> +
> +	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
> +		srcu_read_lock_held(&mpath_head->srcu)) {
> +		if (mpath_path_is_disabled(mpath_head, mpath_device))
> +			continue;
> +
> +		if (mpath_device->numa_node !=3D NUMA_NO_NODE &&
> +		    (mpath_read_iopolicy(mpath_head) =3D=3D
> +			MPATH_IOPOLICY_NUMA))
> +			distance =3D node_distance(node,
> +					mpath_device->numa_node);
> +		else
> +			distance =3D LOCAL_DISTANCE;
> +
> +		switch(mpath_device->access_state) {
> +		case MPATH_STATE_OPTIMIZED:
> +		    if (distance < found_distance) {
> +			    found_distance =3D distance;
> +			    found =3D mpath_device;
> +		    }
> +		    break;
> +		case MPATH_STATE_NONOPTIMIZED:
> +		    if (distance < fallback_distance) {
> +			    fallback_distance =3D distance;
> +			    fallback =3D mpath_device;
> +		    }
> +		    break;
> +		default:
> +		    break;
> +		}
> +	}
[ ... ]
> +static inline bool mpath_path_is_optimized(struct mpath_head *mpath_head,
> +				struct mpath_device *mpath_device)
> +{
> +	return mpath_head->mpdt->is_optimized(mpath_device);
> +}
> +
> +static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_hea=
d)
> +{
> +	int node =3D numa_node_id();
> +	struct mpath_device *mpath_device;
> +
> +	mpath_device =3D srcu_dereference(mpath_head->current_path[node],
> +					&mpath_head->srcu);
> +	if (unlikely(!mpath_device))
> +		return __mpath_find_path(mpath_head, node);
> +	if (unlikely(mpath_path_is_disabled(mpath_head, mpath_device)))
> +		return __mpath_find_path(mpath_head, node);
> +	if (unlikely(!mpath_path_is_optimized(mpath_head, mpath_device)))
> +		return __mpath_find_path(mpath_head, node);
> +	return mpath_device;
> +}

[Severity: Medium]
Should __mpath_find_path(), mpath_round_robin_path(), and
mpath_queue_depth_path() check mpath_path_is_optimized() (or a callback
returning enum mpath_access_state) instead of reading
mpath_device->access_state directly?

mpath_numa_path() and mpath_device_set_live() call
mpath_path_is_optimized(), which invokes mpath_head->mpdt->is_optimized(),
whereas __mpath_find_path(), mpath_round_robin_path(), and
mpath_queue_depth_path() inspect mpath_device->access_state. If a driver
reports path optimization dynamically through .is_optimized() without
updating mpath_device->access_state (or vice versa), the two checks
disagree: when current_path[node] is non-optimized according to
.is_optimized() but still has access_state set to MPATH_STATE_OPTIMIZED,
mpath_numa_path() falls back to __mpath_find_path() on every I/O, and
__mpath_find_path() treats that non-optimized path as optimized and can
re-select it over a genuinely optimized path at a greater NUMA distance.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108204733.5579=
95-1-john.garry@linux.dev?part=3D4
