Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEBE4C77B1;
	Tue,  8 Sep 2026 10:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788862811; cv=none; b=tkT8fLYk0F4mZgc861tdH8rLRagANzzdMd+eRsQkHm/gudENxLpJ8ba2kS/MpO7q8v/CsoF8J2ERKSEEW6XtSPYdvJ8+ZH1WHUWx46v2LYXD8aPUxQXyIda7TO2Ce3sQDn9DMK/etMLGVN3hqXHxUPubDQn0EnyoRzPS3UkB0Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788862811; c=relaxed/simple;
	bh=/hfez6LlcgNFv/p+jR7J758dTNJNBoCBWp2Fp4GTfPg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YrCy7eIHSXWy362gJabkAyvrDFwJs3TKSjiQ+Ej/wLX5Qhi4pr87DdBDQjt2Mo7RuGPbdVD6iBIHKKYKutBhcDJ8LjVUWMW05L2qhtinDjWDgo4W1NyDeBbLvhs33iH4qJJLFz7Wsf5WLvekyUldFoyRyOhEkoY7T+AqAArAbDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FAB1F00A3A;
	Tue,  8 Sep 2026 10:20:09 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 31/40] scsi: scsi_debug: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-32-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-32-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 10:20:08 +0000
Message-Id: <20260908102009.66FAB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the scsi_debug driver to replace hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> The functions mk_sense_buffer() and mk_sense_info_tape() are modified to
> take a 16-bits sense code as argument.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D31

