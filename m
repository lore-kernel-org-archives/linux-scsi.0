Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794336007;
	b=zTNPWB+QFhK47VMIPzcqDfc1PWw70nAddwQ/ZhpLePE/080aQGmRaEjnlpbWtiX9Aljh
	 HXfJpkPkD0DLMBLmbRM3pHLMwBAKlKY0moZ9TF24zD9oyKg7Rmvs+8Q04tntoyQsQQA0M
	 Rx3/o6vmHj9rDEt+myhRvvETq5PpBci0q16KrmFe7e0hWfdnTqpA7v/BIPkNFgLGzy4Fk
	 7ZMtIIV8uDmIxCAGLeBpOGfEQfHNo8VwomT3ciw/HPNCu7+4TMvh1H61/ajj2eqmN3mO/
	 gb9mamBr8p6QCa+TZdfBX0hAIFVoELczXnUXfR4Hs//sGdy16FRJRgTUFMTd0Sp12ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336007;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GVR8k0QD4pCJ9sK5CZbcvTqjo4RC8k2y6IEjNs7VSek=;
	b=bKuuh67Jh/v7dHG/3/G645tip3YVjguz1iPuSU0L4GJuWT8BAVQ29G6eWuD/jhn/0pxp
	 DIpU3jddtkkqRv6XmNkffiH8xt6E2qy0+NjMu6UUzgGqaYlo7DshpiuooC/rvExEr3tqm
	 d/L+mr+43i+MWeRCMcS/KgesTUFcwDidXxzjoBwV5deivwmFgLH0aLlhdq8jAagMpUtW8
	 dj+w7YQTWLtlyQwjY4lewJzjX77QCcRA5WMSVKdcrpuTndDRtvzCO1IcEYI5vzf0LNG3U
	 KkR1CEvdb5UW0kG5HAjbCdrGR5WUpi1nhTKnJROiHEdy9vh2z4xZSor09Zu9A7tF4mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nn6sya8V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A6960A3833
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 18:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nn6sya8V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77771F008A5;
	Tue, 10 Nov 2026 18:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794336006;
	bh=GVR8k0QD4pCJ9sK5CZbcvTqjo4RC8k2y6IEjNs7VSek=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nn6sya8VErU9FcMXVzK8ODsL7hFYgQIqRXkY4B2SJ6MopAfifmYLnXwWs1dwB6QAA
	 rGhNKor2YqiCBuYSnxdq+oUX/XJxtsGGoTDpKUBDoO9+QcOg4qFfRNsFDKjzrtRneM
	 8Bu6yuTNJms/+nFp+R7n8p+EzQAf1tqRW+M8VdC/s9Ku2P7RpCpbU3SklsuwYD3dzf
	 Q0UShs0HQCUH9U8xncvKt2W2+eysE9pIEcuKxihdzhs1AXBLO2IU6g/1JsK8hxeTNU
	 FH4dP4wh1wm5PGN6zVIcM14Dzm81Sou7AYsSTwvB/O2l6xOxbcdho8ffvlyfgu9TDQ
	 ZRuCbbIdHeWEg==
Message-ID: <sashiko-outbox-207594@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: scsi_debug: handle protection information for
 WRITE ATOMIC(16)
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tal Zussman" <tz2294@columbia.edu>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261110-scsi-debug-pi-v1-1-539829902b3a@columbia.edu>
References: <20261110-scsi-debug-pi-v1-0-539829902b3a@columbia.edu>
 <20261110-scsi-debug-pi-v1-1-539829902b3a@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 18:40:06 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] scsi: scsi_debug: incorrect CDB byte offset in
  resp_atomic_write() [1]
--

commit 48252d9d72a1d4d7e89b4f529cfc1af6aee082f9
Author: Tal Zussman <tz2294@columbia.edu>

scsi: scsi_debug: handle protection information for WRITE ATOMIC(16)

This commit routes resp_atomic_write() through __resp_write_dt0() so that
protection information is verified and stored for WRITE ATOMIC(16)
commands.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index a922c8318a2fb..7d50650396377 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
[ ... ]
> @@ -6328,6 +6329,7 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
>  	u16 boundary, len;
>  	u64 lba, lba_tmp;
>  	bool lbp =3D scsi_debug_lbp();
> +	int scsi_status =3D DID_ERROR << 16;
>  	int ret;
> =20
>  	if (!scsi_debug_atomic_write()) {

[Severity: Medium]
This problem wasn't introduced by this patch, but does resp_atomic_write()
report the wrong CDB byte offset [1] when boundary exceeds
sdebug_atomic_wr_max_bndry?

drivers/scsi/scsi_debug.c:resp_atomic_write() {
	...
	boundary =3D get_unaligned_be16(cmd + 10);
	len =3D get_unaligned_be16(cmd + 12);
	...
	if (boundary > 0) {
		if (boundary > sdebug_atomic_wr_max_bndry) {
			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 12, -1);
			return check_condition_result;
		}
	...
}

boundary is parsed from CDB byte 10, while byte 12 is the transfer length
field, so the sense data points the initiator at the transfer length
instead of the atomic boundary field.

[1] https://sashiko.dev/#/bug/linux-0276b62a-b78e-4b07-bc67-b1a9f88dc08e

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-scsi-debug=
-pi-v1-0-539829902b3a@columbia.edu?part=3D1
