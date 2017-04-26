From: Jens Axboe <axboe@kernel.dk>
Subject: Re: three little req->errors follow ups
Date: Wed, 26 Apr 2017 06:54:23 -0700
Message-ID: <0cc3d6de-0e01-9723-451b-29951e0395a7@kernel.dk>
References: <20170426073422.14511-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170426073422.14511-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/26/2017 12:34 AM, Christoph Hellwig wrote:
> While moving forward with the block error work I noticed three more
> places that pass non-errno values to the end_request variants, and
> never actually check those return values.  This little series fixes
> those up to always pass 0.

Applied, thanks.

-- 
Jens Axboe
