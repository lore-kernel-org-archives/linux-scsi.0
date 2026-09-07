Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9532E7367;
	Mon,  7 Sep 2026 02:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749675; cv=none; b=sE3vcl+NlWpj6iVnQ6ZRwENqgwL4PM0vlWmTa1T8NqLhaV3kivAcmL5kF6D0+ZZEA+HbHKTiNKUD7dbZXf/qin0//dcsCaLkT+0C114lG1dothzY8CKGcMaEaMrIyW0lVdiFokQuaAfAwNCwj5csmYidgtuNTXDqCvbd6avYBHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749675; c=relaxed/simple;
	bh=l6B24fOa6ch70HDUfJ20udU0UXxawFzPaxa9EcI4ITo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KXJT+/cp62PqPsv12lb7QCTw/KxBqiLttAS6uq3EjciEYgfoRWGL1wUBpjGAOcAXOFrcSj5iJ2Horbp0TctHc/sdL0Ds1YSzjDtrgHBbNy9npjj9y4nmw6nDmOFa7rtj9um2QJ6zCgslcKmD4lgQ9u4MAVOTCqjBbPwNPRaLaCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0/8fZnf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0/8fZnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDE11F00A3A;
	Mon,  7 Sep 2026 02:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749674;
	bh=l6B24fOa6ch70HDUfJ20udU0UXxawFzPaxa9EcI4ITo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X0/8fZnf2pSxq+Cp3nBAcgs8BpJOvG8UkOuu/fLDYK80mf7SjkJgM0mlQdzoaAlm+
	 yOvRcWQMmPVLRbhAeZMy8fYZVHdd9Rl45WB3KCPSLj4q7H6AgkwZZr66SI0HqYENG8
	 o2ll8xxEG/jUvo6Z7FBmDntMM+27zSXAJm310A8973Nz2TdZGoe6We9/egabjNUAz4
	 Ml1tCJO/T+NAWHXFEMH5E8IA7hdpa2lFCSEOWGePdRFcu347sx7irzDGoo53Wi3Qfy
	 kAe7xxedEgvksGTkF5mWb4lJAuYmRa6vyk++5wRUUaUZqC6xDxQRUPNwg/QQRN5ZYt
	 QhLNRmjaA2QpQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 11/40] scsi: ch: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, dlemoal@kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, cassel@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org
In-Reply-To: <20260907024343.1046387-12-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-12-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:54:33 +0000
Message-Id: <20260907025433.7BDE11F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D11

