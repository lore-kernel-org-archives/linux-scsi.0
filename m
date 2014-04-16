From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/8] blk-mq: bidi support
Date: Wed, 16 Apr 2014 10:52:43 -0600
Message-ID: <534EB55B.60107@kernel.dk>
References: <1397634299-7466-1-git-send-email-hch@lst.de> <1397634299-7466-3-git-send-email-hch@lst.de> <534EB2BA.7020705@kernel.dk> <20140416164406.GA19850@lst.de> <534EB38F.7050801@kernel.dk> <20140416164739.GA19947@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140416164739.GA19947@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/16/2014 10:47 AM, Christoph Hellwig wrote:
> On Wed, Apr 16, 2014 at 10:45:03AM -0600, Jens Axboe wrote:
>> There's nothing wrong with the check, it's identical to one I sent out
>> last week. But it's not part of the bidi enable patch, it's a separate
>> bug fix for bsg.
> 
> Do you want to split it up while applying or should I resend two
> separate patches?

I cut that part and applied, whole series is applied now.

-- 
Jens Axboe
