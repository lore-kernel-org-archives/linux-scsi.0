Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794028084;
	b=P60UwOBOaA45+qHdNmWkg02/iRsJWazF4h7TdpkMbGL0Z65Q4/DZGAB9Ys4xJPoyzueM
	 CA1Fe/fmI15kSfYWjwJOShinnBNFILtY9OirEaize6hR99ygAdaOutcz8YzcN5diteWiL
	 5fqxiwzLAkwK4g+vUwbJ3ynB6DiH/yGSoiClzKzjQeh5zQcK3QLmkv7kLqxzMh0vl9YqG
	 3iFnIRyzAl8PzLsAjJpoJej/w9p/ngRe2lSSK+w3+mH+KZfyxdfsYX3jvoEqA9pRA3ddO
	 lK1K+Q2/ypdtkwwUBbbwi/axEA3AKLahR+9EXIsRf6XS8hP8nxGqqkXEi3chDOv7CEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794028084;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2/uzpiTnyIDmeuumQuPqSuEPfkJ7NI8oGaUfAzoTW3w=;
	b=nfp+pbcb2p4ZsNFmgLzmw7zRfc54r+RwG6QkFdsw+1qO158NY8FVexjaGdhLybtF3RZ9
	 cdn5U+/tCX0j1erCw2xgfWhPDjAM/NVFN2DPUZVt2lZZQ8/Ogc91b+/G8uGSOjqtljvfN
	 92Z0f+EDCHOfquGvDAkXgOWVt6uDk6/EttNES1iXuQT+fDND45axwtithkBL98W+xybPl
	 sNmxdG3hIfD9HifiT8Ma4ENa438dH+uIvW71bD5U7j0UlvinoSNRnNfroY+vU2zbvmVYm
	 ONhCJggStwiV7OhtsaTuve1t0f5+Mz8stkjDlSQ36a18CKy3DC623Sc1w+WiaejM0oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J8uOoHEM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECE9606A326;
	Sat,  7 Nov 2026 05:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J8uOoHEM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6D51F0089F;
	Sat,  7 Nov 2026 05:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794028083;
	bh=2/uzpiTnyIDmeuumQuPqSuEPfkJ7NI8oGaUfAzoTW3w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J8uOoHEMp4gxp8jE9cD0li10YdgYm13tmbLZnMS0lg7Ot3ySzyevQdwgOX6Y+/jO8
	 nI0bqIll1ce1FkJb3tLMwySc73f9x6TYK9szQFQhTj6ESw/hcOBY8p90BUMRjl21nA
	 Qti1WitM7jVaZhBx99YaoMjsjdCGPjMJOE4GFesVefVZYZh/gyIskaYaTkaM06Hm1L
	 h93P+XYsRVbll1PWl0wLke/ZW+Hb/PV64HjBgwotr4R5lUw0wvda8agjYIdnGWtHsg
	 liC8Tvyg7RGjUkmHYG/p4VqCGyX4eav1fakvqji2dUy9bFGI7NHZ/vdwJoyJsb4WCH
	 HOkGIj7CcWMTg==
Message-ID: <sashiko-outbox-202608@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: Constify struct configfs_attribute
 pointers
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhvbWFzIFdlacOfc2NodWg=?= <linux@weissschuh.net>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261107-configfs-const-target-v1-1-a1bf9511386c@weissschuh.net>
References: <20261107-configfs-const-target-v1-1-a1bf9511386c@weissschuh.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 05:08:03 +0000
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
- [Low] scsi: target: incomplete ct_attrs_const conversion in target
  core and iscsi
--

commit d8c2eba7f9079194d5b3b7e6d1172b540dc79568
Author: Thomas Wei=C3=9Fschuh <linux@weissschuh.net>

scsi: target: Constify struct configfs_attribute pointers

This commit constifies struct configfs_attribute pointer arrays across the
target subsystem and its fabric drivers and switches struct config_item_type
definitions from ct_attrs to ct_attrs_const.

> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/targe=
t/target_core_fabric_configfs.c
> index ab8f81650710e..61929f28fcc57 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
[ ... ]
> @@ -921,7 +921,7 @@ target_fabric_setup_tpg_base_cit(struct target_fabric=
_configfs *tf)
>  	attrs[i++] =3D &target_fabric_tpg_base_attr_rtpi;
> =20
>  	cit->ct_item_ops =3D &target_fabric_tpg_base_item_ops;
> -	cit->ct_attrs =3D attrs;
> +	cit->ct_attrs_const =3D attrs;
>  	cit->ct_owner =3D tf->tf_ops->module;
>  	pr_debug("Setup generic tpg_base\n");

[Severity: Low]
Should target_unregister_template() in drivers/target/target_core_configfs.c
also be updated to free t->tf_tpg_base_cit.ct_attrs_const instead of
t->tf_tpg_base_cit.ct_attrs?

In addition, drivers/target/target_core_stat.c and
drivers/target/iscsi/iscsi_target_stat.c still define non-const struct
configfs_attribute pointer arrays and initialize .ct_attrs in their struct
config_item_type definitions, which will break the build once the
transitional ct_attrs union member is removed and CONFIGFS_ATTR_RO is made
const.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107-configfs-c=
onst-target-v1-1-a1bf9511386c@weissschuh.net?part=3D1
