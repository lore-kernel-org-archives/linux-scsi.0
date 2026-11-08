Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794171757;
	b=U9QxI0wUSEzb5oShfMMIvji+fbITcj7bSr182ewBsxCx0G2h1Hp8rwDhsP7ZPkudtniT
	 TXCRujAvgcv5rkJtLRtSSwNlwCYARqaXAqIVmw+xQZtXgnbPSlqlqK6TVpnvC6Bq9oUkk
	 l1Tqt5j7+ftN1UVUYcyDJk2t3VUyBN5uSHgxSFp8s4I96hPI0f1iIhHb5wRNgcNPfU2AO
	 JnX0cxGKqVYpRPGZvkcLpZ74bMHnuDZF5lG1YYdpElls1U3cZfKMObgmpOpEYEmRQjI9G
	 h5Ntl+GJzmAZQuyY+gEy15YOUQGx1zkq3lT6pgbrn6DNtObJbTv8CH61JJ49mhjF5gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794171757;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+EZH2jyGgPaBdWe8HIIwVmJ0BqWFPii6GucH24sJEzA=;
	b=NLmRSmW2Tf+5KTiMyL9NyxkNzxT1uBrS5pqwd63LMx4v98TYIiBlJX/1LzimCTO/MWLC
	 H/Wtgg1HuWzfDAChe/gn3UoLetVM9xdz1apio5c8PE0GxGSn9AOi+3BuZZLz5lTbTjXwi
	 PmClVixeV3x83EBRWZ3zuNyAJ3piMoIeWj3Wi3dplcpLxMUS5G6PeZ0KkXZbh7VMiFJyX
	 ICuER7jc/Qg4rnpWy2t54bhmRbvaLrTMYx17yzITzrcTQqNICP4CHg9v7H/ymnLALb2ul
	 w3K9ZwUj+oen06Iyo5u9qwQVW05nilOO1zCZ0gLc39odAd7BOM2+u+c72mTx5JTHBWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bjnJiKhm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4CE606A321;
	Sun,  8 Nov 2026 21:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bjnJiKhm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75A31F008A3;
	Sun,  8 Nov 2026 21:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794171756;
	bh=+EZH2jyGgPaBdWe8HIIwVmJ0BqWFPii6GucH24sJEzA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bjnJiKhmfKUiXf+7eTtV+4QKUh7nnChW7x8e0DwrWPPUbrh+hs+VoC4IixpXAhbQV
	 9MIgOxk5DHHoc863hMhcvLwhGh5ZfDk4Qwg8/B9fl44dUReY5MSDUxis6SkjwR42V9
	 enRbasVgu3VRU+As6VMvMYQl+xlTgvxU5u2dU4UYNR5lpCqmPvLRgeAryTGiamA9hT
	 TzlVIWcuqnavdHYkrasGZZmCi1FwOsUbcyeSHx9Rihy/8OBhloNtyWhwQaxky2FqIb
	 fVjEUlgpYNYyR4mDnghrtjwGnYTewWW78jcrk2wTU6qfnSKoABtuKB+IVfwmiQQKOD
	 UBzbZCHePNA/Q==
Message-ID: <sashiko-outbox-204044@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 08/29] libmultipath: Add sysfs helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.garry@linux.dev>, james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de, michael.christie@oracle.com
In-Reply-To: <20261108204733.557995-9-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
 <20261108204733.557995-9-john.garry@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 21:02:35 +0000
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
- [Low] libmultipath: duplicate parser and ambiguous return in
  mpath_iopolicy_store()
--

commit 12aacc0c8ac98ed4ae873a73979622db40d4f52b
Author: John Garry <john.garry@linux.dev>

libmultipath: Add sysfs helpers

This commit adds sysfs helpers and attribute group definitions for showing
and updating the multipath I/O policy and displaying per-NUMA-node device
paths.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index cdf8fbc5105b3..ae5a73d570b33 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -620,6 +620,100 @@ void mpath_device_set_live(struct mpath_device *mpa=
th_device)

[ ... ]

> +static void mpath_iopolicy_update(enum mpath_iopolicy_e *iopolicy,
> +		int new)
> +{
> +	int old =3D READ_ONCE(*iopolicy);
> +
> +	if (old =3D=3D new)
> +		return;
> +
> +	WRITE_ONCE(*iopolicy, new);
> +
> +	pr_info("iopolicy changed from %s to %s\n",
> +		mpath_iopolicy_names[old],
> +		mpath_iopolicy_names[new]);
> +}
> +
> +bool mpath_iopolicy_store(enum mpath_iopolicy_e *iopolicy, const char *b=
uf)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(mpath_iopolicy_names); i++) {
> +		if (sysfs_streq(buf, mpath_iopolicy_names[i])) {
> +			mpath_iopolicy_update(iopolicy, i);
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(mpath_iopolicy_store);

[Severity: Low]
Can mpath_iopolicy_store() reuse mpath_iopolicy_parse(), and how can callers
tell whether the policy actually changed?

lib/multipath.c already defines mpath_iopolicy_parse() using
__sysfs_match_string() to match against mpath_iopolicy_names[].  Also,
because mpath_iopolicy_store() returns a bool that is true for any valid
policy name even when old =3D=3D new in mpath_iopolicy_update(), a sysfs st=
ore
caller cannot both reject invalid strings with -EINVAL and avoid clearing
cached paths and flushing requeue_work when the existing policy is written
again.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108204733.5579=
95-1-john.garry@linux.dev?part=3D8
