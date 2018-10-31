From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: remove exofs and the T10 OSD code V2
Date: Wed, 31 Oct 2018 18:34:21 +0200
Message-ID: <c9740eeb-6b96-35b6-a436-7537669da1a9@electrozaur.com>
References: <20181027082019.20838-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181027082019.20838-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc: Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 27/10/18 11:20, Christoph Hellwig wrote:
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

I think I'm changing my mind about this.

Because of two reasons:

One: I see 3 thousands bit-rots in the Kernel and particularly SCSI drivers
that are much older and fat-and-ugliness consuming then the clean osd
stack. For example the all ISA bus and ZONE_DMA stuff.

Two: I have offered many many times, every time this came up. That if
anyone has a major (or even minor) change to the block and/or scsi layers
that he/she has done. And that now breaks the compilation/run time of
OSD or exofs.
  I'm personally willing to spend my weekends and fix it myself. Send me
  a URL of the tree with the work done, and I will send the patches needed
  to revitalize OSD/exofs as part of that change set.

I have never received any such requests to date.

So I would please like to protest on two of Christoph's statements above.

"The code has been mostly unmaintained for years and is getting in the
 way of block / SCSI changes"

1. What does "maintained" means? I have for all these years been immediately
   responsive to any inquiries and patches to the code in question.
   And am listed as MAINTAINER of this code.
2. I have regularly, for ever, every kernel release around the RC3-RC4
   time frame, compiled and ran my almost automatic setup and made sure
   the things still run as expected (No regressions).

So Yes the code has not seen any new fixtures for years. But it is regularly
tested and proven to work, on latest kernel. So it fails the definition 
of a "bit rot"

Christoph you've been saying for so long "getting in the way of block/SCSI
changes". And every time and again this time please tell me, you never answered
before. What are these changes you want to make? can I please help?

Send me any tree where exofs/osd compilation is broken and I will personally
fix it in "ONE WEEK" time.

(If compilation is fine but you know runtime will break, its nice to have an
 heads up, but if not my automatic system will detect it anyway)

Lets say that if in the FUTURE a change-set is submitted that breaks OSD/EXOFS
compilation, and I failed to respond with a fix within "ONE WEEK". Then
this goes in as part of that change-set. And not with the argument of
"Not used, not maintained" - But as "Breaks compilation of the following changes"
I promise I will gladly ACK it then.

So for now. A personal NACK from me on the grounds that. You never told me
why / what this is braking.

Thanks
Boaz

> I guess I can put it up on github. In a public tree.
> 
> Just that I will need to forward port it myself, til now you guys
> been doing this for me ;-)"
> 
