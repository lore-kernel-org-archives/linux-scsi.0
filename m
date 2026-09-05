Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6283515C8;
	Sat,  5 Sep 2026 03:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579013; cv=none; b=iLraYth8ZOs7WZLbSQ0xpuS4XWyvPQ7cGhWXMV+MuNfIOIQaiJOlpY7tI3jpogYMHeWR9Xqtn5L6m1dW71b04z8uTTcKDDCAI1+XeRaBgwvexc3hIRvxi6StDNSiIPzXx4ktmgWFE/88JSNbNg48Ap43zU8nmYFCbsi1h3qxO9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579013; c=relaxed/simple;
	bh=mWgnvPTgEnwqj1zEhnN9c0WYS4MLwSS2wS7crDz37P0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rYLaFa9AnKS2xq0VmThZp+ynz6ClnyB/PcW5Czcc4IWU0tIoGO7qYmmELpD4s5wWVMrJVu/5muHZUtPIDjZHxUjxu5ovs76rFvEEXCsPaiht3SPYTf01vMeazm6xi9po3T/1Qn6J8vN9Q135NlWSK4fDJHNGcNQrzF0YG1H5/BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wd79MzsB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wd79MzsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66141F00A3E;
	Sat,  5 Sep 2026 03:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579012;
	bh=mWgnvPTgEnwqj1zEhnN9c0WYS4MLwSS2wS7crDz37P0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wd79MzsBlf7/IFPh0okXt889sJAqDgICrdPy2z2OuWFNDW50tstoOTjqCnH2hQu60
	 lqQ+KAxjf2891tbthj4oiB3m2+81/bnD+LeJuByUC+Qdue4I3CvzOPDLyRqIj7LvBb
	 MYiGJEY5Wb4GMMLUpj0F8VGTAiCI8AwJiPWLPW9jy0k0tryZa8Dr3bMXrYKOSMaY36
	 4f5ck4+vqtD7rXMSdNDKXmxxhA6AYaItmJDOW9Xp/X6ESMW1TN+VT8hJZvv5p90GsS
	 tHM2tt5t9P3hG/2mCWoib21ihxfZYqjXFX8Qaw8jDSQwNcxAl/2sKuORtKmM12VwnC
	 RJsncHJNUZzpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 15/40] scsi: device_handlers: emc: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, linux-ide@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260905032224.509860-16-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-16-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:30:11 +0000
Message-Id: <20260905033011.A66141F00A3E@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D15

