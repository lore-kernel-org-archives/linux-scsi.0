From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: sym2 on sparc
Date: Sat, 2 Oct 2004 15:44:08 +0100
Sender: sparclinux-owner@vger.kernel.org
Message-ID: <20041002144408.GS16153@parcelfarce.linux.theplanet.co.uk>
References: <20041001182056.GI16153@parcelfarce.linux.theplanet.co.uk> <1096724000.2157.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1096724000.2157.1.camel@mulgrave>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, sparclinux@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 02, 2004 at 09:33:13AM -0400, James Bottomley wrote:
> On Fri, 2004-10-01 at 14:20, Matthew Wilcox wrote:
> > Could someone with a symbios 53c8xx chip test this patch?  It works
> > on non-sparc.  If I don't hear of any problems, it'll be in the next
> > driver update.
> 
> Do we have to do this?

DaveM sent me a reply saying:

> Just print the IRQ out as an unsigned integer, it's not the
> end of the world if you don't use the special sparc macros.

Again, sorry about the list address confusion.

> Putting architecture specific knowledge into a device driver is almost
> never a good thing to do.  If all you want to do is print out the IRQ
> designation, I suspect this is a generic problem, not a sym2 specific
> problem, so what we need is something like an irq_to_string()
> abstraction.

I agree.  We could probably use something similar on PA-RISC.  There's
about 25 drivers in-tree that're currently using __irq_itoa().  Most
of them would be better-written if everybody were using a string.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
