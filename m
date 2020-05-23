Return-Path: <SRS0=JddF=7F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD715C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 May 2020 05:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87137206DD
	for <linux-scsi@archiver.kernel.org>; Sat, 23 May 2020 05:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590210373;
	bh=ZmYRoB7kTaTVSglawGt/NnmH2wQWwMENngSKZjHvH4I=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=yg+EDAtnUbJKbZ3fOJsWrXR7RLcyNO4wEPJmNe2DoNyVOi5tXCi6gjeQB8nQqcaEu
	 gKMOVtvgEdTQhiFu5KnN5UBmvJXCMLHTRBTqaTp/fjoRBPTLvfzDwvfPYeGzCb9cfb
	 5ydKluWON+Zh0Jj52vuYH3OEgTKm4P1mXsV080Yo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387604AbgEWFFF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 May 2020 01:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgEWFFD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 23 May 2020 01:05:03 -0400
Subject: Re: [GIT PULL] SCSI fixes for 5.7-rc6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590210303;
        bh=ZmYRoB7kTaTVSglawGt/NnmH2wQWwMENngSKZjHvH4I=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=WNZXSgVvFi3CJz5VS0P+So/i3K1PGYOaFslqCF5mNZ6+0e3NTICg7lXmew7nVqP9S
         2ue2AslxAk1jRrWE880j1g3oL88wfD1jJyf3UFqDhOr10IrVYqspHfX8+XUMNJZ/rY
         vqdVw9P8dNATI17d5FmENWyCUgsqv4NsAH1b612k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1590194620.14721.28.camel@HansenPartnership.com>
References: <1590194620.14721.28.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1590194620.14721.28.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: f2e6b75f6ee82308ef7b00f29e71e5f1c6b3d52a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e644645abf4788e919beeb97925fb6bf43e890a2
Message-Id: <159021030329.8790.17113090927006479228.pr-tracker-bot@kernel.org>
Date:   Sat, 23 May 2020 05:05:03 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 22 May 2020 17:43:40 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e644645abf4788e919beeb97925fb6bf43e890a2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
