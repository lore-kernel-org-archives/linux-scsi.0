Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E964E50AC14;
	Tue,  8 Sep 2026 09:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860565; cv=none; b=S3H1QzwtiTKG9PjrKL16sdEfZRNXmB0EWFufKG4MuqvQQZdHC3RtE00jpngqJmtyaLVp3fv+YiZ+/+MiuKkwLlRUuK/URaLHoJkuxtJDt5Hm3Zm3VFm4bC5KP/6iRHuHcQA5RCXIWzPl0SuqTylZwpQoWDg+Ly6QSQTbzSh2PYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860565; c=relaxed/simple;
	bh=yi0+4o35Ro1puEKpCQwR9YhGJNbZXHyiiOjy9SePg8Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VymmFRsN6b1yqUVFe2JP6DVonFpN0tHUPFBMKWtB4I27xxRM4dsnqllcwDF8vzluABHKORASTDXSQuusYR5QCMvZs0E7LAFO7nA+1/GEk4jPKGy857Cy+/WHgFBPJ4jQiu7C4+VAZDwDO+2/srA/cOKpIQYbQwqycY5WQIm/hcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UOA9FGsl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UOA9FGsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545F91F00A3A;
	Tue,  8 Sep 2026 09:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788860563;
	bh=yi0+4o35Ro1puEKpCQwR9YhGJNbZXHyiiOjy9SePg8Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UOA9FGslP5mhJ2liFC/V15PvkkTT2dASsZdLJrWvrMyCPId21Kydlvh4FqldpsLXS
	 WJBJVtzOSFMb1g6koakGwyPApe3K+3TPPcdB+JLf52jX5LmCUcGSWCiekE2ukkyT6x
	 VQcgMXkPXh6fGmPng/vc98hFuQJCu2ymUXi0mmG7CuSIMPKwrucsApCMDSj6TtQpwY
	 DHzfbfqewY2KektjfypB6BS9T7JNEXrwb02+gn0EgadXQFhWo3ZapILa3apHHZe/Qd
	 nZdeK4qGVtpL6dBFdZu76oPdkoVSGtZIcFgQ+CzT+xfN8gGHmaKk7bo5KAgxhzI5U6
	 PH4g7spRZTTng==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 18/40] scsi: mpi3mr: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, dlemoal@kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-19-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-19-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:42:42 +0000
Message-Id: <20260908094243.545F91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the mpi3mr driver to use the 16-bits sense_code field of struct
> scsi_sense_hdr and replace all hard-coded additional sense codes and
> additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D18

