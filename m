Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7479849F138;
	Tue,  8 Sep 2026 09:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860137; cv=none; b=sQ7ExXLiIvUTa2Xka8jt0fRNUlhmMs8uEehykBs7YwhDt8KCXN32INWX3aDeOdfZpioUYvQLB+PHHinD2cO8OdEhw7EupF9wcKcm6mwBOdDBApd9WTc9Jdx28pdD9cDtpFzzSUUnXemigI/hvupHjlWskDBf9I02Fy+v350Yp6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860137; c=relaxed/simple;
	bh=dV/IN6//iVHQNN1cvjv0i5PKa96oX3NBA7Z4b2SrCmw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TXavkAEznacmYgu/Q0S0RcKgqnhqopsCPmYrPzp/tztdzi73Ee5FP6Xg7k2aSsbZc9I9mwftX3v/FBnQ567EzIC12/8wRofDTba0ERWoKiJWuHOJqqfGhd3Ipc3pj4WDm3Lyf6JSEvVPvazcMPj5wZ9ZgJcOwOmGbvyF6Pv7QvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=meeyxXFk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="meeyxXFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC3E1F00A3A;
	Tue,  8 Sep 2026 09:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788860135;
	bh=dV/IN6//iVHQNN1cvjv0i5PKa96oX3NBA7Z4b2SrCmw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=meeyxXFkr9WsQyfASWBLvXSCqqkD4LVocy63axJiLsd6CxJdeKYY+qe0yu3nFEicu
	 lbpKdYoOP5rJKKdLJf9XIN860wbya+jxYVOEubYJzVM/1QvEE91YIR4c/g2a3W9NaG
	 e0kbq3iGojqAtXAKGl7QiYaqCO8YjccUZnqCULp+TXTY1pJmfECa5vvj+i3gsgOWOD
	 Iian7s4kH4zSt5N5U57hhsyMX5rBSvrfmSHiF1Xh5Xi20nDZvbDTnrY4UMXZioFBz+
	 hU1OShTkMQVErKZMFfYeievn1KzR0CGtq1lrQ8UnkyPcngqgiyISMiqKfza+VZ3wd0
	 jZOZB+3E1BiuQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 13/40] scsi: device_handlers: hp_sw: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, dlemoal@kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org
In-Reply-To: <20260908090308.1085097-14-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-14-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:35:34 +0000
Message-Id: <20260908093535.4DC3E1F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D13

