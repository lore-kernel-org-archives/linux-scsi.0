Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B2859B40
	for <linux-scsi@vger.kernel.org>; Fri,  1 Dec 2023 21:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsmFbN92"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87028C433C7;
	Fri,  1 Dec 2023 21:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701467392;
	bh=qmbsoxcxIJIlk3h1E7uwFaBTfx8Io3d31jXx4Y/j29w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lsmFbN92YOkwTYmuEds0N23azn4FYyF6+BY7ClrM/4sGX+6InebqT1zFiaT/5VWig
	 JRP9NOQRKwcGr0rQwL9DlnD4K6RcCsonmpP1kS8D6w7Oz40+Mb8IFuJMG2xsVKeBkP
	 N4vV89Mvt16qnNX6PLrWzA7i+WW2hrTsLjFE0psIGCQHiejDf4B1BBpXoA5Avb+O9o
	 E5gaacUiNyxNcy12q4XaRvezd6c+pQ/e1vgpipt6W7KjeO8Z/k81IdYYZApEL2yyU9
	 Ww+PmpSvLMEsIKeEcdcqyV1LCufLazgsP6/4nsXR041LI0vi8oEatpVy6d1gIU2mz2
	 +Nfd/suHZIJQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71FC6C395DC;
	Fri,  1 Dec 2023 21:49:52 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.7-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <ba9a6adb96ce110b1a74c6161fa58415049d5ef6.camel@HansenPartnership.com>
References: <ba9a6adb96ce110b1a74c6161fa58415049d5ef6.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ba9a6adb96ce110b1a74c6161fa58415049d5ef6.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: b09d7f8fd50f6e93cbadd8d27fde178f745b42a1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ff4a9f49054a9cc5ae733155398d2aff2ef90836
Message-Id: <170146739246.2332.1556898783145456659.pr-tracker-bot@kernel.org>
Date: Fri, 01 Dec 2023 21:49:52 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 30 Nov 2023 15:28:27 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ff4a9f49054a9cc5ae733155398d2aff2ef90836

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
