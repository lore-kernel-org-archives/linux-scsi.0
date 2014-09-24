From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH block/for-3.17-fixes/core] blk-mq, percpu_ref: implement
 a kludge for SCSI blk-mq stall during probe
Date: Wed, 24 Sep 2014 08:33:58 -0600
Message-ID: <5422D656.7020006@kernel.dk>
References: <20140923055554.GA10189@lst.de> <20140923055648.GD11740@mtj.dyndns.org> <20140923055924.GA10295@lst.de> <20140923060141.GF11740@mtj.dyndns.org> <20140923060906.GA10547@lst.de> <20140923061152.GI11740@mtj.dyndns.org> <5421968B.7080309@kernel.dk> <20140923192432.GA24441@mtj.dyndns.org> <20140924082348.GB8894@lst.de> <5422D589.5070009@kernel.dk> <20140924143320.GG16555@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55009 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIXOeE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Sep 2014 10:34:04 -0400
Received: by mail-pa0-f46.google.com with SMTP id kx10so8767461pab.5
        for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2014 07:34:03 -0700 (PDT)
In-Reply-To: <20140924143320.GG16555@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 09/24/2014 08:33 AM, Tejun Heo wrote:
> On Wed, Sep 24, 2014 at 08:30:33AM -0600, Jens Axboe wrote:
>> On 09/24/2014 02:23 AM, Christoph Hellwig wrote:
>>> Thanks, this fixes the boot stall for me.
>>>
>>> Tested-by: Christoph Hellwig <hch@lst.de>
>>
>> Sweet, I'll shove this off today, so we are done for 3.17 release.
> 
> Cool, once it hits the block branch, I'll pull it into percpu/for-3.18
> and apply the patches for proper fix on top.

It's in for-linus now.


-- 
Jens Axboe

