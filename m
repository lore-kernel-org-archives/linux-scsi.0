Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E4F9C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 07:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25E8320727
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 07:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgEOH5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 03:57:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:43690 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726665AbgEOH5a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 May 2020 03:57:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1E1ABABD0;
        Fri, 15 May 2020 07:57:32 +0000 (UTC)
Date:   Fri, 15 May 2020 09:57:28 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v6 03/15] qla2xxx: Simplify the functions for dumping
 firmware
Message-ID: <20200515075728.hiilzcdiel3pepvo@beryllium.lan>
References: <20200514213516.25461-1-bvanassche@acm.org>
 <20200514213516.25461-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514213516.25461-4-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 14, 2020 at 02:35:04PM -0700, Bart Van Assche wrote:
> Instead of passing an argument to the firmware dumping functions that
> tells these functions whether or not to obtain the hardware lock, obtain
> that lock before calling these functions. This patch fixes the following
> recently introduced C=2 build error:
> 
>   CHECK   drivers/scsi/qla2xxx/qla_tmpl.c
> drivers/scsi/qla2xxx/qla_tmpl.c:1133:1: error: Expected ; at end of statement
> drivers/scsi/qla2xxx/qla_tmpl.c:1133:1: error: got }
> drivers/scsi/qla2xxx/qla_tmpl.h:247:0: error: Expected } at end of function
> drivers/scsi/qla2xxx/qla_tmpl.h:247:0: error: got end-of-input
> 
> Cc: Arun Easi <aeasi@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Fixes: cbb01c2f2f63 ("scsi: qla2xxx: Fix MPI failure AEN (8200) handling")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Daniel Wagner <dwagner@suse.de>
