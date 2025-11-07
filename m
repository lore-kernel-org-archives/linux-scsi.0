Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463211DE8AE;
	Fri,  7 Nov 2025 16:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762531579; cv=none; b=hoIgQOrj4vn9biBiYHEvLWKqv++eEAK4pW/orcQBreBCuRP1hCzh64CJmr4Lv3x45B+mnXctIL61i++5TskCHyIpnrMAdQbiswmVkbnkn/pMM4Ng69jv3thT37neIvCR6Sf4PqljHJFxbsERhqx66+2w5LWzKrTa9Q6x9ZnHSAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762531579; c=relaxed/simple;
	bh=JRDDN9rUaJFN2x7oqFh3tjTq8EKF7hbnlMpxGfW1uUo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jxZuldMcnP9ulQpmhhIkgnyCVdh6tfPfp8uUu3A2C09pYhMw0dftWz+X8zzRuVWmJN2YFBF5vCBbitdiaayP4OVieujvzOvqQbQ9Znrc9YzTlOvxe2E8dcZK7zojYiQnNwmzhII2Gp5bJI5Ugw6U9IR8qnHDbc8wB0XS8aGA6Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jGsgP85T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jGsgP85T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2B3C113D0;
	Fri,  7 Nov 2025 16:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762531579;
	bh=JRDDN9rUaJFN2x7oqFh3tjTq8EKF7hbnlMpxGfW1uUo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jGsgP85TpuslnNPceKMwaQLVK7ZMkySBkbtlpiZ4egryvN/5eTSeyNvytRAsJ3/AH
	 tFfabr03sYEHbCW54H3QvMKxe8IdgDPOZOnZkCab4B2uQ94Q+PE+J/WoExRPDDHJ0f
	 T0VBHZRhwGA/bCKHm4I5pnzok4kNYsQpsNzNgwXCFgPYr9dhhY2c7x4QnWKir2aUWN
	 LF1qoOcevc7XeUtuYm6zox6199gmad31Jn+RiVsFXZnHcKdx8eegKd+uqz544c9Gdy
	 q8GbNat0p2jM2y8rIbfoCPByi1DRKw1O62SFhvN9B01OVdujVMDdaIWfshujfBWP8Z
	 avOYDKGNlD3ww==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE30739EFFCF;
	Fri,  7 Nov 2025 16:05:52 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.18-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <9f265f47e0b99894996b89c8d79d2e40d324ddce.camel@HansenPartnership.com>
References: <9f265f47e0b99894996b89c8d79d2e40d324ddce.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <9f265f47e0b99894996b89c8d79d2e40d324ddce.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: a2b32bc1d9e359a9f90d0de6af16699facb10935
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 11a6afabb4b38e70b6d697fd90fddedb9ad0ec43
Message-Id: <176253155117.1077315.1797535502900069638.pr-tracker-bot@kernel.org>
Date: Fri, 07 Nov 2025 16:05:51 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 06 Nov 2025 22:44:17 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/11a6afabb4b38e70b6d697fd90fddedb9ad0ec43

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
