Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4394C43219
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D14FB61AF0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbhKSTtY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 14:49:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236252AbhKSTtT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Nov 2021 14:49:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 873EB61AF0;
        Fri, 19 Nov 2021 19:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637351177;
        bh=w/cV0A9d6vhVxYizPKfIH3mkDSr6ob/IVDyHXYbsy1Q=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=V8RQWVJvtgaxO7JctxEjYho+M4RqbjJ17CEuy8si+6HvPQU//qntsgV2rodl5XTAv
         QIQX9hlhUD1tqrRbzaBLu9hToMSXA9ymgEmxjNlFY5hzhAvyYMOCodXz9RXJHs1/js
         e76Vit860XUcdjwjR6l82L/uoVpq9AeJX8hxbe2+Cm5bkTifCg+QpQEqh/5+7Dqdfb
         +7QFVQXdFumnLBCiXu/vzdnns7GG123NQFGHYcKei3JmDEEUe8bVzER1r+L9xXyrLQ
         RT9VUc0PhLYHWSfmivTgKailo34nd2lmoORnXq1okeRDXHVm4lc0bGvc3uZFYLhg34
         EKz1t5D5sTCvQ==
Subject: Re: [GIT PULL] SCSI fixes for 5.16-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <0a508ff31bbfa9cd73c24713c54a29ac459e3254.camel@HansenPartnership.com>
References: <0a508ff31bbfa9cd73c24713c54a29ac459e3254.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <0a508ff31bbfa9cd73c24713c54a29ac459e3254.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 392006871bb26166bcfafa56faf49431c2cfaaa8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ecd510d2ff86953378c540182f14c8890b1f1225
Message-Id: <163735117752.2946.13162608094770241495.pr-tracker-bot@kernel.org>
Date:   Fri, 19 Nov 2021 19:46:17 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 19 Nov 2021 13:20:10 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ecd510d2ff86953378c540182f14c8890b1f1225

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
