Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8581C41513
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 11:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350221AbjHQLWB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 07:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350228AbjHQLVu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 07:21:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4243530C6;
        Thu, 17 Aug 2023 04:21:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBA0E62475;
        Thu, 17 Aug 2023 11:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D76C433C9;
        Thu, 17 Aug 2023 11:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692271308;
        bh=7l2iK0Rl3cNun0w/0hRjyVQ2btmydVcX9txx5+Pem1c=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=LgiaB4lv94RcjIj2BZEpQjpzM7GHa0hfJ/MywvcePSY6QC1gLKmjX86ljIyzBJntc
         lDpV8KYG/f8IlHr2ryhhuEhaXwWC38W8HUoIobXnASGxC6ETXzK/26k816+Odc2ft3
         RCrvKEdH1sbjgDz36F1mP98flJo8IYLxkb9yOz6tXMtAKAmP0isRNrJLuBMN8cvc3t
         5QyeFQEvLQQYMNKPPeqSBlUMHH1bjAdBtZYT2OMiMgGlZO++2I6jTgHHHCN02uni5M
         UVYg3HAMBfBZHW3iN1ImsAU/vWOYWdcelQTzICD/+uPSo0pwlub7OplmFPak+f0rX0
         zoRI6kUKNIRtg==
Message-ID: <ea81b759-c009-ffa0-2883-b6909bc521a4@kernel.org>
Date:   Thu, 17 Aug 2023 20:21:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 08/17] scsi: sd_zbc: Only require an I/O scheduler if
 needed
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-9-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230816195447.3703954-9-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 04:53, Bart Van Assche wrote:
> An I/O scheduler that serializes zoned writes is only needed if the SCSI
> LLD does not preserve the write order. Hence only set
> ELEVATOR_F_ZBD_SEQ_WRITE if the LLD does not preserve the write order.
> 
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

