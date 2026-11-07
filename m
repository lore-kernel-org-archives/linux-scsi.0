Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794044596;
	b=PoP4oQhxse+8LvO+wZULBSOAIhwTJz5NNwF/6UARVaTnjIjLly1GYxN775UXduWbh/JD
	 jbvIBwVbYK/0A4b+mjgqDCVoarAybcA4fh1T57PzNCM1fnGN+fnVizGNIDRULuG3tHUuy
	 BjTJV1UwSKKUAm+pmSJdrBnuZ7IYehpbtb9bkowDHub8kienPGlZO5LeVrf/U81lTaXSL
	 cyBQ9OXTnyEBZqITcxri/RC1CE6Q433DFA+wIHNJQHQBCLN+48Ua+rMibJ5ElcroMEvJ5
	 v4y23PovtjZohyAG5u4p7N/XJO9+vywYzZcGBEdhSUAHtqrQyPpZDHvPueX1zgp3ntg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794044596;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WQU8dbzMneA2H4ynHWCuuIO/tMyBhgYdQ1+qi4sxouo=;
	b=bNULPmzjkx8i6NIUjJkUdXRFL8VYqF5U2WxEBcYjG8nVR5melVb3KGM707bIx+d0uMFj
	 THFMvr//1goLAm3h69gLlV7aVE4R3oiONlEUdagPF+eRKPlF5yei7sAcXLd6UdcsQbhwG
	 Z7lbmL/f2nqpuKgedFCTrzL/EEjWHdcwJsLp76Fp3uxNg8+Ne3YeurJwbS1nZD9rpKkfj
	 79JAxoo9d/32meUg+TA8yk7YIu7iALSD8FJ03tay9et6JQpXVrVtRxPF3cG6O2f8fTzHM
	 EJrsF380FqyCWTfV1e+tyGuWR8JGBIKxe5prBCUFByN0Gc9NtSylhLxg06t824ghmvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=De4Iptsm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF8C606A326
	for <linux-scsi@vger.kernel.org>; Sat,  7 Nov 2026 09:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=De4Iptsm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF151F0089F;
	Sat,  7 Nov 2026 09:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794044595;
	bh=WQU8dbzMneA2H4ynHWCuuIO/tMyBhgYdQ1+qi4sxouo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=De4IptsmfrL5hGHdfpAY9i9sIBoOS9Togb3DOP09ZmKxh7228C9AfeWn2AIk24tiZ
	 03pW7a8v0Ba2BEID/4+stms7gWToJsSZnftz8KMg21oz1m6reiqDsMvWTAFoM1heoY
	 vRBGWyElaxSJy6SkS9+JUifnRT3XkWbwn0abqDVuRLxJ/43N1WJTD0PAuUUnTH5SmK
	 K5Cib7E+pUZ9cJEVV5GRk82kRzHfrVtrpk72lMJLZlH9Yi2cnhyKcZy5yPu0A7dOo8
	 2XQKC3mYKxoqJUNnnHHDGnAHPNEGwTHp0B0dhW+ahVqILotwmVdOr9ZBaPEugDGUQK
	 0fncbV3SXUr+g==
Message-ID: <sashiko-outbox-202780@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: be2iscsi: Fix NULL pointer dereference in memory
 cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: mdshahid03@gmail.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261107093611.42311-1-mdshahid03@gmail.com>
References: <20261107093611.42311-1-mdshahid03@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 09:43:14 +0000
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
- [Low] scsi: be2iscsi: missing Fixes trailer in commit message for
  beiscsi_alloc_mem()
--

commit 3a59c9fd50bd58745d465b3451671b988442c55a
Author: Mohammad Shahid <mdshahid03@gmail.com>

> scsi: be2iscsi: Fix NULL pointer dereference in memory cleanup
>
> During memory allocation ,DMA memory may be allocated successfully
> before the descriptor array allocation fails.
>
> In this case ,mem_descr->mem_array is NULL,but cleanup path tries
> to access it.
>
> Use mem_arr_orig to free the DMA allocation of the current
> descriptor and handle previously allocated descriptors separately.
>
> Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>

[Severity: Low]
Since this fixes the error cleanup loop in beiscsi_alloc_mem() from the
initial driver commit, should the commit message include:

  Fixes: 6733b39a1301 ("[SCSI] be2iscsi: add 10Gbps iSCSI - BladeEngine 2 d=
river")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107093611.4231=
1-1-mdshahid03@gmail.com?part=3D1
