Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBD5525A97;
	Tue,  8 Sep 2026 09:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859948; cv=none; b=kUOvQqsSkMmH5op3tagU3Xo8lgEPfRe3dbieU/ulA63FGv8LE6ldNZj/3rixTbTvDmQpKT9EnRIyLu9IEQmfSN75C7ikuL7Xh4lHWvX1zrnAQ4zKi1cChyslrY8+GPHUd5QP0tbtEcMG1keSyMSL5OF0m+sc5Jc0HiFKWL0TCLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859948; c=relaxed/simple;
	bh=dvnxt7369CqDh40tZ+eL30WdE5b7GJYtuocv+O2KLh0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=phEMAC5yExR/QSAgmB6eZWziGRTXxkp5uML6O4XIC7KRdxsNtzMCUVHec5VnsAO9d3hYIFSo/WNHV+fOO3KflsgXeb6tknbzhM5A4iaOIUyp5IMlie3dk6g0we4Qcpq0ceDzV+SwgfYuiCCUzZajUhhD1tmeOBOcNY+X5JoB1H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FhuYh2GI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FhuYh2GI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813771F00A3A;
	Tue,  8 Sep 2026 09:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788859947;
	bh=dvnxt7369CqDh40tZ+eL30WdE5b7GJYtuocv+O2KLh0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FhuYh2GI38L4jrdS/Uu4v2KhFBdo5bBc+vqZaeBQbou2KnIN1JcspQcsRqgRMZNZj
	 shXnSdBZyc8qbiBXdY3loSI8NhrG4MWx9qzYt7c34pmS9PHPjJIT0z2xCUJXrv8ehM
	 HTH6QDHCwxKX8rey86vymsVxmk8jIR3Z05OHPXmH8ncQqU5jBZ/zJ0O8dyc/5PLXwD
	 7/bCKYtPC2YkpzgJRPJBcDSG/zfVz5v0SPZLV8NUQ2XRzVldOQ+kyWWDgJfY/k1yNE
	 52A2FJtIQC945974rvaTlWHZSOOIoVhtGHIKbqnWgShxFj3TxwUO8av429uFM1cRit
	 smmcyE7j6osEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 11/40] scsi: ch: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260908090308.1085097-12-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-12-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:32:24 +0000
Message-Id: <20260908093226.813771F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI media changer driver to use the 16-bits sense_code field
> of struct scsi_sense_hdr and struct scsi_failure and replace all
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D11

