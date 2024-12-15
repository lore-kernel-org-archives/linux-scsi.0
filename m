Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77C0C8CE;
	Sun, 15 Dec 2024 00:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734224053; cv=none; b=XlvukFvtATSE8kHGTwNQi7Oog60nTdLnF+WSXUAhFj9oTnpnu4AzJEDYRL0agr7VqyepL9lntkBZW+X+R08EOYpVAoLaLVxowtRXseeulQjolLJwlEJ/++e6PyS4bNQGe8/8iTsVpDkxXkGk1Ld3iSIriuXo0w9ET/52L8R+0sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734224053; c=relaxed/simple;
	bh=fQ7fyIiCvqRBnS9dD3O0cMYTdMkV8mPuYqd5RZlaUHs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Uf0P/rUztptCxDo5oI+1Dx74RxOzY8hclguqOEVhIo1BG1kWt9XvtxmxAC3lSG1oOkNQ32cgwUaqCq2A2/pX4+APd/Lx9+QA9HntniXm3uaynoaNGTKOuIr57HCfisUNwPw4/D31e6BpxUvJ+hHCdS2D8cqcY+Bath/2E4+eAUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehm82Brh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehm82Brh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DCBC4CEDE;
	Sun, 15 Dec 2024 00:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734224053;
	bh=fQ7fyIiCvqRBnS9dD3O0cMYTdMkV8mPuYqd5RZlaUHs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ehm82BrhRarDttsXs2RY4mVJTEVKh1iI9mbCoiR+2GcMZvvz2K4XCH9vbNAWm70WA
	 XlyyjQfzVTpPhWL2aUHhbVBFiw9wVtGHMd9A67gAplscpALnJRNyPKK8iddY05kEmt
	 LPJPclntMpddMC4ei9y1x6/jfS1Rb7KAuaw8ohfiaUoylidOko4ASJqGmWO94P1Qij
	 zCAsBIc2hnmWyaLvUEgY0dJv6aHqj4n8qtm68r31qwn/Q4z3kIwuiydBchF4mHssW7
	 lNcPsUx02l7ObzVFmWWkRR3PtUsHESfnws14pfduITb9sjLzb9fAUQXoVPAnRRgeNQ
	 Ov89hUIATqw7g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70CD2380A959;
	Sun, 15 Dec 2024 00:54:31 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.13-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <395d805645f141b15ef818dadf39c8689986e8b4.camel@HansenPartnership.com>
References: <395d805645f141b15ef818dadf39c8689986e8b4.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <395d805645f141b15ef818dadf39c8689986e8b4.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: f103396ae31851d00b561ff9f8a32a441953ff8b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2d8308bf5b67dff50262d8a9260a50113b3628c6
Message-Id: <173422406995.3425667.13785335161823338952.pr-tracker-bot@kernel.org>
Date: Sun, 15 Dec 2024 00:54:29 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 14 Dec 2024 18:08:14 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2d8308bf5b67dff50262d8a9260a50113b3628c6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
