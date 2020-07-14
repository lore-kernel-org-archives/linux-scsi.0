Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5F5C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 21:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C95F3206F0
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 21:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgGNVrU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbgGNVrT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 17:47:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13DDC061755;
        Tue, 14 Jul 2020 14:47:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15DE515E36717;
        Tue, 14 Jul 2020 14:47:19 -0700 (PDT)
Date:   Tue, 14 Jul 2020 14:47:18 -0700 (PDT)
Message-Id: <20200714.144718.1999288638464825209.davem@davemloft.net>
To:     loberman@redhat.com
Cc:     linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com,
        netdev@vger.kernel.org, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com
Subject: Re: [PATCH] qed (qed_int.c) disable "MFW indication via attention"
 SPAM every 5 minutes 
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1594734629-9969-1-git-send-email-loberman@redhat.com>
References: <1594734629-9969-1-git-send-email-loberman@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 14:47:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Laurence Oberman <loberman@redhat.com>
Date: Tue, 14 Jul 2020 09:50:29 -0400

> This is likely firmware causing this but its starting to annoy customers.
> Change the message level to verbose to prevent the spam.
> Note that this seems to only show up with ISCSI enabled on the HBA via the 
> qedi driver.
> 
> Signed-off-by: Laurence Oberman <loberman@redhat.com>

Please... I asked you to look at recent changes to this driver and use
a Subject line consistent with those changes.

And if I do:

	git shortlog v5.6.. -- drivers/net/ethernet/qlogic/qed

I see commit header lines using "qed: " as the subsystem prefix.

So I have to ask, where in recent changes to this driver did you see
examples of people explicitly mentioning "(qed_int.c)" or other file
names?  Where did you see other changes not having a colon character
separating the subsystem prefix from the one-line description?

Please, format this properly:

	[PATCH net] qed: Disable "MFW indictation via attention" SPAM every 5 minutes

For the future, just look at what other developers are doing rather than
inventing your own formatting.

Thank you.

