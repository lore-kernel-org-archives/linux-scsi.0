From: Matthew Jacob <mjacob@feral.com>
Subject: Re: Warning - running *really* short on DMA buffers while doing file
 transfers
Date: Fri, 27 Sep 2002 00:29:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0209270029280.18144-100000@beppo>
References: <20020927072441.GT5646@suse.de>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020927072441.GT5646@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org



On Fri, 27 Sep 2002, Jens Axboe wrote:

> On Fri, Sep 27 2002, Matthew Jacob wrote:
> > > 
> > > So I think the 'more tags the better!' belief is very much bogus, at
> > > least for the common case.
> > 
> > Well, that's one theory.
> 
> Numbers talk, theory spinning walks
> 
> Both Andrew and I did latency numbers for even small depths of tagging,
> and the result was not pretty. Sure this is just your regular plaino
> SCSI drives, however that's also what I care most about. People with
> big-ass hardware tend to find a way to tweak them as well, I'd like the
> typical systems to run fine out of the box though.
> 

Fair enough. 




