Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3F8C54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 23:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E49620781
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 23:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587771025;
	bh=ISuRq13IYKhDPE2J7pCl085V6rP+LvrWMY2++avaavU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=Qzn1Ichrhcr4wQ+lL3Da/309RIeqrRiRxL0CPX7TV6SyXG3f+s1Dkl8tvpd2oQ7DQ
	 tz5UGSS06bewdXTZfz/sfdJ4ODSUDAftKJddUmDkonkfvvD51i6YXp9I3VKaHAAaOl
	 1EQK61hDTvovoXpkW1XoPWcYtIeqjJan3X+5HMo0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgDXXaT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 19:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgDXXaT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 19:30:19 -0400
Subject: Re: [GIT PULL] SCSI fixes for 5.7-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587771019;
        bh=ISuRq13IYKhDPE2J7pCl085V6rP+LvrWMY2++avaavU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=WnxUJX2dqkZvTLg1jZRkVxAMJMwjip+RCJhbjP3lYM9p2q5MY5glrMJ2mJA780Abt
         qAIhAd3Qt8+690wq0UTcDr7qJKylAWzDXfGbVpjfMRuUmdf1j9K1B1TJ+G/gLXvVhB
         zPl5lHuil6xmW3HFg7LGYjFOg9NDYrIAeequQjcU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1587766958.4513.19.camel@HansenPartnership.com>
References: <1587766958.4513.19.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1587766958.4513.19.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: fa17a6dc84d1eb6b62bcf981a4ddcc966b1a2c04
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5ef58e29078261ef5195c7fee74768546b863182
Message-Id: <158777101896.26626.5023469776276987063.pr-tracker-bot@kernel.org>
Date:   Fri, 24 Apr 2020 23:30:18 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 24 Apr 2020 15:22:38 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5ef58e29078261ef5195c7fee74768546b863182

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
