Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B33535E1CB;
	Fri,  4 Sep 2026 01:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788484821; cv=none; b=igmHtZCGZ4MBrvmmXzM6wQaeT5n44F3MPSGvQu7WCaxWWrFBEKpOBeZucgJooiDpJiBn952xaCCLu6a5ujlSDzH2jWxotmACSZjtV0LGhQwus7SfbKL2e3XFSCzhza8tnKNUBZoqSvlSPjnrDStkm7musZqa76r//7CD1c8QItk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788484821; c=relaxed/simple;
	bh=/bVk4dRpbl8K2UXdgoYNWWzuF/WaXeVeTo8ExWkRNqA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hByVPJQYhEXvop9rNrovM//BODI/9KW+V6x4Ye/R3rf+7HzkApr/5QzrVdF9pqsZQjaVB1F+bjTvStX3zkMKHBHy65NmRrMEzgeXfF+RW96g2YiqnqdUkz2rmDm5zUUJRX3V/V9KvEYiuGU+YfmoDZ9hGaRD3YCFXnDmvcDGylk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HzQ45Un1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HzQ45Un1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60141F000E9;
	Fri,  4 Sep 2026 01:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788484817;
	bh=/bVk4dRpbl8K2UXdgoYNWWzuF/WaXeVeTo8ExWkRNqA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HzQ45Un1/WszoVL3VuZzd3Ntb0cuSUk7MmDedllp1p7pb5hE1Bv/1Ibs3GResKuo6
	 TkT/gI9Y7PcvfEsA547Jji1syRomhZpBsvZbl4Dtpnqy15lD5MuZ1/xPX9KsezfsLm
	 OhEmJcqRnfAfBFUoU2BK7/Nev3P5jDgs7+pm5qeQ0XTsHt/LLXUksTD/2Bg3xB22Wf
	 hkjyspHd53PhZcl177PYwnKxyhKUK1YP3AfwN3iIJmhkuKNPjL/5Vsq9X31+QSTMo5
	 4hNLjnbTD+BIt/9d0JWibCz1WJXKX9YiOFlhkhTgiHXQg60/rLoIVQ3wBBf5IqdnHH
	 hBVEceFHa6Y2A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 15/40] scsi: device_handlers: emc: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260904002644.157668-16-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-16-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:20:16 +0000
Message-Id: <20260904012016.B60141F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the EMC SCSI device handler driver to use the 16-bits sense_code
> field of struct scsi_sense_hdr and replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D15

