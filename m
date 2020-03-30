Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FCBC2D0EB
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 17:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96E8E20780
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 17:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgC3RMG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Mar 2020 13:12:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39716 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbgC3RMG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Mar 2020 13:12:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5510B15BFD4FD;
        Mon, 30 Mar 2020 10:12:05 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:12:02 -0700 (PDT)
Message-Id: <20200330.101202.660829992934953878.davem@davemloft.net>
To:     skashyap@marvell.com
Cc:     martin.petersen@oracle.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org, jhasan@marvell.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/8] qed/qedf: Firmware recovery, bw update and misc
 fixes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330063034.27309-1-skashyap@marvell.com>
References: <20200330063034.27309-1-skashyap@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:12:05 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


You add the new qed_bw_update() function but nothing invokes it.

Remove this from the patch series until you are submitting changes
that actually use the function.
