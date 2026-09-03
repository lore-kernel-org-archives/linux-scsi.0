Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F0925B08E;
	Thu,  3 Sep 2026 03:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407432; cv=none; b=pCt5wrEooXe+n0z7MTErKibLSH7xzHhebqgOw9sxGitNvBt5NZNTGt3NTvRu1S2W2sb6+fbMjJeXdRXB4/I4zzDM8KogHMx7/IHUZGp3XSPQ7KGwQ+FBihGWDttKAaLaWay96plspMSZX8+u1amzioTub6HIbQlF4wX7bH/Pn0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407432; c=relaxed/simple;
	bh=r0Fb6XzBM8fRkao/wYo9TnAh2me8T+HaPHHEpRlxSkU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Phfcsceh+quKrL28H2B/lYBJ3qYB1diaClds8C9O0gy/LO4Y7FsyVmGbbn+IWoH1bL00ceYmXsldkVwmweOGx1DKuyKkjUljM+MTROKq8m/98MgcmSrjFxdKrwPREdWYFn5t+szXH1yZsyRJ7YSR/kk1Vb648l6ypHCwcpF2mhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nn4rYIAl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nn4rYIAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4711F000E9;
	Thu,  3 Sep 2026 03:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407430;
	bh=r0Fb6XzBM8fRkao/wYo9TnAh2me8T+HaPHHEpRlxSkU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nn4rYIAlZe5HmUhNsjbK4xUwIBigqeRWFupzvHwePAlGWhgpqh5WjbaqEhz8vzJh8
	 2O6ApEzH79JnYGJtLE2Rx11Hf7gA6EJoa845wh0UmjNaRTxhTqzW1fo40qDc7h3EjJ
	 a45aEBJzw/D7KNIFoKMWwcRKua9REtLaZ89r9s/4jBJ2BsyZAP8ojxQftkqRbwVYsk
	 moOmsdbY/Tx4j3SUNXx+h0otTOEm0BtAsQdJqBF2bbzXizSbVg38KhjlZlThcoM5gu
	 36OT+JOp2uW0K99Tt2drmOGPVkkh3LOJu99vRk8r+sdJseccUtCi54F3Nk7OsubdzN
	 bQeQQKxRXQxPA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/40] scsi: constants: rename internal struct field
 names
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260903034201.112211-4-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:50:29 +0000
Message-Id: <20260903035030.3A4711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> To make the code more clear, rename the code12 field of struct error_info
> to the more natural name "code" and the fields code1, code2_min and
> code2_max of struct error_info2 to the more explicit asc, ascq_min and
> ascq_max.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D3

