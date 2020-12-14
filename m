Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D008C2BB48
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F20F0225AC
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439358AbgLNQYN convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 11:24:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440030AbgLNQYJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Dec 2020 11:24:09 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73CE822795;
        Mon, 14 Dec 2020 16:23:27 +0000 (UTC)
Date:   Mon, 14 Dec 2020 11:23:25 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Several changes for the UPIU trace
Message-ID: <20201214112325.464a2cb0@gandalf.local.home>
In-Reply-To: <20201214161502.13440-1-huobean@gmail.com>
References: <20201214161502.13440-1-huobean@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 14 Dec 2020 17:14:56 +0100
Bean Huo <huobean@gmail.com> wrote:

> From: Bean Huo <beanhuo@micron.com>
> 
> Changelog:
> 
> V1--V2:
>   1. Convert __get_str(str) to __print_symbolic()
>   2. Add new patches 1/6, 2/6,3/6
>   3. Use __print_symbolic() in patch 6/6
> 
> Bean Huo (6):
>   scsi: ufs: Remove stringize operator '#' restriction
>   scsi: ufs: Use __print_symbolic() for UFS trace string print
>   scsi: ufs: Don't call trace_ufshcd_upiu() in case trace poit is
>     disabled
>   scsi: ufs: Distinguish between query REQ and query RSP in query trace
>   scsi: ufs: Distinguish between TM request UPIU and response UPIU in TM
>     UPIU trace
>   scsi: ufs: Make UPIU trace easier differentiate among CDB, OSF, and TM
> 
>  drivers/scsi/ufs/ufs.h     |  17 ++++++
>  drivers/scsi/ufs/ufshcd.c  |  72 ++++++++++++++++---------
>  include/trace/events/ufs.h | 108 +++++++++++++++++++++++--------------
>  3 files changed, 131 insertions(+), 66 deletions(-)
> 

From a tracing point of view for the series.

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
