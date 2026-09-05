Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36223385B9;
	Sat,  5 Sep 2026 03:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579668; cv=none; b=l7yaeSCVCk/DilIhocsupVtw45THwAMJ4HrLlpSllmih2FGucLakQpJ0ANlQCoAHHtw/LNUXqeXcMsgNTcQ/CF6PakYTTLyQsAlg2beR4crQmyfrzgB11XQOfGjzO87PBs/VbZoF9QBY/KV4a/sHbCMZfPeLE2vhCXpbxkfRtl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579668; c=relaxed/simple;
	bh=KiaPLfQUILgK9voDm5YY7jxsj3JgG9vpfyJXehbp728=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Kq0Oin0EX1MGMjSAn6Kk/BsOHjNYp942mek/SmwREe1IfKatKP91w6BiViyiXMjZ0ua8CIHuyEalmZYXhaZBXkrIvuSXQpCwhya6VPr2TJm3T4or0fiV6pjBfKtJqBnFTc2T5w6NuZm85/KrRHsT599hlzLiIVcmI8hARQrOawo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LSdoGcOv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LSdoGcOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0411F00A3D;
	Sat,  5 Sep 2026 03:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579667;
	bh=KiaPLfQUILgK9voDm5YY7jxsj3JgG9vpfyJXehbp728=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LSdoGcOvgO7OKOTlSnk4uaKoD8ZMi51puPd22hDVWAObRimo9XNInDr0hthvEQaJr
	 jGoW0fJ3wLrLnLfK//9lAFjQpVwtWM6wGs25NY9ud8H6G9PFzgbmHENV4kCIaJA7dd
	 x8bNr3uAeKpVIK6hbyIYXBE95MyYMqSbNR6Hij9W/kUJ9PuYRuo43e5tsxBAKYwSM0
	 zAyWGnnNkJI89LsBKWRG6LCc7NLa+AjCihIf1VKEymNBEmsbmVuzDBR+yn6lnWJGp1
	 hyYnOSHDlHbaOk3MRXThAfUP/PRrr7d9lTmrL8ZQz61Dwb0pc6qk+lnt/IOhCzRRut
	 RlME1+krr+KVQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 36/40] cdrom: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260905032224.509860-37-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-37-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:41:06 +0000
Message-Id: <20260905034107.4B0411F00A3D@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D36

