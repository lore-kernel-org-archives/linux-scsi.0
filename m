Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B425B2BF3F3;
	Sat,  5 Sep 2026 03:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579452; cv=none; b=BZIpJV6vm12mtn5kuf3OUqyteLKa84cpQv5jXutDLkPxlwjlkGT4TZY3apwCQIToeIae1RdOHMobpJHAxPyY+Pb86wq1QqEJsqKlr+H2g86dNEwILXrfHLfrCzZfK/r0m4VnE/mN0dacl5eIHZ6dQfU5QCAnRjIRBEkLdLa/03I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579452; c=relaxed/simple;
	bh=TH/dYRfKb+gRRQyR3lim5xYNQUDvdiXFKO5IrV25d1o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZJP+VTwe/PDVbHoO0XML9ymQD0WpH3T50fP5eOGoBGA2T+nEbslV48KPxKNNEclGwnbRbOmaDJrYO9ejFb2u0YHoAuo32hixUoFQxs5D9ckL98hRbdMTlf76YD2jPqJgbiuKPfKAiNCv8ewq7wFbtAxb6M1k2Od4ghaf4gO3KP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RGd1jIZu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RGd1jIZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189C51F00A3D;
	Sat,  5 Sep 2026 03:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579451;
	bh=6GhG26Q9MfHF9uaD3q1sCqAg6zMcFjqN5dHJ0Rmip2A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RGd1jIZudLHkopeWXk/1SZcATrWqDsPVXBtSFJfqwJWPfic+jLpm/lzAEdYeT3MYQ
	 /dl1PaCf9yrXc8avnrI591OZzVhTcrxfR2eIfG/QTa6qWwLsPvPFxWvSwBCU+jA5y7
	 /iF05kvfgrwhJTrmmQgaVNGZZIIzWSpC/W0i6JG7wlygIJsXwApH69agsnMjBS8Sja
	 VhQxZPPmw49gzI6OymBFcg9wmCUkResqjubezpZzWr5qNTXwIQ2aqc25i5X4Sq2vhD
	 3yRGtEE7k2P6cndIRwW76Td+OG8nmPsynmrWjaiHqs62khtXm2U1C4Uk/i8jZhVX2R
	 BbTWwZUUtzjaQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 40/40] scsi: remove scsi_build_sense() and
 scsi_build_sense_buffer()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, dlemoal@kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260905032224.509860-41-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-41-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:37:30 +0000
Message-Id: <20260905033731.189C51F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Now that all code has been converted to use 16-bits sense codes and to
> initialize sense with scsi_set_sense() and scsi_set_sense_buffer(), remove
> the inline definitions of these new functions, change scsi_build_sense()
> and scsi_build_sense_buffer() to use a single 16-bits sense code as
> argument (instead of separate arguments for the ASC and ASCQ), and
> rename them to scsi_set_sense()  and scsi_set_sense_buffer().
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D40

