Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DA72D5408;
	Sat,  5 Sep 2026 03:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579690; cv=none; b=duZ0l0n0gXxQmT3Nm59AJBPxNlxJGDMC35mVbClBVRWqbiBGu+NW3KHFgJsYlulvjMg648DWhieGxfPwyOG+dms1JcUI3fiyavfRkhidIFnOngyfyxGzzREweVEvxA2bh+n/hFhbE4NCbQvDYhLQ6c5IS+XKA8VGie3/ranW7F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579690; c=relaxed/simple;
	bh=txMi8t3GpfsvJaRKv2gIqYHPkQJBuzXiD1TrTcN3sP8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LSG25AYpJEBW6i3cdcbbNTT41iuJy2LH0ExQ5YKcsxZ6lANTS/iYymloQUhfpbJLSi8wnEPbycjcvLKE1pugrTefpaKFJFkYlYkD8L434TNnvSF/sC79QnF1yBd2vARaFJ0oWewo5zzEPynde4G010sk/GlkSZMMS2G7i7nDSFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UVidyz4h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UVidyz4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD0B1F00A3D;
	Sat,  5 Sep 2026 03:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579688;
	bh=txMi8t3GpfsvJaRKv2gIqYHPkQJBuzXiD1TrTcN3sP8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UVidyz4hWDZFlRHRHn3MyILr8PA2FzLg1L8+S/wUNt+n8sBZwu5+druaziD9cjvRZ
	 hcRLgjfa7buLFHhNodMCzmaBilrCjBWlRUGpMr+BTlmIYizj4oG+j6lcS1n6KOLnHv
	 O4EqxOl7QN0B3pVmS2pwNFkFMSDLWAPgu49+NTQACRNv4T2yECP2LV8I8uIIlUHrbD
	 tql6rv/thXuPIWgR3gyF22sM9aRun2EFUo5joxALjGotFHfGVEYdxUcaN53s4OUN8Z
	 Pv07V2zchWTxCXvoxX8RNyU/hPbkUh1zALUqb8HTXwkvVA4+fUpjqTH3r2wcYQN5VB
	 T6Cc0zkKEYv3w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 39/40] scsi: cleanup scsi_proto.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260905032224.509860-40-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-40-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:41:27 +0000
Message-Id: <20260905034128.5AD0B1F00A3D@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D39

