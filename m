Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1D320DD40;
	Fri,  8 Nov 2024 20:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731096355; cv=none; b=ZX2Ov+6H73xyuwYoLXmJ2qbbUBy6y0Wmej1kYZrK3GSz2jS+L9yuQ5HMXoQARGWLEfqWEtLaNuyt8a/CmXsDgVpvOHcbm6oSF70vQkSmvusZkP04gxxSkmnDPR71fCJkYPq7dd22L17WxHRHV6/ofaBWNH4iZJkcWeHhDUG18wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731096355; c=relaxed/simple;
	bh=rGCbvKEEaZR+5c9aobalBOHFPD0OJ9ipQ3V4pCtwJws=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=W6eJ/f9CTUdqp3vq1UHNtZHP+sotDxqJTTULjCatH7HXOU0RxcVWdobOUfMBZef8VMoQVw8s6IbCndn5lBuW/lXx+Kdn5IkBvVUTMScODbQYnWKqwIB/mMlQ4WS5mA+mkUFMHFpbHuPLN5rOKToGrX+3lZKpZ9qNvTYCYiYE6Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKRiStFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKRiStFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD20C4CED3;
	Fri,  8 Nov 2024 20:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731096354;
	bh=rGCbvKEEaZR+5c9aobalBOHFPD0OJ9ipQ3V4pCtwJws=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=dKRiStFJOu4u+AnKfCFseo0BXov7tgFSpwkzOnWsELCLr+oYyR29YucQTgtBY3ZTs
	 4qPt5hziW1wICopt8KuT2M2iyhl72sbsnI7AFlt7UBmWvCwt3jpdMlbTSBGurTs64+
	 GjwIkiIorDVhnjXxAPiqtUAFymHHF9S60WvUntQ0LBw7Gq+tP1BAsBnDrIiq1JU2d8
	 YMa5JwM3bcDiK3xUKbIqCdxicHmD8WMMMFTqviwCo0+hRlNvgRrVDm8PcagxgyOWKJ
	 vARz3/HPvYl35d0R+C1WXuNxdmxTydYWFyzGNbOVusW8gT6BHL5s7aeW9QlnZ0u1/9
	 ZLK3WTLpSUt3Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 715373809A80;
	Fri,  8 Nov 2024 20:06:05 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.12-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <d5a5c6467b9556633b8538f403202e800aeb3c82.camel@HansenPartnership.com>
References: <d5a5c6467b9556633b8538f403202e800aeb3c82.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <d5a5c6467b9556633b8538f403202e800aeb3c82.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 54c814c8b23bc7617be3d46abdb896937695dbfa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c291c9cfd76a8fb92ef3d66567e507009236ce90
Message-Id: <173109636396.2749259.16851192746803206073.pr-tracker-bot@kernel.org>
Date: Fri, 08 Nov 2024 20:06:03 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 08 Nov 2024 14:51:35 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c291c9cfd76a8fb92ef3d66567e507009236ce90

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
