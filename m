Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794234591;
	b=MiRBJvF5P+UBF2MRbCVP/PNlU+5H122nOMdX9knxlSyspA+ZLsXmUX+c+YEBvqkq7ue4
	 ektC7N3fyaezZGatHRlQMR+vNQm8R7fvO56ZI9nEwkz61wSk0Zn1guJLYmhfbEwbUIO3P
	 LC4GpoY6ZaLCDHYUFkAOZqlFJhPgx17OyyorTssioHxrz0PCndi7kE810VnI9JyyUCnQm
	 hYcBNQlS/L47Hh6RIJTUtvb7gPoa/BcEjPmkX5KbLiokE7bP5vkS9nF6rkHkuDTL/p1UV
	 egRxPxEy3QYlXwbkHGnxBv0tSDPEJXavRqL7Y/MORg7WAi19XeaDNiyZrRfOuTw5cgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794234591;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=F0yDTuUVfgJLe2qpUKu7QKmJAdlcT6aKd3IeGANqofM=;
	b=yntesCtDpxY1Lw5NEwzuAcnpats8b7+/z8ZROezuUuExxDtu6yDjsAQywLa5jhTFQZpq
	 ORIq3Ka12fh8sJzwsFxrntEf9mgax7ZS+yH4zIIiL6DUghiB6hlX9VO1xBYzK/03qww3J
	 m7xBJNft9C5STSYa5qbeji4TZ9lXDkt6Gn9dSI9991GMqAAYGYOHNwPjQMh+dYscOYrJR
	 dpsJOfq5bHbAo3gVwj0PcngaVRcbj8VcpTvHap1UvBkN1tqI6GoBUeGpsMApSAfQ7Ii52
	 gQnuHYts7gWN5t90ZTOdRZdH96fvMqr0K1hKUY6I2nlyaSAxuShVXJeiG5ZtOwvy2/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PN2rZskP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81384606A31C
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 14:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PN2rZskP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A39D1F0089F;
	Mon,  9 Nov 2026 14:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794234591;
	bh=F0yDTuUVfgJLe2qpUKu7QKmJAdlcT6aKd3IeGANqofM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PN2rZskP1XqtpVr0/3SAdpYakyORpcbVv5K0MhqnKa1nxd9uFZpWWrSV0FugZGbgu
	 kfyeLAhPEV1eWyHk3GHW4hWg0Pb45CxstA3g48HHTMRyhbqoySeRgCkO0C6gtICF6o
	 qg19/PY8RAccmNTnyYkO+PeeORPliw9CYG1aBk+G3+Ag4WKqQlLnLyae5XcP5eIrnA
	 L90dQdVmkvNRzlBRCtToayUc6AllfhvKeiZ2R7gfzoUq4ieXV207uSGV9c60o7viCJ
	 BjhmSoVn74uZxWoWVvu0oAMRv5hh7ESqt0kDzD0ZVRLFyYhtdWG58D1rgnWAwTdarH
	 bRRo87jZAAQ+w==
Message-ID: <sashiko-outbox-205105@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: qedi: Add __printf to debug helpers and fix
 format strings
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QWRyacOhbiBHYXJjw61hIENhc2Fkbw==?= <adriangarciacasado42@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261109141738.1624579-1-adriangarciacasado42@gmail.com>
References: <20261109141738.1624579-1-adriangarciacasado42@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 14:29:50 +0000
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
- [Medium] scsi: qedi: -Wformat build error in
  qedi_alloc_nvm_iscsi_cfg() on 32-bit DMA
--

commit dbd61cf20f660a9013f24529bb4ce72d39dfb22d
Author: Adri=C3=A1n Garc=C3=ADa Casado <adriangarciacasado42@gmail.com>

scsi: qedi: Add __printf to debug helpers and fix format strings

This commit adds __printf() attributes to the qedi_dbg_*() logging helpers
and updates format strings in qedi_fw.c and qedi_main.c to match their
argument types.

> diff --git a/drivers/scsi/qedi/qedi_dbg.h b/drivers/scsi/qedi/qedi_dbg.h
> index 8649518658691..70acb55847f4f 100644
> --- a/drivers/scsi/qedi/qedi_dbg.h
> +++ b/drivers/scsi/qedi/qedi_dbg.h
> @@ -78,12 +78,16 @@ struct qedi_dbg_ctx {
>  		qedi_dbg_info(pdev, __func__, __LINE__, level, fmt,	\
>  			      ## __VA_ARGS__)
> =20
> +__printf(4, 5)
>  void qedi_dbg_err(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
>  		  const char *fmt, ...);
> +__printf(4, 5)
>  void qedi_dbg_warn(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
>  		   const char *fmt, ...);
> +__printf(4, 5)
>  void qedi_dbg_notice(struct qedi_dbg_ctx *qedi, const char *func, u32 li=
ne,
>  		     const char *fmt, ...);
> +__printf(5, 6)
>  void qedi_dbg_info(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
>  		   u32 info, const char *fmt, ...);

[Severity: Medium]
Does adding __printf(5, 6) to qedi_dbg_info() cause a -Wformat build
regression in qedi_alloc_nvm_iscsi_cfg() when CONFIG_ARCH_DMA_ADDR_T_64BIT
is not set?

drivers/scsi/qedi/qedi_main.c:qedi_alloc_nvm_iscsi_cfg() {
	...
	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
		  "NVM BUF addr=3D0x%p dma=3D0x%llx.\n", qedi->iscsi_image,
		  qedi->nvm_buf_dma);
	...
}

qedi->nvm_buf_dma is a dma_addr_t, which is u32 on 32-bit DMA
configurations, so formatting it with 0x%llx instead of %pad (passing
&qedi->nvm_buf_dma) triggers a format warning and breaks CONFIG_WERROR=3Dy
builds.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109141738.1624=
579-1-adriangarciacasado42@gmail.com?part=3D1
