Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0645A9443;
	Sun, 21 Jun 2026 17:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782063279; cv=none; b=o186MnQmIBi15X383t0wglF8cJZK6CK2q33RHY9+xzLigM60PNaCjU3sC5o5T8P7iDQfLolLE7j3E656Q22EUQpST7RkNLfacGIt2zmMuG3FSe72S22zGf88wdq2/gWUp5hqbx5Y7xrtkhyS41L6Up0HAoTViJmCzD0FHdChEh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782063279; c=relaxed/simple;
	bh=Ao7foHkRsbXHwIndWqZsFI9BAusKANGVWzoP68HYYbc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TIbZObEyKrYdYk/T+CkRgDrTUtpIw/SiDusJzzi2qGVxC+hZaNhtSri4A/fLZS39xj1HAz74P++Ev6/h0D7uCX8ZPZHsL+JllbavE2GU/ARjZXCggDkJm+JCHXxiBMAc8NK1AFzRbvhd0MVln3Xn1Fz1w3joVOE/c/KnJd1BU2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UG4aFQnO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UG4aFQnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7091F000E9;
	Sun, 21 Jun 2026 17:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782063278;
	bh=5qJzhn02LYsAw43dttRBH6uod8tebcnf5vFMi3OPEPk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=UG4aFQnOTDWellsSZTvRzj634bR6vaPAlVfU6IV0dKthwbwitllqN1gQAowR2reFu
	 vZhJuhUJHtc53BZMI8NtTPbIXmWSSGSrJem23dDYiXOXbmPj4zvGt+0Y97OPrAW1Ac
	 t1qd2RAbwE5yjVVlgMVraJLJA59DSw37ig9mZ/7bdrJkE5E9rjpbWjjUwcR872/TcZ
	 pJAfmPrNE27OJuciWfCpF9vr+KJF/qHrKosDDPQEc9ElF+cIDLr6gF7GTTrob3b1UN
	 vdnuiEjvvp+Q9OriSmJOwnrst7HB53Otdyn9W507xd4tZj3RFM6sh6M8Z1f0sKWMm6
	 lm14yF3aLEiXQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56B913AAA6E4;
	Sun, 21 Jun 2026 17:34:31 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI updates for the 7.1+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260621135133.12271-1-James.Bottomley@HansenPartnership.com>
References: <20260621135133.12271-1-James.Bottomley@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260621135133.12271-1-James.Bottomley@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-misc
X-PR-Tracked-Commit-Id: 4f87e9068bf3aaf45f226261d5efd50bec42c12c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8cd8cf7a07e5d141b0c75ce6cf470630e11aa11a
Message-Id: <178206326986.453872.7938642391593302042.pr-tracker-bot@kernel.org>
Date: Sun, 21 Jun 2026 17:34:29 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 21 Jun 2026 09:51:25 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8cd8cf7a07e5d141b0c75ce6cf470630e11aa11a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
