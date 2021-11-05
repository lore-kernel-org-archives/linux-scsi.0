Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422E0C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 16:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B8AB6124A
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 16:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbhKEQLM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 12:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233126AbhKEQLM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 5 Nov 2021 12:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9A3CC61252;
        Fri,  5 Nov 2021 16:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636128512;
        bh=zKegTsRYwShURaAhoJC3gMMqFkHaD1sWFCoyhpvBpAw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ACeqH5rH8KXY76Jdrr/26aaPEDWmePgKPal1Gq6K39N9I3REK4nuglJUtJ1L9HOvM
         ibuDZcrOY3x4jTxg3xB28ueOVoOTbsJ/xYZpTl/aIqQT0WKCidDGJ7RU8429837NQ3
         yKpZSO9X26jdZgb/5KFt1r55AH6XOEyN8lDn4plhzzNtHqTb6TDViVgIvlYjmnkjn7
         FG86emzlCEn4IXibZ5I7xH5hLlq75BXl4vp01Z3I1Qto4STsDzFABdJZcL2bbHAbEF
         DmBkAjRSEmKOSAzNJlnHs5w7cYyEfLs18LBlcGWsLQlnx4MAI8JICXPG0lljTSz62D
         umQj+qj0b0E+Q==
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.15+ merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <b13f25e87fd8d4ed027ef64aba8ebd7273c4b8b8.camel@HansenPartnership.com>
References: <b13f25e87fd8d4ed027ef64aba8ebd7273c4b8b8.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <b13f25e87fd8d4ed027ef64aba8ebd7273c4b8b8.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 83c3a7beaef7fd261c190b69f6be6337f251bf16
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fe91c4725aeed35023ba4f7a1e1adfebb6878c23
Message-Id: <163612851260.17201.4106345384610850520.pr-tracker-bot@kernel.org>
Date:   Fri, 05 Nov 2021 16:08:32 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 05 Nov 2021 08:14:27 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fe91c4725aeed35023ba4f7a1e1adfebb6878c23

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
