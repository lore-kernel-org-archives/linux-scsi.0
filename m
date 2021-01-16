Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4ABAC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jan 2021 20:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67B602245C
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jan 2021 20:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbhAPU2m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Jan 2021 15:28:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbhAPU2m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Jan 2021 15:28:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 78DAE21D7A;
        Sat, 16 Jan 2021 20:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610828881;
        bh=Xw/VNlfwy5YeX0aoPrdMTyWWFQHQD0FzJjaDKMJgAAk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=u2gigHckGklIUSxzDaqE/4iQjr81Avg6W41TP/6CV7UFTayGdtzlajlVrtPyEwveL
         zQP24KiF7BIHul+wA12jwf+Ze/yt6CKc2YIx9yZBbHkTGgH2C6FSyRUYj1NcpNAtKg
         MjSBEwiMg7M5LRfgjzLQ9fW1eJ68XFQpThUSeNU5biiZybUBikiyjsVcwxsMhw1mt9
         6XhhgKcrXjm/X4ETSclF7LawwqPBKWIDlKONsAN0641J1DrYbC9IsfltFCesqB5NhF
         gMi80bk5ZYVKrymXQjvmQHHRrd9BNpFk57roSlC3nntScfTTWsErY4/4DSlVeJ1BGd
         sSo+O0LwOwcbw==
Subject: Re: [GIT PULL] SCSI fixes for 5.11-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1aef3ddd04fcbfe8259f21d7c8a80404770b8af6.camel@HansenPartnership.com>
References: <1aef3ddd04fcbfe8259f21d7c8a80404770b8af6.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1aef3ddd04fcbfe8259f21d7c8a80404770b8af6.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: be2553358cd40c0db11d1aa96f819c07413b2aae
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0da0a8a0a0e1845f495431c3d8d733d2bbf9e9e5
Message-Id: <161082888133.18233.3757872085763392333.pr-tracker-bot@kernel.org>
Date:   Sat, 16 Jan 2021 20:28:01 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 16 Jan 2021 12:21:17 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0da0a8a0a0e1845f495431c3d8d733d2bbf9e9e5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
