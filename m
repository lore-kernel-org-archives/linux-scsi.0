From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: I/O write ordering
Date: Thu, 23 Sep 2004 02:58:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040923015819.GU16153@parcelfarce.linux.theplanet.co.uk>
References: <20040922025805.GA148414@sgi.com> <20040922143208.GL16153@parcelfarce.linux.theplanet.co.uk> <1095864485.2143.1.camel@mulgrave> <1095864709.6297.5.camel@gaston> <1095865892.1715.5.camel@mulgrave> <1095865863.6340.7.camel@gaston> <1095866530.2295.8.camel@mulgrave> <1095866930.6340.11.camel@gaston> <1095867824.2295.13.camel@mulgrave> <1095898796.6359.18.camel@gaston>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:23248 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268135AbUIWB6U
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 21:58:20 -0400
Content-Disposition: inline
In-Reply-To: <1095898796.6359.18.camel@gaston>
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <matthew@wil.cx>, Jeremy Higdon <jeremy@sgi.com>, Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>, Richard Henderson <rth@twiddle.net>, Paul Mackerras <paulus@samba.org>

On Thu, Sep 23, 2004 at 10:19:57AM +1000, Benjamin Herrenschmidt wrote:
> And that wouldn't help vs. spinlocks which are in real RAM
> (we have a similar issue with IO leaking potentially out of locks, 
> if we don't use some heavy barriers there too).

Yep, that was the problem that SGI wanted to solve.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
