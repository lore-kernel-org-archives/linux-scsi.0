Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98580C43603
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 08:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 730B8206A5
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 08:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfLPIhL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 03:37:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:37120 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726077AbfLPIhL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Dec 2019 03:37:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 64439AD31;
        Mon, 16 Dec 2019 08:37:09 +0000 (UTC)
Date:   Mon, 16 Dec 2019 09:37:07 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     Martin Wilck <mwilck@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, linux@yadro.com
Subject: Re: [PATCH 3/4] qla2xxx: Fix point-to-point mode for qla25xx and
 older
Message-ID: <20191216083707.zecfn346ogxpq4s6@beryllium.lan>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-4-bvanassche@acm.org>
 <fdff60ffaacad1b3a850942f61bdd92ab5bc6d12.camel@suse.de>
 <20191212200720.wbq2en3pnnpegrij@SPB-NB-133.local>
 <20191214010400.r6ord53kwbh2lmlm@SPB-NB-133.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191214010400.r6ord53kwbh2lmlm@SPB-NB-133.local>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Roman,

On Sat, Dec 14, 2019 at 04:04:00AM +0300, Roman Bolshakov wrote:
> I have noticed the issue only when I use SLE15 as initiator (I haven't
> tried centos/rhel kernels yet). SLE15 initiator sends PLOGI multiple
> times by a reason unknown to me in spite of LS_ACC response from target
> on each PLOGI.

The currently released SLE15 kernel runs still an older version of the
qla2xxx driver. Though we have backported the current qla2xxx driver
for the next version of SLE15.

Thanks,
Daniel
