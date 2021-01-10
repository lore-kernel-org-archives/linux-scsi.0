Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FFCC4332B
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 21:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F371F22AAB
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 21:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbhAJVV6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jan 2021 16:21:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbhAJVV6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Jan 2021 16:21:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9C83A22AAD;
        Sun, 10 Jan 2021 21:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610313677;
        bh=BeMW1H/pLqMxPy1MS/evxQoWhECMoCOzDEx/lzx/uHE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=uzoVc0FIEQZmiSdn6gCXhmaOwbl58yUhg6mTAiA1+K/FXKVip58+7xgaQ4ULpqXzF
         GwnN8OR5E3B6Qi7owA/LKc4aW5cMROry1leeFRI6jtf0sk2jwIuLmldwSTVbTIAkdz
         2nGCZklb1xesy3LavtnnUeuJUtXK8hZJIn/zqGRuR3U0GusPY6xam2l0E2p+idrZFd
         tYrCyY2rChkBSWau7xU+SAdFYFcNCWCVgtq29PM+XPBHhpN7+qnvPX7tMIA89YF731
         7SJS2+DIXFskqmQNe6TPBaj4uACtswSy38N9GHiaEXOzs0zGrRGxyZQaG0f0EvK8GV
         R4rzo5poh8mPw==
Subject: Re: [GIT PULL] SCSI fixes for 5.11-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <14455f8f5d119cb74d3dbe66898863a1a79c0f0b.camel@HansenPartnership.com>
References: <14455f8f5d119cb74d3dbe66898863a1a79c0f0b.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <14455f8f5d119cb74d3dbe66898863a1a79c0f0b.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: a8f808839abe3a10011e28b46af1848dfd8c4f21
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 688daed2e5daf0a1513effdc05ce3c56ade836f9
Message-Id: <161031367761.28318.10874253762165538049.pr-tracker-bot@kernel.org>
Date:   Sun, 10 Jan 2021 21:21:17 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sun, 10 Jan 2021 11:05:27 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/688daed2e5daf0a1513effdc05ce3c56ade836f9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
