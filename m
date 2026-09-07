Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB47379EF0;
	Mon,  7 Sep 2026 03:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750133; cv=none; b=smvSg8MYicE3pVP0skc/D8U0p2zAUh9J5MwQrF0vkyvAikdH3O46lWT0YGg5s/7IxNfPDvCJUcQUke3sULHHxnWsH8UheWPNzCEQtnj9ZpPiUN8qc9DGfltUqq51ajFlOgG7cvafZ5t9yK8Gt9uqCktFxaVmJf2DAjJVil55pbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750133; c=relaxed/simple;
	bh=8e5Bl1d/4kp4OhiCrQXLJZj8Z9R+xYS9/0KQ1lEjnb0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ls78U/0MXEBa4HhC2vajXr0bxW+jk8DE4Ckx97/SelqZY6a2vQhBjG7ufmzCfkmjeqYiF4EUxMSPdgc+fkVQzqzgCGHdjXImHpzYd8ujpcgsysG2ARECYUNgPB6wlCLVYfCb7PPh2NEdK40gEpkwyJGJcn8cyZaOdE4FSEVsf7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTsFDc5N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTsFDc5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7818F1F00A3D;
	Mon,  7 Sep 2026 03:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750132;
	bh=8e5Bl1d/4kp4OhiCrQXLJZj8Z9R+xYS9/0KQ1lEjnb0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QTsFDc5N595NboLqdBODsMyIH3XVe5yXlSNLbbetujentPuV5sQIgwn7PyagIo9tU
	 4Uk09qr8SnDoyuE3KwXQDPi0d2FHzvbUR9EncN6N5L9A5/zVapOHadwSHEVjk2/tk7
	 QoyYvxYbh0d4fWil18vVoZJMGkDRzXybxAq54ARNqogvcfxvyzTQHXbxhkStLPaFNZ
	 KdD6KJWRBjfmKkiPH/kacVgDKzsNpa6LxfyRekOIMHhULkxTLeS+462/l7f2Mk6piM
	 KTOEruzK9ZD05NRlaal4zRpbekgr6uf3MH1gHGpIDxM0XBQSr+R+mSH1vV7SOLZful
	 mtGVFBE/T7nAg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 15/40] scsi: device_handlers: emc: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260907024343.1046387-16-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-16-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:02:11 +0000
Message-Id: <20260907030211.7818F1F00A3D@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D15

