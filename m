Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE287EB64DA
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jun 2023 19:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjF3T2f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jun 2023 15:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbjF3T2d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jun 2023 15:28:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA343C3A;
        Fri, 30 Jun 2023 12:28:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EDF2617F4;
        Fri, 30 Jun 2023 19:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C827C43391;
        Fri, 30 Jun 2023 19:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688153311;
        bh=3F6SdnrkxCmk8vjNW/8p6klWG/9eWUTHnB2hLknsUgY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=emZkF4ZZQB6sfTvgNdrhFhNqaN1lEng7jsolgvjTYQOE9wpxI92+mxM6XCfxt+U1c
         7Gi3ZZBe5wJ1z3ZpS7LAnhWY4ivk6m4O2Dpl+frr0g+01IjE/X7KK5RF2NUkDqyvom
         S36mFv8OwcLwzCHGKg1WgrGoF0niV4H1gmjU0Cg5X+O3xxhrJGD4EdkW4XSEv09elc
         TKViU/kTGhkhbu/O+CPke4J0hqCUpPRko9P5gOvt6CzDJCfIXu3cJiBTNyaQghT1gw
         OYZ7vVMMyb321CL+88yIYVkzk74pnJaXWbV7Xh/t2ZVbSCEhqnQu1sK9AxBCYwlTO6
         H4E8P/WZj9fCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A457C43158;
        Fri, 30 Jun 2023 19:28:31 +0000 (UTC)
Subject: Re: [GIT PULL] first round of SCSI updates for the 6.4+ merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <23bd2eafa9b9a23e4a8a96fc0180bba9e77e42ca.camel@HansenPartnership.com>
References: <23bd2eafa9b9a23e4a8a96fc0180bba9e77e42ca.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <23bd2eafa9b9a23e4a8a96fc0180bba9e77e42ca.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: af92c02fb2090692f4920ea4b74870940260cf49
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ca7ce08d6a063e0ccb91dc57f9bc213120d0d1a7
Message-Id: <168815331143.22437.18267744756992839649.pr-tracker-bot@kernel.org>
Date:   Fri, 30 Jun 2023 19:28:31 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Thu, 29 Jun 2023 08:48:28 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ca7ce08d6a063e0ccb91dc57f9bc213120d0d1a7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
