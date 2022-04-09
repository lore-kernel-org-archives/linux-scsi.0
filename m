Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77533C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Apr 2022 16:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242711AbiDIQnf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Apr 2022 12:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242704AbiDIQnd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Apr 2022 12:43:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A88B2FFE5;
        Sat,  9 Apr 2022 09:41:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CEE360AC6;
        Sat,  9 Apr 2022 16:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09BA4C385A4;
        Sat,  9 Apr 2022 16:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649522485;
        bh=zMDnnOa3Vi49gQPuCC83OCw0cGMqnQZHUTyiA51skfQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=aV0Ej8t1KQuvAnhYXcH+5Iqs0EUZltWdGzpgHVrBj6We5cQAALZfSMi1NiJniKUFB
         M4TaaFGPRV49jzO1TExSKc66rDFeS0Bv/1iB5U/RCHQLrHPSgPk0gJN3pgrAySIDHm
         Wb3pqNB0otbmcKWOBMdxwfuvuJfyb4RO5Bdl06B6/WSM9mDZEGfKFW7ewvty+XfVhH
         EIJesa5pxbdWx86KWNUXJmlnIKYXKLlWSzrtUQ1NG5uWfImnHAYSmeKl4fZNZ+vb1n
         U+wdTrqIJapvOv1Ex6EV+c3AnjnHoMns3u8qSJFPYW9hn0MGlBQ7RNmaQImybn8uvl
         Y3TJPHtxfdCUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB489E85D15;
        Sat,  9 Apr 2022 16:41:24 +0000 (UTC)
Subject: Re: [GIT PULL] SCSI fixes for 5.18-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <7677b962e5416dc69b6c960dcfdba8ff454a8781.camel@HansenPartnership.com>
References: <7677b962e5416dc69b6c960dcfdba8ff454a8781.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <7677b962e5416dc69b6c960dcfdba8ff454a8781.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 56495f295d8e021f77d065b890fc0100e3f9f6d8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e1f700ebd6bea293abe3c7e2807b252018efde01
Message-Id: <164952248495.27192.182728584381152854.pr-tracker-bot@kernel.org>
Date:   Sat, 09 Apr 2022 16:41:24 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 09 Apr 2022 10:34:25 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e1f700ebd6bea293abe3c7e2807b252018efde01

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
