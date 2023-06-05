Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24517C7EE2A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 09:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjFEJrl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 05:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjFEJrf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 05:47:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE63DB;
        Mon,  5 Jun 2023 02:47:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 891AA62179;
        Mon,  5 Jun 2023 09:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44176C4339B;
        Mon,  5 Jun 2023 09:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685958453;
        bh=EzUEQM2utiFHPCfBNGwA4VIo4xQtleS/MQuRBh/gPLY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=s2vssPGz5R+bh14558HyTE1Yy8PbJbGyPkbDA68GaQpF5wo6pCus07ifWOYgR4DaN
         s6fCjH4ihBa3+9jbc5mCO8HO+IA4E2BLGI80EWSiA98t3JCl1Mj9XCqU4kE5A9QkDe
         mT5oHO94om76nlmW6QjBJJ8x55XRJsyuW5i670OTBDZkH0mWDU0zgIdWDFIu9e7QWG
         PuxOGinvvtF7mzf9IKouJu/Tz+gcm78LZ7k/SBfaDraxqy9PAzrWz1LUfvp/9/9U5V
         4o09vq9yQQ01fh8oVRp5sBFMXCQ4Kcu6dCmIJLeaSbg3MR2Q7PiA62dWQegFgURYMj
         ynsxBeWVXCuTQ==
Message-ID: <95bd1352-4f58-8f0a-63ef-66f8e4a6ee79@kernel.org>
Date:   Mon, 5 Jun 2023 18:47:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/3] ata: libata-eh: Use ata_ncq_enabled() in
 ata_eh_speed_down()
Content-Language: en-US
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20230605013212.573489-1-dlemoal@kernel.org>
 <20230605013212.573489-3-dlemoal@kernel.org>
 <932a4de0-8858-13b7-0b76-520c81f5b0ea@gmail.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <932a4de0-8858-13b7-0b76-520c81f5b0ea@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/5/23 18:45, Sergei Shtylyov wrote:
> On 6/5/23 4:32 AM, Damien Le Moal wrote:
> 
>> Instead of hardconfign the device flag tests to detect if NCQ is
> 
>    Hardcoding?

Yes. Will fix. Thanks.

> 
>> supported and enabled in ata_eh_speed_down(), use ata_ncq_enabled().
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> [...]
> 
> MBR, Sergey

-- 
Damien Le Moal
Western Digital Research

