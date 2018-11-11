From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: remove exofs, the T10 OSD code and block/scsi bidi support V3
Date: Sun, 11 Nov 2018 17:35:07 +0100
Message-ID: <5c1952ce-988e-45be-db01-0cf7277be0f5@interlog.com>
References: <20181111133211.13926-1-hch@lst.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181111133211.13926-1-hch@lst.de>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com, ooo@electrozaur.com
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-11-11 2:32 p.m., Christoph Hellwig wrote:
> The only real user of the T10 OSD protocol, the pNFS object layout
> driver never went to the point of having shipping products, and we
> removed it 1.5 years ago.  Exofs is just a simple example without
> real life users.
> 
> The code has been mostly unmaintained for years and is getting in the
> way of block / SCSI changes, so I think it's finally time to drop it.
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
> not even for SG_IO passthrough commands.

What?? Do any Linux distros track what commands are sent to any (or all)
of the SG_IO passthroughs? I would hope that the last part of that
sentence remains unprovable.

Doug Gilbert

"I've told you a million times, don't exaggerate!"
