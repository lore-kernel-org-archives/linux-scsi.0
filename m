Return-Path: <SRS0=wQ7u=5W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABCBC2BA18
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Apr 2020 07:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73DB32075E
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Apr 2020 07:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgDFHjM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Apr 2020 03:39:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:45426 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgDFHjM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Apr 2020 03:39:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4EEB9ADEB;
        Mon,  6 Apr 2020 07:39:10 +0000 (UTC)
Date:   Mon, 6 Apr 2020 09:39:09 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH] qla2xxx: Increase the size of struct qla_fcp_prio_cfg to
 FCP_PRIO_CFG_SIZE
Message-ID: <20200406073909.3sd634h27as5cnbg@beryllium.lan>
References: <20200405231339.29612-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200405231339.29612-1-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Sun, Apr 05, 2020 at 04:13:39PM -0700, Bart Van Assche wrote:
> This patch fixes the following Coverity complaint without changing any
> functionality:
> 
> CID 337793 (#1 of 1): Wrong size argument (SIZEOF_MISMATCH)
> suspicious_sizeof: Passing argument ha->fcp_prio_cfg of type
> struct qla_fcp_prio_cfg * and argument 32768UL to function memset is
> suspicious because a multiple of sizeof (struct qla_fcp_prio_cfg) /*48*/
> is expected.
> 
> memset(ha->fcp_prio_cfg, 0, FCP_PRIO_CFG_SIZE);
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <hmadhani@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks good to me.

Reviewed-by: Daniel Wagner <dwagner@suse.de>

Thanks,
Daniel
