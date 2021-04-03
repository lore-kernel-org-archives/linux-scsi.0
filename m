Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93DCBC433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 16:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BEE56125F
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 16:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbhDCQKp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 12:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230516AbhDCQKp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 3 Apr 2021 12:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 38D626124B;
        Sat,  3 Apr 2021 16:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617466242;
        bh=57qukBiF7YIUSpERUhYhDeqxB1WYMSI82WkJQHI2uTA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Om4oVlU0JwxODBS2ox9tVk1B/JWnNSAuY+ASSX6mklsIlEHlEfSvaGSWmSwPJsvZ5
         UgGCBncqBzePO1QIWAfgiuG1Z8uaE0kQ4dGtE0Q4XSNpcc9W50m2GT/5EhIXlQgr5f
         IY0JR2dKetzagUCNspdvGr/DklRKkvx9FCZGEXaE0fZtHwHXEyeWLpB6eZAQHhU6FR
         NxJTm5FD5fSj2vPVKz3n5htYaQUjCH7njffEr7p7C+mAoHq/bJ2hI1S8KYmUyzaJkV
         2i+wC+sjUAY3olPXAvdeuAkkomxNjRJnVvHaaC5vEGsOmv9okpQffpdJduGLOi7uV5
         dVmWDAtioEDkA==
Subject: Re: [GIT PULL] SCSI fixes for 5.12-rc
From:   pr-tracker-bot@kernel.org
In-Reply-To: <9aa8b614478d74ee0cb37dec9e20270c94d7f7c4.camel@HansenPartnership.com>
References: <9aa8b614478d74ee0cb37dec9e20270c94d7f7c4.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <9aa8b614478d74ee0cb37dec9e20270c94d7f7c4.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 9e67600ed6b8565da4b85698ec659b5879a6c1c6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 57fbdb15ec427ca3a6f35d4b71fc90ca9af301ea
Message-Id: <161746624210.28218.15590403217710872547.pr-tracker-bot@kernel.org>
Date:   Sat, 03 Apr 2021 16:10:42 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 02 Apr 2021 17:34:28 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/57fbdb15ec427ca3a6f35d4b71fc90ca9af301ea

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
