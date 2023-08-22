Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43FFEE4996
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 05:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbjHVFwX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 01:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbjHVFwW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 01:52:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5403F199
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 22:52:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1B6E61122
        for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2023 05:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1672C433C8;
        Tue, 22 Aug 2023 05:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692683535;
        bh=wBDsmtjjIuZYRyhm+GeZPyBHWJEfetyFyHEJ/wpD0lM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=BjzSpjxr1duP4vFKRG9v5G0+54X9c0FqajsK9abZJnc1i2DjwkJJcaDYQQm/xBvyN
         yf+UVLD2QcTBOHobagCyCWvDqineaRSEVJYW2ub2dSPOcI0h6VnjK/a90V7ZhaaPRA
         r0iRF8fyaO71WYN8wW9FXyZ+WkWptHNmLAYmcS9luFzIfkbykmZ/k4eMMovkRpO6EE
         Rva6BQ1YoZ+TrWCuyenfq4b01kR7bpBYHT55YK+jbiMg/iNxdAdx+ijxsfgjDC55t/
         If5U2LrM7lcQAWlpKkK8j9KCaubFpzNoxzghLlApA5z8FlVU2X66eHT/BKMNavNgxT
         9R7QeALef+5Dg==
Message-ID: <9badf5d0-a813-a92a-e72b-f4b2b9b65fcd@kernel.org>
Date:   Tue, 22 Aug 2023 14:52:12 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] scsi: core: Report error list information in debugfs
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230821204101.3601799-1-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230821204101.3601799-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/22/23 05:41, Bart Van Assche wrote:
> Provide information in debugfs about SCSI error handling to make it
> easier to debug the SCSI error handler. Additionally, report the maximum
> number of retries in debugfs (.allowed).
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

