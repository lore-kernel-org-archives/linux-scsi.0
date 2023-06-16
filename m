Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31243EB64D8
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jun 2023 07:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243483AbjFPHT3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jun 2023 03:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbjFPHT1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2023 03:19:27 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC0E170E
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jun 2023 00:19:27 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 73FAD6732D; Fri, 16 Jun 2023 09:19:24 +0200 (CEST)
Date:   Fri, 16 Jun 2023 09:19:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v8 19/33] scsi: ch: Remove unit_attention
Message-ID: <20230616071924.GE29882@lst.de>
References: <20230614071719.6372-1-michael.christie@oracle.com> <20230614071719.6372-20-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614071719.6372-20-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
