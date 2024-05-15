Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2F439ACD;
	Wed, 15 May 2024 01:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715737748; cv=none; b=gYxA/5Gm5w171nRVN+l0LYGz1uQPuDDdW0yTFMGkcd8AptDm8dmxWtlzaCXbyO4JGaggCw9kwH1Le/5huL76W6xVLE4UgtQgROOzwkmcVb2qIVwC9E44dHmnkTjT1rFYgOaCdVhOxWeBsTNQsPLKg9Tia+HqdzZxSnclC84Vumw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715737748; c=relaxed/simple;
	bh=K67qoiLiuoJZYCrUnU6ml4nqPt6J/mHxM6sR9bPa088=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jZTt2tckuhe4hL9/YAdKpIMOfIcTDWoImoFkXL8ESDn4mkV0Rx3uIX+RB/7XaXWafXqD87FzvXkMge1+j2mjGRSAXZUzhYo+TV2IkeER/MLCY/l5fM+FY5yKVKN5zw7tF5vMBmFCVLR6UMkpj5gphQSFvxoHRCCA5WtEArYHEuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sGnOOWtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sGnOOWtA"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 896AEC2BD10;
	Wed, 15 May 2024 01:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715737747;
	bh=K67qoiLiuoJZYCrUnU6ml4nqPt6J/mHxM6sR9bPa088=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=sGnOOWtAxAWmOxCciFSSgUL9mshZ5JLJERVh5R3a6Tl9h+d4TSMCJWYh9iZvPWLPx
	 HwGGC0/gnnK423o/361BPzFRMf2y9bt4pS51olJP6UAIPFLNqidSEnI9csXDXNa2hV
	 I1m3Ta3N1CC/W0YgAQ7GRyrL4HNuxTsZLgWtmCLLZIBEc1sBvm9paFKEQxO2S4eHK0
	 okrOxm1V5vUebt0fzLOPr1iMiubfFC+O5cOfugEZwO5HbSIidtMH3zJJhkXncAWaXo
	 wDL2H8v+xyxcQEDfth3hrehoW3LaBkGJMHnm/MhZtD5XU2+LBoAS5fls7VVwJDpojM
	 R7/vF8JpgSu6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8087DC43339;
	Wed, 15 May 2024 01:49:07 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI updates for the 6.9+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <b34d2038bb6af20946d7ad4cb456cbca0a896cff.camel@HansenPartnership.com>
References: <b34d2038bb6af20946d7ad4cb456cbca0a896cff.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <b34d2038bb6af20946d7ad4cb456cbca0a896cff.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 3668651def2c1622904e58b0280ee93121f2b10b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 113d1dd9c8ea2186d56a641a787e2588673c9c32
Message-Id: <171573774751.23667.11017122750447395095.pr-tracker-bot@kernel.org>
Date: Wed, 15 May 2024 01:49:07 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 14 May 2024 12:06:41 -0600:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/113d1dd9c8ea2186d56a641a787e2588673c9c32

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
