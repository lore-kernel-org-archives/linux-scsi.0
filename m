Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73469C4CECE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 23:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B5A32074E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 23:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584143111;
	bh=Kxau0moSAMYSWiLcpmT3YowaPzatf5NFeuKADxdAf2M=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=2e84lQ96w247K9hdIUdIxa0yrYRrpxB0KTf0J165dvOaWdHengDACCaMpachfK92g
	 lae3vTLk4OWwZOzaYJcBHlBiHWRYF7qqOhokQm00V211jQNO1T0aZ2QLjNoHz90KiU
	 MDZVk/Uen9Fg0EYGP7lDjfolY5/QS9ZScSKil22c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgCMXpI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 19:45:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbgCMXpI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Mar 2020 19:45:08 -0400
Subject: Re: [GIT PULL] SCSI fixes for 5.6-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584143107;
        bh=Kxau0moSAMYSWiLcpmT3YowaPzatf5NFeuKADxdAf2M=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=1cgSFqo2oAgVAq8LFQXigb2JPX3MOKB3jSzs7ahKTZ9h/7im7bawJdiCNAI16Wk6j
         9JDccKFZEWdytAg73zJMqY7d2e+wZnWDulT/BzzeY19utGgX0W+009EU1HThPjW4Zz
         /m+hQlPvcYCzqV83mDzNrUzxA+Pk5p9Xzn2Gws2E=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1584141787.20167.3.camel@HansenPartnership.com>
References: <1584141787.20167.3.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1584141787.20167.3.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 394b61711f3ce33f75bf70a3e22938464a13b3ee
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fffb08b37df928475fef9c7f2aafddc2f6ebfaf4
Message-Id: <158414310781.22111.18203643165756736516.pr-tracker-bot@kernel.org>
Date:   Fri, 13 Mar 2020 23:45:07 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 13 Mar 2020 16:23:07 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fffb08b37df928475fef9c7f2aafddc2f6ebfaf4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
