From: Matthew Jacob <mjacob@feral.com>
Subject: Re: Warning - running *really* short on DMA buffers while doing file
 transfers
Date: Fri, 27 Sep 2002 00:34:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0209270031360.18144-100000@beppo>
References: <Pine.BSF.4.21.0209270029280.18144-100000@beppo>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.BSF.4.21.0209270029280.18144-100000@beppo>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


The issue here is not whether it's appropriate to oversaturate the
'standard' SCSI drive- it isn't- I never suggested it was.

I'd just suggest that it's asinine to criticise an HBA for running up to
reasonable limits when it's the non-toy OS that will do sensible I/O
scheduling. So point your gums elsewhere.



On Fri, 27 Sep 2002, Matthew Jacob wrote:

> 
> 
> On Fri, 27 Sep 2002, Jens Axboe wrote:
> 
> > On Fri, Sep 27 2002, Matthew Jacob wrote:
> > > > 
> > > > So I think the 'more tags the better!' belief is very much bogus, at
> > > > least for the common case.
> > > 
> > > Well, that's one theory.
> > 
> > Numbers talk, theory spinning walks
> > 
> > Both Andrew and I did latency numbers for even small depths of tagging,
> > and the result was not pretty. Sure this is just your regular plaino
> > SCSI drives, however that's also what I care most about. People with
> > big-ass hardware tend to find a way to tweak them as well, I'd like the
> > typical systems to run fine out of the box though.
> > 
> 
> Fair enough. 
> 
> 
> 
> 
> 

