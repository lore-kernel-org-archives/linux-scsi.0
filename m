Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5A41C27;
	Sun, 20 Oct 2024 00:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729385938; cv=none; b=Hc7d5+8nWQlEn1bpLXySJHGtjIW8eLAgejbcJq1GtSBZm1+A3jkMEULUrJdYMs7KIi6YQT8mdqNA9mWCY0m9b9TUUyGX1sg7v/j0WYmSbCxquZq3/YFCCigup6GxjNnjyrXuqo8avEGWPZDaz2ZBgpaJ7ta4BrDxTleTI34QIe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729385938; c=relaxed/simple;
	bh=5PfoagMo7M2h6lYaeNu2koOydDiQ+5fcrnNeFOYwOIY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=O4pcrOcUU40cyZGEQCSTJzOF8Z4uRA0cH8rNVLHdvbelDOnDCkmBZoiLdwSBWwwGkMRuPDt4/eq8FOa8cypG73IVmdCGOb/9YEH/A9+5n3935KlWnqiz2OuaB8OS979Syg6IFtDwmXs9nbvh6K9ydByHKEu/eNgiT78A5sT+hTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U1vDX7Mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U1vDX7Mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BD4C4CEC5;
	Sun, 20 Oct 2024 00:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729385938;
	bh=5PfoagMo7M2h6lYaeNu2koOydDiQ+5fcrnNeFOYwOIY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=U1vDX7MbRdNcg0xpGJSsW+NIhyB05uirylBIQL7nV80oPP4jXqW/fLTEfRk9wjGgX
	 H+JbgO7HV8OPtEa/x8ug9Nb/JNPJGPCV+j50neJjL9ti1xvVYynq/+LLZB8yp+mTOz
	 b/eU8dPQQO43/HT5k9KP9pkiN33VDx03PsvqbhIQPMoJcvZXsCfYM/KyYN3PqPSx5s
	 Ah7kkBZun+qZu6/SyIqczhNLwVRu67wA3LEwe8vnn6A2iYOX21kvjcYrG+MsBKPvmg
	 pksfnXl8oSG7GZe3WFVBDViMVKGi9dZExrV59lJ3kkMk3t1seCtv2nVEa3/Fvw5D0c
	 gDylWDK0T3kSg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 719EA3805CC0;
	Sun, 20 Oct 2024 00:59:05 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.12-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <902b72f033da4e706b0e622c6241df90ee88a4ec.camel@HansenPartnership.com>
References: <902b72f033da4e706b0e622c6241df90ee88a4ec.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <902b72f033da4e706b0e622c6241df90ee88a4ec.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: fca6caeb4a61d240f031914413fcc69534f6dc03
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 531643fcd98c8d045d72a05cb0aaf49e5a4bdf5c
Message-Id: <172938594394.3503243.9378110829787147351.pr-tracker-bot@kernel.org>
Date: Sun, 20 Oct 2024 00:59:03 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 19 Oct 2024 15:30:07 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/531643fcd98c8d045d72a05cb0aaf49e5a4bdf5c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
