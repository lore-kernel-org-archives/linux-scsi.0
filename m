Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479342F5A06;
	Sat,  5 Sep 2026 03:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579050; cv=none; b=aubE4usk+WIzD347+2x9tiH7n3da9q63dzBM0m0L01Rs6g3+vwAIdpi8RGKUkKWdovRQZNBNwZZAnIsRcKrk0tgphcKqx0j0nwC/sL/Xbk2YL5wNbWy978tBnYbWK9bzRskGXGqgOJujI4W17hub0UJpxpDDWOFW4J5fEubfYx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579050; c=relaxed/simple;
	bh=QaK4MHjL8TYRQ8OeJNxBfvW6bG8pPpVE9iUBYEYYt0Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IccaNxTVy2xmTWpdtrNOqH5zpNUOSg5Cp1+b9m02uUaRQmlkqXlD2pfwFgya51Nrlab3hfgBYqTZ/WZNjV1cfWv/hjEyGthYdqBCQieLSm+3oecbgOhNCmoLxIytIoU0Fmtq4LUognXT44ZmY2uWWY6548mtblX1wK52zJ15gDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jmJcKhus; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jmJcKhus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B221F00A3D;
	Sat,  5 Sep 2026 03:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579048;
	bh=QaK4MHjL8TYRQ8OeJNxBfvW6bG8pPpVE9iUBYEYYt0Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jmJcKhusXPxcIGMJGT2jn4BRjkIec5hroVNboYjAGn3NvgkhiwU2mDG3nfBWYhXBD
	 YwaztXTQLm6CDEk3klxM1IfZE8Ktuwfeo/d3zMXHSmurgVLhCdwEu6TtOJtF+XP3Ia
	 q+2325v3QC4f68OSiMejXqCbssp4ivlMwbC4/7Tdg+CKIzW7hlF9VVekB7GaTxPnyO
	 gkutmvMbXQOoNtYrsNB2W62iwbBn/9EgN6AF5LLaUnTSxdflA7z3ckJMTZI5OweV8s
	 aFLFi5X2WG8vvrncbgOEVxTw2VOsIMH9hx/zOAwcqMoU5rR2JQ8izWyuzvoD6Bo0oB
	 VlfZ6GCUJVheg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 14/40] scsi: device_handlers: rdac: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260905032224.509860-15-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-15-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:30:47 +0000
Message-Id: <20260905033047.C5B221F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the NetApp E-Series RDAC SCSI device handler driver to use the
> 16-bits sense_code field of struct scsi_sense_hdr and struct scsi_failure
> and replace all hard-coded additional sense codes and additional sense
> code qualifiers with the enum values defined in include/scsi/scsi_sense.h.
> This helps with code clarity as the sense codes being processed are easier
> to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D14

