Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793927489;
	b=1vJ/k993/m/9POKmSCRoORBMecmdRn3DhZX0trrT+qug7+dtqBBIzLtx4j/IX3Q/Gyx9
	 1tN0BV+X+V2/+j21OD5p4bWNoMCEUo50fdz/uB/alaJqjq3Rq2f4YRWV7BplQ+fcRPPnq
	 29NIGyaBu9swujXaBwefis8QHKL1+VfiG8gpXWIbbZJX5wlnhP/k4dfn6ZVwcWfOi8+o+
	 cT8mAK5ElkXxVNP8Lk0kIA/dgUvFiuPEdF5UNsNvpSkzJrt84yBFe61Oot9SUp3lHaASP
	 dUdHVj4a4ecm6Nqd5trKTQZmkZzn/yysLF0xERFi5B6709SeCNu1uY0hMWOUFV/8yVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793927489;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kzx1BjMEl1JiBDa4VLIswVuq1A+EOL6hX187jBkZYyc=;
	b=F/CKUVl3kRghi/yS0Di0K/WzIPelTuhU6Lg16q2eWRuNy+IOCRhyiC9dAftkVSZKDVxz
	 WB0COI/UBB/ekL7wTbl1K3u3G9TAPkTPTHzMWhwUWnML0OE99PsPrnxOPWB/5JgcWMlWJ
	 cPnM3fcp6o185BnP5LGg6euLhT8pem2PL2HjCfmLRkNmeiQ6pIEt4cekXgri+W4Wz4yOs
	 WJTEWSg4FJIyB3Vd224CBkiTWVGoTKcPODXg20kQ8WRWBj1jmzhG57yMBtQK++/0qqaPx
	 yLTZgO+CQsm7CYd5Er4Q0ymFBKIHqMZ6zxGObzVRW3AcuHuFAszAv/ai9Jb9o46butg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PdlunCmz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AF7606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PdlunCmz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5BC1F0089F;
	Fri,  6 Nov 2026 01:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793927488;
	bh=kzx1BjMEl1JiBDa4VLIswVuq1A+EOL6hX187jBkZYyc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=PdlunCmzQAng8cMSsG1DoxqJIFElFOyIFGqCNmrDHcvRyo9rKnNs8JpxFijWPhzPc
	 /FNCMBfcCdVXWT1pyGXOaUQ8JHZZZo+QlP7EWLrSbgDBum+up/FxLSDOxijOF6gCP3
	 2o9ZJKljC3JIjtwjPbvBmDJuTK2nWAcRHYKXxAnOEyqgIV79croOmjstnnQEseW+9O
	 DtFKnddI/Ot5GXk1ssrMGKx/0/hunppqSt9EP1EiqPvmi8B6zCdiTYVX9AiyVKyDs6
	 XBgVrbzxmeq1NgPTcyaPp7C6zWYuUvZ8ZtBPShzDWfLIS/5456QcxjZ5dFzpIJ2rRO
	 b4fEWopu3IyJw==
Message-ID: <sashiko-outbox-200483@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 23/37] scsi: mpt3sas: Validate phy_number in
 mpt3sas_transport_update_links
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1793925772-1303-24-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1793925772-1303-24-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:11:27 +0000
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
- [High] scsi: mpt3sas: nr_phys_allocated check breaks mpt3sas_transport_up=
date_links()
--

commit 228d8378247f2aec196daebe40235a2011620814
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Validate phy_number in mpt3sas_transport_update_links

This commit adds a bounds check on phy_number in
mpt3sas_transport_update_links() before indexing sas_node->phy.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3=
sas/mpt3sas_transport.c
> index 32db07ed808a9..1041ee7591bfb 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
> @@ -1176,6 +1176,11 @@ mpt3sas_transport_update_links(struct MPT3SAS_ADAP=
TER *ioc,
>  		return;
>  	}
> =20
> +	if (phy_number >=3D sas_node->nr_phys_allocated) {
> +		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
> +		return;
> +	}

[Severity: High]
Should this check against sas_node->num_phys (as described in the commit
message) instead of sas_node->nr_phys_allocated?

In mpt3sas_transport_update_links(), _transport_sas_node_find_by_sas_addres=
s()
returns either &ioc->sas_hba or an expander struct _sas_node:

drivers/scsi/mpt3sas/mpt3sas_transport.c:_transport_sas_node_find_by_sas_ad=
dress()
	if (ioc->sas_hba.sas_address =3D=3D sas_address)
		return &ioc->sas_hba;
	else
		return mpt3sas_scsih_expander_find_by_sas_address(ioc,
		    sas_address, port);

For expander nodes allocated in _scsih_expander_add(), the phy array is siz=
ed
using sas_expander->num_phys, while nr_phys_allocated is never initialized =
and
remains 0:

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_expander_add()
	sas_expander->num_phys =3D expander_pg0.NumPhys;
	...
	sas_expander->phy =3D kzalloc_objs(struct _sas_phy,
					 sas_expander->num_phys);

Because phy_number is unsigned, phy_number >=3D sas_node->nr_phys_allocated=
 is
always true for expanders, causing callers such as
_scsih_refresh_expander_links() and _scsih_sas_topology_change_event() to
return early without updating expander phy links or adding ports for attach=
ed
devices.

Additionally, for ioc->sas_hba, _scsih_sas_host_add() sets nr_phys_allocated
to at least MPT_MAX_HBA_NUM_PHYS (32) while only initializing num_phys
entries:

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_sas_host_add()
	ioc->sas_hba.nr_phys_allocated =3D max_t(u8,
	    MPT_MAX_HBA_NUM_PHYS, num_phys);
	ioc->sas_hba.phy =3D kzalloc_objs(struct _sas_phy,
					ioc->sas_hba.nr_phys_allocated);
	...
	ioc->sas_hba.num_phys =3D num_phys;

Would a phy_number between ioc->sas_hba.num_phys and
ioc->sas_hba.nr_phys_allocated index an uninitialized _sas_phy entry where
mpt3sas_phy->phy is NULL, leading to a NULL pointer dereference in
mpt3sas_transport_add_phy_to_an_existing_port() -> _transport_add_phy() or =
in
the MPT_DEBUG_TRANSPORT dev_printk() call?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1793925772-1303-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D23
