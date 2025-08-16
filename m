Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9D7347D0;
	Sat, 16 Aug 2025 14:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755353316; cv=none; b=cuR3is1JBsmlMsIfZ35Nb86J1ErgVWbo+fJC9fECjueKURtZZe+ktMA182JU0mtAaeKeww7v9xYEPoJ+XCfxS4sTxsTJ+CN2G1wlgxrduzyP0PRwJKjWs5QOMQ4meyvoF6aI8TjRMs9gyZm4rU7NNb0HVVS845SSC1DN4siG40U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755353316; c=relaxed/simple;
	bh=EeJAQTz01KG2mWnq3FvyJZd+IRi434jT4xYEy8hDRjE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Frw2XvezUM+4dalWIPH/w/r2z0g+Ds0kuWALlqmnvR9bKDdQ2W8MC+S9BWmIEAqwahCenn/gh82VFwM9QrdQfReuK7AkJPblsGNGoqe3ycWINLPTWg1IEquZp1JdW/9obIzQjgvAiT2isaw4U4bpVwMpDS9iS9DqYvUlstheYec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y5meBbgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y5meBbgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B56C4CEEF;
	Sat, 16 Aug 2025 14:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755353315;
	bh=EeJAQTz01KG2mWnq3FvyJZd+IRi434jT4xYEy8hDRjE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Y5meBbgK/DCriqGqxjoKW0SJ4yhDlCQuvHmEfKVOvQElKUSpANGbEYE1SlgPw8sKL
	 oiG3I+ITJPV148uDmfjISC2GW9hKPQwTkn1DhvaPwtPRYu8XDsnsh8XYJ/lEB1wDjd
	 XnVnVp4bk1gfbDqFHNovg9lcswHXU1ZyKJyjUaiyl8bdI88oa+i5Cyp+GwSL6Qtg6j
	 ITbuU9YHBsuAg2rPSgK8H5F9VrF7euLwReDd8tA4ydiavMTGyILP8LiPUr0kqKvjd1
	 U3T46xIVumHGFa7+xKsPWbig3sHM+IWYQztmOTZ9fPDvq91Tqw23u9b8NvHt4oK+d2
	 Ym5YRsiCyjNHw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADE2339D0C3C;
	Sat, 16 Aug 2025 14:08:47 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.17-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <5597dc1584d9b50c6f003c77b474d22443d81bf6.camel@HansenPartnership.com>
References: <5597dc1584d9b50c6f003c77b474d22443d81bf6.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <5597dc1584d9b50c6f003c77b474d22443d81bf6.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: c6b819e0058e5f34cb274018e1f5cd5b671cec7e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c5f3e78d35c00599673e9ba9f2b641969f8667e4
Message-Id: <175535332620.1477675.11455672976921382179.pr-tracker-bot@kernel.org>
Date: Sat, 16 Aug 2025 14:08:46 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 16 Aug 2025 10:12:01 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c5f3e78d35c00599673e9ba9f2b641969f8667e4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
