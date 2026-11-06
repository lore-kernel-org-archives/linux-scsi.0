Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793927856;
	b=QD3gvAu98fiG0zd4r+8SGtbPnldZr0Ti6y5vRPwt5mIpoJyKAzDJyJnQC83ZYuybO1uS
	 4La71PfbJMj1R7weD4fbcejcYnury4KCwvakajynASTvdm4Z+qnG0cJpfrLslZGdDkth9
	 N4CA7qjazJpKFVlrblKMtna/ELOBDnDkDik6Kg0svtKtF3OqvzoXW1ae1nVYzDln9jmmP
	 ucityLj/pjnHO7aJu0G7FgRTSFpEWq3eKsRTalSm/TxnxZAXevPIEUF3NDTJNwo6y/Ee9
	 sn5/RJf8Zl+pgMP3MRwQVLacFGq/H9X4/EvUGatd2x80i0vmJaZqrYTVliKEXbHzVdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793927856;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1cWaegeEzBQXDhMcs7bfvoDb5SUdgm0F4yysGyu2qAA=;
	b=CJmvXNgXNQZrtBkBJ0rSexGpiiOBYQ/Z2zQOmBSHM4hGQsHR9veBeF3JkXMK6Y988sXV
	 uZ4ev2fHbPm7ijxXCCJ6b9LOI1lMnlev5lKnsc5h69jgtpwD06aSa7HN8IlqUITgR5XJw
	 xkWUJmmkMH3q1U1v1eWRPkUOK5svN/jotAbM3+r9wqJJVUg7NoAFdcmS2XuvSMLvBQVb/
	 XPaTxmuhIOkCDuFGG9VxYNqsst5WL7otXVDBO+AQ9AUhD8FoaYIMAXGRynK9Sl6oYbIwl
	 CPoYcqNl0gZoVUCu2KeqRS68m1di8QGDz9eJphPxyh6kFwfeXDyPlLzpAc44En8wncA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ea858LDY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF51C606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ea858LDY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3C81F0089F;
	Fri,  6 Nov 2026 01:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793927855;
	bh=1cWaegeEzBQXDhMcs7bfvoDb5SUdgm0F4yysGyu2qAA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Ea858LDYZKpd+qjHnXheUGbotPchZ8tuU36/tz8w7bqNQ4cHdjuTt8fr4pjLDfIVZ
	 DJ+Dz5GczK+LbYIqC5/Xj5tr3gDJ6lzDcmxQg3R9CAXYDJISU+//gsW/7c7wZGy2fy
	 bmEqCp6BzmKYrMSCP403cuQHQVnAbnZbXPnlpLD30sF7Ux2a+zasn0VWrVdacPjWnK
	 /oaCK4dWsKWT/x8tCRIPky2MdC1jSuD8XQL21SKasEj5I5VRoa+mjkqQN2LsvE0pd5
	 LP410a//0OL6etLMUdhx+GGh8dpb9fiW5zbu9MY46IqZ7DRCfKcdq71igqD79cI8Wu
	 4RH1MyQ7i6OHg==
Message-ID: <sashiko-outbox-200502@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/37] scsi: mpt3sas: Validate SMP request/response
 length in bsg handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1793925772-1303-8-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1793925772-1303-8-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:17:35 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: mpt3sas: zero-length SGE in _transport_smp_handler() for 4=
-byte buffers
--

commit 64327b5ec9fbcb353b873461686c34d1c93bb8da
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Validate SMP request/response length in bsg handler

This commit adds a length check in _transport_smp_handler() to reject SMP
requests whose mapped request or response buffer is smaller than 4 bytes,
preventing a length underflow when subtracting the 4-byte CRC.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3=
sas/mpt3sas_transport.c
> index e74a526efa8db..abb46a5e1c1af 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
> @@ -2095,6 +2095,13 @@ _transport_smp_handler(struct bsg_job *job, struct=
 Scsi_Host *shost,
>  	if (rc)
>  		goto unmap_out;
> =20
> +	if (dma_len_out < 4 || dma_len_in < 4) {
> +		ioc_err(ioc, "%s: SMP request or response too small\n",
> +			__func__);
> +		rc =3D -EINVAL;
> +		goto unmap_in;
> +	}

[Severity: Medium]
What happens if dma_len_out =3D=3D 4 or dma_len_in =3D=3D 4?

Later in _transport_smp_handler(), 4 bytes are subtracted for the trailing
CRC when setting RequestDataLength and calling ioc->build_sg():

drivers/scsi/mpt3sas/mpt3sas_transport.c:_transport_smp_handler() {
	...
	mpi_request->RequestDataLength =3D cpu_to_le16(dma_len_out - 4);
	psge =3D &mpi_request->SGL;

	ioc->build_sg(ioc, psge, dma_addr_out, dma_len_out - 4, dma_addr_in,
			dma_len_in - 4);
	...
}

When either buffer is exactly 4 bytes, data_out_sz or data_in_sz is passed =
as
0 to _base_build_sg() or _base_build_sg_ieee() in
drivers/scsi/mpt3sas/mpt3sas_base.c:

	if (!data_out_sz && !data_in_sz) {
		_base_build_zero_len_sge_ieee(ioc, psge);
		return;
	}

	if (data_out_sz && data_in_sz) {
		...
	}

Because both _base_build_sg() and _base_build_sg_ieee() only construct the
two-element (outbound request + inbound response) SGL required by
MPI2_FUNCTION_SMP_PASSTHROUGH when both sizes are non-zero, a 4-byte buffer
skips the two-SGE branch and submits a single SGE to the firmware (for
example, placing the inbound response SGE into the first outbound request S=
GE
slot when dma_len_out =3D=3D 4 and dma_len_in > 4).

Should this check reject buffers with <=3D 4 bytes (or < 8 bytes to account=
 for
the 4-byte SMP header and 4-byte CRC) so that a zero-length SGE is never
passed to ioc->build_sg()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1793925772-1303-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D7
