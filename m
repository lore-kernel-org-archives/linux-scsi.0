Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AE54B7162;
	Sat,  5 Sep 2026 16:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788626245; cv=none; b=dNs8qryuIf86dFXxBAUqfmkhfpWogY8iJBRd/ynuNO5WAKdvxwnjtL5aw+Z7STwHo5IBF95V63Uwiio4Ntz1qTByksGe1B39bG22JNWr1VdtACICqaeXk26MGjiUWWBVmpUuWpMC+i7k176cRIAXzUBgKFFrm9p5BxAeD3P7NYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788626245; c=relaxed/simple;
	bh=5GMh+LBQ2fLBeXzup/UpQxL24wxAW16KS9EuaNiPOSo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=eWSrp+YMSilSogkfC+YKaVeof8HmAzdtZFZQFG+vYOGiKzOfYTmFqrV7XtoPNAI7iHqW0+NBcTl6DlbRCVuRGLdtm4gRtZ81JtckmhwSrkPbRMTqwJHDRH8r+zBKy4kaM/4idJ3WbPESjynplcB4UkbHLaqky/ZY/hnGrR2qqRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dl0pEX+L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dl0pEX+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDEA1F00A3D;
	Sat,  5 Sep 2026 16:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788626243;
	bh=/FiX74/4vIerYdQ9s1DnRO5j0kDtuxSbLFMhQ+pqIXo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Dl0pEX+LJqDcac+1j02dtjcUeV2ymyZ6WsrrFDsBYsPq/EQqdn6O00trnJ7Z6uBpj
	 GkPlh8lArHhoXqu1xMOtbKa4sOniyoVSvcTQOiGDtZihSGzv2nWhfN9RUOYfgq/hk7
	 PPNWnc/zb5jy4zSAeIIQqkV0aS92Nnvij8XHFfGgcP5yL9PIDyLBRMZc2Nf7OCztBa
	 Hb/+PbU9hwWv0A3W3Ff17/ZtT0H7d3XsQtgySJRXJRRTSArJ3YECUqdIwAUHkzZV5e
	 c3P/ijTE5PPNrJrYi/JZaSWxfFIIqTnY3HCkLjR9HvZeJJ0u+/ZPpLYWAFe1CoOTq7
	 5ZFzXvY9RWsdA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A2B3924FDA;
	Sat,  5 Sep 2026 16:36:24 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.3-rc1+
From: pr-tracker-bot@kernel.org
In-Reply-To: <d7c2465525ad601d8569fa7219a8add38bf4aa26.camel@HansenPartnership.com>
References: <d7c2465525ad601d8569fa7219a8add38bf4aa26.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <d7c2465525ad601d8569fa7219a8add38bf4aa26.camel@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes
X-PR-Tracked-Commit-Id: af8c27375733fb6a6df9fa484cda77cc3dd0cb80
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0d9ff90a5422cc7509258aaaba1e7481df4d332a
Message-Id: <178862618344.1285306.14448293748877284416.pr-tracker-bot@kernel.org>
Date: Sat, 05 Sep 2026 16:36:23 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 05 Sep 2026 12:17:35 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0d9ff90a5422cc7509258aaaba1e7481df4d332a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
