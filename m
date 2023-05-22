Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F26C7EE2E
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 23:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbjEVXMc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 19:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjEVXMb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 19:12:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A465EA7;
        Mon, 22 May 2023 16:12:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 397C762CA5;
        Mon, 22 May 2023 23:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2B6C433D2;
        Mon, 22 May 2023 23:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684797149;
        bh=99kPGD3M7DQzlajQDUrP8KoLC8rGnM1kR91USoH29aw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=g6YvxGgM1XECOca1RBlSuAMOQBCyvnnMhoT0ulF9OStij6dDQWuk87L6KvKX3Aw//
         Je3MDR71outThUTIA0kwih/RioU5SxL+15TZw2cl2pJBgIqUFDyf/XBc7dQdfVcS/q
         BbjRSyiFEtTOrbTn5jSENaUVpGdsdFEJy7miP1iA6rIiydBlY1ynKBJs9qd67juW4j
         vSjbkjmk6h3IMbdGtPZCC99byFri2CMoNBcnlhjGb9hKZMKmTa53TIuqZv5GIsZMSy
         dprucPPyxHJu/Tw37hH+1hWvRBwIWDRHcn+QItu8Pk2dbDQzJwlwrvc2KOh/I/WXw5
         F7Bt+rDOagnzA==
Message-ID: <dfbe04fc-7884-7cee-70ad-5fadac18a575@kernel.org>
Date:   Tue, 23 May 2023 08:12:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 00/19] Add Command Duration Limits support
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Niklas Cassel <nks@flawful.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230511011356.227789-1-nks@flawful.org>
 <yq1h6s4nix8.fsf@ca-mkp.ca.oracle.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <yq1h6s4nix8.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/23 06:41, Martin K. Petersen wrote:
> 
> Niklas,
> 
>> This series adds support for Command Duration Limits.
> 
> Applied to 6.5/scsi-staging, thanks!
> 

Thanks Martin !


-- 
Damien Le Moal
Western Digital Research

