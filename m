Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EF1240611;
	Sat,  5 Sep 2026 03:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579287; cv=none; b=csmGbd8TH1wdtDHYesod1/Mt89cS0TBF+YRiHvc2ghsatvDt8dsZPSA7yDpGY35ZYAUthHDMFwAgcqYWpY7i72GnKY1mcA+CW4L1PIcjpLDVH6fi2ehg5tzOckbnozpbqDx+fTI07axWfuQAIvlnRZyuDoPINTEgHSFvX70r3c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579287; c=relaxed/simple;
	bh=xWJN0xvX97RokvMUzEMVBrFgYab9SUT9svGV881QEDs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=snXF5OVwN3POt4G26GNtVTuWhz0rw7sZbyNVuXdh45NG1J+6tdPGJrz5slSmmR843iMKlbrP679PUlULmyuEpx2VhW8azbLw4RIrz5SBEcIbNexlqzeU4n6ciBlUF+MFtGellh18NXMmLlX/lQKOKigqnwhWH+JZgOOUKnRGtjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HlpPayxE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlpPayxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3611F00A3D;
	Sat,  5 Sep 2026 03:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579285;
	bh=xWJN0xvX97RokvMUzEMVBrFgYab9SUT9svGV881QEDs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HlpPayxEPBXC9pDZW4Ajw46lxJvKHn6zyGrcBd1uHza2OpBmdFgnKVVzyeKb64FIj
	 Q3u8qHlWgqr/jl70ok6ywruwQqoo7cERwDiX81SFM8bozcEustab86gnZLpXnZ0sp9
	 sGschcLrpDu3TBrZ9mVIToMv+zwQrRfZDJfVy8CKH1wiEeATCmBUBSf4zUbFWXFD/j
	 4WfD66cm5JtPVAvq7MXs9E5nHjaDNcGih4Hyi9fmVmKtOrXVEMjCy5JuVGF75rRIrz
	 vBZLRfhD1KUOYuSMUpeabwaNj/Vl/bFTGUbs3mznKbHdOQOmyPjsdR1HUc+0ABEN6X
	 JDB7EUPZKD5fw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 09/40] scsi: sr: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260905032224.509860-10-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:34:44 +0000
Message-Id: <20260905033445.4D3611F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI CDROM driver to use the 16-bits sense_code field of
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D9

