Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AA63E6DF7;
	Mon,  7 Sep 2026 02:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749802; cv=none; b=PBNJa6FNVs5tJPmBxWponUqF7MqznJ+3cim+i6xymDtxxTk+ww7vmOm7CZAePoAL9757Tj8yp6uKf5dmswZQqVZP4ojrsVCUHEg8sO8iVJ6FogNGfKrjof+DKu759gSaKLKlKj+AU++TlfRWy/mGnGrrdDvvSZQIKnwfHSbqf3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749802; c=relaxed/simple;
	bh=j0wco6XDefirXMGgQNf3MTOijr+VQ07niUGb/G1YFgo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AjbMbLLw6C689IEnHNAcPec81wAEcsWMeUnmkMQ9cNNJrdd0CT9Y5xQIJCwPHJx49qcHDuYEEPkM0zkyjDuvaYdVVjbEs+rwMbzbCUhPqcHrtdYAQr+6dZG+kxL9m6QZ6zE6QrwKPcEy7Xe2vQNiagEylu/YLiyjWguDMPtVlTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4lqvsoz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4lqvsoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DAF1F00A3D;
	Mon,  7 Sep 2026 02:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749801;
	bh=j0wco6XDefirXMGgQNf3MTOijr+VQ07niUGb/G1YFgo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z4lqvsoza6r+Szt+Fh3fL51a46y+ORSXxPr3fLIzIfRL+yNR4o3uJ6pp4cliZnaWL
	 xebszHHejdhL6SRSAfSaq5O+8dNY6gcPjO71g/jueATeStCqbYeJimCdiEC6Zo70/P
	 PhHVo3xa3I0BWKJPD595ZMBOMbTMxAaQ+JyD0Ibl6EYTyRkq0Tl0XVoDbbJImUALyk
	 QZKTMl150z+9ju8azcc3QgHTNmuhmji6y8J+eu/qQaWMkV6oH/QGhwjVg2XpmM18Ui
	 yRCTsCfeGWoc7XIAUhfxEU/OTUKE0u5SN853CIk9E3u1WXZ8Sov3y9VaRezl6dNLuU
	 MlEPvAVOZRfpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 21/40] scsi: megaraid: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org
In-Reply-To: <20260907024343.1046387-22-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-22-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:56:40 +0000
Message-Id: <20260907025640.C0DAF1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the megaraid driver to use the scsi_set_sense() function and
> replace all hard-coded additional sense codes and additional sense code
> qualifiers with the enum values defined in include/scsi/scsi_sense.h. This
> helps with code clarity as the sense codes being processed are easier to
> test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D21

