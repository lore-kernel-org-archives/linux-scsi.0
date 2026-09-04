Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF9B1A6817;
	Fri,  4 Sep 2026 02:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788490580; cv=none; b=mzHKwn8EHy2Jq8xeV8LJG5c7sgD3GcdqH3Kc12YqnJ24a5I91D3IfNf1tk+MHRdsx8tlAgE1bqNHibHj/IwMTFGuun3sIgqWbxMTefdQ3rtJW4KulePoLyz54wjW+D5Ct7hmd+2Y9p2NinYBT4CHqZeACmd065io/vxgaSF4bGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788490580; c=relaxed/simple;
	bh=Q7pvBorg4JUb2rsGTNHXsQQD/WfgLLBqgOOIjqh9nus=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qcL3jaxDG1PyexdPRnF/YmX9jCSowoFFJCTtqzIP3nvZYjGlILfEaUrA1Gd9zs74+YgzDoZc9PI3evOuPxfR+xCdIiuqXdjbYmZ8fiw/dD5lKmRGMTkt71UmSwxoqrqL9iAPHIwYN8WjWNTv8gzrSeCBthWGb2AoV2S/Qt5hAB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQP6reKE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQP6reKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1CE1F000E9;
	Fri,  4 Sep 2026 02:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788490579;
	bh=Q7pvBorg4JUb2rsGTNHXsQQD/WfgLLBqgOOIjqh9nus=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nQP6reKEYI294X6j0IsbPdVHKggyB427sZBDsG7O83wFY0/Gs8uLPN8s7O9nU6e4G
	 ISNyJdyh1z6dm+D/1t+TybicVdOg1CFyKO90FdfuAJ956Tl4MYb3PRLqiEYS+h2mrd
	 54x4kv3GrA6iX3PkryOvO0q9YCad4GkZ+Fuj7hNGiuYnY17qo8nOzZVVYyK7Cb943g
	 vNvegdjOS5M/cY14wGK0VIWsjvmu/STQa/Rj39xMGQwEZ1hk2kBgVoi2OgmrqiH0K9
	 gGGjxgMY9eOStxuAcxnJwsj47VQT/M9GfrN/S1w/TRCmO/ElBZdn+hfcm3G8T83jHc
	 pGC3RP2pSZYvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 39/40] scsi: cleanup scsi_proto.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20260904002644.157668-40-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-40-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:56:18 +0000
Message-Id: <20260904025618.ED1CE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Now that all users of SCSI sense codes have been modified to use macro
> definitions and the 16-bits sense code instead of separate 8-bits ASC and
> ASCQ, remove the now unused asc and ascq fields of struct scsi_failure and
> struct scsi_sense_hdr, and the old (and incomplete) definitions of SCSI
> additional sense codes and sense code qualifiers in scsi_proto.h.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D39

