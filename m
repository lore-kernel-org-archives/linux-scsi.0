Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CA634F48F;
	Tue,  8 Sep 2026 09:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858780; cv=none; b=jdlDXQaVxux5SFpCs/3bFDlUkqZIJITTHIDFa0FaG24JuEiGp0MFYYv4WAAAsJm5ysGeofMnYIAjqnUHElLFKTMsXgqdbDeDln4NIyHK517CE3PCNvXZqK5tpQBYy+ZxeFZCWhyMtTc1fPxeiMrbrnxmX6vLbcfkXTa3RvlswGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858780; c=relaxed/simple;
	bh=aIW3hcOL2Boj+6zI3u/Z/X9uYF84jwxqX9e1exWJJ8g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=q8sN6FPj6vx+T50rRiSA7+fxsHblLlewV0KLehFscgdnYU+HhqjIpYXiltmw8UMoTdHa2JaqTRUnJrg3BTWqB2ifoq2rsXTRi4Ji35YQiux48MguZ0CB1OoFbsmqa/Bfaqn1fBuSAHkR6mfkLfwA9oNUL+BzX9CPKJKtf1eLQVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495781F00A3E;
	Tue,  8 Sep 2026 09:12:58 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 02/40] scsi: constants: use defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, cassel@kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260908090308.1085097-3-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:12:53 +0000
Message-Id: <20260908091258.495781F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The SENSE_CODE() macro is used for defining the array of struct error_info
> which associates a string description to an additional sense code and its
> combinations with additional sense code qualifiers. These are however
> hardcoded values.
>=20
> Now that all 16-bits sense codes are defined as macros in
> include/scsi/scsi_sense.h, modify sense_codes.h to use the defined
> sense code macros. While doing this, 2 missing entries are added for the
> codes OVERLAPPING_ATOMIC_COMMAND_IN_PROGRESS and
> DEPOPULATION_RESTORATION_INTERRUPTED.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D2

