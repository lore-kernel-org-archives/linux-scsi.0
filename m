Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A70EC25B0F
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Aug 2022 21:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240139AbiHMVsN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 13 Aug 2022 17:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240126AbiHMVsL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Aug 2022 17:48:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0B025E90;
        Sat, 13 Aug 2022 14:48:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52B38B80ACA;
        Sat, 13 Aug 2022 21:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF187C433C1;
        Sat, 13 Aug 2022 21:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660427287;
        bh=w01MTOJAXMx0A0gnLiCYME8/dgjk9cw1LhnBpPsuFjo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ezsFT7GP/HC4kUOBomJ2F2KeWn3jeZJHl0jmgcmBb5PiALSnoyRGXBBF3hgDlkSkN
         exFgecx8HXI/wwTKC8686wSScOR03aO9dC+gJe0/C18GMOZZSdJTFLcghO5uQHZ6hE
         LQIg9sScQS0mlRQQz+g9Cu8o+JphHGlwpEwGNdeNBPUTj9KC9b5LLc6KSjEA7HAQqk
         2Q176AUTm4A7e50MGDLKYZyYhHRWh6Pbq0iF9/BNdAN0tYBH5VTyeto0N4SGTtyqJM
         engQYozvt3lQQds5NwKVPWRRDwQlnTIQRtmNkX0eavb88Q9fT6AVJy8L2Qv/TgTn7V
         IETZGjCRw/UYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD0FAC43141;
        Sat, 13 Aug 2022 21:48:07 +0000 (UTC)
Subject: Re: [GIT PULL] final round of SCSI updates for the 5.19+ merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <62ef6e3d028a5182f4485d6201a126bbf4ca659c.camel@HansenPartnership.com>
References: <62ef6e3d028a5182f4485d6201a126bbf4ca659c.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <62ef6e3d028a5182f4485d6201a126bbf4ca659c.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: c6380f9924270d51cc233cfd592b279be3881e6d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e140f731f9807035e967c401198171f316744696
Message-Id: <166042728783.29926.7997145025146579249.pr-tracker-bot@kernel.org>
Date:   Sat, 13 Aug 2022 21:48:07 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 13 Aug 2022 13:55:46 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e140f731f9807035e967c401198171f316744696

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
