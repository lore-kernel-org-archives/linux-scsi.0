Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFF6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 20:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA72C60E8D
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 20:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235610AbhKLUpA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Nov 2021 15:45:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:52504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235581AbhKLUo6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 12 Nov 2021 15:44:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C49A760EBD;
        Fri, 12 Nov 2021 20:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636749727;
        bh=BbrZGW6EuifenVBCtUSrw3Sl4ZA4TbRwj1V5lfdXkUU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=jrFfBBYONy6+y+boqOP6wYWJIIyyn6h6S1DG8FxhyRwVeibkauR/edXJj3W1cy6r2
         r3LIbyDTw3zyMvuTgvYEjZvtE/TDlPYDI36uVqS5U0yURzCYMgPusQ2LkutS+DvN40
         gzBVZdZDa47njb2H643JqPdQFNaWkYVnQqZsbkuMkheHv1zpP18+zZLgV0e5q+cyZ9
         FWy8heXatApEL/zQcb0Z1Qt+Z3W/BgwmT9Uppt5KDLJW4cLOm0R/EoR0U0CjJ9Z0sN
         Jjis7YNyNq2Pk3N43X047Nd6lxPpHkUUueUsglJDaZUgeOkVgSj0JMsiNPxcgXwIAb
         GUZUWd6Yg3OmQ==
Subject: Re: [GIT PULL] final round of SCSI updates for the 5.15+ merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <d9405d786496756564b31540cc73a9d22cc97730.camel@HansenPartnership.com>
References: <d9405d786496756564b31540cc73a9d22cc97730.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <d9405d786496756564b31540cc73a9d22cc97730.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 3344b58b53a76199dae48faa396e9fc37bf86992
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6cbcc7ab2147d721700029a78558dc0ea4207153
Message-Id: <163674972776.4802.5369135287794805070.pr-tracker-bot@kernel.org>
Date:   Fri, 12 Nov 2021 20:42:07 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 12 Nov 2021 08:43:14 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6cbcc7ab2147d721700029a78558dc0ea4207153

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
