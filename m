From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] bsg-lib: fix kernel panic resulting from missing
 allocation of reply-buffer
Date: Wed, 6 Sep 2017 08:07:43 -0600
Message-ID: <42e9ef4d-6981-2b0c-bdc3-afb5b1750666@kernel.dk>
References: <20170906134416.19980-1-hch@lst.de>
 <20170906134416.19980-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170906134416.19980-2-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>, "#4 . 11+" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/06/2017 07:44 AM, Christoph Hellwig wrote:
> From: Benjamin Block <bblock@linux.vnet.ibm.com>
> 
> Since we split the scsi_request out of struct request bsg fails to
> provide a reply-buffer for the drivers. This was done via the pointer
> for sense-data, that is not preallocated anymore.

Confused, this is already in master, was included before 4.13 was
finalized.

-- 
Jens Axboe
