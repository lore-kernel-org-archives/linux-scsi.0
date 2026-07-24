Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C62238150
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 18:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917133; cv=none; b=RSMNnh3cg9e2tvBCLUSFNkoOdJLd3nVvjQbLQjlwzZ9tLdps38XW9FzKObnQQdFASKWKdrf9X8XK+vjj3ql4r0j7PfwWYDV7Jfb+6XuYEy5K0kIAfl3iBtlj9CuJsucwAVO8oEGJr9aST/q5yxZMeN2HgkZUFvrWo2Bk7ssTqS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917133; c=relaxed/simple;
	bh=FR/FdfndFpLSprRhOuy664CH3/7w2+Rk9mVibTXNCrI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pw6Y4LomygdhrT8U5lviMjv7oj2Rzs3UiC4SASN+TtcqXeOtCzg4oglFztjZWnDJfCaEXeoKEE+i9aUBzLYRhhRYajYIxKXq+cFPt03/ProjgiougVcNLcq0js85eymuhWW+/J70kxLBIgiQGvG+K4ZTYC9SFcFWUPm0nvP4sUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GLAkCkOR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GLAkCkOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313821F000E9;
	Fri, 24 Jul 2026 18:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784917132;
	bh=FR/FdfndFpLSprRhOuy664CH3/7w2+Rk9mVibTXNCrI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GLAkCkORJI7kpnjXtwvbYVS6uH4VgerFiyws5pEKbT6nJDtyYYJf0AofjF5leUO72
	 yLwyFx2fkOqSIh95KYh/E09+kH10M2wfjfrXfsE2jsIk/ksscXkHYuYMACzzvtMExT
	 LFJI1W/l1RSD/YkOsDZp2mW80Gys0R51hQLFs13sUAuFx6uTwibExzmI7BRsb9Dud6
	 D6Y3SW9wYuzvuB0FMo4dP97kosqQVOZIwnak+4kvF9qDLzn6ByZrKRGqlTswSKKHBh
	 i2ShHIOGdFBXig+hbRiym+i6h6VkM+TDMhLKi0r3HKiZVU2LCaNiCzge/dC+28gxl+
	 2LIIUvGcmK5Vw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 13/13] scsi: fnic: Bump up version number
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724174811.5118-14-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
 <20260724174811.5118-14-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 18:18:51 +0000
Message-Id: <20260724181852.313821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Missing Signed-off-by tag for a Co-developed-by contributor in the =
commit message metadata.
--

--- Patch [13]: [PATCH v6 13/13] scsi: fnic: Bump up version number ---
commit 0b3f5f40f11defa58bb2ce3f372901e2f5c3c7e6
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Bump up version number

This commit bumps the Cisco FCoE HBA Driver (fnic) version number to 1.9.0.=
0.

> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> Co-developed-by: Hannes Reinecke <hare@kernel.org>

[Severity: Low]
This isn't a bug in the code, but should there be a corresponding Signed-of=
f-by
tag for Hannes Reinecke here? According to the kernel patch submission=20
guidelines, every Co-developed-by tag must be accompanied by a Signed-off-by
tag from the same developer to meet Developer's Certificate of Origin
requirements.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724174811.5118=
-1-kartilak@cisco.com?part=3D13
