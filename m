Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998879;
	b=asij6/IBiEkmqRPa2JvHlSHfN1IjTjeARZmJhIpbmaFBhn0rcS21us9RRc0fchptKJo7
	 N37bs4VFqSljwQ5+LKjNojMFwCjb0jhyzGKvdpCi8g74t53teHg6xZhK1xQlsMjSN24pq
	 gGXyHAqeMcYghKhGjLnAy62AKs/hfwbf2Mce+wkZL9HgBiwS7Z3K3R+6ln54IXjAA8Kqo
	 oQv6TN6e4/N7Tr7ihEIyeE99UETukm15IAE3LozMeW/kK9GNhW4X4oiqXiAkpBHKuCPN7
	 NGG7LOkflAl2hlSIjKdewZJRy3fTSwdvlFm60rUJk70XPivCeyE/oc1qWndvm4lM4nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998879;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=B4SigNmDFPXWjmiCEuZDqjKp3qRBm8E8uQ7Qzd63H1k=;
	b=l9bRyD9GXgL00iuSiDk+rNY0wD58mLh86iXtQOhLe6pbS/9f8QMoa4/m6V4HJuZDhLIw
	 /Xn/9u9bgVOgEgCtuIYpmcO2v+qArdSluILmIQ5m1vSTyb/zhiMHiAjQxy9um+rNCiIAB
	 yD7Ay1sF1aLK4fd39YnRhpnkdV2bEeGgCt+/Z8W2lxDZD+mnNYeDdnNotWkv5kW1ka7HU
	 Nn4COVKGMmAzz70BgiazGgBP5ebfEiZ/PwKp+lWlBGtBUB29ten8R27hVO5FVGnbBZnT5
	 wp3U58mzjeaoOkuZy3QjIuA6VKvsnUTV7H+d6n4EiTgmEUOAAiP+h6jZvHCozJVNXAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ir+VUaTd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F11606A33D
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ir+VUaTd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086A41F000C4;
	Wed, 18 Nov 2026 10:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794998879;
	bh=B4SigNmDFPXWjmiCEuZDqjKp3qRBm8E8uQ7Qzd63H1k=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Ir+VUaTdCSQ9/xu+WYByso+/DK1srktzrjQdQg54ih0JS44vtWssuoGDH3Act9sSh
	 kVCi5rWx0euajPiJNJUM0aHTjnTZvzYpdE4VpvurE1cw0Sd03DVM3qfaJMVgbeQCUR
	 JlpSgaNAn3cGE1c1Wcb24It5QuvSiyZVC9HilO1AAXwJVIyiflPi6JSpmpwDkbdtnq
	 Y+ZZlNECSmRJnsfWImjFr6/xsV+rQfKFVFxFJ21jw1rFP/MrCBWXpteU8WSz9PfJby
	 mWSNBdDjv70hK3f0lg64HDB7GBYIcHgXuM43K+FYTnjAjhMSV1VjUtJDsP63e6YwWY
	 VMsJA3OVBJZIA==
Message-ID: <sashiko-outbox-220746@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 36/37] scsi: mpt3sas: Bound NVMe passthrough transfer
 size against PRP buffer capacity
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-37-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-37-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:47:58 +0000
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
- [Low] scsi: mpt3sas: missing Fixes trailer for commit aff39e61218f
--

commit dcbf2f39152738ac023acb7b93f4568b59a44fcd
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Bound NVMe passthrough transfer size against PRP buffer ca=
pacity
>
> The NVMe ioctl passthrough path builds a PRP list into a fixed per-command
> buffer sized as sg_tablesize * page_size. Reject requests where either
> data_in_size or data_out_size exceeds that limit to prevent overrunning
> the buffer and corrupting adjacent DMA allocations.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
This fixes an unbounded DMA buffer overrun in the NVMe encapsulated
request handler introduced in aff39e61218f ("scsi: mpt3sas: Added
support for nvme encapsulated request message.").  Should the commit
message include:

  Fixes: aff39e61218f ("scsi: mpt3sas: Added support for nvme encapsulated =
request message.")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D36
