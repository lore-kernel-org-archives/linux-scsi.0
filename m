Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9036851AFF9;
	Thu, 17 Sep 2026 17:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666372; cv=none; b=f7lAFxdrfMHvYpbDJXcgPf2boq5sJx8MVA27cI29YELOKgarDxkK8YZV1NQ4+Nm8LiPnn8DJwJZE2vEMya0Sp5VBOEqzVCzG6mgLAmooFOlkC6NJY95HJI/dYfjfwfxlaZKjW1nH8EUPmiBTUDjrFOPr4ig92vfMh/cEK8GrbMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666372; c=relaxed/simple;
	bh=L574wte6Fs7YmhZhJzXet7+9C9bbi5o9V+zzEZMvGG0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qJXW+Lq/TYkBUfxrz2PLyG0NNZazQy9E1ufYi8O/HfBUNJSKCVUJxN8w6kD4ID+ou4dY7vKijxki7g36ZFflTy8o/Vluy/L6nv9uXOkpZcobYGrZZU5BLxbL+4dIJYXutAlSxJYKYleu6TvZMOhLyAFNRgoIQ9ysng5YuqtByvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZU33jod7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZU33jod7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0581F000FF;
	Thu, 17 Sep 2026 17:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666371;
	bh=L574wte6Fs7YmhZhJzXet7+9C9bbi5o9V+zzEZMvGG0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZU33jod7WpMCH6FHlvETK1W/AvHSl40aIKDxWVAmLabCx9shVa7lGd8tfgv09/VVO
	 kG32Y0C2r/w+1Oz2rXRtEQrTPQOh5ijgdTXdoIn9/3maqBS42804IvymeSg7VfA7WM
	 b/JoC7yjT7ahTNFlQRYlX7reQYrRKj+Sn3QDE7c6F2HPW0UYsNb7Ei2uk+waVZ6CsK
	 iyd+hh+ZK/2QokIt++8JyIx1i2UTb8kQByAqViAC66iI59KnLGB/DXZkPK5hpQIbh2
	 wbJKXM+8wUeQ4epRixve0ahhkiVl0T+hXEq8Ebkv0bwRCdm553Nfpx1+YAEMdwy4yK
	 OmASN2Rq+WqNw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/40] docs: filesystems: update mmap_prepare docs
 for discontig kernel pgs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, selinux@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-trace-kernel@vger.kernel.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-perf-users@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, linux-rdma@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-9-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-9-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:32:49 +0000
Message-Id: <20260917173250.6C0581F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Describe the newly introduced discontiguous kernel page mapping mechanism,
> detailing how to use it sensibly and how the API looks.
>=20
> Explicitly detail the various discontiguous actions available and how to
> use them.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D9

