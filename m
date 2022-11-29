Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CCBC4321E
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Nov 2022 13:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiK2N2M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Nov 2022 08:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbiK2N2L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2022 08:28:11 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3E31E720;
        Tue, 29 Nov 2022 05:28:09 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id AF80A6732D; Tue, 29 Nov 2022 14:28:05 +0100 (CET)
Date:   Tue, 29 Nov 2022 14:28:05 +0100
From:   "hch@lst.de" <hch@lst.de>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] block/scsi/nvme: Add error codes for PR ops
Message-ID: <20221129132805.GA13061@lst.de>
References: <20221122032603.32766-1-michael.christie@oracle.com> <yq1o7sumo0c.fsf@ca-mkp.ca.oracle.com> <538bcade-c453-e6f8-4530-808a9bf2140a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538bcade-c453-e6f8-4530-808a9bf2140a@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 29, 2022 at 04:18:19AM +0000, Chaitanya Kulkarni wrote:
> > Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> > 
> 
> perhaps a block tree since it has block/scsi/nvme ?

I think Mike has SCSI work that builds on top of this, and reservations
ar originally a SCSI feature.  But either block or scsi is fine with
me.

