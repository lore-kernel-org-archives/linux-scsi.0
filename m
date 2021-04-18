Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367A4C43461
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 03:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B60661248
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 03:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237165AbhDRD3f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 17 Apr 2021 23:29:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237157AbhDRD3e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 17 Apr 2021 23:29:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5A73861210;
        Sun, 18 Apr 2021 03:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618716547;
        bh=BetVpmd3ru1nHglAC6wSA5Gnp9ETHrOmrVErleOxNv8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ChevqbMc6aqe0efK9Kvc3F3/zjSttAqNI7SdsNjavwYVuFzZ4wIOTn3PTjzSkXZlS
         S2AkvmlBVAlqC3OMKHwt/vwcCVHLJjDCjIMdAjQBzPvKVsavh/V8Z9FWMFwPEhVKBy
         3P/hQpDzlbHekxyTE51rJf0ZLPZu+1e5EtuAlkBcCv8FiJvibhIDoC6Cfpql+Ijq5u
         EsuG9rQhav6lTqpc4OrOg/U7o6ogox44kUB+Z39O0w7Ga7LKcJDX4E8Vq0Ww0139Pw
         9pWNGIZCbqv7tXqstrEPTetTw8XHW1vy0r4aWeKe97e50E7Pg+gfZConFXjHqgWd/f
         CT6P0JTAGq0XA==
Subject: Re: [GIT PULL] SCSI fixes for 5.12-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <57deba188660d1a81c658f30befe8538dd7a625e.camel@HansenPartnership.com>
References: <57deba188660d1a81c658f30befe8538dd7a625e.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <57deba188660d1a81c658f30befe8538dd7a625e.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 176ddd89171ddcf661862d90c5d257877f7326d6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c98ff1d013d2d53911c4b3e8ba14c7cd141cf1ed
Message-Id: <161871654722.19812.9601947344077869609.pr-tracker-bot@kernel.org>
Date:   Sun, 18 Apr 2021 03:29:07 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 17 Apr 2021 18:46:43 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c98ff1d013d2d53911c4b3e8ba14c7cd141cf1ed

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
