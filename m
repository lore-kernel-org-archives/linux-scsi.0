Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C736C07E96
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 05:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DAF26198D
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 05:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhGFFlG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 01:41:06 -0400
Received: from verein.lst.de ([213.95.11.211]:59159 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230004AbhGFFlG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Jul 2021 01:41:06 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CA00568BEB; Tue,  6 Jul 2021 07:38:25 +0200 (CEST)
Date:   Tue, 6 Jul 2021 07:38:25 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Don Brace <don.brace@microchip.com>,
        James Smart <james.smart@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH V2 4/6] scsi: set shost->use_managed_irq if driver uses
 managed irq
Message-ID: <20210706053825.GB17027@lst.de>
References: <20210702150555.2401722-1-ming.lei@redhat.com> <20210702150555.2401722-5-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702150555.2401722-5-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Only megaraid_sas actually ever uses more than a single blk-mq
queue, so this looks weird?
