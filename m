Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDC143D4EC;
	Wed,  1 Jul 2026 11:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782904244; cv=none; b=IebJx4W3ZrhmPAJdD+CEPrrydt+Ii5OSg+HKUwM+TMtwFxwF8ipo/0psSKmy2X3bqT5g4BX2lN8ZkVHPVsdT/wtZEW9oTRgeRQZWmzkDhANj0XME/rIXjY2IRuhjOpD1JnBHLXFDDJcxrjHJkHwUDVD+G/TEXRpUo3Mx8fBpHEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782904244; c=relaxed/simple;
	bh=pzw1L9/U5R5xaXCb71RjmhA57B3SOc19lURo8YC6WPE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KeTqIFZLUW6FKGfKnZB/77HKAGdBOVj0KBqvrBqdUEY6gPfeJVGdToanuwWhBvMDNw/FbszxGayVETsH2xoXmXMVeeSlZtmU2d1sHHA5T1FKlRH5iVX0w+9WQHTI9ntLRe1KTHlTMWKNmrKcNtAVguXUTjFQoGURRODREm+aMHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cPJYYQPv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cPJYYQPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7688C1F00A3A;
	Wed,  1 Jul 2026 11:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782904242;
	bh=pzw1L9/U5R5xaXCb71RjmhA57B3SOc19lURo8YC6WPE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cPJYYQPvbBFry/CxLsbY5qyW2T7lzOelBVH4eKsnYIzsIOGkZZjIoGYm1Vsxgw19x
	 QD16oM1h6n4qfu0f5Zuo28WH8Jt+fViIUAoJlggXukY1Jpf83F3tI612ZFEaD392CU
	 IePhaOX+XmnRRLzNyOSB3gXKxHvh6BBxM0QqvbumN/ov1MsDuXcSbLE45Pw6q9sreG
	 sBm8CaGk60IJNSshOJsUuqpIAzfzmFAahNZs71hIAAXGcyonYtEddKaI96rPYvP2YN
	 4joudRqjXWSwcW6wd/CfTkC6kJz74psU+WyWJlqVYpDbMOGidXMUsPf+s+KP+9U1Nq
	 9bGIENRjOelbA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/7] ata: don't keep pci_device_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: linux-pci@vger.kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260630-pci_id_fix-v2-1-b834a98c0af2@garyguo.net>
References: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
 <20260630-pci_id_fix-v2-1-b834a98c0af2@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 11:10:42 +0000
Message-Id: <20260701111042.7688C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> pci_device_id is not guaranteed to live longer than probe due to presence
> of dynamic ID. All information apart from driver_data can be easily
> retrieved from pci_dev, so just store driver_data.
>=20
> Signed-off-by: Gary Guo <gary@garyguo.net>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630-pci_id_fix=
-v2-0-b834a98c0af2@garyguo.net?part=3D1

