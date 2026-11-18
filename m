Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997351;
	b=ot1Eh5odLJjw4Apoug/1NoacLPpYddrs6Dzb3htDbB5xMgWWCz6AD1+VFNtmk7eU7In0
	 iKFoNGYJSN9w4g5f8oyWoACVb5TpnuHvJ8YcU3YrjgLKPoe/jRmTFXJw9ad8fTMs8msPU
	 1GUviSxuEDKHn3QE6JXbLHzGGi2N4R7UbOuodUhrqAryezWfSWfdfU9D/qZD6lU0SNiip
	 tMFtYuTHVwSvUmmqma9UG9dSgXuAjBP1tJyW6TvvW3Y2zoUiMmMG0Hyagd2deI0CddWkH
	 twaPQvraxX0eeB2SYazt+kybfe6AyjenZIMRteIJXSWhk/fjkNS2gdJptSoHsmohXdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997351;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bUHVFNefYZS8D1nULQUQw0o1Z2rNQDopbIK8wdY8HCk=;
	b=kZVFqGrXbE9hrnXyBE/axrYO040vL7IcuegKMJv2jX+qWURN9iIXfK0wTWQy79IQM6S6
	 O6IVzZaTt195y/rnUvS/IHuJiuplul/rHK8Mn+DzerYvaOv9ABTyqRgBsYoP8Vf4hCb63
	 rydDeYt9dxKxYfCSucJ85Mgpfc7n+Lh34H4qtVcrzVB/sEpI8ajYCEkZPSiVpFlASVQdH
	 kLMrWwLNb6KJQ81w5Ju+zmm6qF+hwgYNRet339fJoDZfd8Wxa0ejYo6TbczBvtHViKTwf
	 eERTpATf/BWZMJAIJX0Uq3MkYCLuLtbWiyLdXtuAXGNClc/bsqBO7UtGtqp+yfDZjpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="X/AcXFKc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74251606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X/AcXFKc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54B11F000C4;
	Wed, 18 Nov 2026 10:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997351;
	bh=bUHVFNefYZS8D1nULQUQw0o1Z2rNQDopbIK8wdY8HCk=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=X/AcXFKcKgt89TcyTNI9/7zwiRn3HhVOnXFBQjtpIjKgwQJSVi7J2G0JnegaUt7SC
	 Pmbb2HVMaST9M2znki7ZwCqIi9dUxV6wD6d2iYvv9yMruQEGCCGQeOtds3BepaCUeO
	 v7w7uj+2N6pl2uERWB1hy331I5mBI7Hvhr9nFg4Ckx7ejaO90kzZyWOdiPI915juLS
	 h2PSZErQoLCgidWqKp6IQoE/qg8IGHGf5i+XixKyusAFf+eTZqvMuZG58Gy/AERtGK
	 VTEyi49kuefhM+q/qYuS3XKBmLKva06jzjV0tyK6VkqP/GYMCYdb+ywRKYWbNoKAxq
	 Tk/EuF1JUCfLQ==
Message-ID: <sashiko-outbox-220682@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/37] scsi: mpt3sas: Fix port_table memory leak in
 _scsih_sas_port_refresh
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:22:30 +0000
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
  _scsih_sas_port_refresh() leak fix
--

commit 4df946a26df1e07b82fd4552694bd9266dd6fd85
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Fix port_table memory leak in _scsih_sas_port_refresh
>
> Free port_table on every exit path, including the early return when
> no ports are found.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
This fixes a memory leak in _scsih_sas_port_refresh().  Should this
include:

  Fixes: a5e99fda0172 ("scsi: mpt3sas: Update hba_port objects after host r=
eset")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D11
