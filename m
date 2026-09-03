Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77E22E2286;
	Thu,  3 Sep 2026 03:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407501; cv=none; b=rcctfyN+tf2/DnLhLxN5rjl0Dhi39YZqbAAlRtN1+obc5W9ziQvdFWBMs3KPFfm1CcDDeoe84brermy34+OnwH32EIjlKH6VG4f1J0RA1XNYlN85NqJsXWXV5eRPiad5fuHuVdtClN3oHK6FWey/Kdlf1srMUYU1oomnMY/jQ2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407501; c=relaxed/simple;
	bh=S1wICeiJqRdlomhUTcEmMcfRYgJWBeWHWheRNa//LUk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=erF+mmGXgCwq5gXKjLMpOzA3MsOhQtgFbQlYXFvjoqQ41oZpmid/gabL93eSKbrjBoWvexi6lImyrXZBUWW2ApeDvJ1VZWw/RRkx77fDwXenUSEf/qlboYhRHcqQsyVyfejPM88GorM9aRn37xJL/uN2Zciw42GAzFMrdCt0/JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VFxzmNux; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFxzmNux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537331F000E9;
	Thu,  3 Sep 2026 03:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407500;
	bh=S1wICeiJqRdlomhUTcEmMcfRYgJWBeWHWheRNa//LUk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VFxzmNuxiva8ha8nsVU0ZPL+SnSFShStNIOG1+SW+tOwKHu/N2wEgliI890zm7a+s
	 3xfEAGBqWjQdcGaGUQBMhOwIW1s0ZRpIQrCBYKPu9f59BpqNTzVrz6713Vi66hAbby
	 INSRNRTU88+zZK1ujZ0NSV4jEACFsh35ik2Kocl1T1SQo/Ng8kcSmsxrt3Vv5g4EqR
	 zDDfo33mR29EzpqObDPIWBJMNVwzPuXzYDHDGx/IwLMMDGrPORFQgHoeBLbAGxzyYe
	 sRP2NUIaVgoeC2FHRjb3XrXfInfQx1FZKsBmfpjFCPz5jAJ4fOccIbxQ++7z2FF9US
	 qImihi+wRcq4w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 18/40] scsi: mpi3mr: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260903034201.112211-19-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-19-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:51:39 +0000
Message-Id: <20260903035140.537331F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the mpi3mr driver to use the 16-bits sense_code field of struct
> scsi_sense_hdr and replace all hard-coded additional sense codes and
> additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D18

