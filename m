Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9D8CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 15:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A108E222C5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 15:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571411709;
	bh=jNLABWjdm0lERQlbQaO8fyozWi8+O01RCDuUO8w3hBU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=pTs8eYnBXwD+QfhCDcjDaXXdD7/U75PK6NRzLbqY0DrpTl8Hmq72X62W6WxnFOoi/
	 woT+qUqfWXlbmIr0Uc34ryrmS5UG1xQtJPDBv0LHPL32a1Wc0AL3GT1/EjqpT6JEpY
	 BTNTnzv9ndUyP6uHZyu5QdUzUk+EbYmatqeChKyI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439613AbfJRPPG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 11:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733157AbfJRPPF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 11:15:05 -0400
Subject: Re: Re: [GIT PULL] SCSI fixes for 5.4-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571411705;
        bh=jNLABWjdm0lERQlbQaO8fyozWi8+O01RCDuUO8w3hBU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=mHvotsD3yWC17n5mSzoYhyGQgIjnJZavJnpkCl5pp/OyFXhamwu26eCJ+csa15tYu
         ahGtpeRNPAiPXme+NNWsaFvvQB4vChc7GbggOSTinm8CeXVLWGGAhZMqJ8Ip0H1sch
         0w7M91ACc+U+P9zek21HDJkY7h5p0AH7jf2bBmcA=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <yq1pniui429.fsf@oracle.com>
References: <1571166922.15362.19.camel@HansenPartnership.com>
 <20191018103540.GC3885@osiris> <yq1pniui429.fsf@oracle.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <yq1pniui429.fsf@oracle.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
 tags/mkp-scsi-postmerge
X-PR-Tracked-Commit-Id: 6b6fa7a5c86e1269d9f0c9a5b902072351317387
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c3419fd6d3a340d23329ce01bb391deb27d8368b
Message-Id: <157141170516.31281.12971067228491407598.pr-tracker-bot@kernel.org>
Date:   Fri, 18 Oct 2019 15:15:05 +0000
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steffen Maier <maier@linux.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 18 Oct 2019 09:19:42 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git tags/mkp-scsi-postmerge

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c3419fd6d3a340d23329ce01bb391deb27d8368b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
