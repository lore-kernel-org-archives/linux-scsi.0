Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29662C77B73
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 13:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbjDSNQw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 09:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbjDSNQs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 09:16:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F91146E5
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 06:16:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA0D463F01
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 13:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494ADC433EF;
        Wed, 19 Apr 2023 13:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681910206;
        bh=QH7MAcJ4ZT/4bmlmJzv7lqicxdwrbixEz3l4QBv592o=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=RtMWtdZKS+fCy5Z8KIr7zzGkOy9s6xzxpA+FNxM6rWKk78hw4lNye/Cp3tEFWxB2f
         VvH3/0Zmczny0YQSzv9j0ecLBIkMPTmiaiKr+r9i19n4kDPAauageta9d6ztj9JHdc
         5fhAcHi33DZNft9iQStU6ZD8sZ7+/ChE1SBDPfz4zo7IVVhFmxOtX+cG3HxJNJO6o8
         jOvqfAKVWTxB+wQ9ra62C4o9CZ4clKxUKVjlzusMHT/5FLDRNDk7lt+A4WuSpkuYg6
         wS316PKL42iUEmq2XDLpSn+sjWKy7pRz2YMi3bN/sVT5UM37v41tI4UX2m4ehJamoj
         Cm+xmzKcJzgpA==
Message-ID: <ed208a85-f66d-d70c-d3fb-12e66629863a@kernel.org>
Date:   Wed, 19 Apr 2023 22:16:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] ipr: Remove SATA support
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        damien.lemoal@opensource.wdc.com, john.g.garry@oracle.com,
        wenxiong@linux.ibm.com
References: <20230412174015.114764-1-brking@linux.vnet.ibm.com>
 <yq1v8hspnww.fsf@ca-mkp.ca.oracle.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <yq1v8hspnww.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/23 12:10, Martin K. Petersen wrote:
> 
> Brian,
> 
>> Linux SATA support in ipr has always been limited to SATA DVDs. The
>> last systems that had the option of including a SATA DVD was Power 8,
>> which have been withdrawn for sometime now, so this support can be
>> removed.
> 
> Applied to 6.4/scsi-staging, thanks!

There was a build bot warning. Was that fixed ? I did not see a v2...

> 

