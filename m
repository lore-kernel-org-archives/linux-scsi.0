Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7E13914F0
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 02:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612137; cv=none; b=MzFz3lvwQse920O9/eXIO9mludIt9po0kLlingJ/DSzs/jiJE8mtBn/2lECjQ/09WljSb+f1pClqTaHEreZ+YmZlXVjVHw86CtJvAyngy/B1ZbXbga069n8IuKZaPAc5AOYt4vqqMIKR8X0Vc4XUwShJIAohJtyVrlNeu0J0LRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612137; c=relaxed/simple;
	bh=7hOo6Dy1x7KohJstyLqmsMPSjBrGuaFkI2asOuzq/fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V1xpQlqGX5ICAnQLwwBX1KQ2jsf55J0VXNnjt/NWpOj+RPBuKlasBXaUYn+mY+Gkgzmt9ECmbEy0XjN8qt2f/CVGKmc7VKwJrsE23YEI0MLNPdNuzA8Xle3E6KMTx6d7RUMEph3oowGtR6uQFMQk7DgCJwrh7sjZI8M0yuSZpQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V+mMNXmt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V+mMNXmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD3C1F0089E;
	Thu, 17 Sep 2026 02:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612117;
	bh=myVhqPmu8F72OKJTpqxjGHHLMEVxoBB4pwp0dykOBHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+mMNXmtvn7I8HKPbB5BKQuu5+YfVhv9FTWpRsK/qHIzAcFX0RqsBlICNqYucHs+R
	 6OA5HZOOFIoUjhgtyF5CfDm721nn9hvwPnWKESxHWbX2weM6kmqPGeMz4OPuoPPt/z
	 GJaNeLspgRS5toizEHPSy7t8qhPrJRnR3JHxAKCd4gKbu4E8Bhjmuzu6Xb+AJPCkoz
	 oi4zBVH6bl7Yv5nqcVVC8fv0zJc0ZsIR3A8N91iMxEC8CAINRF8NalBLLxNpNJ7jSe
	 vztt1RPYoXMq0NszyjOd6mVLXKu/n5JFWZN5UHZZFfAJg8HeeE/py/FbkXDsZtTsbm
	 H7O6m0GjYsFpg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Karl Mehltretter <kmehltretter@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	Daniel Wagner <wagi@kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: Fix the ql2xfc2target parameter description
Date: Wed, 16 Sep 2026 22:28:19 -0400
Message-ID: <178961190574.3672510.9517140388257581437.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906171009.2560-1-kmehltretter@gmail.com>
References: <20260906171009.2560-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sun, 06 Sep 2026 19:10:09 +0200, Karl Mehltretter wrote:

> The module parameter is ql2xfc2target, but its MODULE_PARM_DESC() names
> qla2xfc2target, so modinfo describes a parameter that does not exist and
> shows no description for the real one.
> 
> Use the parameter name in the description.
> 
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: Fix the ql2xfc2target parameter description
      https://git.kernel.org/mkp/scsi/c/779f202a92ef

-- 
Martin K. Petersen
