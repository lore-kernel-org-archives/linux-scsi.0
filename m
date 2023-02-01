Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D15C636D4
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Feb 2023 20:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjBAU6k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Feb 2023 15:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBAU6j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2023 15:58:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AB5761C7;
        Wed,  1 Feb 2023 12:58:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 705D261967;
        Wed,  1 Feb 2023 20:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A12CC433D2;
        Wed,  1 Feb 2023 20:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675285081;
        bh=Adh5ghEwbtw8I0OWfEKdrV1inFBmY1+szV6y0YMD0FM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XFnypkpf/V5hXxajTi1c+6K9bhgXqEOQZzYcuOB/XchCBWD/VGA+G/8pjrmeZH/Dl
         1274ZLRTQKbf8JUXsAqORPrMJ5LeJAk+ACffQ1ptQTW4SkmNg7Xsb0RZ5g8C0YmuBW
         Qfmai7R0V/YkbjD0JDx1OuQxltOs40MAzx/6gpZucEi1v5pg6GGmQIitypsj5RDCdI
         CJOlNH6B/Rc4hrBYXH9OZ3g9XEnw2/0Vvmqi2TyYK3v8lTXG5iahWGZEB/BypYk/+i
         R7WOTii1mp+GFvdLTJcBECf8k8LJQya69nBRPMjdr/GlbX8oW+42ZvU2GQVKO4On9r
         IHJ1zoKSZ4VHw==
Date:   Wed, 1 Feb 2023 12:58:00 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>,
        Pankaj Raghav <p.raghav@samsung.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v4 1/7] block: Introduce blk_mq_debugfs_init()
Message-ID: <20230201205800.t3gpx7w3aw2ozab7@garbanzo>
References: <20230130212656.876311-1-bvanassche@acm.org>
 <20230130212656.876311-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130212656.876311-2-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 30, 2023 at 01:26:50PM -0800, Bart Van Assche wrote:
> Move the code for creating the block layer debugfs root directory into
> blk-mq-debugfs.c. This patch prepares for adding more debugfs
> initialization code by introducing the function blk_mq_debugfs_init().
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
