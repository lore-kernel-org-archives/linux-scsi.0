Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E9C7C2FC0E
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 11:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350316AbjHQLbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 07:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350335AbjHQLam (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 07:30:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8824730ED;
        Thu, 17 Aug 2023 04:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BAAF645C9;
        Thu, 17 Aug 2023 11:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB699C433C8;
        Thu, 17 Aug 2023 11:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692271800;
        bh=9iBX8eFneX6qmfZrwbciUSeBSx9wphMtbzaqOc1osH4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ivUXrD2PK4g+Qf8EhfLT3X34j40bqLsHWWW92PoUjMkq+HAvMQXRtxec5E2YgH/yl
         ZlRoDcwfmtxr6/AYldCesxSHmAB2yefZbyRb2OG1xkeTxbAkucjliRhxizohdepULe
         7W/o2hqJMN/Vpsz3yCsQPkl6rq71a2Y/4ejNMH8cYL95UaEyJ842KZMGGyBD/iC3tL
         KCvjPyw2QTqlZKgg0gyT7Ukrx9w/iXcXvBj59tPJIRIFWq9bulXtJ/fOvzWim5oLaI
         xvXfXmZYhWOXnrcCM0at/tRnr6Mn1kC+4gm6pu7C1DU4oLEHhPEGISdyJct5h99rKF
         jzV+aW00Uuu1g==
Message-ID: <7cb19c97-e18b-9cb3-d7f4-489d8f01f5d1@kernel.org>
Date:   Thu, 17 Aug 2023 20:29:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 10/17] scsi: scsi_debug: Support injecting unaligned
 write errors
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-11-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230816195447.3703954-11-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 04:53, Bart Van Assche wrote:
> Allow user space software, e.g. a blktests test, to inject unaligned
> write errors.
> 
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research

