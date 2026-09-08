Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C93524B1A;
	Tue,  8 Sep 2026 09:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860280; cv=none; b=GyPcHYXDozKBk8q3fWmLDii8BvwrmKGePOQFEhOVBG1Lj6DgG8oPjomcsk3/k6JLL4bNT0Xb/6Dwl+VznJNAIgk1e2e2Kd4MdT1PkOh6yjrjAtpsD+Yzcs1DUli9lLTsTgffVWNntd6SGqv82Cws34107Lfr0tYLRVSgTQ7MlRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860280; c=relaxed/simple;
	bh=E9Rw8lt5dTntzfZE2RINq/EHR+7l2n60SQq0T9V1f2Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pcdjwmJhKdKR6WPTagfkBLYKEDblknLvzmtvCWjloeLs22bOkTGz96yRoTe8iNnDVs+n6N+sKcqp3+x9JLkUTUpmPbZyp0MJx/2NQcVxP5KPJRAb9BjrKE3Ggh8Tcltpk+aWuxbo84kMhBaVJLdPWg2tYgoRreIqREcsPc8f+uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UzwL73+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UzwL73+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8571F00A3A;
	Tue,  8 Sep 2026 09:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788860279;
	bh=E9Rw8lt5dTntzfZE2RINq/EHR+7l2n60SQq0T9V1f2Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UzwL73+CdLu1KStgdcBbh3X07TZzHZ6dT5ZCzo3hhC586EVQd1wKni96NhuI0QhOp
	 N6pHpbzZchAg84LNcsthIL2IlgiFjAti8F/AvpAIO59EDPwlKwvinusbUTEvGWjBon
	 NqGLwB6nZ9wDYwiruOHpLslGDzhiqML8k/ia/q2dUF7wLyWuUvuWn32Smk3PHdNAN/
	 fmbC8pwDYxed9oHn2g3zDj+q78kekMjjR1amoIZiW/yuWOSgPbzFcJj6syqEJK4GN2
	 m706PyzP9s8+2Jw+TIwYqWRV3E9OoAhMqbyNQJbGOVHoRj1gK4K+VoyIprMp6G7eJz
	 klKufQE7KsXVw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 14/40] scsi: device_handlers: rdac: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260908090308.1085097-15-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-15-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:37:58 +0000
Message-Id: <20260908093758.BC8571F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the NetApp E-Series RDAC SCSI device handler driver to use the
> 16-bits sense_code field of struct scsi_sense_hdr and struct scsi_failure
> and replace all hard-coded additional sense codes and additional sense
> code qualifiers with the enum values defined in include/scsi/scsi_sense.h.
> This helps with code clarity as the sense codes being processed are easier
> to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D14

