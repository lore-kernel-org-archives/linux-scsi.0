Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997351;
	b=IQDdoQpfEI/Wj18LjU6ouUxDFbvW4t7VKQFmkxxkxV1QYRLYzJUHVGprjepgBrNgkVuT
	 h2sibgRVksH3mlqAQh8GmHLXWUdj6TsaEJIAhgeNTryUBNAlMiMxorlWg4Jar729iCVzs
	 rumo36grQft4DtzIXC5FHzd47dYqDSk1H7kQgQPTLM4VKAkKRqURym3SL8KyAPNBXb5ih
	 5yv46ajJzRUWk5PYPpxBri9hiVwhvMqggVeX32sNJUq87t+xISARVkO24vz9RtzUNIv0n
	 96nURrT3K/NzeI+ToytDWfannzs34N9cLNdYNaHqlVqoUKszthTMAIc4Xse6SZmm/0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997351;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=v3mOq1jMU3S32zQLHnCGgVxipZihZw+4skQcojdvw9E=;
	b=TfJ36DgS7Rd7qxL0qQV+kWLL4sVUUwFWJd5PwMB1jC/qIS8dq0KTBYSL3RWT4EngfEXF
	 BD+xwczj/SKWyGx5RaJD8rzTpDX9yNnoZMDsvPwV4kgzG98Z5l3kctZSGer24QfCcaVuP
	 dGbnf6qaWjtkEaeLFDz5L1fhlFu7Fh6RH88D30M/e4DFJf/ZMALsIUFHQjMN0kd9Evf7i
	 poUI9obwCT2SbXMkx6WUElHw19JKdaDTU/TXj2bKbe9kTpzav+AIm0EHyLB8lo/SU9xZD
	 7IZQTUQrqs9iFfjIWSALqcI9NgRcCYOd/4N9VWy6EPo1G6o2pvMb2DicmJgKSRgPq4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AACkj9IN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DA6606A32A
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AACkj9IN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878321F000C7;
	Wed, 18 Nov 2026 10:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997351;
	bh=v3mOq1jMU3S32zQLHnCGgVxipZihZw+4skQcojdvw9E=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=AACkj9INgPzlwQ4jAjaEk96JawpJOaf9GsbuQwOLumvMCCWA2tpRg3R1N5Pn18iG0
	 6CVbNHU3oRrCnhkNY5M6AcpfdysiIg4e3K/D0ihLBM8mLcaoDZK5e08064LnlhDFn7
	 T1J3qTt7NDYmVfJFFycZQ+VkfQ5oalSZg42zAUFAk4Z2MwflTHNXB1JWxN1E/6p6sD
	 w5y749F0C8j10tgZBbB9r6Jb6rxiNPWaH/eeQj1HgJIdFn9IiAFe3Bhf2XWYLuNRdV
	 qvjfHVfTDfwsckqw0BcMG77YuF0A9LFuev92WVq33x9emVCNFA92SGeUXq22R7V4qH
	 xjM085wlSycXA==
Message-ID: <sashiko-outbox-220683@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/37] scsi: mpt3sas: Validate RAID configuration
 page length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:22:31 +0000
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
- [Low] scsi: mpt3sas: missing Fixes trailer in
  mpt3sas_config_get_volume_handle()
--

commit 1a9b4a845a58146159a3e5de43ee7711eceec2d6
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Validate RAID configuration page length
>
> Check the RAID config page length and NumElements against the
> allocated buffer before use, to avoid an out-of-bounds read.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
Since this fixes an out-of-bounds read in
mpt3sas_config_get_volume_handle(), should this include a Fixes tag?

  Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D2
