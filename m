Return-Path: <SRS0=4aQo=EM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F89C2D0A3
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 23:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDCA520867
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 23:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604705849;
	bh=O/Zw+F9WW3C6aE70BN/uupbODTcf+QM7u3KUK9cqDjE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=1YqgPEhJVTr12h89Vic8K8qytOsI6g5psChVpsC6mJvfj8I4i/1ihID8vifZsspbP
	 5M6NKnbrv2OpBOI1hspoEsvDxBcnWs4FHineScK7zcZ9pM2Y5/dm750tKp+MuMwPTW
	 RsqiPNb7Z3rsOT42S+PSFR9l+JPkOFhNBKCtyBKc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgKFXh3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Nov 2020 18:37:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbgKFXh1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Nov 2020 18:37:27 -0500
Subject: Re: [GIT PULL] SCSI fixes for 5.10-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604705847;
        bh=O/Zw+F9WW3C6aE70BN/uupbODTcf+QM7u3KUK9cqDjE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=OZgzOWKOlVw+nCBUoQEhbKB3N57omU153rAdCW1kV5Sz649PAa86qwHt27JvhGZXm
         Scc5jTbyLvxZEjkp38Ar+qXvEl5Dv7rsBRnJwr3+qfpil9D8oNQi7Q/4H1ijCIxToi
         46wN3KJSyriArQ162FVgwhBqUyfYuWyzDLGmmlGc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <8a60c7bd72f908a637f0f9e60cce7ab3a047e343.camel@HansenPartnership.com>
References: <8a60c7bd72f908a637f0f9e60cce7ab3a047e343.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <8a60c7bd72f908a637f0f9e60cce7ab3a047e343.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 5feed64f9199ff90c4239971733f23f30aeb2484
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d4fc96832f0131c8f2fb067fb01c3007df6d4c9f
Message-Id: <160470584695.19097.12436655830782607257.pr-tracker-bot@kernel.org>
Date:   Fri, 06 Nov 2020 23:37:26 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 06 Nov 2020 14:26:05 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d4fc96832f0131c8f2fb067fb01c3007df6d4c9f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
