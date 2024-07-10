Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD0C1EB40;
	Wed, 10 Jul 2024 22:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720649769; cv=none; b=uJnV0XWPXanTDXi0bo+GawopzaAbZ+/XwtPCR8sCXIgWmgmYgKdYXQGUtWpRhwIVxtVYwzyH5DBk5P8aGv6AJ52MLzrcOCwr242Sw5mJR3LXbk59RzPC8C6bowMubMPdobbMEDYSUyICkNHEjwOh8ti+6hWegTMxijpaDadYT+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720649769; c=relaxed/simple;
	bh=/ScNMZbF1u94QbxLNgn4U8rtRUtwa37bEYF+DpCHnBI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=b2ZnqThgd6tX4rQvTw4A7/8aHrduCNazo+OHAcDE18bLYisKBbkLFVX8+UfGs0GRvOYBnzvb6qUNdMe6vAt7L9BtkmtomlycbNW9VhIv/8k5F3Io3HdHE0JanlQfziu13/vpiwAkL6Jeg6aWp9Y8ZMKJz1x/jZ2EWMMVA6H1VnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lBjrqXyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lBjrqXyb"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C60CC4AF07;
	Wed, 10 Jul 2024 22:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720649769;
	bh=/ScNMZbF1u94QbxLNgn4U8rtRUtwa37bEYF+DpCHnBI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lBjrqXybaXr9K0UuPdvlzUN61Vntz6015EMDEdstmr7/Dacccg54Rzd3X0BPD4m5Q
	 JxrcNML/keojcBJw7bLxCM5/6pkNiI1Ey7nMSLrVDZXquF+g89oNiu8uwYCZzNDu1Y
	 VRjr2sniLPc55oT285Yevw5Qao8Z4iw+2R/X6ciapSDAODdKuzT3OziWf5f4gczFhL
	 vpsS1QhB+IxEQy/NFvLQYUJA0UMUUxrhA+WgyRn+MhNlhZ5m6IWzSlaWk3+FWpahDH
	 exFtIWgzuqWZiaFvEPwYnEDZnkIZIXg2H0I/r35euncJ73eQ16d1g+hnJoH2TUN2X9
	 G2+ks1PYttjmw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72CD4C433E9;
	Wed, 10 Jul 2024 22:16:09 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 6.10-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <ce3dd4dc5924fa3fbc1468a5dca262aed50bb4d7.camel@HansenPartnership.com>
References: <ce3dd4dc5924fa3fbc1468a5dca262aed50bb4d7.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <ce3dd4dc5924fa3fbc1468a5dca262aed50bb4d7.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 7a6bbc2829d4ab592c7e440a6f6f5deb3cd95db4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ef2b7eb55e10294f4f384f21506ef20a6184128c
Message-Id: <172064976946.29271.4940298787438254487.pr-tracker-bot@kernel.org>
Date: Wed, 10 Jul 2024 22:16:09 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 10 Jul 2024 10:48:56 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ef2b7eb55e10294f4f384f21506ef20a6184128c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
