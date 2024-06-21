Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA92017C201;
	Fri, 21 Jun 2024 22:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719007442; cv=none; b=UJNVpqQj5wljMMNF20oSU3EpNcv70SuhnU7FFPI0lMHi18UNqvlgFBXyWTELq+Yuwse9eNc6F4Jz+geXneCwUtujBp88UA7bNi2l+I9PRZY/qyCcpuYiFvznwqXtPdfcsxvYtKFXH0Otnx0GP+5zr7JhN7iSK1Ohf0tZ3wluQ0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719007442; c=relaxed/simple;
	bh=jF/Ew9xvorUsIbwRT3gErAKtBJlC0FxYzWDU9LncFpM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=RX+A15yO9reELReE9NHHBEyVMNusUeOzgKGZm7TMF9LPZ8jVZQy1c5OlymCzaWwuMiX0JVc8IxhaiMiuortl6GzMsQeVGGpuEFlfAASOG5ydREd3k1/CgKgfVe+9IBlMKH8XHesd7dytjHXzEOLHpBE1gyOR0+CCUxb07jWh6C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pRyJyD3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pRyJyD3u"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6AA1EC4AF07;
	Fri, 21 Jun 2024 22:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719007442;
	bh=jF/Ew9xvorUsIbwRT3gErAKtBJlC0FxYzWDU9LncFpM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=pRyJyD3u211eWC31bBf6HkZwyYvw9YxzTHZ20BasvNmDpnboxBaoEPj238X6KqnOw
	 o+KqJyokqRBmJR1/I1STZr0h3g6yJP2pC08d1Oa5PTIOdi7Xv2jb5XyBAaU62r34Km
	 RC3zEeP7KuarHPfQVK7I8NELYk/uPmLEOSTytEfvzGUxF2dUwjGCKqz8GGNHnJeda+
	 GvSVOP4it0SsJME/+Pv9feCTfE85u6CRU9mmEAI821jqBc4CwaSdOqGJZQq1FKk2yE
	 1tg2M33sRZdJ4KWe7cGCQZ9r7WpAldQ/HInZJm/2jdWObIcfx8vuCnkA/yj9UDK0Cm
	 m+6q60lUut2bg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B2E3C4167D;
	Fri, 21 Jun 2024 22:04:02 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.10-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <317d2de5fdb5e27f8f493e0e0ad23640a41b6acf.camel@HansenPartnership.com>
References: <317d2de5fdb5e27f8f493e0e0ad23640a41b6acf.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <317d2de5fdb5e27f8f493e0e0ad23640a41b6acf.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 57619f3cdeb5ae9f4252833b0ed600e9f81da722
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 35bb670d65fc0f80c62383ab4f2544cec85ac57a
Message-Id: <171900744236.4837.16690801950672021328.pr-tracker-bot@kernel.org>
Date: Fri, 21 Jun 2024 22:04:02 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 21 Jun 2024 17:15:57 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/35bb670d65fc0f80c62383ab4f2544cec85ac57a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
