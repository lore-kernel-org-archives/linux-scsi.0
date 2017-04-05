From: Jens Axboe <axboe@kernel.dk>
Subject: Re: ->retries fixups V2
Date: Wed, 5 Apr 2017 12:18:07 -0600
Message-ID: <3d389bc8-9de9-f523-f1b3-3e1d4a3d4dba@kernel.dk>
References: <20170405171812.19911-1-hch@lst.de>
 <20170405180653.GA5548@kernel.dk> <20170405181605.GA9702@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:35543 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756125AbdDESSJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 14:18:09 -0400
Received: by mail-it0-f54.google.com with SMTP id y18so88057653itc.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Apr 2017 11:18:09 -0700 (PDT)
In-Reply-To: <20170405181605.GA9702@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

On 04/05/2017 12:16 PM, Christoph Hellwig wrote:
> On Wed, Apr 05, 2017 at 12:06:53PM -0600, Jens Axboe wrote:
>> On Wed, Apr 05 2017, Christoph Hellwig wrote:
>>> This series fixes a few lose bits in terms of how nvme uses ->retries,
>>> including fixing it for non-PCIe transports.  While at it I noticed that
>>> nvme and scsi use the field in entirely different ways, and no other
>>> driver uses it at all.  So I decided to move it into the nvme_request and
>>> scsi_request structures instead.
>>>
>>> Changes since V1:
>>>  - better changelog for one patch
>>>  - move the new retries field to the end of struct nvme_request
>>
>> Applied for 4.12. If we do the below on my box, we remove the (now) 2
>> holes from struct request and shrink it 8 bytes.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks, added that too.

-- 
Jens Axboe
