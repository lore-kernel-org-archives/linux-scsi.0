Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE26A2BB17;
	Thu,  3 Sep 2026 03:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407592; cv=none; b=joQyxEMxjACLiUkYZ6eLS/0b/Sv6T9n1hN1VkzpWNHSPuznYSJabCjR2/jcQIwj3G+tUtRH4rjPt3pNIleXZHZWRrkOh/DY0t/KOFbs1eBxVsT0uiduVdic313A8L5FyJM8E6OyHKzSMdcBXKeywRdI99fWZFO+BpqbdLihPJc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407592; c=relaxed/simple;
	bh=3fUYPowHqpo5R3AlIURrLaSI6Gx6yv0aIC+t3Hpdx7w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SelQ4qIvRAMjlUBVUMTjqD1JC/r54KSU0x+hkpJ3Wq1pirD17LLlCY+ZTQqpfmYfUsJvT/xhnnQGFaROHL1fY/ckVLHkjsMTI1Em02A64qlRpwZ7tRvD2aavbrjA07gxDm4wUKH+ibVMJkfYSfPpqX+oUBwBCrzG472Fvg4qPVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DsvccAay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DsvccAay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51651F000E9;
	Thu,  3 Sep 2026 03:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407591;
	bh=3fUYPowHqpo5R3AlIURrLaSI6Gx6yv0aIC+t3Hpdx7w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DsvccAayPYAH0dfNs6O8ilxLdH8tgiGcmq0asMeq7jRGEwCmRgEo+AsmTVsjkNXOY
	 k3tlOyKiQqyCy0qMCYKdnzPQgKCfBjTrLJ8/b+jx34X9u0i4EC5URTwMcTTLOMX1aX
	 4Ffj/68BDODkdQjNe+LVAD4ZhlsJbWL8VPDvc3loxLyjw2gOEWUhCNCeMAcvzjg/Pc
	 ZmTJBBHQlq+W/aqqxNW8hW235i6jKlvJqp9Kp9+4USatplziwGtJB9rvpVcHrtuJDF
	 8rX/Aa3IdgbvVihd1PcDFg7UIgEKD+4xoy4XRtex73rfXVzQIHol3fJ5dMVsVQwdi2
	 dHyxHiQZNNQjQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/40] scsi: constants: use defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, dlemoal@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260903034201.112211-3-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:53:10 +0000
Message-Id: <20260903035310.A51651F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The SENSE_CODE() macro is used for defining the array of struct error_info
> which associates a string description to an additional sense code and its
> combinations with additional sense code qualifiers. These are however
> hardcoded values.
>=20
> Now that all 16-bits sense codes are defined as macros in
> include/scsi/scsi_sense.h, modify sense_codes.h to use the defined
> sense code macros. While doing this, 2 missing entries are added for the
> codes OVERLAPPING_ATOMIC_COMMAND_IN_PROGRESS and
> DEPOPULATION_RESTORATION_INTERRUPTED.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D2

