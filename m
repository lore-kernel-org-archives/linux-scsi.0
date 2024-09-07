Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9101667E1;
	Sat,  7 Sep 2024 18:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725734174; cv=none; b=Jc2vGJq7s8/A0gOOpp64IBxqX3IPhelJ67Yj9f9E8v9HkrrZVhD2W7gdqPu6RJTwDWkCqRbT7bzi+pyj5HXBQbNhQmotWbgT0tKkxNGh4JEZAwqtbtem45V8WokdkPGyD852ljRWia8Lj0nImZfRKt8tzhY7oGLpoN2O4Gw1gYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725734174; c=relaxed/simple;
	bh=LmR6GmYEEA0R7izZ0QG+Yt4MMF/b+dUHokt1BB9erNY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=XTf5r3/+gYRlksK2XKNi2cDjdgyTJoDOzz4uebEAPV07C5lU6vc8DEfQmdwQQb2JbWmRemGf+x+qVkNwp2XgSqv1xekzA353hcbE3l9/2s32ic+6YWDFtR1mYOw8vhYgGdYFk/gIPXg/rlQPncL10A4rINhua+NFvpCXsf+32cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XX3iqFrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XX3iqFrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAF1C4CEC2;
	Sat,  7 Sep 2024 18:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725734174;
	bh=LmR6GmYEEA0R7izZ0QG+Yt4MMF/b+dUHokt1BB9erNY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XX3iqFrsKymyzZpYQiVfvplbw4rnix71okE6bE4/7CmTQjX/FUZlebfDdpid4KGOL
	 PwKbbl5xF10Qj/D0n93ekmG+k5rbCYrtEa8cME0aV5NuINWVL48z9b0ABBpXq2r8UK
	 TyJ0P1/qvvuDLW5Yn1yVK7DkOJ8dCGRIlB6uqOhc/4OwUnFhiXHRMAAqGTGeNfdgk0
	 EqGoGR4bzu/rYkLjJGA/jVLiuDpMzXql8hiU7HmWFKz5IUmgRI8Ksm9VOdnqu21mgZ
	 ZpQOJ9trSi1PadpbK8kh3xt6SNbsBI460hpk5D6ZlDnFatPJLM+Yqh9YTPnuVQGtfs
	 gvXNDTigzqvVg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33BD53805D82;
	Sat,  7 Sep 2024 18:36:16 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.11-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <27f70daa7591cc513244457041cafae3e1949452.camel@HansenPartnership.com>
References: <27f70daa7591cc513244457041cafae3e1949452.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <27f70daa7591cc513244457041cafae3e1949452.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 0f9592ae26ffe044cfb2b2d071ccf4427be57ed4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 37d4cc69876f6ed981b54b07f0d07fc4d4bd9f13
Message-Id: <172573417479.2736849.11923689114351452658.pr-tracker-bot@kernel.org>
Date: Sat, 07 Sep 2024 18:36:14 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 07 Sep 2024 09:44:03 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/37d4cc69876f6ed981b54b07f0d07fc4d4bd9f13

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
