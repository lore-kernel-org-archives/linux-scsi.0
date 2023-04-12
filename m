Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E396C77B6C
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 22:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjDLW3N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 18:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLW3M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 18:29:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E0A7D81;
        Wed, 12 Apr 2023 15:29:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54330638E0;
        Wed, 12 Apr 2023 22:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27186C433EF;
        Wed, 12 Apr 2023 22:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681338547;
        bh=aECm2tZB/vDnVu4A3LP7xh5xQgQuB2VMr36U6ePH4R0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fMg/ody7gG6VpASyqfK8NQmVVPRTQyBVSL1eLzoRJXg+XJlUPGdoZLBXgcHIKvF7i
         OV/0gSMNd/DwmCr3rZrWXwbj350kN1PjLrZ+Kx1QcFz1riysedu3mNjXZ3t/lEu4Sk
         s9xIldozXjENU6Na5zPlA/pjyr/atl4uUcTR4XBFKVoWIwsstHNehtDDRVP/F5fP0A
         s+BLtWlBjR0oRffQmzvx8WypJPq2rQNnI9MTSlHUuQT8LBcM7xTXa9/F51QbN5RPvr
         b0J5DqK6JYmi4M/DcnUff409hq2hDMgf9WCiOp4CjPvwNS+kFw5pXUFNqXOiUbEGUL
         Up5/2fU+VzooQ==
Message-ID: <fe9fdfc9-5eff-ba29-5139-0aa44ddadc35@kernel.org>
Date:   Thu, 13 Apr 2023 07:29:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 00/19] Add Command Duration Limits support
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230406113252.41211-1-nks@flawful.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/6/23 20:32, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Hello,
> 
> This series adds support for Command Duration Limits.
> The series is based on linux tag: v6.3-rc5
> The series can also be found in git:
> https://github.com/floatious/linux/commits/cdl-v6

Jens, Martin, James,

Any thought on this series ? Can we get this queued for 6.4 ?



