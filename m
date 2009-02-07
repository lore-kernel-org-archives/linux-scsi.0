From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: TRIM vs UNMAP vs WRITE SAME and thin devices
Date: Sat, 7 Feb 2009 15:47:22 -0700
Message-ID: <20090207224722.GA31509@parisc-linux.org>
References: <20090123041558.GC24652@parisc-linux.org> <4979AF62.7070409@redhat.com> <1232721777.4430.7.camel@macbook.infradead.org> <498DA052.6090605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <498DA052.6090605@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 07, 2009 at 09:53:06AM -0500, Ric Wheeler wrote:
> I have been poked at by some vendors about the status of our support for 
> the virtually/thinly provisioned luns since they are getting close to 
> being able to test with real devices.
> 
> My quick summary is that we most of the work so far has been done 
> without any real hardware to play with - in 2.6.29-rc3, I don't see any 
> low level ATA or SCSI bits that turn requests tagged with REQ_DISCARD 
> into the specific ATA or SCSI commands. Did I miss something & if not, 
> do we have plans to push anything upstream soonish?

Bearing in mind that I'm now three weeks behind on email, you might want
to look at
http://git.kernel.org/?p=linux/kernel/git/willy/ssd.git;a=shortlog;h=trim-20081231
which has at least one known bug (fixed by Dave Woodhouse and Ben
Herrenschmidt).  I'll be able to give a more coherent answer in a few
days.  Or maybe Dave will beat me to it ;-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
