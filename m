Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8DC2C032C;
	Thu,  3 Sep 2026 03:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407405; cv=none; b=fSBqueDwuma9fffivzqLpTxFlyN7yPoHcNYHu7TKyVuaIh/mxrUrbIYQyUnqeSllbSgC+2HV5s1qWkKeAjrc0nUrC54tI+bnbRAIzC2MQDpga5ZTQnTPKwikzZOS9EtlkUB0emZQKaWqzMMFCgSJYHfd8jVSY5WZ/0QyLbp7zF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407405; c=relaxed/simple;
	bh=+YypaiLmvR10nh640kZ60lUQVVtRQzpfIyh061bInOE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eiCKi33l/hKOnt/nM0ZU8b0pi/r22GQX7vEV+utzUDaRicd0IAyM1EKqmQeWzudyM6eqNqljnBDK6UrJSGSV7H4Z3YCvpYYaALAA8jHi5OMUPiG+gaJYbZXp5/+S9tY+SpY4gqL+KRqPsq71MFuUHEh7pLI5FGUuEilNit7l680=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7TMrQ3S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7TMrQ3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5973D1F000E9;
	Thu,  3 Sep 2026 03:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407403;
	bh=+YypaiLmvR10nh640kZ60lUQVVtRQzpfIyh061bInOE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i7TMrQ3SxdQnSxAfyuM93dvrm0CmquTj+omq8IgilqhfH8eLBw60gIfJN66ELWkmC
	 Wq86xBs93/donC4gpxVz/akQcJOa8Tz9w2NOERTKH6J1JI4YtYIpMwn/JqqFK6dnGt
	 rX58PiViatLVifqPnmu6+cshnKhJl0tmaLOvFmz5wf8hrOp3pmosZRNiHfqiESoeMW
	 4hwdojDBDoxlM7iW3Auc7qdZEHFQ9gyUOwnotEgXWSPJjjOW3I7TaTGH33zW5U6Bef
	 7Uo7FVtrcCI0jHnR0ORkNplviEO6pHV5+cu0Ba4qstg5gxXXoVT5MJ7YgqjmNL4X2C
	 0Z2TkKSY6/p5A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 15/40] scsi: device_handlers: emc: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, dlemoal@kernel.org
In-Reply-To: <20260903034201.112211-16-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-16-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:50:02 +0000
Message-Id: <20260903035003.5973D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the EMC SCSI device handler driver to use the 16-bits sense_code
> field of struct scsi_sense_hdr and replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D15

