From: Jens Axboe <axboe@kernel.dk>
Subject: Re:
Date: Tue, 15 Apr 2014 14:16:14 -0600
Message-ID: <534D938E.3000503@kernel.dk>
References: <blk-mq updates> <1397464212-4454-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397464212-4454-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Matias Bjorling <m@bjorling.me>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/14/2014 02:30 AM, Christoph Hellwig wrote:
> This is the majority of the blk-mq work still required for switching
> over SCSI.  There are a few more bits for I/O completion and requeueing
> pending, but they will need further work.

Looks OK to me, I have applied them all. Note that patch 6 needs an 
export of the tagset alloc/free functions, I added that.

-- 
Jens Axboe
