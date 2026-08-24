Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C10E2147F9;
	Mon, 24 Aug 2026 01:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787536103; cv=none; b=ttd8RRWGvqT5iLQ9IV/SY95wfca2/LJ27UvQS23HGfEXa4zH6Paz6l0NB11779GX9mcHMcw+2eA5pCbcEjdSFMXRMsJ6PP8MI5mbvxzy/q0dDokmF4C5HVGBzEy7YXBm3GGVdfRsr7Y4Rqa0+cPgFP2jKF/iJsdtuVxJ4UShkWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787536103; c=relaxed/simple;
	bh=4Y1aIE9ZLYh1gYOJ2JaHG/OFeoaLbaHpfk3s78xvFXE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=cMECMfee+nTIQ2JVQZrgVoPgFJdn/upVXkGnkPqgOcZgLK+71xEna9FLpfd9BeIVupTYqkvf4vsOTly21wb9lhW3e8Xuc2kzmK3JcHNdfudGkSAQWfaFS0prsurssSHNb/hncRQHvjh1EuWzyiRbj2twlWe5Cr1W3rTqDVwLbLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dfD/KUAQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dfD/KUAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF2D1F000E9;
	Mon, 24 Aug 2026 01:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787536101;
	bh=mHhGfp1mLXWk1Z3ALge4lQCcNJAJ1jqGFnF+XgqgnZA=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=dfD/KUAQtaFb6YAAxpYbbFeOWE1T1GwnQQBOTpH6cQiFxcEV19y1eLsa+RsHWJgQI
	 kbD7wLZfHoOdwdF0kyD4SUGHJdFnv5+kQPOK8Fi/PbjRmRCfePO5Qe80bQI/G/aQ5y
	 eXjN90Ovl5WGfLnryjkIOJkM8w2nj9OeVepwOYXmoDI2ALEYOXmM88Zg7OLiEMeA76
	 eO33+5SRlVCliZ9s9UZHBcSnPS9XfmoqezQLw40hrzZBccB9ieiCTyGxFeQ2u6ff1h
	 xTzWZrzVkJmWY+jRCGdhkdvY5YIl4pJ7W0xXo+UZw6LVCjXmfbD6GlNx8wmmGgvOby
	 UOr8c6pUsqk4A==
To: Dan Carpenter <error27@gmail.com>
Cc: Atul Deshmukh <atul.deshmukh@qlogic.com>,  Nilesh Javali
 <njavali@marvell.com>,  GR-QLogic-Storage-Upstream@marvell.com,  "James
 E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,  "Martin K.
 Petersen" <martin.petersen@oracle.com>,  Saurav Kashyap
 <saurav.kashyap@qlogic.com>,  James Bottomley <JBottomley@parallels.com>,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org,
  kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix an loop timeout test
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <an1twcxTYSFkkUTA@stanley.mountain> (Dan Carpenter's message of
	"Thu, 13 Aug 2026 10:09:53 +0300")
Message-ID: <yq15x10p9uq.fsf@mail.kernel.org>
References: <an1twcxTYSFkkUTA@stanley.mountain>
Date: Sun, 23 Aug 2026 21:48:20 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Dan,

> This loop timeout with "retries" set to -1, not 0. Fix the test for
> failure.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
