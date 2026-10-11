Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29180348C77;
	Sun, 11 Oct 2026 18:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791742685; cv=none; b=rVH4/AXVHROhZNj6mGty8OulqfZqeLx45l18hBqh5Gw12cpX73FPswjdMud34M/Epx76i1EjoLaneaOCmrrU8dUvs0MdASVh4ifyAA3DJfa0CzJscWWQ1AN5/dgYBL6A4hrbv4CKqWJlMqdfd2XpyTaQC/gpbIgFZ/R0KlOGl7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791742685; c=relaxed/simple;
	bh=DiRA+nzZGYXa3rDgfwac2EfgZS/6zvHSUOAR60DEF+k=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=OZuxEqORTrnK4gl0ix1NNGmjMsSXVMbNKvbMLEfFrxknDdXiu7YrcyiGXZQj2LDgGTqqKFGLpCFE1SnP88ZEeMQhWVg3jzbrjWELrbCDs2t4AK41dVevuiT/3mhS/5Np9LFHcNSRuzZo+KPX+ht6Uu3xb25Vxu2kMXvmdEIbbRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T8eLueUL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T8eLueUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C093D1F0089B;
	Sun, 11 Oct 2026 18:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791742683;
	bh=+vEDMzDToXhzEbBrLIrl//foeA1hvJb2rYAAwa0/Yg4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=T8eLueULy4M9j1w/VoPIQPaJoQ/AE5Ja4o6Qg65TR7DlMcJvgqyPY5j0KcsuokDFa
	 z87mZoKzWUf50Ur/YWGyxFsP8wBSaBCjowcMdS7UYVV/6BKrjNp90g9FM5RoOLTUva
	 lsipRy9SRQvelST+AQymV0LA7oqnL2En3vvOfy6XHDjWHNEWQDbapwkonrb33Yqd14
	 JeOYe0549Yp69GIMiESplboin1737HaNiiy8m/2ok3/ldugsuxzxB1qQ9slklJf19c
	 nZRLW2BLgHwhcG9cCjRqwiDt4+EM7eCLnX6oyRWH44UMDFP6NBiUg5+vR3hC7tdV5M
	 AxafiTTHeiV9g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B453338119D3;
	Sun, 11 Oct 2026 18:18:03 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.3-rc6+
From: pr-tracker-bot@kernel.org
In-Reply-To: <eab58e05da0087c70f5473874a549572a9ab0230.camel@HansenPartnership.com>
References: <eab58e05da0087c70f5473874a549572a9ab0230.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <eab58e05da0087c70f5473874a549572a9ab0230.camel@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes
X-PR-Tracked-Commit-Id: 469fa055664bfd8717b087a80d59c03055789c17
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d5b6dc381db93ff2d1888f7d99c06e0bd85f4083
Message-Id: <179174268245.2129915.5953531512027094879.pr-tracker-bot@kernel.org>
Date: Sun, 11 Oct 2026 18:18:02 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 11 Oct 2026 08:18:55 +0200:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d5b6dc381db93ff2d1888f7d99c06e0bd85f4083

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
