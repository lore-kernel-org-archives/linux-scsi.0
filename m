Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998012;
	b=pQidJ3bTnpvmgQmBB4JsChceVif9LXkNUtBHs/dN/DicJrKU2ZdNIPEAWrqonULRLogW
	 XqKVsXVd7Fp88PI9hZkYeguPgc8nYfvrKcvDzZJgdfZ/oKLbBbjZc/5Dyu/hbpx7mU8Tc
	 tRfsqYq/rPyqWMS+xjDeB/X+bX1TAQdyqM0EzuO9yC6aaYFvXAxHOKTvK0QMNchZg6jZr
	 HM0cUIPXIS6/emI/uYSrXt2xiLcR5cDJF4rtWZkcFxZavOX5dYldX4nzI7EkVyvgWcALh
	 GZXBHfxHN5JJQFr/fe6g7+GS4rOEatyWxUZRv3wh2EH2603X9xczdpRrio44CN9yzHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998012;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pnwRg5v9+rGLdkXWseB8MBV99OrtW+gV9vD9zjfhYPU=;
	b=RArk5MuTgy6fVdFcnGPSgLOrTG4vCJtdhc1YVjG4r7bbJ5po06xDpkU9WBNZ/VtdVtUF
	 O8m8O6dR9QdJxB5e3Glup9qx/Yn57ZZZ85Y2HNYHEcaeqhwH0+bDNe0vqJ30gEB6WNC6K
	 klloRI3dSMKg2xaSz1T8FXMhMu0bK72cpPqIJ57Lx/A1XJV9Lzg4sSb3v+eJbiyRD+HEL
	 Jzh1ILjh6XzUqc/JWwFXtTDo3UPdt1NcCeSZCQezyzqjIxAfFzCBgRRTK7mT0B8jaGTWl
	 geyMhuFXRPBeNmftadAQBzpHH8I0WVIpqK6zS4eVKgPHvvAL0rqqezGQ3oh8ebEJQkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f01++Jdn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8463C606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f01++Jdn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B3D1F000C6;
	Wed, 18 Nov 2026 10:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794998012;
	bh=pnwRg5v9+rGLdkXWseB8MBV99OrtW+gV9vD9zjfhYPU=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=f01++JdnbNy2dlfgwccGObJhiGlFgDN5VDg0paJbxHIR8h9/kF4yTsY6xCOksLTzb
	 tthgo4yf/YJ3RckeiLxOfYBiqmUUicfCwRN+l7CF6Ft8Q4H36jWdJ/AN3550/IB+Zd
	 pJSGRWLCRL1TKQErbavRtpGM3T3jABWXf0Y8jtBiNLPBPrwN9yOTV+Cgwqt3bLzhGK
	 kNCZ3OOZWVSBGVSypLLZVemdR+meADEDv2YfHkaCznZalfxVwOZfeb3uFiGxU0Twe3
	 w0ifGMe1cptSDmv1NG4igCNg4Ae11jTOXsL/7LBHKROCOLJpZf7cm4HBFPP8hwDzn0
	 +ilXIZKtTRhJw==
Message-ID: <sashiko-outbox-220704@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 19/37] scsi: mpt3sas: Reject implausibly small
 MaxReplyDescriptorPostQueueDepth
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-20-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-20-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:33:31 +0000
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
- [Low] scsi: mpt3sas: missing Fixes trailer for queue depth underflow
  check
--

commit bb0ded0f5bb17ca3004a3f754f6ece2a684ed10e
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Reject implausibly small MaxReplyDescriptorPostQueueDepth
>
> Avoid an unsigned underflow in the hba_queue_depth calculation when
> firmware reports a too-small queue depth.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
Since this fixes an unsigned underflow in the queue depth calculation in
_base_allocate_memory_pools(), should this include:

  Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D19
