Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A36C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 05:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiDEFyx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 01:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiDEFyx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 01:54:53 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6F6344C4;
        Mon,  4 Apr 2022 22:52:55 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id AD00A68AFE; Tue,  5 Apr 2022 07:52:52 +0200 (CEST)
Date:   Tue, 5 Apr 2022 07:52:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.garry@huawei.com>
Cc:     damien.lemoal@opensource.wdc.com, hch@lst.de,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] libata: Inline ata_qc_new_init() in
 ata_scsi_qc_new()
Message-ID: <20220405055252.GA23698@lst.de>
References: <1649083990-207133-1-git-send-email-john.garry@huawei.com> <1649083990-207133-3-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1649083990-207133-3-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 04, 2022 at 10:53:10PM +0800, John Garry wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> It is a bit pointless to have ata_qc_new_init() in libata-core.c since it
> pokes scsi internals, so inline it in ata_scsi_qc_new() (in libata-scsi.c).
> 
> <Christoph, please provide signed-off-by>
> [jpg, Take Christoph's change from list and form into a patch]
> Signed-off-by: John Garry <john.garry@huawei.com>

Signed-off-by: Christoph Hellwig <hch@lst.de>

Although I still think merging the two patches into one to avoid all
the churn would be much better.
