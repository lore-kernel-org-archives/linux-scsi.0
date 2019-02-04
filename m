From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: remove exofs, the T10 OSD code and block/scsi bidi support V4
Date: Mon, 4 Feb 2019 22:31:39 +0200
Message-ID: <3be11773-5ea9-4c08-25a5-dc556ded2d6f@electrozaur.com>
References: <20190201075557.9249-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190201075557.9249-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/02/19 09:55, Christoph Hellwig wrote:
> The only real user of the T10 OSD protocol, the pNFS object layout
> driver never went to the point of having shipping products, and we
> removed it 1.5 years ago.  Exofs is just a simple example without
> real life users.
> 
> The code has been mostly unmaintained for years and is getting in the
> way of block / SCSI changes, 

For the 4th time: Which ?

> and does not even work properly currently,
> so I think it's finally time to drop it.
> 
> Quote from Boaz:
> 

Hello? anyone home?

Please resend without the below Quote!!!
Because yes I said that but I have also said the opposite. And I have clearly
stated in reaction to the last 3 resends. That I now oppose to the below statement.
And that you should please remove it.

Do your own text please. Don't drag me in the mud

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
> 

NAK-by: Boaz harrosh <ooo@electrozaur.com>
For what ever that means ...

Cheers
Boaz
