From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 9/9] bsg: split handling of SCSI CDBs vs transport
 requeues
Date: Tue, 24 Oct 2017 11:46:12 -0600
Message-ID: <251daef6-a5bd-47d1-99a2-24d0d11b7bff@kernel.dk>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-10-hch@lst.de>
 <20171019155933.GE26185@bblock-ThinkPad-W530> <20171020162630.GA14277@lst.de>
 <20171020164727.GA26380@bblock-ThinkPad-W530> <yq1bmkymlss.fsf@oracle.com>
 <20171023062949.GA16978@lst.de> <yq17evmmiye.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:45354 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbdJXRqQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2017 13:46:16 -0400
Received: by mail-it0-f45.google.com with SMTP id n195so11025286itg.0
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2017 10:46:16 -0700 (PDT)
In-Reply-To: <yq17evmmiye.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

On 10/23/2017 01:17 AM, Martin K. Petersen wrote:
> 
> Christoph,
> 
>>> Yes, I expected the bsg bits to go through Jens' tree.
>>
>> Ok, then I misremembered it, and we'll have to delay the remaining
>> patches until the next merge window, as they depend on the previous
>> ones.
> 
> I don't mind taking them through SCSI if Jens agrees.

I'm fine with that, as long as the last issue Benjamin brought up has
been fixed up.

-- 
Jens Axboe
