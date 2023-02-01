Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1F1C05027
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Feb 2023 21:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjBAVXi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Feb 2023 16:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBAVXg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2023 16:23:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F92402CF;
        Wed,  1 Feb 2023 13:23:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1226861977;
        Wed,  1 Feb 2023 21:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29467C433D2;
        Wed,  1 Feb 2023 21:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675286614;
        bh=8S3kW7VseP07P/lxfoWYDP5EGGcIyCY/ePp03k1co4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dnR4BvUqNgZ9Es7tRxePeHwA4MZJwqBCqPr8t5FdjcZViSUwLT0SXshYvDJCsZRCI
         WBQmre/jClwtpjVXgNx6R0/aUShDoxIoQgUwVQAa1UKEdjqQSwnozJ0aW8zBIwKUPM
         Id+dY4RrFzRzzlZ1QLmUr3i4PvQuW0KnAPMbtxngJR/EgvLZDReSXAkG58ZfbigZIB
         Y4+yp5l9q9D8QljTxkYR3Z4zjCZBU+L7X43YRe9IMv5nzdP6O+LU8rITkgPwiH0nBR
         FaKWZKD8D4yvYBkYw6pfdWQoDjdgpdykV+FNXmif9hsEqSJ7BnewPjV062qr/SKaKX
         HFvMenQN5QsIQ==
Date:   Wed, 1 Feb 2023 13:23:32 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>,
        Pankaj Raghav <p.raghav@samsung.com>, mcgrof@kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v4 1/7] block: Introduce blk_mq_debugfs_init()
Message-ID: <20230201212332.p3mdb5ab3qisuo2x@garbanzo>
References: <20230130212656.876311-1-bvanassche@acm.org>
 <20230130212656.876311-2-bvanassche@acm.org>
 <20230201205800.t3gpx7w3aw2ozab7@garbanzo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201205800.t3gpx7w3aw2ozab7@garbanzo>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 01, 2023 at 12:58:00PM -0800, Luis Chamberlain wrote:
> On Mon, Jan 30, 2023 at 01:26:50PM -0800, Bart Van Assche wrote:
> > Move the code for creating the block layer debugfs root directory into
> > blk-mq-debugfs.c. This patch prepares for adding more debugfs
> > initialization code by introducing the function blk_mq_debugfs_init().
> > 
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Ming Lei <ming.lei@redhat.com>
> > Cc: Keith Busch <kbusch@kernel.org>
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

Sorry but actually a neuron triggered after this to remind me of commit
85e0cbbb8a  ("block: create the request_queue debugfs_dir on
registration") and so using the terminology on that commit, wouldn't
this not create now the root block debugfs dir for request-based block
drivers?

  Luis
