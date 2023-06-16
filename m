Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B760EB64D7
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jun 2023 07:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244598AbjFPHUJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jun 2023 03:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbjFPHUH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2023 03:20:07 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279861FF7
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jun 2023 00:20:07 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 864B16732D; Fri, 16 Jun 2023 09:20:04 +0200 (CEST)
Date:   Fri, 16 Jun 2023 09:20:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v8 21/33] scsi: Have scsi-ml retry scsi_mode_sense UAs
Message-ID: <20230616072004.GG29882@lst.de>
References: <20230614071719.6372-1-michael.christie@oracle.com> <20230614071719.6372-22-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614071719.6372-22-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 14, 2023 at 02:17:07AM -0500, Mike Christie wrote:
> This has scsi_mode_sense have scsi-ml retry UAs instead of driving them
> itself.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
