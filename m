From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Wed, 22 Sep 2004 01:02:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040922000211.GE16153@parcelfarce.linux.theplanet.co.uk>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211346.58267.jbarnes@engr.sgi.com> <1095789421.2467.414.camel@mulgrave> <200409211409.11095.jbarnes@engr.sgi.com> <20040921190625.GB11708@colo.lackof.org> <20040921210341.GC146363@sgi.com> <20040921211108.GA16153@parcelfarce.linux.theplanet.co.uk> <20040921214302.GG146363@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:14988 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266613AbUIVACN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 20:02:13 -0400
Content-Disposition: inline
In-Reply-To: <20040921214302.GG146363@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 02:43:02PM -0700, Jeremy Higdon wrote:
> That could be very painful.
> On Irix, we actually had a separate spinunlock (io_spin_unlock) that
> added the MIPS equivalent.  I'm assuming we don't want to entertain
> that here :-)  (Though tell me if I'm wrong)

That seems like a reasonable solution to me.  Want to float it to Linus
and see how he takes it?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
