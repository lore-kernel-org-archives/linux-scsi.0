Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998544;
	b=MJd26aI7c6OUhyw+zFO2oPYIhXWBl9JHP79TM/NzIUQP7N4YcMF1endkGxvuZC+Oav8c
	 8Lbg0SMd8hHR7wiKQySZ4fH8dXEkjyiqCKPuXiTORBZuuI4bt8VZW40mYU29NMgb4ieoO
	 uxytY6HQAEAY8feB4g6eVAwmh2sKPRgGpN1M7zR7wwdq5jLTaiylSkiv9eTcIAvFWCkFr
	 3NONGj/bpVunGT5qsJkVE8zmdKAHJw+A/GH+0nIeYxSN9YJH8hIK7rZys15iUOfSzBIbv
	 k5vKLt5IoLI8UiGbI1AMwAsB53IiFQe+YEQ5IYo7UnaXuFDdVHbcXAHMRBg0TUsxHgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998544;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2HdFm/NWofXrDujxW8JbWK9iPt47T2zcCKOvWrWO62Q=;
	b=H4Rnw7vJ5NyKSoJD57dzzVAWYLwIH+q8CUWCKyxrxKuLiSwQmri+HgAbnfjr4r3NpW9S
	 oMFnxT14teVrv92a0Q0Zt6dW/Dyy0f5T1BHC97WkCRs9yrdTkbiDfsG3OrE6eX6o6gEn1
	 X7c0EYECw9aSaZVrZYCd/GAFuxUc/jO96g6FYagiIWJ8kWX5haarXM0QJTcOXcZfMy43d
	 tDiqKZlEz7l4BtH4C4HNxRBjrCy7QRz8Rj+MzaDPXtXOg0DMUnq0YmlmxfS93KPae0goR
	 d7zZdc3GpnUevDbKpAL8RsOSUZr/n4c9XfyqEtkGlqB+YgxvVZ+gzErnIxQmbUE5y8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lHTK6dCm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A73606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lHTK6dCm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9081F000C5;
	Wed, 18 Nov 2026 10:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794998543;
	bh=2HdFm/NWofXrDujxW8JbWK9iPt47T2zcCKOvWrWO62Q=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=lHTK6dCm5VsKhWtazngTWxz2fxPcbKwk2Y2WfpeFdQihEp4fPqe+J4nq9PjeUi7Hg
	 BY5hSJ0yz58/gnJ8yHJIwbfzIPNNnUaWDPbJVvpm/CGMU8Sy4eJtwpgMgk/zXEBEuO
	 srq1+LwxjXC7wCLAxsyCaPH245PJzV1RBUmJQ5YoxDRfVF5rcnKZkep7cDylSTvMk0
	 uAecfvV7lg/aVZiEciT+GgmWV5/viftxwI5zYTCpMRjulGiiTSVieRQMb3PTjDI3wY
	 wdKa0BnTSGhSfK2+bTHD0keFjxtIKm/1XMRARwbgUzP3aN25MS/Qe4s438tG8v5Pgx
	 o58T4ANi/P0Yw==
Message-ID: <sashiko-outbox-220734@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 23/37] scsi: mpt3sas: Validate phy_number in
 mpt3sas_transport_update_links
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-24-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-24-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:42:22 +0000
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
- [Medium] scsi: mpt3sas: mpt3sas_transport_update_links() breaks
  disabling HBA phys
- [Low] scsi: mpt3sas: missing Fixes trailer for
  mpt3sas_transport_update_links() fix
--

commit c51193b4a92bbce96daf63111a51b7401382049e
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Validate phy_number in mpt3sas_transport_update_links
>
> Check phy_number against sas_node->num_phys before indexing the phy
> array.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
Should this bug fix include a Fixes tag:

  Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3=
sas/mpt3sas_transport.c
> index e88205b69067f..5f087d0b4d7a9 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
> @@ -1176,6 +1176,11 @@ mpt3sas_transport_update_links(struct MPT3SAS_ADAP=
TER *ioc,
>  		return;
>  	}
> =20
> +	if (phy_number >=3D sas_node->num_phys) {
> +		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
> +		return;
> +	}
> +
>  	mpt3sas_phy =3D &sas_node->phy[phy_number];
>  	mpt3sas_phy->attached_handle =3D handle;
>  	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);

[Severity: Medium]
Does this regression break disabling excess HBA phys in
_scsih_sas_host_refresh()?

When HBA firmware is downgraded to an image exposing fewer phys,
_scsih_sas_port_refresh() updates ioc->sas_hba.num_phys to the lower count,
and _scsih_sas_host_refresh() then disables the remaining allocated phys:

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_sas_host_refresh() {
	...
	for (i =3D ioc->sas_hba.num_phys;
	     i < ioc->sas_hba.nr_phys_allocated; i++) {
		if (ioc->sas_hba.phy[i].phy &&
		    ioc->sas_hba.phy[i].phy->negotiated_linkrate >=3D
		    SAS_LINK_RATE_1_5_GBPS)
			mpt3sas_transport_update_links(ioc,
				ioc->sas_hba.sas_address, 0, i,
				MPI2_SAS_NEG_LINK_RATE_PHY_DISABLED, NULL);
	}
}

Because sas_node is &ioc->sas_hba here and i starts at sas_node->num_phys,
every call in this loop now returns early without clearing attached_handle,
remote_identify, or negotiated_linkrate on the disabled phys.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D23
