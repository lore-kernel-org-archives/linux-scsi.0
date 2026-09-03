Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7352345EA7;
	Thu,  3 Sep 2026 03:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407687; cv=none; b=XbJADrsGov341NAXAxp0F/ZUI9q/Z/pSQIO0KQA8a+dUMiZhFLEifFjdHoGpT2/d1VuT/zmQS2gNM7lLkLnqONouo06rbAUxpWWhI53DfADzuIfV6IMkQImQ5UJeBoPIK/U4o/VNzfIOqq8/PXzhzpHrk/whGAaRmUN5ojiiDZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407687; c=relaxed/simple;
	bh=HT5ngCLxGP36Ej1bAf2FUgMhy5Cgf4m5VR1158EQEEM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=a6aPt629QeB4ktq7XLJfQNcaklLVCElYPO60rN16hMKrTK3ZjYfylyAn3smXGcTE5oC5GJDadRAMFijvLwrjcYpj7l2/AdFMzUw/BTwFPJOK1ZEJUAiTcSTw7yxOTbiM30V3rvg25Nrs/fXdIhnB7vNzKk9q7/hSy3+8bLSPqDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UylPPtTp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UylPPtTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249C51F00A3A;
	Thu,  3 Sep 2026 03:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407686;
	bh=HT5ngCLxGP36Ej1bAf2FUgMhy5Cgf4m5VR1158EQEEM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UylPPtTpwRUmss+3N1HG7FU9DS4qbapgYcrZepArmWIWm9txTvL1trDSah1Tqb77D
	 wT1wkZCByQxcV7vC0UFOYHMKw4tE3FBxHylTRC5R2rAJujEIwdY1j+7ZEWvMgcnb8R
	 kyrJQ/98BmW41YwftdaHS9hrwCWHG3ppJSL1JXLY9E0/d9+H5oSTVRJiY84daTlKoi
	 IePo5dpiZOv/EERmCRgv4bw0KdiUiSRdhcldJOyyiBv2c8PhiWPVA8egxo/qUuF6El
	 qifK5ufG8N9itF9fPGqjhNZuzdEy8CkDh7buJ4nf+LHticsI+8t1JZHkUdXdTkZm3Y
	 iJcPdvAR0Xwcw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 26/40] scsi: lpfc: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, dlemoal@kernel.org, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260903034201.112211-27-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-27-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:54:45 +0000
Message-Id: <20260903035446.249C51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the lpfc driver to use scsi_set_sense() and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D26

