Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997688;
	b=Dxyo5OZT1vQzrPsuPWbuD9qtqRFVLCLizkntsdnZCEx14WAFPfo6xmTmtH+0KA+2CwOl
	 bU1JoQ+onSLF+7ex/Q2nTJ8VgHfZmXAANCSR5/vJ2sqScQl2XEjA2CwF6SnEAzbNL9plZ
	 EqLuuayOiEfKSQpCBdkVfTB7qpbPdKQmtU4I9E+LHtrjPeDEXqxUlo+ABrzpwRfVIXBBN
	 ChXYWUbtdP5NByE36aLBcJLYRonSzPzPdl+LuUQmNSANZtdKOtKzI/wMbw5mNKqxV5mbW
	 JBxIWBE8y97TIBqP2FQLYV1+SlYGTWlhIXsBD3L2gpgBqBjQR7NM+jS/FMbWM9vmGMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997688;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rIrJW03fwF33MogeNbS6lX8lvVMuvSqM9WlFIZR10TE=;
	b=gG3XgCUtY94PYMHp7NAcqakP/7pxqptfZDnZzavh0MfG3f+iFWRcNxYzeL2M3bhIJGCQ
	 LWvXScHF4IxjUqDZL7v3GaaATHgAmof4JSYQL59b8b2b2wFlNtFOJG+94I0aUNnIWZ1yi
	 0Z52wPohqIEUDd0w5XxDZuhCynMKP8Am2fEoATt4+cEJVJghWUnDhD+OkAGraXcD4W+zz
	 SU6eSJ0+wGxdv2ma+IwwJGhsn1OtBtQcPbE+pcmB8Yd/B5iQeHXCWtMH9+IRVPWKWHjKp
	 yHI3fz7GLS9NFMFnouPTrmOqiBOaU2Ey9/Uj5TtiFnhx00cf7cqzM3KQYMh20W7z+xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mFk4+0Sz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1E5606A331
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mFk4+0Sz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99CF1F000C4;
	Wed, 18 Nov 2026 10:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997687;
	bh=rIrJW03fwF33MogeNbS6lX8lvVMuvSqM9WlFIZR10TE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=mFk4+0SzbldnSjnI6L3LNNcmt2NF6bIAE8wh1FY4fPaYhb5Ih010aCqt2Nr+YKr9P
	 b4+GnKjOTy5XwyRgZpeJuRs8QwNivqZMNnddOiXe9sYpqBXrDcglmbrdHxu//Q2++9
	 ePfkmzD54O7spfhtCJl7NzIKFfhZWbc4t5XvzyxiOyA5pVGLCx04z2EnCdn4AppKNS
	 b1iF62oK3Ph7QUt6FeJTVIDIrLMJ4nsDNhKv8W3LIKSow8Py7IsiaVIKm1mKpe9tA5
	 ii0Nt48E2zFmj5E5GcyJmA5aYEJhPKJrQQ2z+QyN5+bWphvxipbkZihIZ+S+9nz45i
	 4CbVWuTNZpLrw==
Message-ID: <sashiko-outbox-220691@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/37] scsi: mpt3sas: Validate firmware-reported
 IOCRequestFrameSize
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:28:07 +0000
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
- [Low] scsi: mpt3sas: missing Fixes: trailer for IOCRequestFrameSize
  validation fix
--

commit b463953eb9cc498a90d368572f626fa18df586e7
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Validate firmware-reported IOCRequestFrameSize
>
> Reject an IOCFacts-reported request frame size smaller than
> Mpi25SCSIIORequest_t, which would otherwise corrupt adjacent memory.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
Since this fixes an unvalidated IOCRequestFrameSize assignment in
_base_allocate_memory_pools(), should the commit message include a Fixes
tag?

  Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D1
