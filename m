Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D792A3B6BE3;
	Wed,  1 Jul 2026 11:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782904248; cv=none; b=Ky0BvAxL+apIjNpCfsBjlv2uHDDFQ9Erm0F9fsF+7U0akg88LZy0tFvc1Hc5K7gLoTmio2mkKaDTx6fpmlqEH2xNonPT1Qgk1z5JquCeVnZhFr48GxybAhYQc/Ls4ZBqi5gSDj5XBgkaefkWvVVCP0kd5AVh93RFR8lri+2tuMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782904248; c=relaxed/simple;
	bh=yVagIikktY7i4HL1prKYj/cUmexTO5EG5Cp/QTYShQc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZHw8SeXSoXXA5dhw9D8CUkfefA0qhztshEWns5W+C9hdk5O4MnzaVwD9pVqjEhpOsn8azCkP8KSzT+yGepsFQXGvKKbbW/XxAZK6SHAQSptgWniy0MfTWL5CfEcMsx/WUVI3dC+cSpCTUJ+dAfYcQHv14+bxqRy8fctaJYaxBaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YispIv5N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YispIv5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637D21F000E9;
	Wed,  1 Jul 2026 11:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782904246;
	bh=yVagIikktY7i4HL1prKYj/cUmexTO5EG5Cp/QTYShQc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YispIv5NroPZyUtmnDaj4O8gl3a2W1L+KPoGbsXfewt+5ymZlcgJ3Mfta24GJ84t5
	 Vn1JDOF+ysTuUJqAP7VCEErlHgXUWSjoADAcd9nNWg/Tb3Mk8D3BGDuTlROnzUUBg9
	 v4npQ/qn8bm/Yg8HPxagtwX6NiMSQX6ttZPaF3piyvhNeWhjubOFQkdoCLraerKWoe
	 hzy8Kttsmq912tyN1vZlCDddfam6YMGvpFu/qWD+MRisa/F7c6y84sjMvYfhqczS8R
	 mjVvtONBTKT56XDTM6Or4X6lXwpEre3rHMuem71E+gfND8pA7MZhetq5ln2aQfFlZ5
	 3K/5KXWMx8grA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/7] mlxsw: don't keep pci_device_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org, cassel@kernel.org
In-Reply-To: <20260630-pci_id_fix-v2-4-b834a98c0af2@garyguo.net>
References: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
 <20260630-pci_id_fix-v2-4-b834a98c0af2@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 11:10:45 +0000
Message-Id: <20260701111046.637D21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> pci_device_id is not guaranteed to live longer than probe due to presence
> of dynamic ID. This stored ID is unused so remove it.
>=20
> Signed-off-by: Gary Guo <gary@garyguo.net>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630-pci_id_fix=
-v2-0-b834a98c0af2@garyguo.net?part=3D4

