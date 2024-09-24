Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8811E80043;
	Tue, 24 Sep 2024 20:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727211315; cv=none; b=KaIwt0NTQgTB2xuDCGXPixLVA05hdIOTWCjeExMkdqmit1jZ9K3ymSy6JlbdGB1GAI8RwLFa9jg6SRdFHI7fZWi3QacK/uNPm7anvK+Lc+3sF8XvmfV9lv7M6TJk71lpMuk1zPlcFhpjju2+lJqORnW2Tr3yyUmV7M4rFrfWtvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727211315; c=relaxed/simple;
	bh=q8m+On7+iH/ccudjlBBHeh66zxCCda4qF3h0IqE1mPo=;
	h=MIME-Version:Content-Type:From:To:Message-ID:In-Reply-To:
	 References:Subject:Date; b=qmh6RlegX7NK8Mu+ClWnLjJwbn1uK2WsDmKx9h0aIU4Sx3oq2wEU0NgIm5/Gcs2ctTcEPljbjWgjOZIm/hvQfk2N9J65vXaMFhRKRGC2PFva0CGl9iO4rX2kLoe1CqSJsAqFabfdsiYzr+umvEupqogohSx+WbhQxgk+OgVdYvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDD+sDyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDD+sDyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BF8C4CEC6;
	Tue, 24 Sep 2024 20:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727211315;
	bh=q8m+On7+iH/ccudjlBBHeh66zxCCda4qF3h0IqE1mPo=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=lDD+sDyC2Xv8w5/jy90w39lwBtlx7p1cDfnM7B2kTmwytYUd+PDX2gN1qJEMMNdU3
	 7TWQAWj0u3WX32eWPWVPWXNxIfKa8jz11wYMxAxf4aI5PeKqaBYKBkK/bW67SNX/dn
	 T/n8fVNJznlf3gBl1u3aJdeodqSslI+y+dvQzjN7dzmEz32vtyo1pdlV55X4HUQwlh
	 OVYB9HWbmZsGsmeJEJ0bVm/eoAHBpWYLNE3SlhcJ6J+H8YlbqSC2O4VS4YC08m0Xyr
	 UGpfkfZ/0Em2YVLuCY2fK2VNyGgxcW75b9Kd15eqReNWRFB4EWB9w3/uvIOX2Lc7mL
	 GqAXy+iHd1weg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B35553806656;
	Tue, 24 Sep 2024 20:55:18 +0000 (UTC)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
From: Bugspray Bot <bugbot@kernel.org>
To: helpdesk@kernel.org, konstantin@linuxfoundation.org, 
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Message-ID: <20240924-b219318-480d0d1ebb13@bugzilla.kernel.org>
In-Reply-To: <20240924-shapeless-oarfish-of-improvement-34aef3@lemur>
References: <20240924-shapeless-oarfish-of-improvement-34aef3@lemur>
Subject: Re: Bouncing maintainer: Michael Reed (QLOGIC QLA1280 SCSI DRIVER)
X-Bugzilla-Product: kernel.org
X-Bugzilla-Component: Helpdesk
X-Mailer: bugspray 0.1-dev
Date: Tue, 24 Sep 2024 20:55:18 +0000 (UTC)

Hello:

This conversation is now tracked by Kernel.org Bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=219318

There is no need to do anything else, just keep talking.
-- 
Deet-doot-dot, I am a bot.
Kernel.org Bugzilla (bugspray 0.1-dev)

