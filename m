Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D3B37A486;
	Sun, 15 Mar 2026 20:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773607944; cv=none; b=Z78lpj6T1rMjt2FU/pDfsdfsJjb827f/uyJpDVdORwHTQBJaAVbTEyEz9i8ou87MisDraP+8owhm/353fWeB0qM3RODomKohBNOtlg6EoLZUpmGLnWmaQ3XZofwkgmnWdvpePwqDt3Mto43cfeb8/2C9HiS83V4tP9Xa9OwZn34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773607944; c=relaxed/simple;
	bh=0+LHqFEsJlI0SC0WSvE16s3nhIM4KlTVA/IE0QnZ16Q=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=H+AZCNT8BhNCqcj6PhgvjRk7w3sTUt7M9oCGmOPiz9TZ8rKJd+zPSHhcp2PI1reYPm+kx+k/PlWRLHpm48fZMGR+/g7tqCeKTRI18iFaz4V5SsJAmUlqC3g9jTIvj339so0rV45iAU+LCAhZ+36kE9Lwj0xz+UHUnoJ/9iRBHAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qTzJFCSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qTzJFCSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB15C4CEF7;
	Sun, 15 Mar 2026 20:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773607944;
	bh=0+LHqFEsJlI0SC0WSvE16s3nhIM4KlTVA/IE0QnZ16Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=qTzJFCSXLJT+oSRV4K23FX/NAYz5cBtTJTo3uqsQNzKLz2/5sbJLvIpxrQwvlpePr
	 Ln8iSOD5qs519W2e6sfNM8FSC3Nn5zK/zvUXVkxWRxkh29HP4TPE/YouIKJYNGMgf2
	 TJJYSYDTwUvPy3aKQIvqk3HnG9qKcD8XGb+CTR1GtECjHH2E/xc6x+keSZNro8gWwz
	 c1Q10t32dgICur+Q0Upj+NK5smxnURKq1V9rtLa6/pqottX8zqQvaKarwSDRqjg2sI
	 LwcTFZzw+v8oQ5S7/5cRyPLM2bXQssoMVZd67IExFl+FFrHQ+kVTDYTrXGWhiOo+sb
	 U6zSVBx8yGrdQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FEA53808200;
	Sun, 15 Mar 2026 20:52:19 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.0-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <d19caa57e2b04b16a3b4c6ba468a33e86c2c43dc.camel@HansenPartnership.com>
References: <d19caa57e2b04b16a3b4c6ba468a33e86c2c43dc.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <d19caa57e2b04b16a3b4c6ba468a33e86c2c43dc.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 8ddc0c26916574395447ebf4cff684314f6873a9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5c2fe8d11ae05411566f9d69321375ea686603d4
Message-Id: <177360793777.1993738.425058906895926119.pr-tracker-bot@kernel.org>
Date: Sun, 15 Mar 2026 20:52:17 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 15 Mar 2026 12:43:22 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5c2fe8d11ae05411566f9d69321375ea686603d4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
