Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8266C175A85;
	Sat,  5 Sep 2026 03:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579786; cv=none; b=QH2IghBrzu06l9SqSBoSXjoBjw8cj7kw1dPJcmqBZE2nmG4cFD/Nm8e4AWIn+k/gMwLNZp31jBhk5xsvgOg6IXPrVz8YBtU06l4EoTkCOLaLTcwVp04/QEnQxy2WZ7ePkenzNYoIFe1l0VBWeoNk2h+JdNXVeDgxAOE8V3oVzLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579786; c=relaxed/simple;
	bh=Z3YlV/kD2afP/QXC47DJfl0Vz8sPwDyJBR1riIZk24c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A4ySa2BsFAC07M9yshjHDFw8IQA32RJh6WjeF22aXNV/FQM+2do9bfFrDT9ap58ATcV/X5gcrjKZjP5XfIeUhq5aBsGkhN42QgbTdMMQ/vvOm1dUFlFENh59lGFWyUsynAt/zGIXDfwi9jLnspEX1PQQGEokxfYXPF4AkQqpO2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=esmW5Ll4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="esmW5Ll4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710CD1F00A3D;
	Sat,  5 Sep 2026 03:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579784;
	bh=Z3YlV/kD2afP/QXC47DJfl0Vz8sPwDyJBR1riIZk24c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=esmW5Ll4neo5qfCa5Omb3Fe2TP6pl3eKW9R4pkPS/mofA7KakUaYM2FYhPV3nzU8r
	 MjYUy0n9SEaQbebf2GkzhBVnBv4hpaC29bgqfSCELGtyv2MVcJ8NRoMCt0ERgkiqad
	 EtPXJyV0gpcsGClPI/mUDTssPLJV//v500JNb3H3Lgx3eUd4kBTnG91qTlWbI49JXR
	 E0eEDw8IL8AQXwgnILDHPv2vLh6bV+GnIQBH/FMmbGg3R2bBy5OD907+rS9yvB7/fA
	 T1r2g7xeRuXNzCLxEGlyvJDGPU5dNLV2EOfEy692vNmoExbJfpjTKQDeNmf5PTrEs9
	 5/+6rUT6lgiWg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 13/40] scsi: device_handlers: hp_sw: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260905032224.509860-14-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-14-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:43:04 +0000
Message-Id: <20260905034304.710CD1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the HP sw device handler driver to use the 16-bits sense_code
> field of struct scsi_sense_hdr and struct scsi_failure and replace all
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D13

