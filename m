From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC] bsg-lib interface cleanup
Date: Wed, 4 Oct 2017 08:35:44 -0600
Message-ID: <4c1113f7-64f0-98a2-9997-9f6a8666acdb@kernel.dk>
References: <20171003104845.10417-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:45111 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752085AbdJDOfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2017 10:35:47 -0400
Received: by mail-it0-f41.google.com with SMTP id x15so16484242itb.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Oct 2017 07:35:46 -0700 (PDT)
In-Reply-To: <20171003104845.10417-1-hch@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>

On 10/03/2017 04:48 AM, Christoph Hellwig wrote:
> Hi all,
> 
> this series cleans up various abuses of the bsg interfaces, and then
> splits bsg for SCSI passthrough from bsg for arbitrary transport
> passthrough.  This removes the scsi_request abuse in bsg-lib that is
> very confusing, and also makes sure we can sanity check the requests
> we get.  The current code will happily execute scsi commands against
> bsg-lib queues, and transport pass through against scsi nodes, without
> any indication to the driver that we are doing the wrong thing.
> 
> The series includes the fix from Bejamin as the first patch as I
> rebased on top of it, but that one really needs to got into 4.14 ASAP.

I added patch 1 for 4.14.

-- 
Jens Axboe
