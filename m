Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A871A5B8A;
	Mon,  7 Sep 2026 02:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749453; cv=none; b=ajrWuLwBEkqs+8WCcL2oAS/GYpo2d+LFnMrN0Gfh9ELK8+HmaFc633A8UusPe/s1tWgggCgX9NIIDLybf7oFOExk3n+ghlww3z6a52JfXlC/LanAq7qfV0IwfUcjceVa8J9lk4rTrYyaETnAdHLMmAJR+QBah9lbfUW9gz98EfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749453; c=relaxed/simple;
	bh=U82sE6vFlMk63JLkSGU4euFZKUyxNJTzK6cPlLHmDS8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l7NOKvFIAESWXsqIQbZqXNU8ogMWQ0/5s/72adI2yYgr8v/1KL711Cwb8t+oXW29Iw3Wj36EkbPTRy+i/HaEgv//8bFJXwOlEaJ65gBfFMW2n8XlYIZt/rF19LEIqUUxR4UAxU2xmecYdLtHGxtN5obiTufvWQqLk8036LsbrJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bI1WdHyN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bI1WdHyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EF11F00A3A;
	Mon,  7 Sep 2026 02:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749452;
	bh=U82sE6vFlMk63JLkSGU4euFZKUyxNJTzK6cPlLHmDS8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bI1WdHyN2uS4yB/HYEAt+9Yu+ifsGmM4lNyjuqkc+Og7EkpJr51BXDZ6Rh1126/p8
	 +p4BiVj1opKf8lIWmQDsRIEEK9MGcm5COddvIZk5DXZte9PAZJkO68Lkezv/LOQQXv
	 0h9gX5Pw+8GuahguvsXojWyHBxC4E1SBxtUEPLAXK4QwFfpzP6WQDI6k8ALN4PsJf/
	 +BIRjUhICxwKLT8YubeYNVN10tvd8yoKDMOhC4dprE+zO+BT8DHge2+gUFqFBKFPMC
	 doon7eCBiuoEPKR2zTBiDaXYJC9W6meBhgtHhQ815qSuQ9Vfy0vMrll+ZJxplpNoKz
	 4wWPsPeOF+Y/Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 13/40] scsi: device_handlers: hp_sw: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-14-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-14-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:50:51 +0000
Message-Id: <20260907025052.07EF11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the HP sw device handler driver to use the 16-bits sense_code
> field of struct scsi_sense_hdr and struct scsi_failure and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D13

