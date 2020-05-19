Return-Path: <SRS0=JQ6K=7B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8629FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 15:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D3102075F
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 15:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgESPYE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 11:24:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:42146 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728725AbgESPYE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 May 2020 11:24:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 669E6B26B;
        Tue, 19 May 2020 15:24:05 +0000 (UTC)
Date:   Tue, 19 May 2020 17:24:01 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v7 15/15] qla2xxx: Fix endianness annotations in source
 files
Message-ID: <20200519152401.oh6cewdru3fu7ogd@beryllium.lan>
References: <20200518211712.11395-1-bvanassche@acm.org>
 <20200518211712.11395-16-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518211712.11395-16-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 18, 2020 at 02:17:12PM -0700, Bart Van Assche wrote:
> Fix all endianness complaints reported by sparse (C=2) without affecting
> the behavior of the code on little endian CPUs.

I tried to figure out if with the patch the compiler generates different
object code. Looking through the filtered diff between the two versions
I haven't really found any relevant changes. All looks good.

In case someone wants to look at the diffs:

https://monom.org/data/qla2xxx/qla2xxx-endianness-annotations.diff
https://monom.org/data/qla2xxx/qla2xxx-endianness-annotations-filtered.diff

Reviewed-by: Daniel Wagner <dwagner@suse.de>
