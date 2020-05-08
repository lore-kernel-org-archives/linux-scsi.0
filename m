Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F7F2C47255
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 538C8214D8
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588960210;
	bh=GMvByFCCZ789DltWRWb8g2FH4dTEAQwyMJtUDrsvMcM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=1U8+0tDhdPTCT9j8jXqLxdzeXpYAV53h1gcy+yNkno9RmqwMjqjnPRUFFU+VoaSGr
	 AYBjSYIVNfFysXbsOLhWmDrYL2YOTLQiSmXQwUf+rZOAkncl+W5MQ7wvEBAQJEFmDq
	 34Y0s58mJzrXGXDPReFoUwngnuogcqnMI36VTcCg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgEHRuH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 13:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgEHRuF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 May 2020 13:50:05 -0400
Subject: Re: [GIT PULL] SCSI fixes for 5.7-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588960205;
        bh=GMvByFCCZ789DltWRWb8g2FH4dTEAQwyMJtUDrsvMcM=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=S2zm6hZzTJK4vZ+ks9zECqP1gkcmEB4zQnJHKFV86Nrkj+FkQed8nYAglt66IjZY0
         xIp+/BEZkimJN4je65kylLXhaXjfhOu9m3LHdIvhVCrgQLlUZ/qL7ZMyRHES9xFGkj
         R7fE7fXZafU2DPe7vkbPktNcQRKlyXpPCtA5Epg8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1588959096.3837.12.camel@HansenPartnership.com>
References: <1588959096.3837.12.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1588959096.3837.12.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: b36522150e5b85045f868768d46fbaaa034174b2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d5eeab8d7e269e8cfc53b915bccd7bd30485bcbf
Message-Id: <158896020526.31681.2474498197163576882.pr-tracker-bot@kernel.org>
Date:   Fri, 08 May 2020 17:50:05 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 08 May 2020 10:31:36 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d5eeab8d7e269e8cfc53b915bccd7bd30485bcbf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
