Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA3C262A6;
	Sat, 28 Mar 2026 03:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774667931; cv=none; b=IBZYfKrM3S+XA3O53/JHOSWzYxRpgCjmzJvLtybqxxcGFGkB3fmu8eU3iONhLsuNjfFGphTsB7o+aH30/3MG6/XEHXesJ9V5aLZ1TUE5pV0eKwprSctVKgKH4w/C/Q/DwJJD1dQ1+5Ei9n5BhhiIYRR23CautPrHsAzjuMCqndg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774667931; c=relaxed/simple;
	bh=LOLVC1pl4rCVBIXhJI9xHi0v33IJ/fPjpoAQ2kGsqJ0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=g7skCUfjEINgIuZfV0zgWM8jGZqDsnKiWk0nAds/fwqsUjUB/OPfbyAFd8dJjNxquN7Q6uNihLm/HLZ/iDlcEoaiINQR5ttSx7TDuL2D+P1Tcah/NAULMOJdE1GwY4fVDA1dSQ2snSix06BUxQiVCQ/Sw17+prD99YiB13eEP7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OgNUv+Jz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OgNUv+Jz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22459C19423;
	Sat, 28 Mar 2026 03:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774667931;
	bh=LOLVC1pl4rCVBIXhJI9xHi0v33IJ/fPjpoAQ2kGsqJ0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OgNUv+JzpmMoy2aDh5DXHZ659rbOofqMu/bAxmCWqN9X7htjIzypQY5MoRTIVhLyu
	 kwmMPz7Un/bbYPIlWWs/bQo7T4TmRsMNTA7WGJq8GOYzYwrJAQdmzcSl5S+1Xg2IRt
	 50WMfrxVL7mIeALWLZcGqqjzuGc0h30rGmzDW+HDs429P9J4SDZqJMHHFPKxZpM1x7
	 9Ijsk5leIlxgJKcb615UtiUB03dnCZSfilk6ny5JFVjWyPbSBr3GYTt2v/PI2q79HQ
	 JQQc4FiZv/Ob+uuM6BTspHgxmTJUYZzlkkWdMulDQ0TE6mIid2vSSjVVMY/gouANTW
	 VU2MQhQTtixzQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 030803930181;
	Sat, 28 Mar 2026 03:18:38 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.0-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <aceb9bcca40ae22ae78cad6a4847bc3ecf6b8bd4.camel@HansenPartnership.com>
References: <aceb9bcca40ae22ae78cad6a4847bc3ecf6b8bd4.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <aceb9bcca40ae22ae78cad6a4847bc3ecf6b8bd4.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 01f784fc9d0ab2a6dac45ee443620e517cb2a19b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: afb54c14047780b97719e8b6e4ea11a0cecc2739
Message-Id: <177466791665.4164734.5228543964298034525.pr-tracker-bot@kernel.org>
Date: Sat, 28 Mar 2026 03:18:36 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 27 Mar 2026 18:18:30 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/afb54c14047780b97719e8b6e4ea11a0cecc2739

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
