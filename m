Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B54C1C61DA4
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Mar 2023 13:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCMNEI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 09:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjCMNEG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 09:04:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A8F64A8E
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2023 06:04:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32C64612B1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2023 13:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A510C43444;
        Mon, 13 Mar 2023 13:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678712642;
        bh=KiZAZPhCFjO37PLs+/BHhU8ZYSfGoR9+8cO1+apkZt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QpEG+UZWxilQIRQXc1oB2F7yOSTudVNzEh6zWUrZJOlAiOxCZhYYd8yTmuqBDSZFY
         Ltd88YpdQOjWh8phEcVEBzLc8c6n84NSoikUixxxYghNWtcEpTHKPlxHFKe6hNntBA
         ZU/q+s4oQdW2WdQ5J5I7qR759dBHcfOhl+d8sZ9jJKid6t3DqB/10v3BmjY+PbJAtg
         2Dw1AYXdZRCqSa0wX522LoRkymw09Ah5BOgRY55gwOZd8Qek/ReU8cN/3PJGwAbwMw
         cqPZ1gaB5nRAhEVPzD4opT3hl8b9bs+WzyTfwO6aB6Yq1nZxfq9ftqtU8MQj9T6ddm
         pEuxHzWLfg5wg==
Date:   Mon, 13 Mar 2023 15:03:59 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 06/82] RDMA/srp: Declare the SCSI host template const
Message-ID: <20230313130359.GB185087@unreal>
References: <20230309192614.2240602-1-bvanassche@acm.org>
 <20230309192614.2240602-7-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309192614.2240602-7-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 09, 2023 at 11:24:58AM -0800, Bart Van Assche wrote:
> Make it explicit that the SRP host template is not modified.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
