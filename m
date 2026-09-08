Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155C14C77D9;
	Tue,  8 Sep 2026 10:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788863060; cv=none; b=mZSbOiFlRvxhFH8v5ZzPhwNtt22v8cdmY6nbrcJ3CsdzZ+OPmp3OTqGZi3rqyiY/8POCqva+H2rWUp4AbMj71JMOFqjLJVIdfbdQayjOla13UsMLdVs62Qlo76W3G1af7Ml0IxoS+k9Lg11o+IlAshiREI+UmRBCaEedTZ5Z9tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788863060; c=relaxed/simple;
	bh=YHWjsy+sOkZSSuxiXdULBStfkN/SyU1nKVu/loaMFgw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gQGDzZlMSMEVElC6U376njW60BeNOhbZj4S+egux6u0BBctiNLZBd52knger8QpTc2LAZblTJmxEDv1x0N6Ye8Cv0LqjjY/pmw2OOUKTpNkZyBF1giEVOJ0s2/Ugqdx+NtwGUp+NaDVzI1oC0Q9k89CAPofVrx2iGWoWW7h7qEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0zlBtSP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0zlBtSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9861F00A3A;
	Tue,  8 Sep 2026 10:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788863058;
	bh=YHWjsy+sOkZSSuxiXdULBStfkN/SyU1nKVu/loaMFgw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q0zlBtSP+M/dQaVn2Ra87qq+hxiQIEOTlXtcpqfOh8RchT9gNg7rCEzDy2xpCe6p1
	 qMldzFRsVfZjrsrgKYIbhbQe68YUokqmatrd4uCGQHKBY+JYvpGE2o0TWCI5jvlEAa
	 McjyGhEwytY1QfTsqYDOLRgdVQcSbuqv8D/0HPNYZPwz0avZumjjQm0+SRErr0UJT4
	 L3RqiO4WN7afvXkJqt/vajvJVyTZHLrPmAAO5JiE3hGyzlO4DxJAsHYS7HX/S7Vm4h
	 HOFzHYbeK4ZO561bys9qGJn4ffLnRKMtAjsSdfqeSmbXuIqjox8s7gbexgklz5F9xC
	 /ZGnn6um3k7hA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 36/40] cdrom: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, dlemoal@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-37-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-37-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 10:24:17 +0000
Message-Id: <20260908102418.1A9861F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the cdrom driver to use the 16-bits sense_code field of
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D36

