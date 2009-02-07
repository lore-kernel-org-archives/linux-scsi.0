From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: TRIM vs UNMAP vs WRITE SAME and thin devices
Date: Sat, 07 Feb 2009 17:03:41 -0600
Message-ID: <1234047822.4658.13.camel@localhost.localdomain>
References: <20090123041558.GC24652@parisc-linux.org>
	 <4979AF62.7070409@redhat.com>
	 <1232721777.4430.7.camel@macbook.infradead.org>
	 <498DA052.6090605@redhat.com>
	 <1234019372.4658.9.camel@localhost.localdomain>
	 <20090207225025.GB31509@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090207225025.GB31509@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ric Wheeler <rwheeler@redhat.com>, David Woodhouse <dwmw2@infradead.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2009-02-07 at 15:50 -0700, Matthew Wilcox wrote:
> On Sat, Feb 07, 2009 at 09:09:32AM -0600, James Bottomley wrote:
> > On Sat, 2009-02-07 at 09:53 -0500, Ric Wheeler wrote:
> > > I have been poked at by some vendors about the status of our support for 
> > > the virtually/thinly provisioned luns since they are getting close to 
> > > being able to test with real devices.
> > 
> > With my LSF hat on, a certain array vendor might be sponsoring to get
> > the opportunity to raise this issue more fully.  The impression (mostly
> > correct) is that we're thinking about trim/unmap purely from the SSD FTL
> > point of view and perhaps not being as useful as we might to virtually
> > provisioned LUNs ... so you could mention to the other vendors that they
> > might have an interest in coming (and even possibly sponsoring).
> 
> I thought we had agreed on a plan which satisfied the SSD and insane
> array vendors.

I don't think we got any input from array vendors, so it's rather hard
to claim this.  So part of this idea would be gathering the necessary
inputs.

>   That is that we would do no tracking of allocation units
> in the filesystem, but instead extend each trim out to cover the maximum
> possible size.  I've confirmed with Intel's SSD people that this would
> cause them no harm at all (trimming already trimmed sectors won't even
> cause a slowdown).  Whether the filesystem people have taken note of
> this, I have no idea.

It's one idea, but absent requirements from array vendors, we don't
really know if it's the right one.

James


