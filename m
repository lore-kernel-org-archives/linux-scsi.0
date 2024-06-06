Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E5113AA31;
	Thu,  6 Jun 2024 21:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717710457; cv=none; b=LIdoTiwVlVoauNpDaUAcv0+rLYxJrhuKz2gy4FLCiPm5IHpJmrowbzRjDV5e7g701/3k91qCMl91vKV93+MOJwtJsu4s7uctLP+qPKhJAhTqqa3IKlNBtZsP9kKebIqfXfMLyxL86A2Nflx08verfTzsX/FOPqoCFcfRPpZRZGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717710457; c=relaxed/simple;
	bh=4zIzx33sDkv7R/xxA8g1AIqLRslHINgKj7vaNorjoiI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ssl+DfRzOqUhmXyX3csyt6tgl0yI/ijd5qOhtQGdmWue6SGlkhIIxja0GCUV+HnmAyqrT7pJtw1WRFUMkkC56KLSMg8sMU6NF0d7muN8eKbm2z+UUPDWr4g0l9/MjLsM+AFYnMOvWeCSzoLi+pl04Hk/oYzrXsJhcbp4yGOia8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b9PPRtnf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b9PPRtnf"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9E0EC32786;
	Thu,  6 Jun 2024 21:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717710456;
	bh=4zIzx33sDkv7R/xxA8g1AIqLRslHINgKj7vaNorjoiI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=b9PPRtnf8ECEr+x/ibCIBqd01CbBTu6QtMbXUhXoUpwniZ1eIWfzy2wQu8bpWd2Pt
	 /WOvmCFcJNkYw4sUjTZ1zw2ZgiQiqb6JlfORG7CoE9aO3pPjM4Cz2DHwYohH3RokeG
	 eyqKfYXfXkcJtF6J3GWLRogdfkJN7gVLQ4ZXdcN3ZRHDR56HyZjfI/0j/Rv/b1PrT7
	 vBSDVFoqgHUMRMgCzfEvfuwF6YKGd2nUfh8jhFUtE3rcS1gq0w0zxmCEil7RAYdpoT
	 B3L5ZfRRXmJJyzMhdbVo2ViWHSyvaKFSi78ZHLbUt7ZSchCHUQ2Ow2Nby5kcMu3XbY
	 reex8DCxWV4kQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA846D2039E;
	Thu,  6 Jun 2024 21:47:36 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.10-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <f91727d00e7d2c0084c71022bb0884442fd1e13e.camel@HansenPartnership.com>
References: <f91727d00e7d2c0084c71022bb0884442fd1e13e.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <f91727d00e7d2c0084c71022bb0884442fd1e13e.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: d53b681ce9ca7db5ef4ecb8d2cf465ae4a031264
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8a92980606e3585d72d510a03b59906e96755b8a
Message-Id: <171771045682.14151.12228229203179950219.pr-tracker-bot@kernel.org>
Date: Thu, 06 Jun 2024 21:47:36 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 06 Jun 2024 15:03:50 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8a92980606e3585d72d510a03b59906e96755b8a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
