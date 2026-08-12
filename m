Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA63471CF8;
	Wed, 12 Aug 2026 15:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786548736; cv=none; b=GR3O5LV5TJmhJi/lyuIabqTinITfCZ3p0KNADS101IPvyGh8sWSsqNqu+YRkDElIBw8wJ6Va+u0zURKpdjD+RZs9s2/CVJnh2zdg2OuEjax4nJ9gqjmnxiC7IVrOCt3cwSYsiDXJ9XkKb0QV6MQRWn2a/YhLwJjwqUuoegmvRJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786548736; c=relaxed/simple;
	bh=8rG+WW6Y3bSx5Bz9rDpwk6BoX4uhhkZMkGDppF/vTsc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Tg1u3+5JQQjBxuFrOHXBVhqZnaFfkajMDCW4BVEQhZz27SCs2/9SjIZgWIa6/Crx6RWwoOe0CChFlW3xuHCp5GYR3PsRmqjQhJ/aW1SMS+BrRptd3/vrbxag0ZkNh/qjRZRWGvZ2n6pN42S3O2N/YKjqhEHrIsrrsddPMfrqh40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hucG2Bwq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hucG2Bwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DA31F00A3D;
	Wed, 12 Aug 2026 15:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786548724;
	bh=b4KlninwR4CAR7b8Fed1mCjcdvZiLZp7fyX1ITRiYNs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=hucG2BwqZWA1n241GBWvRWn4INIkHSqdILkLAJhNRN/KkSnD2WJaxOJJmDgnYMa6g
	 jcuAzlDwQFpHMGyEJ4vvNUie2pzN1LnHhl4AcCqI0cxXA+FGMCrPHDHmnQY90sQ3S7
	 DFa9P0HC/YwOkAlnpJwszf2EVJd0TcFopfn9CpsWjXMujgImF4hiw27YaImKrTRVIo
	 DiLWTuVzBTVH211L7WIXjMAX+NIEFc0QqKgycK+JTzCMSRONu+HRU/vAGRA2hcRx+k
	 zwgjnvxaztLVasCdaJGmSrfnjaqTIOamG3fF5+L7eVonUtET911+ZfHB4+NJMxw5Vx
	 MTBYOhU96Xf5g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93BBD380AA67;
	Wed, 12 Aug 2026 15:31:21 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.2-rc7+
From: pr-tracker-bot@kernel.org
In-Reply-To: <b1267cecf372f9f8f8472bfc8eaff8290803b5c9.camel@HansenPartnership.com>
References: <b1267cecf372f9f8f8472bfc8eaff8290803b5c9.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <b1267cecf372f9f8f8472bfc8eaff8290803b5c9.camel@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes
X-PR-Tracked-Commit-Id: c4f6916a99cf105c3ff340b6210fcbba3fa66b35
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3d6d817622b0a9721e3cc404df3469171582be13
Message-Id: <178654868022.1537055.12863477059097753565.pr-tracker-bot@kernel.org>
Date: Wed, 12 Aug 2026 15:31:20 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 12 Aug 2026 13:27:31 +0100:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3d6d817622b0a9721e3cc404df3469171582be13

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
