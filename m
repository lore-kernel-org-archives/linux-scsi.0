Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102CE1E3DE8;
	Fri, 30 May 2025 05:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748582666; cv=none; b=ooc5g6d/FcWBSMIc18sX20WXUy/d1JS8v7slFCutKxpOXN7ey/Y/UVnvcgKQqpGFuvYB5TPIB3q0qsDgdKOz9bjoRx7Z8IgYQjdzHk4DFNwlofwqf4MKzQNtkybtp5swDU+9cky4JQGcxSIiPOqlZ0b9YdEO03xYd6PXem+LlHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748582666; c=relaxed/simple;
	bh=cSxXqu0nPAJXe1SrSdjshtvXHNTLmKXOjJ18BB1sqP8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Vyypo0FO/02Q0bicE1AjSBI9RQIOJ2CTu0L42WFCb7XvRvMBxSI15qZX7jSnQ3We7JNIwYuJE+RZSyn7yAHljsAJuXS/7hXSqC31cgd9laKjkm2z9rf/uVjmcuatxcwTtdKDsISvn/w8Cd9nO4S8ellOZu6wkBNVyH6500JMWSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kdYx89NA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kdYx89NA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D965EC4CEEF;
	Fri, 30 May 2025 05:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748582665;
	bh=cSxXqu0nPAJXe1SrSdjshtvXHNTLmKXOjJ18BB1sqP8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kdYx89NARfGgfnQdFIvgCL5C/ypyqFajB9Bxdyd1TBJdZN5NaRf1V8dO/nEOlubwT
	 JlAhGGEOUorWXWsvlDrdWkYFLkETF2N2zai5OBdYJxIna3YYQx34BMEOdH7zCM1HOp
	 5V8PncIl8RHX7kBFnaSnBX5ZcgOyuc1qIgjAb6cVNdSL+vsmaBXsPY3SZTMRfF7AEZ
	 ZhEOrZtxYPMQQ/q+5tJTYpw0uhr0uEV9gTTD+rNk2rOOtKc5CnDw39Hx24b1fzl/gM
	 HSVL4sfhIECHgT7+EZ2jI4cc6qh8RewtGUh1IwIuUFEY1CjjLOuC1/QNrlGNWSDIY3
	 NcH9oGztH88qA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE2DA39F1DEE;
	Fri, 30 May 2025 05:25:00 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI updates for the 6.14+ merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <a68bfa4b6e75c8bfa2cb847d0b4867f44f9b8109.camel@HansenPartnership.com>
References: <a68bfa4b6e75c8bfa2cb847d0b4867f44f9b8109.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <a68bfa4b6e75c8bfa2cb847d0b4867f44f9b8109.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: fd2963e729ed69ced422c230a3f70fa6d5a5ce25
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f66bc387efbee59978e076ce9bf123ac353b389c
Message-Id: <174858269928.3833287.8406966347256308279.pr-tracker-bot@kernel.org>
Date: Fri, 30 May 2025 05:24:59 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 29 May 2025 13:50:39 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f66bc387efbee59978e076ce9bf123ac353b389c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
