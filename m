Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B172036FB;
	Wed,  8 Jan 2025 20:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736369943; cv=none; b=s7rkkqED44Votg177grcFMj5kCwcC8W+u71TnY8CzPGLIWj1GdcckUutiusI+FKMAKot5WqeNMtuma1kanBW+XwzYMdlPbphydaN5PVEdFifZmqZXnVPWpKwkhvxY02fhobnW+u0OeKv2O6+pSKZIYe15u2jLz4yCYh3TiqPsSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736369943; c=relaxed/simple;
	bh=F2up2AvAbnOjbUtQJ2l0xZPVyyuNrrraFYTYMCSJjiA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=RJXcXNLrMETrjnGbR63nX2P80w8a83iIIrISkl7he5JfDwa1Zxg3GmWFRnGZ5lfyc/6HvH1tr/nonVLHYxJZbEVNrg/1uMtDLgdt0ai2odcRv3bhwmzA4CU64fAnutNkN6AnW16mhKJ3e+f2O0Dr4zhNFT7SxJjVi/EOdcVmGUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=INa3o7kE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="INa3o7kE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F29C4CEDF;
	Wed,  8 Jan 2025 20:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736369942;
	bh=F2up2AvAbnOjbUtQJ2l0xZPVyyuNrrraFYTYMCSJjiA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=INa3o7kEotlACNexfA6472fTU0514gdecMHNztdR4vglG+s+J9PkE+FdaicaGiXuW
	 HZGmxX0NHZ034HnQuzpZhQdXabGnX9MflIhX9GHEZKb7qzf/A2a7oPqxJEaB6p8vMx
	 8a7pbmxU6t8l4C+3mNQSWp/oYVwm3mOF6HqVynZi6BfxSOwVEeZTWaazpH+7bgL9Eg
	 YJdrignAW1Lmu/Ei9bWVco/yq75S5Q4tJL7la/x3dHkY/8sbp5TrisEXm8FepjONxx
	 pJR3nQpRxq31UGCZnVaRPzPBQOcg2le16YuMTFCW/+DdJPSFx/ggYnRWynjMaTTv36
	 dheOnkPTk+8Tw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 72087380A965;
	Wed,  8 Jan 2025 20:59:25 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.13-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <4954d5ac31f5bb5f68c62ae5d825871eaafc1a5a.camel@HansenPartnership.com>
References: <4954d5ac31f5bb5f68c62ae5d825871eaafc1a5a.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <4954d5ac31f5bb5f68c62ae5d825871eaafc1a5a.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 3b2f56860b05bf0cea86af786fd9b7faa8fe3ef3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: eea6e4b4dfb8859446177c32961c96726d0117be
Message-Id: <173636996405.775029.2661454460447875129.pr-tracker-bot@kernel.org>
Date: Wed, 08 Jan 2025 20:59:24 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 08 Jan 2025 11:31:26 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/eea6e4b4dfb8859446177c32961c96726d0117be

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
