Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A125CC77B71
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 05:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjDRFf5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 01:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjDRFf4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 01:35:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7AF5589;
        Mon, 17 Apr 2023 22:35:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAF3660C4E;
        Tue, 18 Apr 2023 05:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1AEC433D2;
        Tue, 18 Apr 2023 05:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681796154;
        bh=Yu+LMKljeOGCvNW1q02mSC/Lf+rvYCvzb6CTtpQmPCc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=WXX8BmLSA8eiEg/ioh87sFYYyH+9Wi8d7Ha1hxQiswnyqQ9E0bVaYV2WVKzZKKEIy
         xWejnTgm4mXd5rPEbu8UCPvaTkWy8QIPNfEwooD2/CB/5w/GUeW5nyTvfPzg6sARJh
         kT3vWaqMZ8MiIX3HK8DZU9wpyBNexFJolnwGEV945PKl1IsTTd5r5600nKRZKoU4II
         CBdl6B2Q2/ztI/gkFizQOqLAZndlVRCEegQvOBUsWlyv+0NUSS7Kbh6yolzt8Bf96q
         ZNVYGpzsI4C93D5nMHCdNU5x3VqlVupsbHkewn8B9frdqjmSdCUcfZDtwzO0MVAJm0
         nYPgVBph1f7FQ==
Message-ID: <f5110080-56d2-936f-b3f8-059b8c8e92c7@kernel.org>
Date:   Tue, 18 Apr 2023 14:35:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 00/19] Add Command Duration Limits support
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <nks@flawful.org>,
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

Jens ?

Any thoughts on the ioprio interface ?

