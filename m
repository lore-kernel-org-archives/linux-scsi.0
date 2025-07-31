Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4972BA2E;
	Thu, 31 Jul 2025 20:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753992148; cv=none; b=Cmaw/APna7BVe5XrNDZiu01WyCij333RWSA8iPl0o8P97W0+O6OFFbb8s1I1jfZ3U9W15ZEudQlUU3SvvqJUttIOiuESUqrOoyQ2qTl+rIC4QMhT023imGEl2vt1VHnpw5EDEbyYzWzkjrSmBaaoP0lKYFbZikkVYKG5jyjgBcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753992148; c=relaxed/simple;
	bh=GiagW4iD+UAgNuOp3Fz45vtJk8PIVpDFegqqLqhgPOw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Nn8Nel9rssLk+RXmusGky4D2sH9ugqPq2fLKAFGGqbQjHD0HSIcJvbz54yoQpMpTGT89lXM9Z7XFjE2EOWkOfmq0leBSTlmffft3GaX7Fii2zdtwCwUsy1EYM/T6eRNWd0RpzLf8COcw9515JAXE+y30tNZY7bwi/UMFOmTlEKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=elEkLTXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="elEkLTXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BF2C4CEEF;
	Thu, 31 Jul 2025 20:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753992148;
	bh=GiagW4iD+UAgNuOp3Fz45vtJk8PIVpDFegqqLqhgPOw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=elEkLTXiVKQqITuYkJG8AMgnDBNOtkDKd5Qx3zXScYSwEcscTzOcGKGBpR01yGlj6
	 dYJV5kWkei5a0GL3hTVUSVISGt5A0vg/R01rMr+R2CVYRRKH/nX4PAdNAmUcXLCtlt
	 1fFJTv/5WHBXujpohzuBgeoWgO0u9Bq1GEhpNCjYWoZNkmqPAUsBU8lxw/JzJhGXL5
	 zSGodnoF+j1qpY5B1wof+EJJOB6LCTvfqBB7UIGnc4Ge6m7nQYrmjkZdBraVUYvBGu
	 QIdtimivXuGBCxaZWkZddZmzqWmSIbjUO2vBmZTNeGsvtzR1gJNRPhhEU3B6/FKaUk
	 oyRemdKK7k6KQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70F50383BF51;
	Thu, 31 Jul 2025 20:02:45 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI updates for the 6.16+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <f50e46e97328c9416ad227a1919874f98d13843d.camel@HansenPartnership.com>
References: <f50e46e97328c9416ad227a1919874f98d13843d.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <f50e46e97328c9416ad227a1919874f98d13843d.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 3ea3a256ed81f95ab0f3281a0e234b01a9cae605
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2c8c9aae4492f813b9b9ae95f0931945a693100e
Message-Id: <175399216411.3278693.11399846262871623055.pr-tracker-bot@kernel.org>
Date: Thu, 31 Jul 2025 20:02:44 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 30 Jul 2025 10:44:23 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2c8c9aae4492f813b9b9ae95f0931945a693100e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
