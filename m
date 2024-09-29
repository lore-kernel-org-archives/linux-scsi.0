Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020F717D346;
	Sun, 29 Sep 2024 17:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727629486; cv=none; b=Ysq495eBNUTtUaLFPxe+ZXJuOqZdEfeaTyCJ8wsP4d9j65xGv771n45Smj1FiUwCnb+K2o/iM457TTZicbyWjaF165jtUTJQi3xeCpsiy3HKo1zzLrKgAVACDi7cbNZhqh2JcP5KENHeCBMo6NAs3C2HnEqWvcIw6UdpiiUKqlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727629486; c=relaxed/simple;
	bh=ZaVdO040slsBId4RkraBzGCGFkF7MdqV40Y4He+nk90=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=bhNir+ECrxyrcEZqSUZgDypWWoil7IGofAEqcuM2gW99amGvyzZIFRzLWFwL2qcVzqsDpsont9OZWZGFQVa0FVGLffXUl3T6Vuc7Aais+M3qlART82uVXqEQXF36Hu8son2AJe3Io0G546/DO14av6oor9hisBrLYc95nOmJBTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IVTdfQyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IVTdfQyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2810C4CEC5;
	Sun, 29 Sep 2024 17:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727629485;
	bh=ZaVdO040slsBId4RkraBzGCGFkF7MdqV40Y4He+nk90=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=IVTdfQyyo0zcoyZBcshmwN+WsfirHa149C3Kcb7V/cb8HSLbfQTwC8bOYpCbXubUG
	 EM3ez+Fl+pEkwMK3WnqU0/obNBhC/paDNRwq95fmpIuTfxl8StoARv/IwLb/1+BhJT
	 w0utdY5AHjZN2SF+y2n45qc6LHmV4YeANfRzwakGbAZlkw7hDdd63Y5qUqq+zoH81A
	 9hA4J53UIAsPOlwukGMWVsLifB88n+lkgRgN2nqWSW6eV3Ve+reBLk61t78mQ7EWYP
	 iZLBjqv3GRqdY8ApRdlXzTmdfV+PPAvYbm75amQQSyGIfz4ca7R4GRhkfvt0APyUC7
	 c2AQrjONU7k0g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id DFFD53809A80;
	Sun, 29 Sep 2024 17:04:49 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI final updates for the 6.11+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <0ea39075394be14ba8c809daa308a16d9330c639.camel@HansenPartnership.com>
References: <0ea39075394be14ba8c809daa308a16d9330c639.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <0ea39075394be14ba8c809daa308a16d9330c639.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 359aeb86480da0cba043a79c87a65806f158e931
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3ed7df085225ea8736b80d1e1a247a40d91281c8
Message-Id: <172762948868.2558104.7388188513460526612.pr-tracker-bot@kernel.org>
Date: Sun, 29 Sep 2024 17:04:48 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 28 Sep 2024 18:08:45 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3ed7df085225ea8736b80d1e1a247a40d91281c8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
