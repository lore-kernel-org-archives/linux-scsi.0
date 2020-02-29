Return-Path: <SRS0=kvmt=4R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC0C2C3F2C6
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Feb 2020 16:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8553D2469C
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Feb 2020 16:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582992609;
	bh=hN2o55zQJWeSJj1BJINpK5gCzFdmbuVzu8aoQPfcNug=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=NtQ4hCs6vK2kPHOj7PYokxhswIX4fYJeGjfFcAiAPpQzaFVtCAnUL9n/4wstVPxqR
	 CVW+m57G3mOhOBSYpOYcjKnnEUMbQOi0u9agUdewc8pRuVUR2fAPxYBsfXtuGqFZID
	 MKoQjbe6TPsSTy8MpopjpRLDy59xZdtOmJLeeYII=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgB2QKG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Feb 2020 11:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727185AbgB2QKG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 29 Feb 2020 11:10:06 -0500
Subject: Re: [GIT PULL] SCSI fixes for 5.6-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582992605;
        bh=hN2o55zQJWeSJj1BJINpK5gCzFdmbuVzu8aoQPfcNug=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=kZLLCUvYBneenMA7eCCSA3HtbJltRJflbe7jscBz3gdo21Rkx4dCj/Ha7FC5ERuaN
         RwoHLK/uabwBuOXUAMMcimseD16Z5LvFrS7qtSeTBj4g33gqhnio16EMLNoaMU4fdK
         FmmEfvPekUc8Ihdiw2EttrnreuSeuV2UulTHku2Q=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1582985668.3507.9.camel@HansenPartnership.com>
References: <1582985668.3507.9.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1582985668.3507.9.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 03264ddde2453f6877a7d637d84068079632a3c5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7557c1b3f715624f3bd4c809f03771ce9384eb7b
Message-Id: <158299260579.20304.5715694865146177189.pr-tracker-bot@kernel.org>
Date:   Sat, 29 Feb 2020 16:10:05 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 29 Feb 2020 09:14:28 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7557c1b3f715624f3bd4c809f03771ce9384eb7b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
