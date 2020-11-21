Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A3DC2D0E4
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 00:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F63522470
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 00:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bkw0G4rq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgKUA3G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 19:29:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgKUA3G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Nov 2020 19:29:06 -0500
Subject: Re: [GIT PULL] SCSI fixes for 5.10-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605918545;
        bh=oSOM7j0eEVzUBFrmcya4338k4MeDVIEQwNFlHtrBg/A=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Bkw0G4rq51VECOavg1mPfrva6JbrCAMGjLlejOJlyYXxyGgUMo5O5pG5cz5SRwsAs
         bOEX8faqtt0Ix8bs0smx/jCamMGuQiNu4cYrCmnxSQDwvW6c4M0deKS5cOdhSCZK7/
         DBZK6pP3kmZOsy3SjygDAoBNNoDhfwJLxmd3hEWs=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <e7089b22f1e74855e76b64e5a0923771a108b770.camel@HansenPartnership.com>
References: <e7089b22f1e74855e76b64e5a0923771a108b770.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <e7089b22f1e74855e76b64e5a0923771a108b770.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: f36199355c64a39fe82cfddc7623d827c7e050da
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 27bba9c532a8d21050b94224ffd310ad0058c353
Message-Id: <160591854586.19527.4602552631932179196.pr-tracker-bot@kernel.org>
Date:   Sat, 21 Nov 2020 00:29:05 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 20 Nov 2020 12:30:34 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/27bba9c532a8d21050b94224ffd310ad0058c353

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
