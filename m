From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [4/5] ncr53c8xx update
Date: Sun, 20 Mar 2005 01:32:28 +0000
Message-ID: <20050320013228.GO21986@parcelfarce.linux.theplanet.co.uk>
References: <20050319035637.16128496108@palinux.hppa> <1111278727.5525.33.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:52411 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261960AbVCTBca (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2005 20:32:30 -0500
Content-Disposition: inline
In-Reply-To: <1111278727.5525.33.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <willy@parisc-linux.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, Mar 19, 2005 at 06:32:07PM -0600, James Bottomley wrote:
> On Fri, 2005-03-18 at 20:56 -0700, Matthew Wilcox wrote:
> > ncr53c8xx update
> 
> There's actually a slight problem with this one: on my Q720 it produces
> messages like this:
> 
> ncr53c720-1: ID 7, Fast-10, Parity Checking
> scsi1 : ncr53c8xx-3.4.3g
>  target1:0:1: target did not report SYNC.
> 
> Although everything is fine.  The initial "target did not report SYNC"
> is because the driver is trying to negotiate over the initial inquiry
> (so, naturally we don't know if it supports sync yet).  The solution is
> to rip out the last remnants of the spontaneous attempts at negotiation
> to force it to wait for the DV negotiation in slave_configure.

Wonderful, thanks for finding & fixing that.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
