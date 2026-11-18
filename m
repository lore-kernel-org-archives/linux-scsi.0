Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998028;
	b=tSRwPMLb71KUxWSbkRowfEH0NiZyA76u9l0UfSJFcPh1TErCyagmtbcvsm87Q40sN6Wd
	 B0gE/VJ78ZCKbmQfrT9DFP79a2y4C/BkdY1Qi1AOYvFKTke9qYdvYg6jRm+KtEg46RpTy
	 VJ0TqTcwEIc1XmzWXSopXTg6CnZVpKt+DM1X7u7Qadsv1lZKwbhyDudNvi7GxqftDoGz+
	 ttiksWjlm/kbxn3mDAf2yRZEgclG3qUn0SNSQhSlks2//Q9nj/MmZCzQHmGdiQ3Rx+p+1
	 DfHqc5nlK7/NJqMzonPrOlsdTR2TyWPJKFDDl7qC8nJF57yJetmtxhVKmZY9HAmW+DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998028;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1fUt7xUwdf/lCtSGDvWepKxlQfni00vPMa7zdI1vcpM=;
	b=TtqnhpPjR6LyDh32CM6PTUGti9BUhEi4dhuyfnlJA2FSWvRzaiu9qRokDftxaewNm2kz
	 QKoXEAEvjZoNuBjh0VYg/0KdOpyqp0nBBTr1abG8y8nqGXVrWr+F+VgAtDN9vRHotSsjz
	 lRgLuVuRnYWwPwjuEBAZ5tFRU5dy9ecb4IxFxGUox0xQXdSD+QB5NEZKcwvqtzSj7qOF3
	 r3ynXRaV4ctDN1qZw8aPbDmGeb3iwGP8XAGD6fcICG9Y8aHjdepfwesd4UliNyUntQjLg
	 JgXvvpTp2r1D7ufmEomb3VUpera6M3EIt8NVyuBlmbNmjj2VOrPVVtqIG5iY/5jxtig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZmO41Cfd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEB8606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZmO41Cfd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD821F000C4;
	Wed, 18 Nov 2026 10:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794998027;
	bh=1fUt7xUwdf/lCtSGDvWepKxlQfni00vPMa7zdI1vcpM=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=ZmO41Cfdz8AXn2sEHbKtAyBOqicKgm/wnpV/WMryfZhfYKu8TYxWKwjUCnAsZLAkE
	 hXvlfDnYvqSzf3EXuG3osM/ccjoLN5W15PoCJpNc7yNc1EU6UgcUk082QE5I5gM9zW
	 mJlf9+L14Ajo+//fqQsUlAW4Bbr4vSqHF4jUVo9JNlpsvmZc5+qJSlnEHmsoBpFevP
	 3FJkiLo0d1AtSK1z13M+tS7UY6Ksj7ICONnejw7shlBfnIpu29zR+RDCw7tlDU0ASA
	 MBJw2fiQvIu8aPwXfBfdZd1jdF+JA17iZhu5QukV6do/Qi9uU1nOTbAY0bLd9zikYt
	 2I9Eq2zbowjHg==
Message-ID: <sashiko-outbox-220705@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/37] scsi: mpt3sas: Validate firmware/user supplied
 device handles against MaxDevHandle
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:33:47 +0000
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
- [Medium] scsi: mpt3sas: missing MaxDevHandle checks in PCIe event and
  add paths
- [Medium] scsi: mpt3sas: missing MaxDevHandle checks in SAS phy change
  and check paths
--

commit 1475cb70df52e6382fa2780421f221a0823686a6
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Validate firmware/user supplied device handles against MaxDe=
vHandle

This commit validates firmware-supplied and ioctl-supplied device handles
against ioc->facts.MaxDevHandle across event, discovery, post-reset scan,
TM/control completion, and ioctl passthrough paths.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 852c164996384..a310605806b18 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c

[ ... ]

> @@ -8399,6 +8418,13 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16=
 handle, u8 retry_count,
>  	u8 connector_name[5];
>  	u8 port_id;
> =20
> +	if (handle >=3D ioc->facts.MaxDevHandle) {
> +		/* not retryable: drop the device instead of looping forever */
> +		ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
> +			handle, __func__);
> +		return 0;
> +	}
> +
>  	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
>  	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
>  		ioc_err(ioc, "failure at %s:%d/%s()!\n",
> @@ -9186,6 +9212,12 @@ _scsih_pcie_check_device(struct MPT3SAS_ADAPTER *i=
oc, u16 handle)

[Severity: Medium]
Can an out-of-bounds AttachedDevHandle in _scsih_sas_topology_change_event()
still index ioc->pend_os_device_add and overwrite sas_device->handle before
reaching _scsih_add_device()?

On MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED, _scsih_sas_topology_change_event()
passes the unvalidated handle to _scsih_check_device() (which unlike
_scsih_pcie_check_device() has no MaxDevHandle check and overwrites
sas_target_priv_data->handle and sas_device->handle) and then reads
test_bit(handle, ioc->pend_os_device_add) before falling through to
_scsih_add_device():

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_sas_topology_change_event() {
	...
		case MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED:
			...
			_scsih_check_device(ioc, sas_address, handle,
			    phy_number, link_rate);
			...
			if (!test_bit(handle, ioc->pend_os_device_add))
				break;
	...
}

>  	struct MPT3SAS_TARGET *sas_target_priv_data;
>  	u32 device_info;
> =20
> +	if (handle >=3D ioc->facts.MaxDevHandle) {
> +		ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
> +			handle, __func__);
> +		return;
> +	}
> +
>  	if ((mpt3sas_config_get_pcie_device_pg0(ioc, &mpi_reply,
>  		&pcie_device_pg0, MPI26_PCIE_DEVICE_PGAD_FORM_HANDLE, handle)))
>  		return;

[Severity: Medium]
When _scsih_pcie_check_device() returns early on an out-of-bounds handle,
does its caller _scsih_pcie_topology_change_event() still pass that handle =
to
test_bit(handle, ioc->pend_os_device_add)?

Because _scsih_pcie_check_device() returns void,
_scsih_pcie_topology_change_event() continues after __mpt3sas_get_pdev_by_h=
andle()
returns NULL and reads past the end of ioc->pend_os_device_add:

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_pcie_topology_change_event() {
	...
			_scsih_pcie_check_device(ioc, handle);
			...
			if (pcie_device) {
				pcie_device_put(pcie_device);
				break;
			}

			if (!test_bit(handle, ioc->pend_os_device_add))
				break;
	...
}

In addition, _scsih_pcie_add_device() (called from the
MPI26_EVENT_PCIE_TOPO_PS_DEV_ADDED case right below and from
_scsih_scan_for_devices_after_reset()) lacks the handle >=3D
ioc->facts.MaxDevHandle check added to _scsih_add_device(), so an
out-of-bounds PCIe handle will execute set_bit(handle,
ioc->pend_os_device_add) and corrupt adjacent heap memory.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D8
