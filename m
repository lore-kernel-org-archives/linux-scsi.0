Received: from smtp.eurecom.fr (smtp.eurecom.fr [193.55.113.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3645A1420A8
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 21:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.55.113.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735853171; cv=none; b=QQbTOfmPcGE4D//a5j2BZDWmu4Q5o30XWKkTnlvCxx9NMcH3fZE7cyiG5LHKLlYdhcI1UBDmqPJMMVtC093cLbRvTdvCHgO+dMEuiTTu1fZ5kRDQEzKUxwFn5kfIKJrZ35ZntCG+W4/MxBdoNcRxpwdSJW2i1MWlIrbEqGBsg/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735853171; c=relaxed/simple;
	bh=z2pEPZL3kfoYP+fC43S3VecVQEESncJD6Qc8zQfkbjo=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=dWzGhocv7Nniy36Fms4uifsGvyvCsOT1TZSsaBnjW7bjbtkNsHCul6X38fDRpmaToyzwUIQmBerfrwig0X9MCt+jSS60aO1LxAXMw9lRL4HgWyhyRm1qYXjaToH6LeIOHeyJA2SiP8ovhCzK2zJ10ea2UrCKFV8+xuyswxcHevo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eurecom.fr; spf=pass smtp.mailfrom=eurecom.fr; dkim=pass (1024-bit key) header.d=eurecom.fr header.i=@eurecom.fr header.b=J6Ej49G8; arc=none smtp.client-ip=193.55.113.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eurecom.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eurecom.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=eurecom.fr header.i=@eurecom.fr header.b="J6Ej49G8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=eurecom.fr; i=@eurecom.fr; q=dns/txt; s=default;
  t=1735853168; x=1767389168;
  h=from:in-reply-to:references:date:cc:to:mime-version:
   message-id:subject:content-transfer-encoding;
  bh=z2pEPZL3kfoYP+fC43S3VecVQEESncJD6Qc8zQfkbjo=;
  b=J6Ej49G8q3fLlGeEZXbPjKWoYOp/39fVl2yMm7AA5Ng2zMcyDRwjZWuv
   5wpbaHYvkOvj8hLJ3B6M0J6Mh2BOAWqR+KrBuijXJzy+t8jDQ0ee6YN40
   JgP7Fm4w2mH6lMxMxrFAkX8C8Or/k4/MShMpXG8AodDFMUpUnzl8OMz66
   E=;
X-CSE-ConnectionGUID: dZhdt4P/Sn2sswL0OnKinQ==
X-CSE-MsgGUID: Ft6Rdu99QnyPOfLGCTa0Dw==
X-IronPort-AV: E=Sophos;i="6.12,286,1728943200"; 
   d="scan'208";a="28361870"
Received: from quovadis.eurecom.fr ([10.3.2.233])
  by drago1i.eurecom.fr with ESMTP; 02 Jan 2025 22:25:59 +0100
From: "Ariel Otilibili-Anieli" <Ariel.Otilibili-Anieli@eurecom.fr>
In-Reply-To: <yq1ed1lf3z1.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Forward: 88.183.119.157
References: <20241213225852.62741-1-ariel.otilibili-anieli@eurecom.fr>
	<20241213225852.62741-2-ariel.otilibili-anieli@eurecom.fr> <yq1ed1lf3z1.fsf@ca-mkp.ca.oracle.com>
Date: Thu, 02 Jan 2025 22:25:58 +0100
Cc: linux-scsi@vger.kernel.org, "Hannes Reinecke" <hare@kernel.org>, =?utf-8?q?James_E=2EJ=2E_Bottomley?= <James.Bottomley@HansenPartnership.com>
To: =?utf-8?q?Martin_K=2E_Petersen?= <martin.petersen@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <2f7a87-67770480-d1b1-141f3260@133486995>
Subject: =?utf-8?q?Re=3A?= [PATCH 1/1] =?utf-8?q?drivers/scsi=3A?= remove dead code
User-Agent: SOGoMail 5.11.1
Content-Transfer-Encoding: quoted-printable

On Thursday, January 02, 2025 19:50 CET, "Martin K. Petersen" <martin.p=
etersen@oracle.com> wrote:

>=20
> Per the Fixes line above: The correct tag for this driver is "scsi:
> myrb:" and not "drivers/scsi:". I fixed it up.
>=20
> Applied to 6.14/scsi-staging, thanks!

Hi Martin, that is awesome. Thanks for handling the patch!=20

Were you referring to this tree? The commit hasn=E2=80=99t appeared yet=
.

https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=3D6=
.14/scsi-staging

Best regards, and happy new year,
Ariel
>=20
> --=20
> Martin K. Petersen	Oracle Linux Engineering

