Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998431;
	b=DSsl7aaEjar6IOb0Rt5ImIjil7aAO6ZShKG+kwBB3RR5cL25NY+Wt+UBBr/r5vhkMltK
	 akuV673eLVza1PA1XrFiPPUP9LdmtWe73g1CLiARggmI5s4WItj/bHJt+nPGqAsckkotr
	 GR8Huw1wnYlj6Ao+j7vmwKf619XLQDLo7nAxpnkHCHQ8zN7QH08EePrGZGpY/4IZVpYiT
	 d+imKlGsEwezFPxlQ9DlNt+gyiNeOoPUAdpo2L4O7yB8qbq429uBwpQHB4B3r6mNHyU3H
	 PeMpT26G1gMGncw5n2jluLBMSBzDa3/fkpyElHG5PXZKz0XPAjZlxzZOoDfI/WuxcVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998431;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RuFTvBtmuxSOSVTdyqUk7JrjOwolQ5mCuGbQKwQoPf8=;
	b=IeIA4LmPamAKVmXRNWfhbtejMoOl3cMocH9KflaMMtGWeJNMMJsCyZ2IiNm8z77mg0tf
	 NqIDEDai8au7ugZlZwnA7IK0+1e5d6HJ70gsBS8pSJu8yLh6avPnC16PxOx/rTIx5snC6
	 2y+g+AH2RZ9lD99StxBg1rI6xjPrxaLX0gbGsnrT3XQYT6gV+K56bkp4yx1ySallWabMd
	 lBswHD7VvoVoC7G+pmET8/MG9vgBdQOdax89vuxG7ndwly/fSyL8x5H5vGPLc1dS897Yu
	 kD6+tH2APa2GfLTePQO3UdVqpzcTKZYNPoNylGzlX5oCXUDMvgCwdFxsXuGESz2yPwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="U8ra/Vwp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B163606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U8ra/Vwp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC87E1F000C4;
	Wed, 18 Nov 2026 10:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794998431;
	bh=RuFTvBtmuxSOSVTdyqUk7JrjOwolQ5mCuGbQKwQoPf8=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=U8ra/VwptSvy14RUVHHxP3I3a9NODT1/a/LaQz9wRe4Mnh4jQF7jLEpUGkfgOeDfQ
	 OyfxEy1qQ0/T9/uhE8+Rc6mghnGhBiktRfvE57DbRbn8RD1CF3+C7fJGRz2fXQAFTN
	 g/CRYZQ6koaYN9DaX9N3Bar43/zU/gx6kPpk+hTg8NGQI7nwIKuZfe9GeulNIbS7iZ
	 oUrJpXHQRkWlTTwV44MYGdqOM8K0QApCVqer4GTHBCIi3DXfHlzyiu+OIg8PT/sJ2F
	 dPUY1t/0YM0eZwBT201LMeDtLGJqYpC7m5OBfWGGyLWSFb3RJe/4p5K4W1lDgSiYvq
	 QwlMQn3aym0fQ==
Message-ID: <sashiko-outbox-220729@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 33/37] scsi: mpt3sas: Bound SMP passthrough buffer
 reads to actual buffer size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-34-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-34-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:40:30 +0000
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
- [Low] scsi: mpt3sas: missing Fixes trailer for _ctl_do_mpt_command()
  OOB read
--

commit 5f3c301389fcadf4a6fbd2c4af7efab3ea17511d
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Bound SMP passthrough buffer reads to actual buffer size
>
> The SMP passthrough handler reads bytes at offsets 1 and 10 of the data
> buffer to detect link-reset commands without checking the buffer length.
> Guard each read against the actual buffer size to prevent out-of-bounds
> access on undersized non-inline buffers.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
This fixes an out-of-bounds read in _ctl_do_mpt_command().  Should this
include:

  Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D33
