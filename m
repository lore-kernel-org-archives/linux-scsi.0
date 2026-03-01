Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1538D28C87C;
	Sun,  1 Mar 2026 18:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772390052; cv=none; b=eP+QWYgt3zLUjba6fbYu1X7kVdspWLsifndRaIM/Xx152A+CCL+lQLm8QDFwKAtUxtm+5v2V4i6dWgQMFuMT5gJrnLnaBQcZQEQQ0afydfrTrSIWflZ6qf0/YkZF/tI+eE+q2liEfzjN5f4PlsFfOWKZ4G5ekra8mx6sQO1OHvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772390052; c=relaxed/simple;
	bh=EeGqZcxNPz4pgmlIvS9j8aCOt7gTX71mnun2gkJkKHc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JaBSS1jX3yZFIz/ePNOJ9BCi5Y7npRQac5TLzk54hAIzwzssEQc4xaaGnotsX46Oyx5uyT97ynSqzXRzjpc1+83oAQ2wrg8F+FBhLfk9Q0U8AyXCYHXtuEhxcqVmjm6+E9/MjjaZQJbqnUGza9Nyc3M4TSYMKMaJCykGNyUIvP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S9BiPSWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S9BiPSWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9964C116C6;
	Sun,  1 Mar 2026 18:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772390051;
	bh=EeGqZcxNPz4pgmlIvS9j8aCOt7gTX71mnun2gkJkKHc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=S9BiPSWxAbZFagFSqhhiccRQ8vc2m6V8QZQR9Rwoi0n1mmtQkC2Jxhs5fvyUham+u
	 LaHRgsW+7senAdtngdimv2qngH+W6HgqW4xsSBIZHc869mxb/77bi5YsUIAmxyLYUw
	 A4ddTOAGlms1zpXwY/bzrwL8taKAI2XP0yjQSU62uQ1VmFagFxb4lCfgG/KL9aShUB
	 zQrWBK6eTWyP/RioZuBMLGteSGZLgsi6h3VREq4oUyY+aZJNYHgs/xXeei6zT0wax8
	 XAQXv4hRFfaki5niEMcHFd5uLWWJoYAnTf3Ya+l8GQIFIz/s4Emfo/WFD4PpzbmZ4I
	 9I0cINvp8zYmg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D0FF39308C3;
	Sun,  1 Mar 2026 18:34:15 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.0-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <2cfc91dd26b621f5b3ba2968f326086c61fe4bf4.camel@HansenPartnership.com>
References: <2cfc91dd26b621f5b3ba2968f326086c61fe4bf4.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <2cfc91dd26b621f5b3ba2968f326086c61fe4bf4.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 2f38fd99c0004676d835ae96ac4f3b54edc02c82
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 39c633261414f12cb533a8b802ee57e2d2e3c482
Message-Id: <177239005402.3391874.735546121295153328.pr-tracker-bot@kernel.org>
Date: Sun, 01 Mar 2026 18:34:14 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 28 Feb 2026 23:26:00 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/39c633261414f12cb533a8b802ee57e2d2e3c482

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
