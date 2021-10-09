Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECD4C43217
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 22:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C014660F23
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 22:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhJIWHY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Oct 2021 18:07:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231226AbhJIWHX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 9 Oct 2021 18:07:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6AE5860E74;
        Sat,  9 Oct 2021 22:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633817126;
        bh=Pch5/+o4hMmf1J4ERTrWneIogNWWUmf+kY7KoB0EFGI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=G1jGdNawbeyUtiptX8AWuJSCd5yfis/Z/ZhFMYB7PUewZs1W1ZdVxCraX1jBN29fC
         Cj8Frbnm+gqt7d4b79PF2Q1LNSfWBEhdTUzrzdhbBk62kbklOAC+pBrPfLwNNVk35m
         ZuE21ZUABMf/9OI2Pl0BWFB6sP5P7tAWdnm65k+k9v6Qn0GIYCNnDjZHKJ1lwlikBE
         xN2CjXmJx/thspeIBIHO3YkZoNrHyRDRSmxOjmuDns0mYWBf9Xeh8EnuaS3viQhwFU
         6FPLRcynxKq0MxhynI48wIijMiwqd/ifW85OG8pFAH0y1p9CjbxhoN6eKw0WnGGCKD
         fItMLk0YR1fCw==
Subject: Re: [GIT PULL] SCSI fixes for 5.15-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <4083dcd4a97427aef6ffca411c1147af4fbd1bcd.camel@HansenPartnership.com>
References: <4083dcd4a97427aef6ffca411c1147af4fbd1bcd.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <4083dcd4a97427aef6ffca411c1147af4fbd1bcd.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 258aad75c62146453d03028a44f2f1590d58e1f6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0950fcbf992f578575f5387decb06f6496aab594
Message-Id: <163381712640.3348.2387435808264351760.pr-tracker-bot@kernel.org>
Date:   Sat, 09 Oct 2021 22:05:26 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 09 Oct 2021 16:55:28 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0950fcbf992f578575f5387decb06f6496aab594

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
