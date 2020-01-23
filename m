Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D25E9C33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 08:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE9CD217F4
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 08:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgAWIIk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 03:08:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:42196 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgAWIIk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 03:08:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7B2B3ACD7;
        Thu, 23 Jan 2020 08:08:38 +0000 (UTC)
Date:   Thu, 23 Jan 2020 09:08:37 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>
Subject: Re: [PATCH v2 1/6] qla2xxx: Check locking assumptions at runtime in
 qla2x00_abort_srb()
Message-ID: <20200123080837.2ibhgjtjvgibqowf@beryllium.lan>
References: <20200123042345.23886-1-bvanassche@acm.org>
 <20200123042345.23886-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123042345.23886-2-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 22, 2020 at 08:23:40PM -0800, Bart Van Assche wrote:
> Document the locking assumptions this function relies on and also verify these
> locking assumptions at runtime.
> 
> Acked-by: Himanshu Madhani <hmadhani@marvell.com>
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Daniel Wagner <dwagner@suse.de>
