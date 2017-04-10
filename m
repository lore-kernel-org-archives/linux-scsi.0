From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: [PATCH 03/27] block: implement splitting of REQ_OP_WRITE_ZEROES
 bios
Date: Mon, 10 Apr 2017 20:40:52 +0100
Message-ID: <676426a4-6d50-ea66-6b52-6ce8f78b59f0@youngman.org.uk>
References: <20170405142205.6477-1-hch@lst.de>
 <20170405142205.6477-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170405142205.6477-4-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

s/past/paste/

On 05/04/17 15:21, Christoph Hellwig wrote:
> Copy and past the REQ_OP_WRITE_SAME code to prepare to implementations
> that limit the write zeroes size.

Cheers,
Wol
