Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104808;
	b=fMTI+edMAx914xTGTFLPpP/wsgayOdSIoKdF9E+BKWiSeH8eEzbAeBVT35YwDK+/iBUs
	 ILeosV+fAuRtS5IvpwRu/By57hr9GK5DJ9UXVsy7kxND89FvSBufYAdUUiGQbfpuK3Tcf
	 5r8PvU4MV1Gj2knjIEre+WKSgNMEZOYF3/lUbmFeDqJ0clBti8EJZdYZtZtxdjOE9mhqx
	 JKn+vpOEPMeJJmXHSuxwE8vjL5Ye06gffP90JmYmB6cOhRZGLgpw++dnF26hDFZpU8fuC
	 yBS6V0lethRs05Kc5yC9xlwNpDliaVo8cSG+TmQ20bkWn7phPHSJtJ8xo3++n6ZTAWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104808;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=wPfw2ysx7MVLBt0SdMQBGMy/H+g7CmnbPxUvxe6bXUM=;
	b=vf/7/fSv3Eer6utGH+gV96nDRLO8/BuJvpUdY0oMbbwhWKVzByOmuLFG3s6k3qBVaVd8
	 Cp69LqlkQuqy+f7MGT2puAIzs52XJHytRZGQoXbblNUPmPi0yz7k/6LAJu7IG27TLMvtB
	 bCJq5YE2x9ZYfEMCapB6yPpqC7IIleA6oSJhcrZnjvvR2BNOiY+gKxO6dPauaBfMG+gyZ
	 z28pAU0hcXldV/ZSRTdRIla+tuj9KaGmDJwJOAUCfJbK9Uxts0qkZ0QGyfyoN/5d0LCjl
	 AT0SmPjPx4LGXLV2PqTf6zQTnO8mf/jFewFfG76mG2zLxzSwGVMMIemp8dbxu60xReg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KRfeY0DX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2FC606A330;
	Thu, 19 Nov 2026 16:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KRfeY0DX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C631F000C7;
	Thu, 19 Nov 2026 16:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104808;
	bh=wPfw2ysx7MVLBt0SdMQBGMy/H+g7CmnbPxUvxe6bXUM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=KRfeY0DXKz8z1m/WOF/p5E+0axc55SfNPfKa1TnBWNRGeymknH0lsjIqi4usxoO+W
	 hvFp/xDsEzz1Equ0BzpL5VDFQCvSim+88v9GoaP7PhAYSivOApQ47QcYi0/3y6Oy5E
	 PmYJPjKPB25CtxsOpjpiWaEegilnnhrtoXab7HCqZesaxf2dz0d6yAFmk1E0iUyANJ
	 UafCiGlD7GKMbeWwJ7j+bj8lb1xoq77taNOJrKcT6etrMm8aJeD5gt3cDAFkow4JK5
	 aSN61b0V4FC37/sM3IWVvxw3HjAKVVk3Ge6dh0Tu+OP1uy2ccnqRu7z77FS9a9nZtg
	 pBBP8E6XzjstQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F21803808210;
	Thu, 19 Nov 2026 16:13:27 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.4-rc3+
From: pr-tracker-bot@kernel.org
In-Reply-To: <6a9f642705eb17beabdeb7388136e28729da6bfb.camel@HansenPartnership.com>
References: <6a9f642705eb17beabdeb7388136e28729da6bfb.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <6a9f642705eb17beabdeb7388136e28729da6bfb.camel@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes
X-PR-Tracked-Commit-Id: e550f2b2b4aab4c5f12db89d04d8978ce4ed7b4e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 27e694b84eca6c7fa0878662764567a3cc396fc2
Message-Id: <179510480642.3187685.13130830298859918762.pr-tracker-bot@kernel.org>
Date: Thu, 19 Nov 2026 16:13:26 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Wed, 18 Nov 2026 12:03:37 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/27e694b84eca6c7fa0878662764567a3cc396fc2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
