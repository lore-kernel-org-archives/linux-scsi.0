Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6668C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 23:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8279760187
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 23:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhJ3XGL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Oct 2021 19:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231387AbhJ3XGK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 30 Oct 2021 19:06:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CCA6E60ED5;
        Sat, 30 Oct 2021 23:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635635019;
        bh=sB4McWzQqEJJmpvnGyq+ZdlbV2Amt04KPHQ+ki7uE7U=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=P6YmzVWc2dE3dD0/TBFiGN7pgCINXXemL3RABvGJwRu6XR484Cn0fHs1nIk3UwsuR
         hTON4aJchMNhIuMb2BWKyXoQyueY4TwxZWf6TJ+gtteJnssl9rxZbjSb1GDerEJzML
         9pgpi9FLMa5ad7FnSbx6NCAZibMtlKvUnqgKL8LyRjWOMHrv41CY0QRkySj1klZmDt
         exsnWo3JIIVQFDHp+VwfqRCu687/HjENXztQRyKVRA+a4yjiukfYGMFCFZ30Hf6c53
         Gy39XfMhO27iRLPAvz4i8//nl83DWbDY21CLDg1ukuWpgjfGnmEMn0sF14hBuwa/bB
         X3eEZsbCsgocg==
Subject: Re: [GIT PULL] SCSI fixes for 5.15-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <fd550fa6f72861294271fdbaf98c09b34a1a8c95.camel@HansenPartnership.com>
References: <fd550fa6f72861294271fdbaf98c09b34a1a8c95.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <fd550fa6f72861294271fdbaf98c09b34a1a8c95.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 09d9e4d041876684d33f21d02bcdaea6586734f1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 180eca540ae06246d594bdd8d8213426a259cc8c
Message-Id: <163563501970.32594.13631547289825516524.pr-tracker-bot@kernel.org>
Date:   Sat, 30 Oct 2021 23:03:39 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 30 Oct 2021 14:45:43 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/180eca540ae06246d594bdd8d8213426a259cc8c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
