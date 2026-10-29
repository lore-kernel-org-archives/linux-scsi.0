Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793238873;
	b=f/7YYk/UKNiK/UVzexYz8WeqmlHkcw6621VSjLL+/QpCfIlMLEp99a15cJk+Bz6HFg8g
	 TWJWPhnXhJKT4Hf/z5spdPSjdp793V7VW3MXoBGoiPZvtd658wyJdCUsr+G0jwhxnG3kA
	 GzZZYxhh9PxoeKu7KDQWZI6n6H/DO+Mv+z2D4ed63DITtlfyrgsrtOkAizcKqqSyHnQJF
	 iEKwWveZqn1xaPcXkSbNLEQsKBVQCLbJPXQu5HLbDzQrCXPO9bcK/pgZ36qz0KTJd0e3d
	 hND5F3M1WSbe9rfgPP9cVAKTdErN6Uynz3y4Qj1Ac8Lpr/tAfz8BCqNte9fMlpC4pVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793238873;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KFUY+ufLmeKpF4j7Hh0RMIGS9MmAEj3cLOlUqVTjeas=;
	b=BZylGfgA619BxgWey0nWWaOE8AtYhSL8p+vTO4wTvJGMDtP1Sdr/xt2HRoLhUjuO2JK4
	 Sr2q8g+mIhatYW5Qjmba8rpioz0u60OEkhQ750GSfWw4uQu5TpX2wkQ3rnogaT25ERqfX
	 dDLK0QMBhUnK15BQoJLHmbUE+ZR5z/iXzSvgDFzWWPdciCU0zZ7LW7dtOvcbuI0tDUQy1
	 lUuwS8L0d5ynk1h73k//HjvvLloZc7zGBLloKQFtBBMiuDqLMTTlsftCkRzN9bPg2W5v1
	 0KuLx8MAKFUUTYpNNyy5MeevexX2j21pSlC0IGJpE9OubvBFpYoM3zr5VRz4r0eGPrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dF0dC2GJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18474606A31C;
	Thu, 29 Oct 2026 01:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dF0dC2GJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625991F01825;
	Thu, 29 Oct 2026 01:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793238872;
	bh=KFUY+ufLmeKpF4j7Hh0RMIGS9MmAEj3cLOlUqVTjeas=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=dF0dC2GJ59i82RuGIVffPk26UPSfKN/Kdc8LjqD8AqQKjOkzDIYNr2cg+HhOFpSyd
	 q+7b2WBXBDtSjIUGzyOlCHsoBT+gpv5JzUZEQtvV8Gyizv1iliNx2FzD76/UFIPMZB
	 w3gIdcM0GMqm+jodujQYcuktIJVI75HCHyj2Bcsije63ihyfCv3XafAj/2Ym0lFh8z
	 4MDrgPUCizgWjBcVpFuTJDaZqe04g9LLjZJ2zLoz72EOu0cjmiUymQcSFHnCdXlZr+
	 VsACayKwGxVXosTv8fsgX2YzNPlwkA+T6dU3Vom4X3R/gyhVd/tA8zaJYhkdij6jV2
	 NlqGyluvyv92Q==
To: =?utf-8?Q?Adri=C3=A1n_Garc=C3=ADa?= Casado
 <adriangarciacasado42@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,  "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,  John Garry
 <john.g.garry@oracle.com>,  Jason Yan <yanaijie@huawei.com>,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libsas: Add __printf attribute to sas_ata_printk()
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261020195934.250768-1-adriangarciacasado42@gmail.com>
Message-ID: <yq14ie546gg.fsf@mail.kernel.org>
References: <20261020195934.250768-1-adriangarciacasado42@gmail.com>
Date: Wed, 28 Oct 2026 21:54:31 -0400
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Adri=C3=A1n,

> sas_ata_printk() formats its variadic arguments via struct va_format and
> %pV before passing them to printk().

Applied to 7.4/scsi-staging, thanks!

--=20
Martin K. Petersen
