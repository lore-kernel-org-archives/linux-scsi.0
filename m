Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794999115;
	b=QqimlXqVBo6KKP+qINIw1iZMRtO9ClEeXd4mimz4OMaBwjWkJGRkr/+lUoVVLLJ7HO5B
	 x+MAXqtKeE3Pn1qyYy+2B4i5u6slq6LpsKAq69JjemUP3drIbRjLCZGFgQ1c8kKHMLcaw
	 cVbXlSc0yo/N0THkKvY+Xj0KdgtE+/Q2n900u3R4SSb0UKnUUqCNmoUX7FnAaRAXvGC2E
	 9MadASURUyUgEGcO7A6NdMUNTTGPCtS1hU6+44Db0ORBjSMMeb2j0O7J2r/64fubKvy60
	 x6ywlS6sn218A5ATZ9c7tArqeU82jN1loSJZnS6EusxN04bsi+4q4MfcLs0agBvBX1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794999115;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=unkljFg70WHS+F3oqtnMcnQgoXoSiOVjxScRsNCVD/s=;
	b=T4hOPNpkn3ifX4UkrxYIzeGcg2Xdm+J8fh1j4FIBIHPcnNbEv6sX72ey5823fcozSPci
	 Z1UrUiutXlGZ/e8aN4wQ82Am5+7mmBa2zIjH/+3FyIWKTnNcfzrfumokEc1ORnp7pce/s
	 Jo+ijuTNhiVoPJDZikPcSB8xYf1rZC44UGrTKzJxEg3hHlZmXkbFxt/yF6RGVApaAPGM5
	 zUHuTEdHuuGdIyK6hP7rJQDy1ZkfB0r7O4puLnJGO6LdEFW3d8qri89OFc+3yWfUCq8G9
	 kRak3U2p0jDLyjWzomXr/Hur1bHl5MEC9Q3ePvS8HWfbatYixuH2XkEy/2vltcf1zXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nc+7Z+qA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A96606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nc+7Z+qA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD2D1F000C5;
	Wed, 18 Nov 2026 10:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794999114;
	bh=unkljFg70WHS+F3oqtnMcnQgoXoSiOVjxScRsNCVD/s=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=nc+7Z+qAercb+n/toaRdUMBMFP4O6HaFqUGLLO2Z7vptB3VP2cDYRihGWx6+OzDF1
	 Ihc9Ay6IuwOl1t4osIVUCpYnSQgCNvtytk+aNmfF1yAPtrCx8HwoLodYu63a9w03qO
	 6+9nyeAhETJmyzOh/4oAGpDEkQ/zRbPhu+8Ow8+MRfxINpF7a8V2ctTrUcE26TJ5B4
	 TgarDMN69B/6SH/Yr35vjfPnS+662FInuhyjANhq0hTFTYwe+ZagFA29QfzdWGXioR
	 KI/lV0LOIc2VnrnZVofpNJqYC4PypE566MAdKFimY/D5YO4t0fFb0VXTiEDdSGpBgN
	 N0Qj5lg//rgnA==
Message-ID: <sashiko-outbox-220756@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 34/37] scsi: mpt3sas: Release sas_device reference on
 error in mpt3sas_transport_port_add
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-35-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-35-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:51:54 +0000
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
- [Low] scsi: mpt3sas: missing Fixes trailer for sas_device refcount
  leak fix
--

commit 0205a572d96fdf5a63e44438539df3b46769fba0
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Release sas_device reference on error in mpt3sas_transport=
_port_add
>
> The reference taken by mpt3sas_get_sdev_by_addr() is never released on
> error paths that branch to out_fail. Add sas_device_put() there to
> prevent a reference count leak.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
7d310f241001 ("scsi: mpt3sas: Get device objects using sas_address &
portID") moved mpt3sas_get_sdev_by_addr() ahead of error checks that jump
to out_fail, and d3c577724f156 ("scsi: mpt3sas: Fix NULL pointer access in
mpt3sas_transport_port_add()") added error jumps to out_delete_port before
sas_device_put() is called.  Should this include:

  Fixes: 7d310f241001 ("scsi: mpt3sas: Get device objects using sas_address=
 & portID")
  Fixes: d3c57724f156 ("scsi: mpt3sas: Fix NULL pointer access in mpt3sas_t=
ransport_port_add()")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D34
