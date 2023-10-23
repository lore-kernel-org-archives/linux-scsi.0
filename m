Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76041C25B67
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 23:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjJWX37 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 19:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjJWX37 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 19:29:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FC3CC;
        Mon, 23 Oct 2023 16:29:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D806C433C7;
        Mon, 23 Oct 2023 23:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698103797;
        bh=9c24LECbuPXeKEVYnL+YstwgmWlNRHad3eNIBCp1Gmc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ojf9hLU9ptKRxTwXzXHAHe20sEeSLdVj53PvhsY4PAVRhJ0HP3cMr2ovuClVXPnWO
         gXqUAZCYFluXTqDGWvtcXj9n0qGOHxHAtFqSu31q3e30HznDgAZZG6W84ApDGSSqUd
         FhZkPmG0PcheRh2zmsBSTl/qkXlEwI1eRV7GUM5g5qq9FN7uSHhNCB1gMDdSekFFAY
         RINDbgwcA0AAbMQb+m4+955o9lHXDr1a7dXE0un2Y8XdiAW9f5Zgo2E3OrGSEfb8SM
         pwd+SfYSpGRDpzgftzcdmGznhIkO4Gf+50ksZ1yW5Agy9iOR0en4zTeRjW6ONZLZIN
         WBV7SJKVBsAjg==
Message-ID: <38f1e5f9-f30f-4a11-b1c2-94e06b00cdac@kernel.org>
Date:   Tue, 24 Oct 2023 08:29:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 02/19] block: Only use write locking if necessary
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Ming Lei <ming.lei@redhat.com>
References: <20231023215638.3405959-1-bvanassche@acm.org>
 <20231023215638.3405959-3-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231023215638.3405959-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/23 06:53, Bart Van Assche wrote:
> Make blk_req_needs_zone_write_lock() return false if
> q->limits.use_zone_write_lock is false.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

