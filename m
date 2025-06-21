Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A3A156C69;
	Sat, 21 Jun 2025 05:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750484599; cv=none; b=F+50eGDVU/7xV9YdfdO/t22f4zlT6HfEch0KnAw/Wwuxqs6SnRuxADdPSg26zuhLv+mPXhtbxc+mpthCTp9sz1SU0iSCqaH4s3NSnG6UxNgS3xyAaZhcltlm4itdQm3Qg/T2jhXsZYTdgen0fIGgGFP7q3CmEgU3Zi0866CtYS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750484599; c=relaxed/simple;
	bh=0DSUaOiZhV8Q3IFG3XWVF0lo8NBkZ/059OdVf8qCP08=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=c87f7YTakcdHYdpmS/7AHl0N6Fae5HEoVzs3jwdZGrJGV8h0z16Eg1dQdL88khMaA5lhC0pOYMpth5cLXm35cz2LVUH5TM99/3uaMhTJkYLIJ/diCihfpcPMWqIC/ljv6IHL9i7V3kp8RBmi+HOP0s75sfP94+wsMwr4Wd3cQJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnqtPyw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnqtPyw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490F5C4CEE7;
	Sat, 21 Jun 2025 05:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750484599;
	bh=0DSUaOiZhV8Q3IFG3XWVF0lo8NBkZ/059OdVf8qCP08=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WnqtPyw5qZ9i1HFX3tAiN6H1oNExjFEnzFe1pIiq6MYGGw7JJ41xdHW6TqiG0hLXZ
	 zX4fW5Vk2pKdlS3+hsInvcd4IAlQnWi7mBMp5wOEoPnWg2kk3FEyMo4QNEIBcBp6gW
	 fybsRSc9qLmkApVGMDaHETMHtIsKhvHFNEy7KxKmtNOcrkgOFm/WVQ/KTAkz2qcUxE
	 PU6Plvn+CYj8xW+rwBIGWfVTx1bF2XhrMTSDKf4y6w6LRVOvpwC1rS/cljQZwskYiu
	 4OBo2h2yZYd4bFvtwqtdRtyxhi8XzjmIyhRP28g7aVfRleO0S12CnnS95JQZAIEATP
	 rnZ4xjq8h1TGQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D9838111DD;
	Sat, 21 Jun 2025 05:43:48 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.16-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <8b2ba4f9bf668716c583d8f5cc10e7f3bd7bd3a8.camel@HansenPartnership.com>
References: <8b2ba4f9bf668716c583d8f5cc10e7f3bd7bd3a8.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <8b2ba4f9bf668716c583d8f5cc10e7f3bd7bd3a8.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 2a8a5a5dd06eef580f9818567773fd75057cb875
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a765b9e6db4082eefe6e1581a9495518685e7abf
Message-Id: <175048462668.1793935.6594559570832609942.pr-tracker-bot@kernel.org>
Date: Sat, 21 Jun 2025 05:43:46 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 20 Jun 2025 09:46:59 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a765b9e6db4082eefe6e1581a9495518685e7abf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
