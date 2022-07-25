Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9920DC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jul 2022 13:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbiGYN4s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jul 2022 09:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiGYN4r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jul 2022 09:56:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DF512D32;
        Mon, 25 Jul 2022 06:56:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D379611D4;
        Mon, 25 Jul 2022 13:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B3AC341C6;
        Mon, 25 Jul 2022 13:56:43 +0000 (UTC)
Date:   Mon, 25 Jul 2022 09:56:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Steffen Maier <maier@linux.ibm.com>
Cc:     Arun Easi <aeasi@marvell.com>, Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, bhazarika@marvell.com,
        agurumurthy@marvell.com, Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [EXT] Re: [PATCH 2/6] qla2xxx: Add a generic tracing framework
Message-ID: <20220725095641.40619653@gandalf.local.home>
In-Reply-To: <723e67b1-96b1-c691-78fb-7b86758a7092@linux.ibm.com>
References: <20220715060227.23923-1-njavali@marvell.com>
        <20220715060227.23923-3-njavali@marvell.com>
        <20220718085438.mdv3rnbwc4bxfxrd@carbon.lan>
        <f49cd5a0-93b8-48a2-5a3a-a4554ef660ac@marvell.com>
        <20220718152243.21ad13e7@gandalf.local.home>
        <20220719082514.egsqevbaxl7a4prx@carbon.lan>
        <65df89cd-0f86-9d11-2f31-da6b6e4a1de2@marvell.com>
        <723e67b1-96b1-c691-78fb-7b86758a7092@linux.ibm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 23 Jul 2022 09:47:21 +0200
Steffen Maier <maier@linux.ibm.com> wrote:

> The crash extension "ftrace" is probably able to do an export from dump for the 
> approach Steven suggested. I had used it with kernel function tracer. Very useful.

Note, the crash extension is just called "trace" and you can get it here:

  https://github.com/fujitsu/crash-trace

-- Steve
