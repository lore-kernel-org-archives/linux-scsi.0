Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96AB3EE1DB;
	Fri, 24 Jul 2026 22:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784930526; cv=none; b=ckx4fFacMPenjschTS7uGlRL8t89Mh6+nbjQ/p7BEeHzORnSePAbr2gHX+kotQ93f8O4RNom0MmSvlx3IVPgcixOsRInXMczDeOatE993Qday5aosktiJptuukM/aHi8TgYzEXWfDLuYaZK3zJz3hY6K3C4zYlFAQOy8xHBsrcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784930526; c=relaxed/simple;
	bh=ZKj6/D+170NHQb4CC9r6Q/MsU8h4G7WoaajuGxIOBLE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SFXwpxbm1ONRN69MteQhrfMhwDKW6OZIabrseNqDFjyi71jsxRj6+N3D4paf3Z7jCD5Y7DRZrx9HRtX8UQSIjuQNbq5p+v9cZm7shXncA4eA0bpnh4YBvWp9pDPb4PVRwazyCE80/VDkhu7vY184gv6Xc3aXWwZL8VIL/b28kYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=niyeUvFR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="niyeUvFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C79D1F000E9;
	Fri, 24 Jul 2026 22:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784930525;
	bh=ZKj6/D+170NHQb4CC9r6Q/MsU8h4G7WoaajuGxIOBLE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=niyeUvFRplw74eWFXarqjm1cvcPa9ZoKaW4gbj2heI60/RG86rHOYNVZiee3clfXu
	 gX4aX6xoIhObKU/Q9ZbMyGovssWiUKLtFcyvFbHwH/ze7R3I9ksauap5EWSiPbDySW
	 elMw6PtWTVSBSUTZIGrPbnb14L3+e7PhYe1WLIjYDQ2t0vtu6cgOX63OyHkvqqzNb1
	 XuMEiE9rJsWqFxnvuEvgbq7MmAD61IWGcjy/HMKzRhYsFE432g3PEdU54W8ynwfY4U
	 JquIHlaA70rvHnWTfrRlNw6RUF8YAuSEpc3YI7qQxFLzNGhQbqvUj4wtw3GMk80PQR
	 oz4jyM0JAln6A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/9] mlxsw: pci: don't store pci_device_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, dlemoal@kernel.org, dri-devel@lists.freedesktop.org, cassel@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260723-pci_id_fix-v4-4-3580726844e1@garyguo.net>
References: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net>
 <20260723-pci_id_fix-v4-4-3580726844e1@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 22:02:04 +0000
Message-Id: <20260724220205.4C79D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> pci_device_id is not guaranteed to live longer than probe due to presence
> of dynamic ID. This stored ID is unused so remove it.
>=20
> Reviewed-by: Danilo Krummrich <dakr@kernel.org>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Gary Guo <gary@garyguo.net>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723-pci_id_fix=
-v4-0-3580726844e1@garyguo.net?part=3D4

