Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F167842668B;
	Sun, 18 Oct 2026 19:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792351372; cv=none; b=cnVGXwu1fXnO2L9NXcmZUch5KV9F1ma8QlLRtoP/u8Yj6WvktH6h+iixsz4RkbGYJ2NM+zIxC7duA6XLWeuQ6Oh+o/h9FCIarNQQCUa/VBAyHDd5A/fSPpgWf/03SKK3cEg1e3E53yp17ZBqdv9Zmb5AdNdPtdlwI0kmUm/TXhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792351372; c=relaxed/simple;
	bh=hpVdL1TBiVXEIL0FEecGyp0WQJvGGHZNKbQ6wQJ3MPw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=QyuaYdBqawN9RCtNruFiPYBWIaUwoxnNzLaLB6N9ZrA+z18yCx9IYEewoVG7aV1qyuk6Zoa6RWylqOUyG7yQ31QsFZoeqa/sy3R9J6bnjmhlx8Dbtk7JGN0DiQJEl+9WOWf61JBfbAIB1bHEO4dKjFM3iL8RicoKz7ducPHnj2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cVnU8Paj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cVnU8Paj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8249F1F000C4;
	Sun, 18 Oct 2026 19:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792351370;
	bh=C2uOwfh+mOVabixs0YsUfKdrckBkg5Ni8FH2SIlNRaI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=cVnU8PajB2H5q8LSz+uM8ci7iu0w3jUkQK4sgBHRRpVTsdyI3sujNqu5kD1t2iCPE
	 d2cpQ34fbJDNduP4V33yMbXEMWF+WIqhpqe6PBApfShG1lB181UVKHZjUR/EWLa47T
	 gJdgEkiqUrX8+RukORb+qwdLDMQzvjgpWdA12qEtegu2wBC3XgD9WkfiQocuzJQJcb
	 9DgI98V+s1JAoflsr5K58M1Ad01ahkzk55uLJxA1p16K5idldlzHQZdgUJk7+JrebE
	 FTI9jCVoER+HFHE2E9wXV8noL43qBv+YsCDhhzMaeUjKu3NnYXuftbScJTtrN7VVA1
	 9f74yC27NMUJw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 77569381196D;
	Sun, 18 Oct 2026 19:22:50 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.3-rc7+
From: pr-tracker-bot@kernel.org
In-Reply-To: <6a4bfcdc8e60669d95abb70bdaa07b87154c9a95.camel@HansenPartnership.com>
References: <6a4bfcdc8e60669d95abb70bdaa07b87154c9a95.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <6a4bfcdc8e60669d95abb70bdaa07b87154c9a95.camel@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes
X-PR-Tracked-Commit-Id: ec6b083915e8146e147314a5f4f1285d07b57bfc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f909e534f5e34feb2ea2701d54df63e21aa506fc
Message-Id: <179235136903.1791676.2735700775646816403.pr-tracker-bot@kernel.org>
Date: Sun, 18 Oct 2026 19:22:49 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 18 Oct 2026 10:38:55 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f909e534f5e34feb2ea2701d54df63e21aa506fc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
