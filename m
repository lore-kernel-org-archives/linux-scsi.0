Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFB712B64;
	Sat,  3 Aug 2024 22:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722724838; cv=none; b=O2Z1b+lS9NJWkMkTw2i/HqbVoqhFqvup635FuSq/bSitBUiD9eY5hkO4ZruN/Fu9CKvKHLGc3IrPsaxA4o7czhZxByCAK2utYRKFqGYSyk6YmMh1xT4pJlxzrnZV0Gj1v3PEmZGFxlmwMImVqmDvCvNy5D9jZx48JZrz/arswCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722724838; c=relaxed/simple;
	bh=ITlC9+cGpkanlxMTZtGk7/kzpYFhresN69une7fdEzY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=qwR774CYGMgFXrH5u36dCgd8UJ9BeDfWamrykNAAf8fecdvs5qtxfnxhOigFrn38zBdmymPT4zf+5aX2WXITZp+iclw/QB1DeqAb1yoiPUgE/+MXiOS2ZZTZ/6j2vx8Dk1fg5O+/aZQlDe1A0eOSkRPVxSwhvvKv0GEvm4dOibs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I3lf3+Vp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I3lf3+Vp"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4B73C116B1;
	Sat,  3 Aug 2024 22:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722724837;
	bh=ITlC9+cGpkanlxMTZtGk7/kzpYFhresN69une7fdEzY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=I3lf3+VpRcv+mYYRULbkzYvXEbSZpF2xpuR4PCRwp2gbHgK1ELQm3CFxPpzM/DVTu
	 P4kmk0X3Dx2IK4KXm0YaSF8aWFvXzTty02n4KS/+vto3D6OVCC6/Qm0+G+gPfyAMMx
	 GwRL6aJD2xCaE+KPeDmrsANduVfjIPYqDfcnt4jd7VRfFjCR1jtdJuG1bwX01xxiMT
	 T/3lcucknPIZpnfDvUOQTt2o2XHUBSF0nKmKdsl6nK3zhUft1klwPfCZIvpLqdB5fc
	 FjKq5EKON8tycTeDKZN51Q6HS9v2kbRNzs48ltOo1J5i52ZceuOfeCFjVoIfI268KR
	 L+7OxePfrti7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9C86EC4332C;
	Sat,  3 Aug 2024 22:40:37 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.11-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <dbfc2aaa8122fe748480f53ab79c0a9efe196ebe.camel@HansenPartnership.com>
References: <dbfc2aaa8122fe748480f53ab79c0a9efe196ebe.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <dbfc2aaa8122fe748480f53ab79c0a9efe196ebe.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 7c632fc3ce64c05bae4addbdfa174f98d0431ca4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: defaf1a2113a22b00dfa1abc0fd2014820eaf065
Message-Id: <172272483758.30345.5833047014221521054.pr-tracker-bot@kernel.org>
Date: Sat, 03 Aug 2024 22:40:37 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 03 Aug 2024 17:46:50 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/defaf1a2113a22b00dfa1abc0fd2014820eaf065

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
