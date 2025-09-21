Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0151D5CFB;
	Sun, 21 Sep 2025 02:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758423031; cv=none; b=APQgykQWq+E+HNSXOyPCzDTCxTxNQUSmqDfgbXq6yaljlFPT+oGx+oN5PbukLQ4rg0HHLvFIUVBYX6Qet2sLAPDWs7rDBBeiS37sj6o2gNcoDi5j21pzviXHZz5Xa8cUUXXpeGstg/wRybxp/r/4mKjIPvPQZ1xT9yZLOWfsiZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758423031; c=relaxed/simple;
	bh=gua0HnErH2SQS9FdlhnVHYsFDptGBAMoY3Q53DE8GPE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=I0zaSFcjh8GRTJ9pZwCuwBtXV0nQVgNpOG2WCxBXQ+JcUisRA4OuQh5eioeKFtgKN6TeUpdG+jYOsjz3+h6u30LJ1SR0pQEcStJHCke4dTJdJOoM8rfWdVk42/IVQ7Hy3t2rAAqHoqPwh1A62VIc6L9MdCqmzlQzaWH9wB4VeRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YscbDKNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YscbDKNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF07C4CEF9;
	Sun, 21 Sep 2025 02:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758423031;
	bh=gua0HnErH2SQS9FdlhnVHYsFDptGBAMoY3Q53DE8GPE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YscbDKNnlrMw88HPrw5DM72PlWLqN7VCBEkSlagAEPLb2H+EPa4koRVAJ8gU1mNvD
	 eOWkF1guEb/DkFVsl2sCtSrOu1HARFq3khbuUUirczAI9asqNrnlatIs8dKlqVlfPJ
	 AK34boQaVVLSkRjrngl/FWewKcbYyBI90FFPkfnQTiK/tbkrj7NtuN0nGuCZBHtDki
	 Y1/DazXI7NR7kFnLXaJ1u7En1a7dKM7rdHyO78aQuTZi0ETjJSQVFYQd6uuGievcSa
	 XnHHWffdMv/t6caxnRnsICMtN2wXdgwDoSN3Suao/fgrBhxlvaj5GNDiXippci8Nx4
	 ik79IIY6U064w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33DB739D0C20;
	Sun, 21 Sep 2025 02:50:31 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.17-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <27520049b10fc42830aedd9a5f4cd7adbbb9ac7e.camel@HansenPartnership.com>
References: <27520049b10fc42830aedd9a5f4cd7adbbb9ac7e.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <27520049b10fc42830aedd9a5f4cd7adbbb9ac7e.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 5cb782ff3c62c837e4984b6ae9f5d9a423cd5088
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fce24200cbddb5a333a157eecf0a8020c1d36d7c
Message-Id: <175842302975.4042380.15077589246474038497.pr-tracker-bot@kernel.org>
Date: Sun, 21 Sep 2025 02:50:29 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 20 Sep 2025 22:39:30 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fce24200cbddb5a333a157eecf0a8020c1d36d7c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
