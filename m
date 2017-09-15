From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] bsg-lib: don't free job in bsg_prepare_job
Date: Thu, 14 Sep 2017 22:31:34 -0600
Message-ID: <ceb7daa1-7863-8fd3-4f9d-575dd2fe2d49@kernel.dk>
References: <20170907115436.5069-1-hch@lst.de>
 <20170907115436.5069-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170907115436.5069-2-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/07/2017 05:54 AM, Christoph Hellwig wrote:
> The job structure is allocated as part of the request, so we should not
> free it in the error path of bsg_prepare_job.

Added for this series, thanks.

-- 
Jens Axboe
