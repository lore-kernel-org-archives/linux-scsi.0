Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E3B3FD96E;
	Fri, 24 Jul 2026 22:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784930526; cv=none; b=fjcAhdAEUywFxjO6ePio7apFJagEIPr+V7XYHs/bzKL/WyQKtOc9lGpsEllFgP9mKKNoIErNDKd3pZcDtgfR5kcloTKROem+PaOzJVFSmXZ1iTRuKefMHtN0uylyGaaPRKbQg8QMHPU+jFyuyzhXCwevUICBqu22nwpFHayqAPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784930526; c=relaxed/simple;
	bh=lJOSCc4sF1P23gsernjs7QoxWU1uA3uVqtHIanV38ZY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rRUZ2+GoyYJ0CcIqhB8118bMITDJlgV9o0uDOk8U3qmIRxwK33d2ujywcu0N5g/LzdPPnzUfAGMP3xVbm1WOOdUkAS5vF2F8h5pGG9yXk4RpgW0b3j4emayponq5/XGhjSDvc6cyAcp94+ao93nq9DayKU8YP/5bRzF4+g9hBWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O6zOSgs7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O6zOSgs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484401F00A3D;
	Fri, 24 Jul 2026 22:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784930524;
	bh=lJOSCc4sF1P23gsernjs7QoxWU1uA3uVqtHIanV38ZY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O6zOSgs78LEwfcElJMc0lYX9WXcrsJgmN8GgWBBHxrX6skC6a9zxFR7JZTdFsnPGU
	 ra7r7DjZqbXfgiySrQVW6Sj+neFW/ePqjFqRskPyrokpk79blEo4RQMc0A2WtWdkwd
	 SfartRyiVHWOxSe/B1MfpIwMvubO433sNoA3aiPo/R1+TvLy1XHqF/errS2p2xgOz4
	 INPqS4YVYdNjVZmkpp0+f1/CsZO9pJaDoIehCL2o1q0VjlxkGgQ917TBWWsxAQLkCp
	 0b9vB5Lmv/DeZshwiQhPbzMHnM8AUACS1Iq+tjTK0c1KKjrBEuXD+LG0N5N9XgP14D
	 GkKT+ygy3Zrvg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/9] ata: ata_generic: don't store pci_device_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: cassel@kernel.org, dlemoal@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20260723-pci_id_fix-v4-1-3580726844e1@garyguo.net>
References: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net>
 <20260723-pci_id_fix-v4-1-3580726844e1@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 22:02:03 +0000
Message-Id: <20260724220204.484401F00A3D@smtp.kernel.org>
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
> Acked-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Gary Guo <gary@garyguo.net>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723-pci_id_fix=
-v4-0-3580726844e1@garyguo.net?part=3D1

