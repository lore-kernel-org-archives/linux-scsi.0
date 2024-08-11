Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5F242A96;
	Sun, 11 Aug 2024 17:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723395827; cv=none; b=tf2WSpXavZPItLgRciO8UjdQ5Ivt4fXjgvX+ZdE0QCO4FGhKRZuj6aLQMt5xRNWsuW1F5IUDG1N6iDIk1r3/wyKJyzv3PIfp2mXAn17GuIzlki0ap7dImtmXQC+4XVR9u2R/wdjn1ojpzfU2S/n+VEpoiwhiDVOcTILik1aHVk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723395827; c=relaxed/simple;
	bh=delJplnts+Eo42jo1doNLy/zZrlVJLkkziHEwyjPGFw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=NKIzQ6lZQV6yN9I1rsJjRJUKAXOOIKZFe0p/hgyVU3qvUg4V+Bu51SoDjBIJWUok23jazX36QEO+2sq2e2wBk443tuo/hn4TVWd42jiIDhlYEqHN9eEngPgM3zNHI8Ik278vbogXBAHUFQ/EGE6EgOVhPHLHtfFtnoVem5Nrll0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XRSjVgyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XRSjVgyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70993C32786;
	Sun, 11 Aug 2024 17:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723395827;
	bh=delJplnts+Eo42jo1doNLy/zZrlVJLkkziHEwyjPGFw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XRSjVgyRIqOqG7GKuixY4CNK4c/0BwW2KDVQx9lS8DcVLmOH9e5HweclwDioMUgVf
	 K1d0evGOv0m/78JUnazBniZMMbsLTw/Zlcl4y9lg+zEB8H+Xz4gUMNrhmCcxbaz19i
	 jkX40yH5edRdBEO7kpoBbNYSWF7heryljANooEbthEx5bDosSsyUgT+sW3HkBXk9Eh
	 u6T+Dh2upF/RZvvT3GQyeIZW3ZZY/5lHH3Z/g1sYlUli0BdOSTJfeXvrm9L6pSuBm2
	 PGD/MdlzMukki0CbtXCOTx3TCCB/BAf7LZ3VwhEWaEyzsnbMM14XU/xMjfXq2W+uQq
	 MyKpObrTwldqg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE3713823358;
	Sun, 11 Aug 2024 17:03:47 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.11-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <cf2e36dcab26d1a1e2137897f28d41c59ee501a1.camel@HansenPartnership.com>
References: <cf2e36dcab26d1a1e2137897f28d41c59ee501a1.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <cf2e36dcab26d1a1e2137897f28d41c59ee501a1.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: f874d7210d882cb1c58a8e3da66f61cdc63cd4b4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 04cc50c2f38b032a167b289f1b351a83dbcb853e
Message-Id: <172339582643.226577.8146935906980434292.pr-tracker-bot@kernel.org>
Date: Sun, 11 Aug 2024 17:03:46 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 11 Aug 2024 09:22:51 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/04cc50c2f38b032a167b289f1b351a83dbcb853e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
