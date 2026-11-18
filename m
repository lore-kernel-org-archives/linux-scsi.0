Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997966;
	b=j3nnN1mIYwRNA5kupcRa6dFqOFo7jIHTN8no6XdalzzYfGqnFiagxxG9DDIj3jY2iw95
	 gQbiRkJsIu3vk6k9n70kDdIbEz/znyt4FGvuKVkDiOgy0qTK1jKgiBUWP1cMORlccF3aW
	 zuMy1IVBddoTqYR+EXmAoF+6e5tReBsr4+X5AZuP+sVk3m9aykAEqX7M84aYaF8RWDedB
	 7p2a1FWpP4GVWAFJFSZw/9GZUb51nSjSHPhqo8gfFppEl8TAI4dvzQ7gXrBAqNuXAuIGE
	 XBDWBL5YHD+83AzshmiItouen3HQa4lLBvbpnl1dAvr9nLP2BI1rUgdC+KC/W+AoeUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997966;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xrRumIJptduDJKe4YU7QukhBjddRy4r1OqrF6A9d1zQ=;
	b=eQ8YLHeVOfuScxIYX16NKm6AfSTqbB1WQEL9l46T732HEwtxx/CEf1/VTQQuxVenIJoE
	 ZO40QM7zUlceaDdEMIkQMTKOxHVo1UZ20bGtEwIIOP+Csf78ISK0sJC6QIb/xJsoCUH0Y
	 ZcH12mPslKONOMlfs45FzoUK0JfbzZ/2K85C61x5++58YH45eGxVQbQhqMIJOxhnpuHiy
	 WlGSLDyAzmf5aZ/6kkB5LcUxtg4d4GT7EITWPy3JMVjZMckeBg6MNdS0Rb9bfvg5A04G4
	 mIHeCjIeDoE2pQv7c8UY72NigZlwGMHsJxLzsqi+FYdNjXL/cBoiQKKB5j59akGKP2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eqt1dtcE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11483606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eqt1dtcE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913B41F000C4;
	Wed, 18 Nov 2026 10:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997965;
	bh=xrRumIJptduDJKe4YU7QukhBjddRy4r1OqrF6A9d1zQ=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=eqt1dtcElYICgMVKih8BGtVXnOmipL+Xr2jJxxlidav22HrwiDBjmSTmmL62Phfu8
	 vniVbK4w06S6ZuaAq5ll/Oq/vM5zjKNZSAhixg35FhHTSJv/LLsG3cLsMCDS+04/m3
	 +cUfY0++cqjiBCrw6KvjpIv0VKca5+PCg2zlZ4zJ5tU5DY3AONojPRRHm3xlPKz6kK
	 BsZJKbEq6fWKqyBG/0yQtKaJBBUBlmS2PZeAiGRUZ30ax5mMUmpm1OKXmooHAb6/Gt
	 RS7Y9JBsiANnpn17jKAGETINKWMbPvoxq7S3ME3oatMQFzCMGd555oo8vzTkyGt/Yy
	 TNkXcNAPgx1Rg==
Message-ID: <sashiko-outbox-220701@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 22/37] scsi: mpt3sas: Clamp num_luns in
 _scsih_wait_for_target_to_become_ready
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-23-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-23-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:32:45 +0000
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
- [Low] scsi: mpt3sas: missing Fixes trailer for
  _scsih_wait_for_target_to_become_ready() OOB fix
--

commit d3ac3b98212039d9647a54f40707cb4be2616395
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Clamp num_luns in _scsih_wait_for_target_to_become_ready
>
> Clamp num_luns to the lun_data allocation size before using it as a
> loop bound.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
This fixes an out-of-bounds read on lun_data[] in
_scsih_wait_for_target_to_become_ready().  Should this include:

  Fixes: aee682fad6cd ("scsi: mpt3sas: Improve device discovery and readine=
ss handling for slow devices")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D22
