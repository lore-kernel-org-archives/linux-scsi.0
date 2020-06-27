Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFB9C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 22:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D543520787
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 22:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593297932;
	bh=o9UuCkRLPFbMKQpe1QrrxuO8Y/Zb0DeBd/BWE4u8gSE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=wTaJj/2FRXJVjvGo3jvjNJP9wDCF3wNk+KCyvh6SN9NUN1M/lwe3XUfh3o2XEm2qy
	 YhhoRpB7b1hubWx5OTByweIzd1vQC0VLjN4ASB91yU32lin8LxOS6N88WJIL3WVJCg
	 a/A6WMCjv0xNb5Bzar9eSMv/drp0v2NRiMiIPdSE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgF0Wp2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 18:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgF0WpN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 27 Jun 2020 18:45:13 -0400
Subject: Re: [GIT PULL] SCSI fixes for 5.8-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593297912;
        bh=o9UuCkRLPFbMKQpe1QrrxuO8Y/Zb0DeBd/BWE4u8gSE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=REXfEGP701Q+wAQDhnZdZwpDqexq5QD0LDUjTC5uA//xDe6lc9w1GK7oEAZhl2FvB
         BbS/+xujuGEI+RItudt6/BvO0X3ZQ3Do5lCFtuIH5s22z5/XrFZdwUSagxADoE4Eou
         iTxPYtH7cwp1gjIXvGM+J6qeU9UTBNGZ0Uef0IG8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1593279324.11424.5.camel@HansenPartnership.com>
References: <1593279324.11424.5.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1593279324.11424.5.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: afe89f115e84edbc76d316759e206580a06c6973
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3cd1c5d582f42fead949947a6e3c8f51797580c9
Message-Id: <159329791282.3578.16906356220652861162.pr-tracker-bot@kernel.org>
Date:   Sat, 27 Jun 2020 22:45:12 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 27 Jun 2020 10:35:24 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3cd1c5d582f42fead949947a6e3c8f51797580c9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
