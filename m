Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1133E7BB4;
	Mon,  7 Sep 2026 02:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749510; cv=none; b=eu+O6g09cYE1OhlTpxFozFVwn6+1/1ajE0QR8f+7AnPSXorgY1DUx5N+287gNSALQhuVyL1F5N+0oqRYHrTH2dTMMA0ZXW9ldU/hu1FPztXXqzrS9BGW0vvx2chYGuAkURgOJcLK6WJSkVG6e6i0oe43eMXJILVWuyIj4PSQAf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749510; c=relaxed/simple;
	bh=Tt30uAqiuoBRz5i67Gsm/d8++8ErFzLJrmQgJjN8x2U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PR1kBM42PkcpAJZ+gvHQT2AHPXi08deQgy+PI0DTH31eHr86i9Hk+D77per6g6NLPoysMgQ9FjHj7H1O7CxM2fiW7fgKjjgrl5dEHIwMnUIAClUgasEvziwEps8JLo2BsZuIXU3WQpn7aBBGfMEsgYho4nKbIPMBRQfp1ISADpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VAtsc8rt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VAtsc8rt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260DA1F00A3A;
	Mon,  7 Sep 2026 02:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749508;
	bh=Tt30uAqiuoBRz5i67Gsm/d8++8ErFzLJrmQgJjN8x2U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VAtsc8rtVpc2xU3scsMbZy5y3AX70e96rFfoWrJfcqOPp8qf7w73WRJj9PPyZzJ/r
	 aDqPgdhqbdhaM0BuRpZ+EqXEfvSRPPpAKo9CrBTVjzrXe1nYQi1UA3q4kr7syWsT/8
	 4sPBvkcQiVmeqpwXRsTWYu3Mv0OfBbJykhakXKPt741n1d0AHmz9dlEF5nPBev3+vk
	 CLFsAKAZlM1egJ0G109xJ1UnbI2AtP8kM1V+fYU45RbY3YET60FH2SdFUoIEa4ix6Y
	 NEZ/chXWA+r5uSEFaQ3R6oR+lL61qXVAHEQrrATRJzJomHXrR9qHm/JpaAw3r668TI
	 r10edBFD8Ai2g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 02/40] scsi: constants: use defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, cassel@kernel.org, linux-s390@vger.kernel.org, dlemoal@kernel.org
In-Reply-To: <20260907024343.1046387-3-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:51:47 +0000
Message-Id: <20260907025148.260DA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The SENSE_CODE() macro is used for defining the array of struct error_info
> which associates a string description to an additional sense code and its
> combinations with additional sense code qualifiers. These are however
> hardcoded values.
>=20
> Now that all 16-bits sense codes are defined as macros in
> include/scsi/scsi_sense.h, modify sense_codes.h to use the defined
> sense code macros. While doing this, 2 missing entries are added for the
> codes OVERLAPPING_ATOMIC_COMMAND_IN_PROGRESS and
> DEPOPULATION_RESTORATION_INTERRUPTED.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D2

