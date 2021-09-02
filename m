Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FC2C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 22:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90310610A2
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 22:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347835AbhIBWni (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347749AbhIBWni (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Sep 2021 18:43:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5FEDD600EF;
        Thu,  2 Sep 2021 22:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630622559;
        bh=56UeBom2GN9iWIlcmoqG0aYrG9Em6B7nLwl/fj3YUmo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Sq0b015Tks1xlM7IsD61AXVvJjkwxJ83yKjRj5xhHYCqJgzUAWSgtVonGM1gJ+qX2
         RmctQWqZf+VqRMY6qw5xD739cYv3cmzQ5GuXZo9unmjIBbl+4OO8QKxQHuNRLvuWJa
         RdhFoCDUEzQnynbCd6R+ea9namkOPp5/SiclPUiGFJe9GUF3ttLeZCV7R/MJ6xgnI9
         P1F035XbHQOj+/4DP7GbQFT7HBK9D7Z69ZRfNyf8+85EfRzKe+C0KUSJG6RFCs30m7
         MOz/a1gE4ERPkSXnALtBgZ4x8HQzShvPn3OOQsFOoZ7guYnFB2JWTiXstTIlK37zzY
         46HQMqRgfoq/g==
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.14+ merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <fc14fbbf0d7c27b7356bc6271ba2a5599d46af58.camel@HansenPartnership.com>
References: <fc14fbbf0d7c27b7356bc6271ba2a5599d46af58.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <fc14fbbf0d7c27b7356bc6271ba2a5599d46af58.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 9b5ac8ab4e8bf5636d1d425aee68ddf45af12057
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a9c9a6f741cdaa2fa9ba24a790db8d07295761e3
Message-Id: <163062255935.25965.4487663518163268231.pr-tracker-bot@kernel.org>
Date:   Thu, 02 Sep 2021 22:42:39 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Thu, 02 Sep 2021 09:50:07 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a9c9a6f741cdaa2fa9ba24a790db8d07295761e3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
