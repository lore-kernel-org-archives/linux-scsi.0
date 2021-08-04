Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1AC8C4320A
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 20:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2FAB60F41
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 20:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240827AbhHDUQH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 16:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231342AbhHDUQH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Aug 2021 16:16:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4F77A60FC3;
        Wed,  4 Aug 2021 20:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628108154;
        bh=7jkHW7pRWM4taXR8B8hOvaQf3R7wec2KH6SPgDOOjrs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=tzt7HhRHtuPLQgXXS76PFNwZvoFpeLwgMMAfdsaqD2XB3jXkKLqPBgm4NlGfJjAjA
         WsIbPrm1szhnRDxhrbFJzdM65+gOh8D14SJO74qzCiy+MmupuDacVOn0R6ZbtZr60Y
         LpUTf6SXmatLpbsGIhMSd5g8uCzRRsQkad+lhxY85FD4nF226KUT+nOj8ByaloxMEr
         PkOCwg+DqgvHjoJ+9+YDJuqs0pP0munPWLVNs988C1dhs3NBbf2b3OftajaAIn+l3r
         4dGCZuiCm9IqyamyyIeF5ps+xIDKiCOwe24VQYDrcGmC8bdCTVMakqgsx2OoAaXQd6
         uRgBi5Xbq/Txg==
Subject: Re: [GIT PULL] SCSI fixes for 5.14-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <271d6e9404dd961ec5ca9983b4730f61401bc3be.camel@HansenPartnership.com>
References: <271d6e9404dd961ec5ca9983b4730f61401bc3be.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <271d6e9404dd961ec5ca9983b4730f61401bc3be.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: f0f82e2476f6adb9c7a0135cfab8091456990c99
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 251a1524293d0a90c4d5060f65f42a3016280049
Message-Id: <162810815427.7114.9142732045601287531.pr-tracker-bot@kernel.org>
Date:   Wed, 04 Aug 2021 20:15:54 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Wed, 04 Aug 2021 10:29:57 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/251a1524293d0a90c4d5060f65f42a3016280049

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
