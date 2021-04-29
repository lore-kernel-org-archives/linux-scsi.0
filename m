Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1202C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 00:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EDDF6144B
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 00:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhD2A1F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 20:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231898AbhD2A1E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Apr 2021 20:27:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A0FD16144B;
        Thu, 29 Apr 2021 00:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619655978;
        bh=4LQ2wZoJ4t0yqoMR2R6HPXeA85UYQY0Y0J5OUuC0rk0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=BTznHtpyyElsOMk8l2xHpB0Jm99D97JfYPev13u9SPiqX9GS1JhvnCmAsLpDo3kiG
         vIj24LPSsfjr48vil+Cq/90mXnrJNmmoprwiCc4B2c636oXo6KuozZNUSWhnETvHgo
         UGoD/AwR6izAK+LFx/XgHYzw6zjiuTzH7t4/aRFf81vmQZppyQaKYsLxbYhDz5BvdP
         wdqUqQn3+FvtHOxz2TlpcSOsRWwy/Vk3wgZNowMdDvQoLygh3SHJ6cc40eso6V97u7
         Xm2H7KfldevClxTTUE/gdxlx8Kdalsz95WytL09iJRCpJtCNp1De6sn0wXYA2Nxarz
         lc1EdC/XgaYUg==
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.11+ merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <14aef9fe8b29ee43c54a38b777905e9f85a25eb3.camel@HansenPartnership.com>
References: <14aef9fe8b29ee43c54a38b777905e9f85a25eb3.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <14aef9fe8b29ee43c54a38b777905e9f85a25eb3.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 7a3beeae289385f7be9f61a33a6e4f6c7e2400d3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d72cd4ad4174cfd2257c426ad51e4f53bcfde9c9
Message-Id: <161965597863.15418.2565857614516223138.pr-tracker-bot@kernel.org>
Date:   Thu, 29 Apr 2021 00:26:18 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Wed, 28 Apr 2021 16:31:54 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d72cd4ad4174cfd2257c426ad51e4f53bcfde9c9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
