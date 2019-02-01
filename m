From: Jens Axboe <axboe@kernel.dk>
Subject: Re: remove exofs, the T10 OSD code and block/scsi bidi support V4
Date: Fri, 1 Feb 2019 08:13:26 -0700
Message-ID: <2dbeeae6-6c0d-0702-acf4-73226ccf64c4@kernel.dk>
References: <20190201075557.9249-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190201075557.9249-1-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com, ooo@electrozaur.com
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2/1/19 12:55 AM, Christoph Hellwig wrote:
> The only real user of the T10 OSD protocol, the pNFS object layout
> driver never went to the point of having shipping products, and we
> removed it 1.5 years ago.  Exofs is just a simple example without
> real life users.
> 
> The code has been mostly unmaintained for years and is getting in the
> way of block / SCSI changes, and does not even work properly currently,
> so I think it's finally time to drop it.
> 
> Quote from Boaz:
> 
> "As I said then. It is used in Universities for studies and experiments.
> Every once in a while. I get an email with questions and reports.
> 
> But yes feel free to remove the all thing!!
> 
> I guess I can put it up on github. In a public tree.
> 
> Just that I will need to forward port it myself, til now you guys
> been doing this for me ;-)"
> 
> Now the last time this caused a bit of a stir, but still no actual users,
> not even for SG_IO passthrough commands.  So here we go again, this time
> including removing everything in the scsi and block layer supporting it,
> and thus shrinking struct request.

I'm fine with killing it. You can add my:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

to the series.

-- 
Jens Axboe
