Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D5E2192F9;
	Fri,  4 Sep 2026 01:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788484264; cv=none; b=drVp9nTNi7DWDupjrpuzanvVEIF/H9yZqBlyq2PzZmtaooJ//WBfwHOzwJLY8xA/tj7BqED2soJ2e4Xv9moeqsSDIyA70yp/gAD0rnmxtfQeTt1lpMpgISb+V4EuzL7waGya0PtXqXOpIPEmgYLIYw98DCTrIjiJ2U7hmx9DZgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788484264; c=relaxed/simple;
	bh=pKu4hEwsBm7v64DzaisWGjWQSBsSQBwbaVCpw5ivpQ0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jPqPsnaTuEgQYj4UNM4Djf9DT7U7DDaLAIeF4KYa/lS6YfUAGOyrvPVZbAr8NbEF6vYTZnlEelePqhe4bLYRafnZbdC3Kb/XNOJV3vJn1g/Zsz0ST+xvvIdL6VIzNq9RVDlP2Yr9ZzDV9Z1NVrfA130g/oW6XmRWYz3pzhlZ1+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KtByspxo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KtByspxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6920E1F000E9;
	Fri,  4 Sep 2026 01:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788484262;
	bh=pKu4hEwsBm7v64DzaisWGjWQSBsSQBwbaVCpw5ivpQ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KtByspxo3PUMNBLelGVnhsFpoyp8mIKReseoFATY2H0hHAa67GpH0kBqQIvaV0Y76
	 Xk8q5ZLdtUTZrXCog/R2qSp+AWDpdhf6w18JsQPH5BLYX+Lj90nJKteVMr/nv1M1uM
	 hryxTlX8+OF9tym5wsPuUD43VYVjYC395JPMpC0VymMuh1vi9qTvHwxP2UJPX8DBVc
	 0MIEGOMqR/wSnxOmoRujJZG5WLmKSAfSXeHiTg8G0aH51Db9ToYWxFmgGrkRRQJb6s
	 e1BhG4FVEboQv+aZDh96JwvoGGQLYB1nBiaFQd9on2PLFRKCEkuKy2FRFZJBRWP0Kl
	 7G1TEWoxK/gDA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 12/40] scsi: st: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, dlemoal@kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20260904002644.157668-13-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:11:01 +0000
Message-Id: <20260904011102.6920E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI tape driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D12

