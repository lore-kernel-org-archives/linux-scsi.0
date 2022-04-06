Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1379EC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 12:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbiDFMYA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 08:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbiDFMXH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 08:23:07 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD3C54275F;
        Wed,  6 Apr 2022 01:11:46 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 207E168BEB; Wed,  6 Apr 2022 10:11:43 +0200 (CEST)
Date:   Wed, 6 Apr 2022 10:11:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.garry@huawei.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] libata: Inline ata_qc_new_init() in
 ata_scsi_qc_new()
Message-ID: <20220406081142.GA13272@lst.de>
References: <1649083990-207133-1-git-send-email-john.garry@huawei.com> <1649083990-207133-3-git-send-email-john.garry@huawei.com> <20220405055252.GA23698@lst.de> <f7bbb09f-562f-fce2-cd16-a1c67fc334b5@opensource.wdc.com> <febb03e4-ea1d-c7e1-58a6-fa564c902af0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <febb03e4-ea1d-c7e1-58a6-fa564c902af0@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 06, 2022 at 08:16:25AM +0100, John Garry wrote:
> Anyway, if that is the preference then who shall be the author? Considering 
> I did most effort I will be and add Christoph as co-developed-by - please 
> let me know if not ok.

I think the co-developed-by is a bit silly.  Just attribute it to you.
