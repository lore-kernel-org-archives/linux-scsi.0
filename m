Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204EC50AC02;
	Fri, 25 Sep 2026 23:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790377632; cv=none; b=Ejo8gaNxrZyRuWsbds5YmseuSXiTvGppI6W9H6JlebTVKJjmvKPdRMHRHZwMXXwggiYFP99ifdZnbqkdSkGAxxx8cuZetjheb76/ErZD9sf0dfgN7rIBBtoZsxfF9q3GbFK9z1qon95hl5bVhOg20t+ch0yp6zOOaDyLgArg5EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790377632; c=relaxed/simple;
	bh=RnF7l85TN4GX3jv4GErhsAWEdcSe1//jx3QoLmBAEX8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=MHFaIGJF3IbmwSbZuOTxqOdAutVoQsSsqPcLc7a/DHOgTGo//SJBhCemc8iokuBTvKJg12iWmEn+KmP+zztcHpzBMU3/3abETJYmNGkIcnWesJ7OUJgexw2eG0/ZSVRbiw1kK8KNgmPpOu/TOeMjxtDSGjc00wuH06YAnjBtrUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Utex9vLM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Utex9vLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074A81F000FF;
	Fri, 25 Sep 2026 23:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790377631;
	bh=oozRJSWoP9r3tb5ttqp/8EaFSt0zb0MJIHHKFJicyWE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Utex9vLMLa0VC0/dUnxxWawHCt0n1pgPbTUmKs2v1g1qjlT4w4lQexi1way76wbzr
	 v5eQxIjDC3JsPqaLiz/ttPLv4GQQdy1AUlNiEBAOuDRGEMY+xpPJQYjUWLex2MfBy+
	 FGlv1P782MiFFMO8qPtw5/81ymmqDg42ligGePHKEFmdu7yFhN3oT5R6MJeGSOxyCY
	 WaPTQldcI8bWe4Y4loXHELbSYJ2gxxJXGzswXaxfm0zT3SJ19L28ZtxVIgqk0XtQbJ
	 4y/fRRUHHjsl2tVBz4QUVFDGVAjIAfDQH4QHxmE47sYGs94rkXSPXiARR3yQ33iAzv
	 lMOvDnaIJ3VYQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A29380820D;
	Fri, 25 Sep 2026 23:05:59 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 7.3-rc4+
From: pr-tracker-bot@kernel.org
In-Reply-To: <ea8f769b49f7d1185f588cf5b9202f300c280af7.camel@HansenPartnership.com>
References: <ea8f769b49f7d1185f588cf5b9202f300c280af7.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ea8f769b49f7d1185f588cf5b9202f300c280af7.camel@HansenPartnership.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes
X-PR-Tracked-Commit-Id: 42d1221d321e55afc7bba9109a77aaf5a817c8a3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 049380360ca6f4cc22ac2f67fe95b98967c887f0
Message-Id: <179037755845.3195274.18063974288286929571.pr-tracker-bot@kernel.org>
Date: Fri, 25 Sep 2026 23:05:58 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 25 Sep 2026 17:22:51 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/049380360ca6f4cc22ac2f67fe95b98967c887f0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
