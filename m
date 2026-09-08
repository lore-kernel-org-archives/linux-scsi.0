Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE7551475F;
	Tue,  8 Sep 2026 10:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788863555; cv=none; b=DfxD23z2DLHmoxZBgYhUXf9b/DrQNzs0ZTiMDAla7Jz9GJKXQPfaomDTe6Zsnk9makak6tka60deASFp9AbMbirOtW51jPT3yhe8XRYhy9BDMYVv/4ISnf/Js0Y87bZQzBlRF0IlSMYL9T3XSesgz7N7bnaiBuxhQxQBaq/PS7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788863555; c=relaxed/simple;
	bh=Dfvs/2K7bMiIFmzKEiWR2RQ5xgJBrwIiNjEtOgOB0Kg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EqNJL2iuKx5ErTc5pCVMb3pK+U+ZDKIEIfencBU+d/5aqXDm5PmRzDOYJQ3FF5O8M+fU/XByThiJhX7uC/wqBiS3Lj83baI3B8XTfL9h9LPCrSuXHOck77j3jsmXdr/hn1j+ll/0e62ryUpVI6dLtm8cj2VLdm5Asi+0Rgz46is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gj+8cp/R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gj+8cp/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082141F00A3A;
	Tue,  8 Sep 2026 10:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788863553;
	bh=j6YT3zC4YBAhmBxHVNqIMqv1uOu3cQpzGE9waj3m26A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gj+8cp/RJJPzgvfPn64RKVHxl8cPSEbucIQzWhIiOkTUpI0luaKp+mBXn5GVh8vlU
	 EgQOYABO8jx7vOeh7IYoGBf4DkM6PYXR9XZcVimyEShCP/IwU17z0xa1YDHllULLw7
	 9jmvlzfOKQ3SV7ldkwIufU7CPlfJcpJMQVqn8bAADRAsOO8NGmnRdqXur8O4veFndS
	 mZo/EdbxDpUh9kjPmuWXT+TB/guMEM7CK41rIowpTTiOJ9zzerg63q5N3zd8Oz+13E
	 ngREHsFdRDyyXM7Iaz6Rt2F4iQGBXpkGFz9LOINqHb7AYeLnl4zkktPqIZXvfFT3LO
	 0adEPTUZH2ajw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 40/40] scsi: remove scsi_build_sense() and
 scsi_build_sense_buffer()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, linux-s390@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-41-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-41-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 10:32:32 +0000
Message-Id: <20260908103233.082141F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Now that all code has been converted to use 16-bits sense codes and to
> initialize sense with scsi_set_sense() and scsi_set_sense_buffer(), remove
> the inline definitions of these new functions, change scsi_build_sense()
> and scsi_build_sense_buffer() to use a single 16-bits sense code as
> argument (instead of separate arguments for the ASC and ASCQ), and
> rename them to scsi_set_sense()  and scsi_set_sense_buffer().
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D40

