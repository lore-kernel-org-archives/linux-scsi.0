Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDE4C32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 19:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3738A2054F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 19:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565724312;
	bh=vNQ+joMke2dm7yF3Ggx7RmIRhAahrYe5k3lhvhMoqHI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=CYN0TmSfQEAYc7NyefzHSK2j6bzgV6vYDfndSZD6zDT0mMTPpm9CAQQjbZ4zfeYx4
	 rqJEnIdl5l+VjP9Q/EbUf/O+rpGGprskXw0pOsRukCYe/g0oSR71Ji7oPw8Ovr1ba8
	 eLXrmA88q4MdDazuVKfCpST5RwQKINo6sve/MF88=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfHMTZI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 15:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbfHMTZH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Aug 2019 15:25:07 -0400
Subject: Re: [GIT PULL] SCSI fixes for 5.3-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565724307;
        bh=vNQ+joMke2dm7yF3Ggx7RmIRhAahrYe5k3lhvhMoqHI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ST24tBVW3by8A7O9v5VdoRi+7Rz0W3ZBYRr461wtNP1AFosVX/X6/FHfx7I5cgDwq
         OVp0sd/xMSZsdu/TJe7JkF3NKC85EwpBBQy6+d8fsJ2PrH7l1qJ3/p5eU9vSTn2s2S
         BIjKvKmmuNPQ++S4o+nFg04Uplri+4lxFwH2zefo=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1565691473.3371.4.camel@HansenPartnership.com>
References: <1565691473.3371.4.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1565691473.3371.4.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: a86c71ba3022331f79662d7f12d1b25188c7e377
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 60a8db790255a6bebcdc41d97e8084a440398206
Message-Id: <156572430747.27765.2413663810950001658.pr-tracker-bot@kernel.org>
Date:   Tue, 13 Aug 2019 19:25:07 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Tue, 13 Aug 2019 12:17:53 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/60a8db790255a6bebcdc41d97e8084a440398206

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
