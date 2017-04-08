From: Jens Axboe <axboe@kernel.dk>
Subject: Re: always use REQ_OP_WRITE_ZEROES for zeroing offload V2
Date: Sat, 8 Apr 2017 11:26:18 -0600
Message-ID: <20170408172617.GA16784@kernel.dk>
References: <20170405172125.22600-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:36196 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbdDHR0W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Apr 2017 13:26:22 -0400
Received: by mail-pf0-f169.google.com with SMTP id o126so16821696pfb.3
        for <linux-scsi@vger.kernel.org>; Sat, 08 Apr 2017 10:26:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170405172125.22600-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org

On Wed, Apr 05 2017, Christoph Hellwig wrote:
> This series makes REQ_OP_WRITE_ZEROES the only zeroing offload
> supported by the block layer, and switches existing implementations
> of REQ_OP_DISCARD that correctly set discard_zeroes_data to it,
> removes incorrect discard_zeroes_data, and also switches WRITE SAME
> based zeroing in SCSI to this new method.
> 
> The series is against the block for-next tree.

Added for 4.12, thanks Christoph.

-- 
Jens Axboe
