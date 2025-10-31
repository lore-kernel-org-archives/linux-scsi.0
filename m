Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCD6288510;
	Fri, 31 Oct 2025 14:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761922202; cv=none; b=Noyt9c+vcW1MR4gIYN4zI7yFV9IvDlL9H/2dbj6P58Nz9p8sxVWr5Kll320v5OZsbRQ7D6WQTeusdRnWvUm7jH2zyV3Fnay2g3ac1dJZmyWuAOIsFOE4fDCtFvqhpmg8SqNVBL6dN/34Ryd9nuGRimDy2WlbPPTF8SiEE61LbW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761922202; c=relaxed/simple;
	bh=iEqmgCDfOHLM1DKy3TJhmzMGjwjM34dui/kqsc4abYo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Z4EzwbOvxGena1WpLK5wXNyJ2oDpAzPBMBd09kr3Ff7PV0gHzqnQTLT6AgxUXGsnHQFGLZTIdhYEcnvnslkjWBknK69HWO9lWHYvdiM0fZlGmjNaDJU/SPs69bLtkY8750Ufmxz2jdSVwDBnGDt6PyfSjRQcCUYspaF2h3HW6Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TyJlaUVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TyJlaUVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E25C4CEE7;
	Fri, 31 Oct 2025 14:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761922201;
	bh=iEqmgCDfOHLM1DKy3TJhmzMGjwjM34dui/kqsc4abYo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=TyJlaUVKeaff0taxDxx72MNrRhmv5ij3/y0XiOOHtV+MMgc+uhwzSFKhXM3JkMINL
	 hoj9gMTxbtNxB1b4ZUGlatzzulfD2696jgLAMJOuEBW37Ajj9SoA4P9tHKYqDQ41O3
	 PX38gD9lOTra4SE8G148TzVvEqwWY6p3x4y0tUoLJuUJa9gOd6VF9ynR1T+ASfdMZz
	 i8o5CBKlfxRKY2FIppadW+KsixmI5Z9qBrjB8psMgDIPlyV2xO1bUa497YDgxVHMMk
	 NzfA3EMrXmS/nITr0y62DSGEXU+jH7nZYDyb1NbVEzmbZDsPpgvJ88x2RxMAAUjm6O
	 GEE7hke76KMOQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33CEE3A82560;
	Fri, 31 Oct 2025 14:49:39 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.18-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <d12222598438fd76ffa4cc797735f6fcc249553b.camel@HansenPartnership.com>
References: <d12222598438fd76ffa4cc797735f6fcc249553b.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <d12222598438fd76ffa4cc797735f6fcc249553b.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: d54c676d4fe0543d1642ab7a68ffdd31e8639a5d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2d51cb1792c7b1d8d5daf55cc3eecf19ddc4500c
Message-Id: <176192217770.504982.12499804776908046465.pr-tracker-bot@kernel.org>
Date: Fri, 31 Oct 2025 14:49:37 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 30 Oct 2025 22:53:17 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2d51cb1792c7b1d8d5daf55cc3eecf19ddc4500c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
