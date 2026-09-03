Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C4B3612EF;
	Thu,  3 Sep 2026 04:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788408036; cv=none; b=Ow3lFeGoSA1QoRBumsewUwelay3JZZzIQtN36D/6WZsVb16Fq71yQQiYV5oAIHeMJLUG3BpAihHzTV8zfAQOWGGjGgODy7mDaPCt6lKoamn4INyCya5VZA8qiEf2WAw+AeGOQUycPiIC5MdkjcMNqOIVGykRykpy88ZrJZJl3PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788408036; c=relaxed/simple;
	bh=Aous4WKbPp53ZCNlhckQ762FGQ1LeecpwAQJMIabGy8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TdGrccDbUdXwv2f2WdW1iU8qc+V/B3ijAtvraQE6rPQ7GJ0zPmJ0oCtinldLRCFg3wtiXx+/QwOrw3R9zziezD+JM40tErx4/K4AP6+l+b0oS/K6qjM08Zhci9zZUg/JrhyBECMcpmZggjumJLJecibaBXXnSWmJK2Tt9YdRTQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BHHOSr1r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BHHOSr1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D2B1F000E9;
	Thu,  3 Sep 2026 04:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788408035;
	bh=Aous4WKbPp53ZCNlhckQ762FGQ1LeecpwAQJMIabGy8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BHHOSr1r86ZG9kwTtk4Pz/tSTzMg93+c7Ovxnks+vNY7bwaS8timqSsyFc6bhNBOn
	 7mtO8BaQnKId+rAmZSVpkeOyPl9kT0hUhpu7mvpFNr2KUq/G22M6Tb3qnGEexj7bCH
	 7gHlOVIwOFTusWK2wAnKmy1L5EHYhGTmdWZGt4NQO9pWHQy5ptJ0v2xQKvtvkC3Ert
	 EMSmOB6z2obAyCnKg9mytdSuB4ofqaSaWDhgD9YhhqAt9O42sDmQa/gaz9oaKcX+L/
	 kQqg+JR8qGpCB8t5QNkrMnf7zuBMEybaxyD9s0kMGLTSHI56k6dZ3UTVHIg2pEtT/U
	 DUoDKOCKDwvyA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 24/40] scsi: qla2xxx: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, cassel@kernel.org, linux-s390@vger.kernel.org, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260903034201.112211-25-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-25-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 04:00:34 +0000
Message-Id: <20260903040035.16D2B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the qla2xxx driver to use scsi_set_sense() and replace all
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
11-1-dlemoal@kernel.org?part=3D24

