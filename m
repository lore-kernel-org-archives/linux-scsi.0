Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7678C4361B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 21:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68CD823A01
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 21:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgLPVvk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 16:51:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:38904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgLPVvk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Dec 2020 16:51:40 -0500
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.10+ merge window
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608155460;
        bh=B9DysIXhEgUOZQj+vQjvPGOspt1ow/4O53wiUOBBz4c=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=GNsid/OT7N4ep60FT1UEsjZgQKWygh+qcBEa1Cj9KgHy9O2XJJMs1wDHNk4qF8RAl
         pVi4/tuwYc9NTT1Etg90UknFeCWQdOJU59sLEpS6qru6RH2XNd962ZkJD7O+Q0K1aP
         DNQpAqu2uZzKw2/I8/fY+UfAdlVUEoJE9oWNjhM7A+k25hgEcrXc6wVYd0oEd2psDZ
         +h+mAP652ejTU4G61CkeZXXfZFWC0w4Cz1jSTh6NE2t3nVBHSwA79EhRa1P1kO8J+p
         lZV0ehoEeHcCaopzqUwxA1wS1eiHCfo3IdkamidmfpTwabUdfCFohHoPgLQ+VrwvOm
         XvkqExCqg59zg==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <3d7eb46bcb309d17fe1c136c7d17154c5ec482b5.camel@HansenPartnership.com>
References: <3d7eb46bcb309d17fe1c136c7d17154c5ec482b5.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <3d7eb46bcb309d17fe1c136c7d17154c5ec482b5.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: be1b500212541a70006887bae558ff834d7365d0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 60f7c503d971a731ee3c4f884a9f2e80d476730d
Message-Id: <160815545995.13626.1033436810146005677.pr-tracker-bot@kernel.org>
Date:   Wed, 16 Dec 2020 21:50:59 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Wed, 16 Dec 2020 08:39:20 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/60f7c503d971a731ee3c4f884a9f2e80d476730d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
