Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D98C9C77B71
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Apr 2023 02:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjDOCip (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Apr 2023 22:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDOCio (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Apr 2023 22:38:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC78199F;
        Fri, 14 Apr 2023 19:38:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CB4160D3E;
        Sat, 15 Apr 2023 02:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430ADC433D2;
        Sat, 15 Apr 2023 02:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681526322;
        bh=nnvRtBPVUArX2X5XMxrrxMrqKwpebH18vALeaycgDXs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=R+qq3N2hnicRtd5efYPy5r6p/i581OF0j8XbtZjjW2QHF6n84aQLbPuBheeERVz0B
         iZyvR3RFCdKCLmkFEcYeKZl6mIHRNlvgssP3JAiKA5iEws1gixDoOT0rzqiSiHlg96
         TH19zawTNJ4YkQF79bA/ERjNgMiyJFCyLwoINrD0LvUc2chbraJkf2yUTZykjKPhJ+
         jEoR/+ZicY6uIanGS/FW2K7/w9wqN2sxh+9/mQxlDNw9AB90TVjy0LumQA4u+0W9kU
         hfWf/4Oy1WqwxCLZs42OqIZK83VrbZI5ey75ZFCFe94KFFpwgfbQCmyPIRM5hKUCIG
         x64VXs1rwVXzg==
Message-ID: <ea56c40f-5701-ef2f-c725-c440aeae447f@kernel.org>
Date:   Sat, 15 Apr 2023 11:38:39 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 00/19] Add Command Duration Limits support
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230406113252.41211-1-nks@flawful.org>
 <fe9fdfc9-5eff-ba29-5139-0aa44ddadc35@kernel.org>
 <yq18rewd1qy.fsf@ca-mkp.ca.oracle.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <yq18rewd1qy.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/13/23 10:17, Martin K. Petersen wrote:
> 
> Damien,
> 
>> Any thought on this series ? Can we get this queued for 6.4 ?
> 
> I don't have any major objections (other than the mode sense hack but I
> agree there's no obvious way to avoid it).
> 
> My only concern is that it's a bit late in cycle. But I'll at least put
> it in staging and see what breaks.
> 
> Jens: Are you OK with the block bits?

Jens ? Ping !

