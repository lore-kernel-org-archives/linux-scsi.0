Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE8E492E4A;
	Mon, 14 Sep 2026 17:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789405624; cv=none; b=ip/IY8xyF4gOpcsLbCy/3PxOFk2z3C16evvekoZAzAHrxGDAmlKzwk+wAhh4jRHkzjAAsNcL8MOIJ77m22Gv9152S5RWtw0WpB1MXzGGV9MmZreeRtBvHBhFTGq1JOf8+mIJ4QuhloJ4CnOcLfCvgj4ENSXdMLDY9FO9tlG00MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789405624; c=relaxed/simple;
	bh=MQcF/CGomkZ3dEdeDHD/Q95+yW149OLQeArDbXHiVzM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ML6UC7Syjj/ALFJqjoEFA4QPqlHqETD65VXpMG9e0Gd0xoY0+7sJhXaG6wS/6nGRTU9Cn9MPj9aFCBrjxRB15KsoB5UIkW/q4YXlxOvUv0OMpv1BVO0AoLrMNNUa4Vkl2C9333xDxWqC/2SWN+MUm68GRLtniiMyMuCzdFwCJhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y4g1lfq0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4g1lfq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43831F00893;
	Mon, 14 Sep 2026 17:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789405622;
	bh=MQcF/CGomkZ3dEdeDHD/Q95+yW149OLQeArDbXHiVzM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y4g1lfq0JkHgBsnAfOst9SbKIjIZ5eXXb66KG0e2Yzqvdz+Cl4Y57fLx0V9X2FgCo
	 6LhaDOo0cVFhfcCo6AosnHH5/nOczsnngTf6yaLcm703B1BKF/hjMr30KP1GTcZzAP
	 ELB/DpSA2qc26i9gtDkVwG6uhp9dgnZ8XdrstmJyt/fIFoy1BO5ANukQ0L6wiPzNhi
	 qHg2KQIBtbkrdYeXm2ZHXELJS1RigduVviWUXmP9oeGsHEHXfFe4l4TdQdJTsvqCma
	 sIRsBN0k3YPcLUm8OmrHFVXo0MgdsfzsGRkyXcEB+VuLmM1aX5KxVguLC459oj8K7m
	 NDhJMBEMKsgLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/40] docs: filesystems: update mmap_prepare docs
 for discontig kernel pgs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-trace-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-9-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-9-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 17:07:01 +0000
Message-Id: <20260914170701.E43831F00893@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D9

