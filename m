Return-Path: <SRS0=1+Eg=D6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88353C5517A
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 23:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46C3221D6C
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 23:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603496535;
	bh=nAjy8bkfhE88+gKUveTQczXrleQW2tS2ziU2FycHsXU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=A3v5+NfZuYfLwcgA9UHBVhZdpRXsVvmpGfecW9JOYRukvVzrO1rdxy+yARH4SY82J
	 hRoWGdfEiwcqMvLAVSWjc/DPnSK68oYmX2OGm4eGhWU67NRzGauBgNnJCidk+opNTB
	 z6JAt5A9U/qm1fIcjQ5T1m7DXIEel6thp3Xcx3IY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758782AbgJWXmM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Oct 2020 19:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758779AbgJWXmL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Oct 2020 19:42:11 -0400
Subject: Re: [GIT PULL] final round of SCSI updates for the 5.9+ merge window
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603496531;
        bh=nAjy8bkfhE88+gKUveTQczXrleQW2tS2ziU2FycHsXU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=tKX9pjfycMsObhbPdsS5PoeKr6beAAi61fFgTzDD4l9zgNEngdo1Eke1Kifq9eXVM
         B2bWFGUV0ktlAo328k/XgFW+/HhgVpB3dQJw2JEuApPXiKvYtGJMB/XkFZu8BQpneD
         TtI4tdQSn1W5gdcXwAZPMbrsepAnXj9joK3cTWpE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <4affd2a9c347e5f1231485483bf852737ea08151.camel@HansenPartnership.com>
References: <4affd2a9c347e5f1231485483bf852737ea08151.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <4affd2a9c347e5f1231485483bf852737ea08151.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 1ef16a407f544408d3559e4de2ed05591df4da75
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: af995383eb653f875c4e4e2349d5b0b4ba839eaa
Message-Id: <160349653124.22217.10098010982248353095.pr-tracker-bot@kernel.org>
Date:   Fri, 23 Oct 2020 23:42:11 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 23 Oct 2020 11:46:21 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/af995383eb653f875c4e4e2349d5b0b4ba839eaa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
