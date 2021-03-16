Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EEF1C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 08:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 589DB64FA1
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 08:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbhCPIpe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 04:45:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:37654 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231538AbhCPIpc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Mar 2021 04:45:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1120AAE6D;
        Tue, 16 Mar 2021 08:45:31 +0000 (UTC)
Date:   Tue, 16 Mar 2021 09:45:30 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH 6/7] qla2xxx: Simplify qla8044_minidump_process_control()
Message-ID: <20210316084530.z4rvf5l4nezhjox3@beryllium.lan>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-7-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316035655.2835-7-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 15, 2021 at 08:56:54PM -0700, Bart Van Assche wrote:
> This patch fixes the following Coverity complaint:
> 
>     CID 177490 (#1 of 1): Unused value (UNUSED_VALUE)
>     assigned_value: Assigning value from opcode & 0xffffff7fU to opcode
>     here, but that stored value is overwritten before it can be used.
> 
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Daniel Wagner <dwagner@suse.de>

