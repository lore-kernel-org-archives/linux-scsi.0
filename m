Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789615;
	b=oTn9W79Ib9djHWel1jQ6doDCTaaTrK82Ye5srtEk/a2Dc+uuHKUKbCiP/Ub2WZSimt1J
	 qYj4XPM4o4xaUsqzY3g319MBeV5HTPfTo+kebt2RohyTeDgQmhHPqh6BWQWh8VvCGivRe
	 DfC47r3cExtCUzvBM+1WAMFMCU+zOMJ3zr1iPVwTz6sme/tw9Z7HYVksiO2wUmPdDaIfF
	 9vIwjszyN8uy0IgDwmipa7MTS9Fs8jWGbpLof8pU8TTyiOaN28yjdv5mGNByq/1YvWs/D
	 S+Yquf49o0HDH0Se0Bn+lN7T+BdPwdK40Y082qr+Ru58nubmbRrGDxaECxXfXE2qiaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789615;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fah5HQHnEdt1XCoBXGmJ8reZ8wG0tbonmUjB4c1xKGk=;
	b=Mi6HLq1sX61KKyOg8FFcp9n/6i2OD8fO7X2gKaI9FO8CJkWsZMQfwbaIo9/4FZ2AfB1v
	 Eit5F3TZi5CVfOovUTLjC1qD3D5Ts+4GRTiEzupWjH6q9EH4mCFTYLtvnqbqFueMBYooD
	 /Fsv9BDwRVSHcHP7G4fTW18SXmeDAkKRzPW9sLnup4OcR34eHYTwX3ci49i/5vf7UIzVi
	 6yTASV9VD2IyFRQhWWt+ZOo0IRuNSSB7ru4oE0nBxLP1ZijyJuCyCTN67kPmjR/pnaLDs
	 KK/XbB10L+V+MbGX2NZbWFVqMvZZ+frY9k6t2veBAIpesfsb3CzOAmT903I/SrLxPdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JbR4DbWf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740B5606A323;
	Mon, 16 Nov 2026 00:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JbR4DbWf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1550B1F000C4;
	Mon, 16 Nov 2026 00:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794789615;
	bh=fah5HQHnEdt1XCoBXGmJ8reZ8wG0tbonmUjB4c1xKGk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JbR4DbWfsNeCTFNBnUyZCyKQjt0Kg0dUTjcE4ZHVXvcg6daBMLzB/UgXoybalApgJ
	 j2BrPZJ97i9ihW9U2E3uvZNXWQFzikBfDlLmKORxNrNKpkOdJZ4wNKZ1jdjlnWeICL
	 VQ1G4N7Z5HWRi+sjwKijToU42RcZe3CltEKNfcbyN/gWE8qjR0VfGDeWf9Fty4BwUp
	 XbEV7Bi3wgvjgkxo1cU8l6GtrrqvAfkIrhX8NQaoPRDSqPZsIMLB+ophbhtzzaynO2
	 OIDuG2iYB822UIDSAxXj5clZ9Co4iiQ9+oG86Y5TdS2gyXYOJSJ4r27zrzs6TYiQ2K
	 Z6nPJtl9nbUSQ==
Message-ID: <sashiko-outbox-215962@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 12/18] scsi: target: uring: Support SYNCHRONIZE
 CACHE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <qiliang.yuan@linux.dev>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261115-feat-target-core-uring-v1-12-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
 <20261115-feat-target-core-uring-v1-12-28cdc137eac6@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 00:40:14 +0000
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
- [High] scsi: target: uring: wrong flush length in
  tcmur_execute_sync_cache()
--

commit 36370455252a7c6edc07d1415bceee399ffd1ebe
Author: Qiliang Yuan <qiliang.yuan@linux.dev>

scsi: target: uring: Support SYNCHRONIZE CACHE

This commit adds TCMUR_OP_FLUSH and wires up .execute_sync_cache in
target_core_uring so SYNCHRONIZE CACHE commands are forwarded to the
userspace server.

> diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_c=
ore_uring.c
> index 629419a4c8f46..f39bf7bf36d0f 100644
> --- a/drivers/target/target_core_uring.c
> +++ b/drivers/target/target_core_uring.c

[ ... ]

> @@ -257,6 +258,16 @@ static sense_reason_t tcmur_execute_rw(struct se_cmd=
 *se_cmd,
>  			    se_cmd->data_length, sgl, sgl_nents);
>  }
> =20
> +static sense_reason_t tcmur_execute_sync_cache(struct se_cmd *se_cmd)
> +{
> +	u32 block_size =3D se_cmd->se_dev->dev_attrib.block_size;
> +
> +	/* Pass a zero length to flush up to the end of the device */
> +	return tcmur_submit(se_cmd, TCMUR_OP_FLUSH,
> +			    se_cmd->t_task_lba * block_size,
> +			    se_cmd->data_length, NULL, 0);
> +}

[Severity: High]
Does tcmur_execute_sync_cache() pass the wrong flush length in
tcmd->desc.len by reading se_cmd->data_length?

SYNCHRONIZE CACHE (10) and SYNCHRONIZE CACHE (16) are non-data commands
(DMA_NONE), so fabrics where cmd->unknown_data_length is 0 initialize
cmd->data_length to the transport expected transfer length of 0.  When
.execute_sync_cache is set, sbc_parse_cdb() jumps to check_lba, which
computes size =3D sbc_get_size(cmd, sectors) even though SCF_SCSI_DATA_CDB =
is
not set, and passes that size to target_cmd_size_check():

drivers/target/target_core_transport.c:target_cmd_size_check() {
	if (cmd->unknown_data_length) {
		cmd->data_length =3D size;
	} else if (size !=3D cmd->data_length) {
		...
		if (size > cmd->data_length) {
			cmd->se_cmd_flags |=3D SCF_OVERFLOW_BIT;
			cmd->residual_count =3D (size - cmd->data_length);
		} else {
			cmd->se_cmd_flags |=3D SCF_UNDERFLOW_BIT;
			cmd->residual_count =3D (cmd->data_length - size);
			if (cmd->data_direction =3D=3D DMA_FROM_DEVICE) {
				cmd->data_length =3D size;
			}
		}
}

When an initiator specifies a non-zero block count on a normal fabric,
target_cmd_size_check() logs a transfer length mismatch warning, sets
SCF_OVERFLOW_BIT with a bogus residual_count, and leaves se_cmd->data_length
at 0, so tcmd->desc.len is always 0 instead of the requested range.

On fabrics that set cmd->unknown_data_length (such as USB gadget f_tcm),
setting cmd->data_length to size causes transport_generic_new_cmd() to
allocate size bytes of unused scatterlist pages via target_alloc_sgl() for a
DMA_NONE command.  In addition, both sbc_get_size() and se_cmd->data_length
are 32-bit u32 values, which truncates 32-bit SYNCHRONIZE_CACHE_16 block
counts when the byte range reaches 4 GiB.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115-feat-targe=
t-core-uring-v1-0-28cdc137eac6@linux.dev?part=3D12
