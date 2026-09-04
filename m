Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0035390223;
	Fri,  4 Sep 2026 02:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788490432; cv=none; b=r/j2+JgfqZysOYfwfjDkmCiSv1PdKig3hJF3hBt9/YxjzAY46meEJFF9Ej+AmFleueiW9TWVRAioIaFEsaqW1EU6ip9FQ/fGgaf8YKpR+xj9Mevytr+Y4oKJmkv8knLmvJfNOqk0XDXkWkYup+/fiVxOcw8MFjJyZBoQ+FE45+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788490432; c=relaxed/simple;
	bh=Uz9ELdi6dnmlVMvSnASpz3v7k19RY8+rpC0mVBC7xZQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QRrSxeAQtgrDFeQZBgxOxEAOqmfm1F6ThTJRzbowpDO8sLrw/ZWt3IzMfYXDUXfSV5sWB8LVqsVUUBeJwzrlYhazLdEla3su1XiZxbbNrv05bZJwO+jrIh6iCndh8aiim7ZS5X+fOzdqCquGLlkyXlFsI6pKGC1Z8dE+1jFobYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XIJ8rA+F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XIJ8rA+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1A01F000E9;
	Fri,  4 Sep 2026 02:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788490431;
	bh=DQcqb+TgEMnEp8qvbwHQoYBkMNzSNgUFoScY2cRCXcM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XIJ8rA+FGwLa8tGIMCayWKwsbeqpznH/uO17cm+KwjrrxdsFh0I3Q3R8HjK+ghnQ4
	 wNaeoEDxS/3mECWI19iqhPJ26nHYsBspjR8KsoGuYwbMbai1B2ovI+O85lg6UXY5xL
	 U6cvijAir9dG4RH796kT0yjnAHUhX/1t+JGpox6/gmpPNxUPFJzJXt2xHxhy7KQJ+Z
	 Hk9hTWmOo3mwiws4eMjd6JaOiAUvvvECL3d1xX4of86fzimN5VfRRZvuwxBOxWFdOd
	 zMOeRnZEzOlI+FPMpAzi3xfH+zVxb6eFO6ZRBSKS7/2YJ4NXa3COs83mUX0UJoughQ
	 DADRmNiCayvpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 40/40] scsi: remove scsi_build_sense() and
 scsi_build_sense_buffer()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, linux-s390@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, cassel@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260904002644.157668-41-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-41-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:53:50 +0000
Message-Id: <20260904025351.1A1A01F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D40

