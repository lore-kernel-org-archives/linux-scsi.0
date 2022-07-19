Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E53C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 22:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbiGSWRV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 18:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGSWRU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 18:17:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ECD53D1D
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 15:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53BAE61B48
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 22:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18A1C341C6;
        Tue, 19 Jul 2022 22:17:17 +0000 (UTC)
Date:   Tue, 19 Jul 2022 18:17:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arun Easi <aeasi@marvell.com>
Cc:     Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: Re: [EXT] Re: [PATCH 2/6] qla2xxx: Add a generic tracing framework
Message-ID: <20220719181716.107c6eb0@gandalf.local.home>
In-Reply-To: <782837dd-5eb2-c7dd-7cc1-25ca97806830@marvell.com>
References: <20220715060227.23923-1-njavali@marvell.com>
        <20220715060227.23923-3-njavali@marvell.com>
        <20220718085438.mdv3rnbwc4bxfxrd@carbon.lan>
        <f49cd5a0-93b8-48a2-5a3a-a4554ef660ac@marvell.com>
        <20220718152243.21ad13e7@gandalf.local.home>
        <259d53a5-958e-6508-4e45-74dba2821242@marvell.com>
        <20220719174056.56d39d87@gandalf.local.home>
        <782837dd-5eb2-c7dd-7cc1-25ca97806830@marvell.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 19 Jul 2022 15:09:30 -0700
Arun Easi <aeasi@marvell.com> wrote:

> This will be nice.
> 
> Thanks for your help, Steve.

No problem.

What a coincidence that I just finished this work earlier this month.

-- Steve
