Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2499CEB64D7
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jun 2023 07:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbjFPHY1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jun 2023 03:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233756AbjFPHYQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2023 03:24:16 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469D31FF7
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jun 2023 00:24:15 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id AEC096732D; Fri, 16 Jun 2023 09:24:12 +0200 (CEST)
Date:   Fri, 16 Jun 2023 09:24:12 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v8 33/33] scsi: Add kunit tests for
 scsi_check_passthrough
Message-ID: <20230616072412.GD30104@lst.de>
References: <20230614071719.6372-1-michael.christie@oracle.com> <20230614071719.6372-34-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614071719.6372-34-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 14, 2023 at 02:17:19AM -0500, Mike Christie wrote:
>  EXPORT_SYMBOL(scsi_get_sense_info_fld);
> +
> +#if defined(CONFIG_SCSI_KUNIT_TEST)

#ifdef?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
