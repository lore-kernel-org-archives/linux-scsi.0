Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D98B27B353;
	Wed,  1 Jul 2026 13:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782914334; cv=none; b=pp+f5k4lNWt0yxIkC6w2c3HF0vpNHNzLRncB3PocbqVA6IXuLGERT2pgYy4PzSbAD4UzAZ8yO1h5rm2RdapUCQMfCMGt9ahOaODquFx2iaEt2beUFCGBt8lfpFtb58IWrZWoo615ke3sVy0eS/VxnQ8e5OAf9wAjZdRHu6SpS/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782914334; c=relaxed/simple;
	bh=RjZ/ZIZ+K+wowVDaDuR8b9Ow9kYVVHeMdBCpq21cESI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qv1hBf8Ne0AMW3WoI4zkBjkNpLZo/BIiZlCp4sxYs3ux/uO3A1nXeBqdjtNn91YBzxXCBp9Oo4LLlj0hE0DESt4UiG1kQdRjYdHwuc9BeQUBvAhy7CQVPc88gP7zKMJg/w4EclqHxMRc7vasCamCrcO/Ic7yB1rl5SQdtJR+pfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cEBX8Nmm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cEBX8Nmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145FC1F00A3A;
	Wed,  1 Jul 2026 13:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914333;
	bh=M3VWoTmM8jK72GbVHspsaZufdJJVK1r2KEIFBDu4FLA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cEBX8NmmoZzbQj9qx5kdB4hf6FozrEwXQbN6H0WqBZ+uPmgolertSmviK5x8hVBUQ
	 6Aqw5GA+/iiDzra1U42t7ufhgMJJ0G7PRvo56Eb05NFMK4rWT2vJJjxtGTP0lucREM
	 7l4XxkhyERwsaH/s/nTdpN+grhhNSiwtRe8n5BnjcUv7kqyt4/x30UHEheG/e6AK/X
	 XwwL3Te2kUy5x2oomlFeix7IzwP7u/6m0g10OX4ElWEYfgzpDOZLRMhYm6FEqx8EaW
	 i63i9jtuy012Zsv2XmTB4eFVeOSeFFLdnk5f2VRGvy9owF8j5ySrZhE+VOc2rm0pzo
	 j1WZ3lhUFtLaA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/5] driver core: separate function to shutdown one
 device
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260701135015.81937-2-djeffery@redhat.com>
References: <20260701135015.81937-1-djeffery@redhat.com>
 <20260701135015.81937-2-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 13:58:52 +0000
Message-Id: <20260701135853.145FC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Make a separate function for the part of device_shutdown() that does the
> shutown for a single device.  This is in preparation for making device
> shutdown asynchronous.
>=20
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260701135015.8193=
7-1-djeffery@redhat.com?part=3D1

