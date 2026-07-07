Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68C9346AED;
	Tue,  7 Jul 2026 14:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783433537; cv=none; b=kI2k2skEDefDUhV5O+o/uj16SM08jQl4MzF4F0QXHZg/1xf5lS3NiiXxTbgIvBVtVe7p/r0uX13G8Z3IfNjs3TEb6RSjbWfzdd+aqqoFm9WX4rcfjUKLDxOkuQHzxTRO8bpUE7PyATbdSBImwT0EnHh9GBvVJWJVrSG97nWca08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783433537; c=relaxed/simple;
	bh=IUpvRC9wcs1dCUCuTPSKS6N90kwfuNsOcY+hxN9a/+8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NzdRsXDqxo1eYVso1JQVLWawvMOWNuaAyUkIvBY5n7ErIIqEgQ44nKiSAoo60UBgu60Qeq0+CakfAiXSEk7nKm70vZjTsoR9l2tYAMF88RiwSX4gojsOJgrbu+r3OAhUpD9eCPw6McTCz79hatN9t+2bCU1QXeHncRkzZKuqR4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=je+MHiFg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="je+MHiFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856F51F00A3A;
	Tue,  7 Jul 2026 14:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783433532;
	bh=IUpvRC9wcs1dCUCuTPSKS6N90kwfuNsOcY+hxN9a/+8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=je+MHiFgYHsOBg91S1REa9sghrqxq1jVQGvqjbExLoTLl/mz0zk5uF1L1HbzkKC50
	 MbTSCczlK1IuCadfNh6jcvgBORPY+pSQfvZ2pqnCd/CvEvC6OXwJmyVt1MmcXAouvR
	 KxNAfqbzmav/tZI/FHOJOBhoq5uZZdJQueOv74fjpmjloEJ7bYh+vUkoBVqrPfIDYM
	 8glIVgKG6SoB0SKOtcQXeJ0ps+aLB1SZ8BNDuCSY2iLaHhckKMrhgWAyTVr3cUX3RY
	 G1EFE/0nBfX+hDxReXUfs6YEjF52Ov6MlMOr6UwfCKEiCsCi3F534QGsShMsp9QOgk
	 CXTbF4i3rivNg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/9] ata: don't store pci_device_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: cassel@kernel.org, linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org, dlemoal@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260706-pci_id_fix-v3-1-2d48fc025acc@garyguo.net>
References: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
 <20260706-pci_id_fix-v3-1-2d48fc025acc@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 14:12:12 +0000
Message-Id: <20260707141212.856F51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> pci_device_id is not guaranteed to live longer than probe due to presence
> of dynamic ID. All information apart from driver_data can be easily
> retrieved from pci_dev, so just store driver_data.
>=20
> Reviewed-by: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Gary Guo <gary@garyguo.net>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706-pci_id_fix=
-v3-0-2d48fc025acc@garyguo.net?part=3D1

