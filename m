Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D702C433EC
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 18:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1025B2064B
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 18:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595786726;
	bh=G2UsRR7v8U3BVxekOFVm5hlD0GarYSBkrkgSz/OzYGA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=WWmeu+HWSZ87V6eZ86h98v+xOVlmRuaWAhbw3KUfhIOgNwk4uD+pdjG46cQhu1QZG
	 F4Js2YaiJ8TP3ugMCi3pHAre609KJ42Bp4eMmuTbbQFo6oYjM63tLbgjev8TnSEnmI
	 J9A/2NYmDTT8NxnycUpUHW90Qm7mAGW0Ah/bG+v8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgGZSFF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 14:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgGZSFF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jul 2020 14:05:05 -0400
Subject: Re: [GIT PULL] SCSI fixes for 5.8-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595786704;
        bh=G2UsRR7v8U3BVxekOFVm5hlD0GarYSBkrkgSz/OzYGA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=CskaT07rottvwpUIkp9uzps9Qt19APtnbFDiJ7pMm75pJns5Pw9xSREWjABM8ptBM
         rCDltvb6LWgFIuo+1SfNVKQUYa7607ogaFanNpJC+/HrGFdLGGluZ6h4ND4ZfbVtlX
         0EzSFfr+QIrq3Rh/nQLAfgkjfFXdq4WkdVNuMZDM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1595743091.22874.5.camel@HansenPartnership.com>
References: <1595743091.22874.5.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1595743091.22874.5.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 3f0dcfbcd2e162fc0a11c1f59b7acd42ee45f126
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cf48f79b74de2bf900d27c924528bb41d73689c3
Message-Id: <159578670477.6689.4787060410711360252.pr-tracker-bot@kernel.org>
Date:   Sun, 26 Jul 2020 18:05:04 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 25 Jul 2020 22:58:11 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cf48f79b74de2bf900d27c924528bb41d73689c3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
