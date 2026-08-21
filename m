Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D2639B94F;
	Fri, 21 Aug 2026 14:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787322844; cv=none; b=aE++q5DVDEPDcDX3c+ke3OdD9Xu0bPVU2ICOgG9TxxaMUnGigpDvsQacW8YarOO838huTtrfG6bowth4mYisMjn2rb/TW6mYHm3nw+Njtj5iGXuOYcKJFubdpPv9bDrgkaIrYv0n6+R1udR1WiZxoISzxFVcEQ028r3QoV39fEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787322844; c=relaxed/simple;
	bh=gOVy9g2LFtuQkdaxGJKsch+hvSaOzXCuwhECKdW5Hio=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RYa/ywWadiUE2IcwcIKfgJW3bH1pvcD26gNcYe6l0raGSdSOEwTv9OIcVaVw5zV/LZxWzYNIOX2W0ynkmv70XUomB8WT4ujsVT0jzD657t6oZh7dhNrzbsb+zCTejd+2Ei+AWEUjZ/8GMYAArLtlQvB5SGFtV9gc7ZP70T0hTAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lLLAAq+S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lLLAAq+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E869E1F000E9;
	Fri, 21 Aug 2026 14:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787322843;
	bh=gOVy9g2LFtuQkdaxGJKsch+hvSaOzXCuwhECKdW5Hio=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lLLAAq+SQarWE6SX30FR2ITZqu8yXqoytHSvuXmjaeqB7GEqxnj2CO+HXKqfQWP6u
	 pUC/cGURUeUH0CgpYg46GoIr2BQEVuNXvN0ohOQKh1V3HW+LdNmtCi5ZrdQp5OJxRI
	 ib38CWQp0GFPR3OkStxixxSa03mXZ7r/7reNmq8A0hIgZjXAHU3ARCtOUcoEJid1d9
	 Sc8DpS3lMnDLVu4QoyxWfB6FE+It0MtgJ1UCX0HNUXUlu0sHUv/7iCyUjGYX6311Yk
	 EM/ogR9/pk3bL6DC18l6BxOtgY68bvAAFEN7ZjyhDJzSyzJmrP3G03pFognun6rduX
	 QWhH7VjzZD0nA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/9] PCI: Link a virtual function to its physical
 function
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260821142414.150892-8-djeffery@redhat.com>
References: <20260821142414.150892-1-djeffery@redhat.com>
 <20260821142414.150892-8-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 14:34:02 +0000
Message-Id: <20260821143402.E869E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> With a PCI virtual function having the same bus for its parent
> as the physical function it is associated with, there is no
> explicit dependency between the two in the device tree. With
> async shutdown, this can result in the PF being shutdown before the
> VF has an opportunity to shutdown.
>=20
> Link the VF as a consumer of the PF to note its dependency and
> ensure clean shutdown ordering.
>=20
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821142414.1508=
92-1-djeffery@redhat.com?part=3D7

