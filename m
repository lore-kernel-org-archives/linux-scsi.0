Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CEAC2B9F7
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 10:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D95E61360
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 10:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhEZK2i convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 06:28:38 -0400
Received: from mx2.uni-regensburg.de ([194.94.157.147]:45512 "EHLO
        mx2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbhEZK2f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 06:28:35 -0400
Received: from mx2.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id C2327600005D
        for <linux-scsi@vger.kernel.org>; Wed, 26 May 2021 12:27:02 +0200 (CEST)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
        by mx2.uni-regensburg.de (Postfix) with ESMTP id A37E0600004D
        for <linux-scsi@vger.kernel.org>; Wed, 26 May 2021 12:27:02 +0200 (CEST)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
        with Novell_GroupWise; Wed, 26 May 2021 12:27:02 +0200
Message-Id: <60AE2272020000A100041478@gwsmtp.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 18.3.1 
Date:   Wed, 26 May 2021 12:26:58 +0200
From:   "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To:     <open-iscsi@googlegroups.com>, <thunder.leizhen@huawei.com>,
        <dgilbert@interlog.com>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>
Subject: Aw:  [EXT] Re: [PATCH 1/1] scsi: Fix spelling mistakes in
 header files
References: <20210517095945.7363-1-thunder.leizhen@huawei.com>
 <162200196243.11962.5629932935575912565.b4-ty@oracle.com>
In-Reply-To: <162200196243.11962.5629932935575912565.b4-ty@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

(Amazingly I also did think "busses" is correct -- seems to be a common mistake; maybe only for Germans that would pronounce "busses" differently from "buses"...)


>>> Martin K. Petersen 26.05.2021, 06:08 >>>

On Mon, 17 May 2021 17:59:45 +0800, Zhen Lei wrote:

> Fix some spelling mistakes in comments:
> pathes ==> paths
> Resouce ==> Resource
> retreived ==> retrieved
> keep-alives ==> keep-alive
> recevied ==> received
> busses ==> buses
> interruped ==> interrupted

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: Fix spelling mistakes in header files
https://git.kernel.org/mkp/scsi/c/40d6b939e4df

--
Martin K. Petersen Oracle Linux Engineering

--
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe@googlegroups.com.
To view this discussion on the web visit https://groups.google.com/d/msgid/open-iscsi/162200196243.11962.5629932935575912565.b4-ty%40oracle.com.

