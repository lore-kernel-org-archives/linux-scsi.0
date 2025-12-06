Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41798A59;
	Sat,  6 Dec 2025 04:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764994891; cv=none; b=r0KgJ8U/Wu/JK3YwXXoQ+U2RRGUtN/GK92CzQ6W+hJCDg5cJ1ZvbYX1CtUZ3Vi3ncSwriJgv6TPAYkI5G5dOAmMCLppji9+VCsktDpmebxTjLVCQprSE9MwsJyoypg/MLEy9LaFiS6YquA7Xli/O4/E+yjnrbiU7XFZJeAxAuPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764994891; c=relaxed/simple;
	bh=/0O0vg/2Wko0Ily/m21gxnqz/1rVD2z9bNmmYlurqjU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Apa4MwVvfpEwe5IknDoKxgavbzCx68ZVKSVnslSbgAVEsm1l4fmv66U4qKnpIQeklEaAwWVw/gK6gydzGtf5jtR8+GA7T1fBWmubF+xLLXZzuc+10qC29wwtI3HPrcuieQUHCE6UdYzzDjJ5UiRDHFWHLD0hgNovqECdkjOSRpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ow6qvoeS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ow6qvoeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DB7C4CEF5;
	Sat,  6 Dec 2025 04:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764994891;
	bh=/0O0vg/2Wko0Ily/m21gxnqz/1rVD2z9bNmmYlurqjU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Ow6qvoeSeoDNAq9xcWdxt7L8+8n88WdDTs+WAKlfbkklacWzHTMXrJZ60HKd1veYY
	 FuEdGpZq4fVfSfuyIzf0N0EBSbe20gPgsZJfEU4ZPOTILUKdtCi39Va8LnJFMWp69c
	 vo1yTvg/ChY9WvuCBh0IDk75SxlNmDgPaNl5r+ASD9QeTww4qIbDxaLE6y1tdzhEdg
	 UP+94cOrI8yttHfqXaHMv8WDmyUHoZ/j7QRYRWkfQ1hfvin9tr+K53ibIPa3/Ybobz
	 OKYshwZegoCWD0ScySToNAfLSWF1yD1Kadfb4NHHdshzQTTuK4yzSWCo4QhaFLJgDg
	 S9W9aVZ8CCo8Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B622B3808200;
	Sat,  6 Dec 2025 04:18:29 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI updates for the 6.18+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <2a61116be868f8cc576deed89455534860200a2a.camel@HansenPartnership.com>
References: <2a61116be868f8cc576deed89455534860200a2a.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <2a61116be868f8cc576deed89455534860200a2a.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 82f78acd5a9270370ef4aa3f032ede25f3dc91ee
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7eb7f5723df50a7d5564aa609e4c147f669a5cb4
Message-Id: <176499470820.1976223.6668830249437511870.pr-tracker-bot@kernel.org>
Date: Sat, 06 Dec 2025 04:18:28 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 04 Dec 2025 23:36:56 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7eb7f5723df50a7d5564aa609e4c147f669a5cb4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
