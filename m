Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B30C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 16 May 2022 05:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239908AbiEPFth (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 May 2022 01:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiEPFta (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2022 01:49:30 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5504F13D29
        for <linux-scsi@vger.kernel.org>; Sun, 15 May 2022 22:49:29 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D3E6B68BEB; Mon, 16 May 2022 07:49:25 +0200 (CEST)
Date:   Mon, 16 May 2022 07:49:25 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 12/20] aic7xxx: make BUILD_SCSIID() a function
Message-ID: <20220516054925.GA12299@lst.de>
References: <20220512111236.109851-1-hare@suse.de> <20220512111236.109851-13-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512111236.109851-13-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
