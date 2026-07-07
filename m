Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A54342315B;
	Tue,  7 Jul 2026 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783433542; cv=none; b=UmejuSZGIWMjR5vEOgUiXda1ChfMeeGlpYW+EcNI4A0IO3PMNXg2oJXb0k8OQfy7M65E5m0RDPfmeJHb9zuOtlXy3VbrNH92kdU6m/nT6sLag5jnWRNDyg/QKoqKi4J3pWFa4GiuZMBlM8FBHEgDF2SFNBJhotWgI4vrQ81K7/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783433542; c=relaxed/simple;
	bh=+Q8bsBDe/NPd3jPzAf281UsX9sWgZa/fkzVNcKGpaGw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hIZ2IxuQ3pB/39iwYtxfzDxps+wf3nMizIFp5GjaycqxDQ9atPvfxk1lcgPubURkrEVWufy+O7+bGa4VbLcml6Bc8NRFFB8xSIH57zLr4qs+h2oC+ls8HzfzOoMz+EnL34yGSsjdp73vp7bl3jMy7wYkU0D39a43jUybpGzR2G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ig139JRf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ig139JRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929C91F00ACA;
	Tue,  7 Jul 2026 14:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783433538;
	bh=+Q8bsBDe/NPd3jPzAf281UsX9sWgZa/fkzVNcKGpaGw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ig139JRfu1SsHtLD/2CqUoX+sR1iL+JWLycuQ54NG3jIc6EfG/OLqzcUJ90VDAsDv
	 N7QhOF7tkFzEN8yVg2vzpzHYvmKwydMnu64BXpUxTTMhZTaIM/TcvISYuzZfvE0FxC
	 kdc1R8QtMsy/hGvikB47Phpvlke1bSJe3a27PnGGJgWRzhqlGZRAqRjQrNj0UJ7iXE
	 yNPQ3zup4TXVy0L7NMwYSwVsF9RBkGhxrW31zvhz1Gnz/fvU+sxVN1X10W0rVKtZpx
	 49hPNYUbOkkhGgjTNPtvbcFI8Hh6yqpgL5S/9rstz9UyR5QBOGFWXieBe2Hofd0cDW
	 zqv6yK6NFfCFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 6/9] agp/amd-k7: don't rely on address of
 pci_device_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: cassel@kernel.org, dlemoal@kernel.org, linux-pci@vger.kernel.org, linux-ide@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260706-pci_id_fix-v3-6-2d48fc025acc@garyguo.net>
References: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
 <20260706-pci_id_fix-v3-6-2d48fc025acc@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 14:12:17 +0000
Message-Id: <20260707141217.929C91F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Address of pci_device_id cannot be relied on due to presence of dynamic ID
> and driver_override. Use driver_data instead.
>=20
> Signed-off-by: Gary Guo <gary@garyguo.net>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706-pci_id_fix=
-v3-0-2d48fc025acc@garyguo.net?part=3D6

