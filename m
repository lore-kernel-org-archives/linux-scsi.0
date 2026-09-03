Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1395F28D8D0;
	Thu,  3 Sep 2026 03:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407470; cv=none; b=hZQkAh2xeLu7PbU1NGIIAQUHWLCLYniDfITsU1ZXoNhIyoFORbUdqL+tNo7JvQvcVl8DgJ6SdzeBGnXuh96rpbKTXZV8ec/i8KnT6ePhAGnim7WQRtDWncBh9jII2LneMkwoNAcsWJb4OxEJR/+kCURScdcaszrMwubG9mO7+hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407470; c=relaxed/simple;
	bh=Qv54XDyu4i/GCVPNbsCF5mJygnOSSncEoDbWGSEOh10=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TRIuT9qnot4jInMFl+dwHwhlkW+Dri/AfCWU9XWeLVFOfY6zHH1ZpS5lyagNwrOLRMSbkGyhmKwk5MQksq4yOB7CrHlo4qWiF4H5GlRDK9mNMjPh9JF+hkO9N4faS3YOL2itD41xHDRhG4eiYKHG4lF+GZKhBsn8oM3BVr17woI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J5GlZRU6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J5GlZRU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAE61F000E9;
	Thu,  3 Sep 2026 03:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407467;
	bh=Qv54XDyu4i/GCVPNbsCF5mJygnOSSncEoDbWGSEOh10=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J5GlZRU6bW0qV5SxMa4kFtgo7KwpZGhZ2UM+XS1NdNwoUwtIyyhI+vis8F7sDVUIi
	 VRwnxik5K8yrEOAwpG5cTKVUlontFRQYfhzCHfxyz+S0uYhi4YN9gUfbmLijTD28X/
	 M1Gh5vl6cFI1anWeSAkGl4M7ELLMbO5QMK2sqRFmfAWWrTlERuUrwFX+UufFWMiuTD
	 2/f3tGgXaYysQ8VMtLqaw8dcxCUYRoOzUJ9D2Ot+DV8PSIH+Q3qEFHtvFJ8/x8gtU6
	 Krhkfvrt5vddZTruRMWBmpqoQrJwCUA2GZPfG4hYd55NDsfAh06FwQSXwrFuM/M0rp
	 C/Cx6/hZ5dKOA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/40] scsi: use struct scsi_sense_hdr to log sense
 keys and codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260903034201.112211-7-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:51:07 +0000
Message-Id: <20260903035107.6FAE61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Instead of passing the sense key, additional sense code and additional
> sense code qualifier as separate parameters, change the functions
> scsi_extd_sense_format(), scsi_format_extd_sense(), and
> usb_stor_show_sense() to take a pointer to a struct scsi_sense_hdr to
> access the sense key and sense code with a single argument.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D6

