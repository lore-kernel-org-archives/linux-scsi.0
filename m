Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B80C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 06:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237522AbiFNGoO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jun 2022 02:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbiFNGoH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2022 02:44:07 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC775381BB;
        Mon, 13 Jun 2022 23:44:06 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D91B468AA6; Tue, 14 Jun 2022 08:44:03 +0200 (CEST)
Date:   Tue, 14 Jun 2022 08:44:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com, brking@us.ibm.com,
        hare@suse.de, hch@lst.de, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, chenxiang66@hisilicon.com
Subject: Re: [PATCH RFC v2 02/18] scsi: core: Resurrect
 scsi_{get,free}_host_dev()
Message-ID: <20220614064403.GB31683@lst.de>
References: <1654770559-101375-1-git-send-email-john.garry@huawei.com> <1654770559-101375-3-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1654770559-101375-3-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 09, 2022 at 06:29:03PM +0800, John Garry wrote:
> This reverts commit 6bd49b1a8d43ec118c55f3aaa7577729b52bde15.

Please add an actual text describing why you are doing this and how
insteasd of this completely pointless revert line.

