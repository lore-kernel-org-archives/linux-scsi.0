Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F7A37E2F3;
	Thu,  3 Sep 2026 04:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788408015; cv=none; b=H8wwnv+DMaHZW1P8GFnQ92gPXxQAz8bOdfo95PTuCQC6m8tzgHtqnu33jptcpyEuoTNyJKdq2Wp+QAY8K5T84OUxs2LrBHd6Y9J+nWxeM35Ek5cy4KhLrsp0ltgu50t52EQo+fsGqbA3ioTCFGG1q/Tz1iedOe9AXdNrP7FV4Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788408015; c=relaxed/simple;
	bh=9U2y7Qj7nue0CP6Hq8Y1sBJGfHRBVq71J8tloGMr1UY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YPLlVRJOb6//Wj0veR5vorjROjiucw+P7IYRMsXOcfv9qvn/JNcAvnbCM1/QjmHN/7qy3XkZ4zsZqVMKCqV96DxUSXICWDUj8ov39SzjjyVjWGN1l9V7RzCd6YfRA4gBgNIz/NXwT8e4+xeh/569h6ZIzEt4aTXGCDtrWBLVQJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D4TZl3Xn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D4TZl3Xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8281F000E9;
	Thu,  3 Sep 2026 04:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788408014;
	bh=9U2y7Qj7nue0CP6Hq8Y1sBJGfHRBVq71J8tloGMr1UY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D4TZl3XnEgXt5QTcMN+uxGzHZlDKPoRRoQkCJ6Gk6bMRF9D0RflFqxsbOZEOB5R/u
	 XRDhf9pQcWcsWd2HjSasQ2CcvKDFG6ULsm1qEmpYrMCr85FVczLIDm/cN0KaBhAyMA
	 EguU+JRvyYpjuWDCMXmb1pppxNaFkt1I9i2V2PoNDwgRjd+3IXqUeGsxdJ7rJdcPxX
	 RTJvE4VJ0bElewPH+/zP3usA9LgvTym4qFp09JDc9FkDudxROe4zvmd2wzksYcbLT3
	 p/CM5J2gnCf8hTdA3gT14x8KhCLEMFzMedYsqtK5/xLdDGHizN7MY3Rs9UEY5k2l2u
	 VO/8NoxqfLGUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 39/40] scsi: cleanup scsi_proto.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260903034201.112211-40-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-40-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 04:00:13 +0000
Message-Id: <20260903040014.0F8281F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Now that all users of SCSI sense codes have been modified to use macro
> definitions and the 16-bits sense code instead of separate 8-bits ASC and
> ASCQ, remove the now unused asc and ascq fields of struct scsi_failure and
> struct scsi_sense_hdr, and the old (and incomplete) definitions of SCSI
> additional sense codes and sense code qualifiers in scsi_proto.h.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D39

