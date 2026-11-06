Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793927962;
	b=K9M7y1G4uLKzM9pn+4qpTjczCPk0o/2ktYcj7O/N4pA1ucifT/AcozHuZjAAg3tjkGR1
	 PJ6haT088FshzPq1QP8dd78Ot1gc63JjZZIFfwIEe6ybSWtuA8k3cRIUW7rXJcDa2n4iH
	 WYZmzWMKYRR4XOZBO05Ad3j0M9bpi7wMotej/CK6QRndcV0u9wQa6X7s42pUk+S6m/f6g
	 mhpUY2pLTDYdFY3mPhspiQ9gI9Y6ns0Mhaf4u+nImvhETke73458TFVR1rRgjEzxYSnFR
	 BbXaAMZtZTSpQiuie/xWPq2+uF67HDGu6gKIAufXqq240rj0El9WanY+ciquYKbzHHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793927962;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QcZ81si9zvIGAJtOQl1f2wyV/uiISZMNlmPP1SC2rQk=;
	b=BNo/+3XLL1R/qQfhNo0v3vLc8x5oUeYiamaL+NJzSXEDXPJIftC2ivy0SbsRPL3I6wvd
	 svCE2eRF3FdQWtrI5hTXRyFBez9vX77BBJj9aYX4r9cI6MH2q3p1g1DT2FfJGYFH4oUE/
	 1b9th6fqFMVwK+bKrMzgvqsnRVM+kI8jTrRye6kyIbeD/vZ5KRdwmLHdIxJGFu/9OJ7op
	 15SfmiHeDgZiatvBFwMh1sbLK6/E82XsUEBrgPOBd8rwdrrNNxRMGqVs+qeTbYkdqwozq
	 xAYOaB6KBEuCo+dntxg3YaOQbcwiis3+IK0tO9ZAniCnSSGDC26D6EPtBKsiW9IJHPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DlvTLlD0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9313A606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DlvTLlD0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF2F1F0089F;
	Fri,  6 Nov 2026 01:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793927962;
	bh=QcZ81si9zvIGAJtOQl1f2wyV/uiISZMNlmPP1SC2rQk=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=DlvTLlD0ThoqvdlVcLxmYfAIURsBMozk2eCINLa/L30Xog9IkK5pmzN7pjnduLt53
	 3+6J0FZq8JB6dwl2FDq1pe9O8aa5g0d+oA1w23/nX6ShaqvO8FsMB1HjYrl5v/Wwgf
	 OgwNJ1CfCweYYRhIrJ7NhVV3WRwfSxxIIKTlQ4iPqEoYWTi1YxKSTyWv/ZgCSnRO94
	 ugqP6pSGYFSIcu+DZcm9zkHzRaO81/7m/ivvbePi9E/xyYSPff3ZJR6C+6gBabPkLU
	 2k/7GwxCzzfvQ+Uxi9XJ7AoUYuJ3/NgnUFLwlsoyBUQeKSV2qg0HZPBULIfGAyjVyK
	 KIZKujeaVYlUg==
Message-ID: <sashiko-outbox-200505@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/37] scsi: mpt3sas: Pin Scsi_Host while an ioctl is
 using its ioc
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1793925772-1303-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1793925772-1303-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:19:21 +0000
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
- [High] scsi: mpt3sas: NULL ioc->shost dereference in _ctl_verify_adapter()
--

commit fa020f05a0e98e1b4c78a00e2fbe33bb7d1cc987
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Pin Scsi_Host while an ioctl is using its ioc

This commit acquires a Scsi_Host reference in _ctl_verify_adapter() and
releases it at the end of _ctl_ioctl_main() to prevent the adapter from
being torn down while an ioctl is in flight.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mp=
t3sas_ctl.c
> index 8bb947004885b..f254e9984da80 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -447,6 +447,11 @@ _ctl_verify_adapter(int ioc_number, struct MPT3SAS_A=
DAPTER **iocpp,
>  				continue;
>  		}
>  out:
> +		if (!scsi_host_get(ioc->shost)) {
> +			spin_unlock(&gioc_lock);
> +			*iocpp =3D NULL;
> +			return -1;
> +		}

[Severity: High]
Can this dereference a NULL ioc->shost pointer if _ctl_ioctl_main() runs
concurrently with _scsih_probe()?

In _mpt3sas_init(), mpt3sas_ctl_init() registers the /dev/mpt3ctl and
/dev/mpt2ctl misc devices before pci_register_driver() probes adapters, and
the device nodes also remain accessible during subsequent PCI hotplug or
driver bind operations.

In drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_probe(), ioc is added to
mpt3sas_ioc_list under gioc_lock before ioc->shost is assigned:

	INIT_LIST_HEAD(&ioc->list);
	spin_lock(&gioc_lock);
	list_add_tail(&ioc->list, &mpt3sas_ioc_list);
	spin_unlock(&gioc_lock);
	ioc->shost =3D shost;

If _ctl_verify_adapter() finds ioc on mpt3sas_ioc_list before
ioc->shost =3D shost runs, it passes NULL to scsi_host_get():

struct Scsi_Host *scsi_host_get(struct Scsi_Host *shost)
{
	if (scsi_get_host_state(shost) =3D=3D SHOST_DEL ||
		!get_device(&shost->shost_gendev))
		return NULL;
	return shost;
}

which immediately dereferences shost while holding gioc_lock.

Even right after ioc->shost =3D shost is assigned in _scsih_probe(), the ho=
st
is in SHOST_CREATED state (not SHOST_DEL), so scsi_host_get(ioc->shost)
succeeds before _scsih_probe() initializes ioc->pci_access_mutex, sets
ioc->is_driver_loading =3D 1, or initializes ioc->ctl_cmds.mutex in
mpt3sas_base_attach().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1793925772-1303-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D3
