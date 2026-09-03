Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398982110E;
	Thu,  3 Sep 2026 03:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407399; cv=none; b=qcBZX2TD1D126t1QDE3NgmMJlj45i/GqvGkbKVVwIAcoF28NegFod4CUzLtKzh0gGIZJqQ1vqH+pzQNHvnszkghyKYjtfcO3m94wBuL3L+dJFvq5sv7NT6USYsxdjK1DleVMqf7CwKVojCHoavxRIZ6eCJ4b1Fkaj2JX/3k8C1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407399; c=relaxed/simple;
	bh=saeuYzNDDDV82Zwsr+hwQ8/2h9huN7/NCcVhSvUfM2Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=seMOnuBnqpMntUBTe+/o3B0qaKKBrOZuvj5OdUNbangBNP/hkHK1mxMW/Qhv2Kt/zgXB4zacIimdQ4CgALqCP9q8eVxBsP6o45n+t+oO6VR03d/D/VdZo+4cdcq6uiR3PTg2WCuCgqsGXXkCz3JA/5JULmCzyfOZFgBhDpqy2E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ih90Deoy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ih90Deoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF911F000E9;
	Thu,  3 Sep 2026 03:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407397;
	bh=saeuYzNDDDV82Zwsr+hwQ8/2h9huN7/NCcVhSvUfM2Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ih90DeoyQ5qVqYNZfNJlCHnA14Ph2j+442c9a4QpTDqiz10QGlJe5gHXeJ3iANY5q
	 RN0L6mhFY4XtYg+D/d8KpPDwUyw4T6kMqi3xYbffFPE8XBJCTeF8sOGNsLPug5Fv+O
	 JZc6Z8y28FXx0CnY4kY9oN+/9uFyMhPyRVrCSe9VfYEXbx8q7jwZ9soGsbS9o3cCgQ
	 7NbvI0sfMG9puB3VtAsuarPtT+XYIJRF8v7Ja6TOBuZ7sZikpRGVqd15bCguimSOV9
	 WQiDiBjPVrGlhJqT2iMh/TeliUq1/9gwrb3cp12IPlP0m1vFe3R12GNLZIp8n7/25z
	 PWSTXTgt89fqQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/40] scsi: st: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, linux-ide@vger.kernel.org, dlemoal@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, cassel@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260903034201.112211-13-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:49:56 +0000
Message-Id: <20260903034957.4DF911F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D12

