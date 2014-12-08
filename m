From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/3] libata: Whitelist SSDs that are known to properly
 return zeroes after TRIM
Date: Mon, 8 Dec 2014 22:59:15 +0000
Message-ID: <20141208225915.1ec39f03@lxorguk.ukuu.org.uk>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
	<1415336894-15327-2-git-send-email-martin.petersen@oracle.com>
	<94D0CD8314A33A4D9D801C0FE68B4029593FA1F3@G4W3202.americas.hpqcorp.net>
	<20141208151559.GB7001@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20141208151559.GB7001@thunk.org>
Sender: linux-ide-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, 8 Dec 2014 10:15:59 -0500
"Theodore Ts'o" <tytso@mit.edu> wrote:

> On Fri, Dec 05, 2014 at 10:58:09PM +0000, Elliott, Robert (Server Storage) wrote:
> > > I have a Crucial_CT256MX1 (i.e. MX100) and it does reliably zero.
> > 
> > make me concerned about this whitelist approach.
> > 
> > I think you need a manufacturer assertion that this is indeed
> > the design intent; you cannot be certain based on observation
> > from outside.
> 
> How is this different from a manufacturer assertion that they follow a
> SCSI or ATA standard?  There have been cases in the distant past
> (fortunately) of disk manufacturers that ignored a CACHE FLUSH command
> just to get higher Winbench scores.  Does that mean we can't trust
> them to do anything right?

At the time they never promised to honour cache flush. The reason it was
became mandatory in the specification was in part so that the vendors
could all force each other to play fair. If its "optional" then it's
tough..., if they say they meet the standard it's class action 8)

If this is a promise then it ought to be good 

James:  "USB devices tend to supply their own driver"

has not been true for some years now. Microsoft provide an in-box driver
and vendors have the choice of using that or certifying their own via
WHQL, which is a bit like choosing between free ice cream and banging
your head against a plank cover in nails.

Alan
