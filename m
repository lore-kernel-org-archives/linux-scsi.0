Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DEE306746;
	Thu,  3 Sep 2026 03:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407388; cv=none; b=dorkowI1n4R/Vl1E6sEb+v226DnGYEMe8Fkxl4PIJv0P1IZa7Wvl5M48dJTftbedSmjY3tDj/WkF+qkF8sQL/779g6cpSPB0N6oWwXWiEE4TJJ13/rpjAXde5sYGtsp5tC+spLSe9fK8/Cw9Qs/u5yTkIklgAilqn8p9fDzyroU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407388; c=relaxed/simple;
	bh=D42iTmHxA0bCNin9K1s8lQfQ3JpWLoYusKUUW41zw2M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nIZDgzzYmBM25CxDeCxY5GCX3egsPBmSwD+/5Kp+e1jbA286vB3fUN6m5bBudwXt9AiEgmnPUg2woQhA4lQ2siyV9qNlHU6P8OoczW334rkiReszPOoIndeoEhsaYP0A7MrANJ7gCexvUyriXZdyu5x4MBDcwKY0cFQnK9FmVj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gglkCgN7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gglkCgN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454E01F000E9;
	Thu,  3 Sep 2026 03:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407386;
	bh=D42iTmHxA0bCNin9K1s8lQfQ3JpWLoYusKUUW41zw2M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gglkCgN7aH+VbzxapBXjqRwEQ0tybBZCILo0aG65DzC2WYgmbFM5a4SOQ8NE9BVV/
	 LDI6zX1NI1Rlr5S5e7VjAKUWTmfBoKWLq8LhJBTYptCE8FiaQOy91rQV7JqbhKix0J
	 D5XBfW+UQcHeO1UeUlKzPG2JClFnZtlj7QnGjxeVOIFEZvWVbG6c607ysgTAHtcGO4
	 35cSos78fcDuCny1KljeMa3lY7zdsG0wnwYTRy68nUaJXFRuMsvDJu5zJ9W1+7NHyS
	 vbrNx7mfy8EtTHFr28Nwi0UV8/iOwkbR1vl1MkBxf30gmLZiL93fCzBTgYiefyLmwm
	 peYdt/CdVtHAA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 13/40] scsi: device_handlers: hp_sw: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, cassel@kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260903034201.112211-14-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-14-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:49:45 +0000
Message-Id: <20260903034946.454E01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the HP sw device handler driver to use the 16-bits sense_code
> field of struct scsi_sense_hdr and struct scsi_failure and replace all
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
11-1-dlemoal@kernel.org?part=3D13

