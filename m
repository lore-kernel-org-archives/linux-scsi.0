Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998384;
	b=YOmA1Qtx4fcAkE2ap3ee7r0F+rSm4v2OeW2gpfyjF/cCaaquXxRwFDKe/DDIwxNg97g5
	 ntzjTTkNHRHNbdPLBzfqn6rbOqYNm9rMnW7KC04ImtLKzVVPy55kSEuAa6Cq1t//5jk+b
	 sVPfZb1R47tmz2kuKIj+8JeosrOnBR4MW31b3dShD58Mb4hfho8RF6R9scazI+5bWdDwX
	 gNFSQ1PzHE8y6TBYNoxEIBmMteYn/mE4gYYvJp+F3r1dHrZJDT5cyyxLmHsdPUb3dVNfT
	 hunlaSGYi06NdmDNogVqzXoiCbsGqEFWvlzpdWPCwKMUVg5Jb5XWJ9bCppskPFzEXYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998384;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Tz06/0E66GmPfK4gkudA+Ojdyp7Fuc+EtkRjUXi29D4=;
	b=Z9M4EsyuIMObbFCpaMmvi2bNtzLF0Lw8sNKlUFuRG9sb7zv6zSqY6u/fLUTuYUzC+Q6P
	 O+wpJCunCGjHxiIk65wY945uNNEYOXLFAky/nJ08t7H54qsUyJcU++kq5WhCLZOoJ39A0
	 aIp1IhvVMwdgU9UFQGxVxD+G79wZEQ+Z+tEmcpBQBxY5m2IuH5vo1ZkP0si3OJZDpD6z/
	 FEgdArmW8m4bMooI2rDdPNySyi54oyWbfKEvZeLlOim+x2foeXGsLeU2Bis4RcXOcwY+4
	 XyCom6Jy0e1uYteJ36jJ7QH8eYpY8MBFru6M4gkOzSOrFAKKajnDpGEy1dLJ/XkOhOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kI26dEH1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54BD606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kI26dEH1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D551F000C4;
	Wed, 18 Nov 2026 10:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794998384;
	bh=Tz06/0E66GmPfK4gkudA+Ojdyp7Fuc+EtkRjUXi29D4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=kI26dEH1COJxcikF7crE7X7gzSAJ8GyYvxciaN3qPqXsBqcBFyOcHXJn1KwGqgGYd
	 OIrQXGeGUtFkm+QfnTDcYmqcqc9Nr+/4mlZ+PlujmRxheZQM4D0AY6qw+xa+4xHeB8
	 bUp11CqFCIFQ1dMBx2fG9KKOV02sxePvii9W3CmHa7jf0OW83d8GJFjWr7+oe4m1xQ
	 DnVH0544cdE4W7cOMJMmr5kS0mJsgRv6M4sUcP7W1Ry4vO4pHYIYKxpnc3TQlFYRfX
	 z40bkP94CMP+f2ibB9DcJKv8nSf8CfIz3lWfmp4mYVrdoxwzOGgISCx+cj9nbIDMaG
	 RObTGQm+MjpCQ==
Message-ID: <sashiko-outbox-220727@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 25/37] scsi: mpt3sas: Fix SGE offset boundary check
 in _ctl_do_mpt_command
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-26-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-26-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:39:44 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] scsi: mpt3sas: commit message mismatches SGE check in
  _ctl_do_mpt_command()
- [Low] scsi: mpt3sas: missing Fixes trailer for _ctl_do_mpt_command()
  SGE bounds fix
--

commit 5758bc759aacfe053f7ee27bcc8629e05f1607de
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Fix SGE offset boundary check in _ctl_do_mpt_command
>
> Ensure data_sge_offset leaves room for two SGE entries within the request
> frame by checking that data_sge_offset * 4 does not exceed request_sz - 3=
2.
> Reorder the overflow guard before the multiplication to prevent wraparoun=
d.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
Since this fixes the overflow ordering and SGE bounds check from the
initial driver commit, should it include a Fixes tag?

  Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mp=
t3sas_ctl.c
> index f979672353677..d3166e0489918 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -714,6 +714,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, stru=
ct mpt3_ioctl_command karg,
>  	unsigned long timeout;
>  	u8 issue_reset;
>  	u32 sz, sz_arg;
> +	u32 sge_cnt;
>  	void *psge;
>  	void *data_out =3D NULL;
>  	dma_addr_t data_out_dma =3D 0;
> @@ -746,8 +747,9 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, stru=
ct mpt3_ioctl_command karg,
>  	}
> =20
>  	/* Check for overflow and wraparound */
> -	if (karg.data_sge_offset * 4 > ioc->request_sz ||
> -	    karg.data_sge_offset > (UINT_MAX / 4)) {
> +	if (karg.data_sge_offset > (UINT_MAX / 4) ||
> +	    karg.data_sge_offset * 4 >
> +	    ioc->request_sz - max_t(u32, ioc->sge_size, ioc->sge_size_ieee)) {
>  		ret =3D -EINVAL;
>  		goto out;
>  	}
> @@ -782,6 +784,23 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, str=
uct mpt3_ioctl_command karg,
>  	data_out_sz =3D karg.data_out_size;
>  	data_in_sz =3D karg.data_in_size;
> =20
> +	/*
> +	 * SGEs follow the request header and must stay inside the frame.
> +	 * MCTP, mem-move and bidirectional data need two, others need one.
> +	 */
> +	sge_cnt =3D (data_out_sz && data_in_sz) ? 2 : 1;
> +	if (mpi_request->Function =3D=3D MPI2_FUNCTION_MCTP_PASSTHROUGH ||
> +	    (mpi_request->Function =3D=3D MPI2_FUNCTION_TOOLBOX &&
> +	    ((Mpi2ToolboxCleanRequest_t *)mpi_request)->Tool =3D=3D
> +	    MPI2_TOOLBOX_MEMORY_MOVE_TOOL))
> +		sge_cnt =3D 2;
> +	if (karg.data_sge_offset * 4 + sge_cnt *
> +	    max_t(u32, ioc->sge_size, ioc->sge_size_ieee) > ioc->request_sz) {
> +		mpt3sas_base_free_smid(ioc, smid);
> +		ret =3D -EINVAL;
> +		goto out;
> +	}

[Severity: Medium]
Does the commit message match the bounds check implemented here?

The changelog says data_sge_offset * 4 is checked against request_sz - 32
to leave room for two SGE entries.  Instead, _ctl_do_mpt_command() first
checks against ioc->request_sz - max_t(u32, ioc->sge_size,
ioc->sge_size_ieee) for one SGE, and after copying mpi_request from
userspace checks whether 1 or 2 SGEs are needed based on the transfer
direction and MPI function.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D25
