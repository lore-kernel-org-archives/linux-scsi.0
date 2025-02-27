Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FD14EB38;
	Thu, 27 Feb 2025 02:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740623887; cv=none; b=jTUEPr9U54ANHJ8wGtHkyKGgV9ZQw7Nic1vzuqYP7O6OD3mfd8iCJdC1eKDFQygXPRiZfoMR4jAEhd4D1eCkXZrafgUQUm8uOtY1Q09iitKA6MXTcgnIaKbXv/tM0UfvB67OWO+3+IPBrc/HUR4w2jE6uJrmIuRLwSq+XRCn4yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740623887; c=relaxed/simple;
	bh=x7+0RbX8L8CrKP+2O2ZWLdb1fHC68R50fFFhVU2RDzw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=mPPGwwFzc8yzpPl2wb5QVtZapnYWb8Zsz95TX9h/plL9Ze2racCLeeGf4GxHp/Mwj8hCQOkjHkE6mYprpX6xHMSkRsaqLFFxLtFJqVy5My2S3bhQ615gUyU/kM6XYtstKg1pJk9zwPNtuM6uoeN8pEQ5GKL4YTzqxHNSl4w/7HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i2V/0zV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i2V/0zV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA6CC4CED6;
	Thu, 27 Feb 2025 02:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740623886;
	bh=x7+0RbX8L8CrKP+2O2ZWLdb1fHC68R50fFFhVU2RDzw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=i2V/0zV8Egs2DZalxmT6vT/9Q1mdXYI+ieaBbBON0M2bA3jkhA4exq1IwZJYm/+Mp
	 0H07hXgea/ljzdOEmMsnt1uF8v3w0n+VeJhoNyPK4JYwnldApHe6N1I1SyOMYJHDWL
	 T5Rs6cxQ0jgTN6t1y1JbJF6ilxpcxRDnCKDSKQpgHLrSYr9lY56hFAbPbqV/Hpy4bI
	 NWdVaGJy8Dd6myuT+mE5GxVXkv7qfn3q4RIVrAY1MddFN33VpZLP6vESdT32c/Cavh
	 K16iY2JWr9TSlBXXv5QiJVd4Lq2P+gpdbioG3moKGwvUcrqeiRpnxKhYIbyi7VLqvO
	 kaYZjbT6TGeuA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 344C6380CFF1;
	Thu, 27 Feb 2025 02:38:39 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.14-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <fe0bc38b7a0b0cc51e29804de3131648f45f4c95.camel@HansenPartnership.com>
References: <fe0bc38b7a0b0cc51e29804de3131648f45f4c95.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <fe0bc38b7a0b0cc51e29804de3131648f45f4c95.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: f27a95845b01e86d67c8b014b4f41bd3327daa63
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 102c16a1f9a9d0ba3b166bf5ca399adf832b65a1
Message-Id: <174062391773.945292.557425787225146985.pr-tracker-bot@kernel.org>
Date: Thu, 27 Feb 2025 02:38:37 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 26 Feb 2025 17:24:05 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/102c16a1f9a9d0ba3b166bf5ca399adf832b65a1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
