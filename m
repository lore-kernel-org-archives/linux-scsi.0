From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 13:39:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921203940.GA146363@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0012AD90D@AVEXCH02.qlogic.org> <20040921162535.GB11446@parcelfarce.linux.theplanet.co.uk> <1095784395.2507.195.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:16528 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S267872AbUIUUkJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 16:40:09 -0400
Content-Disposition: inline
In-Reply-To: <1095784395.2507.195.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 12:33:08PM -0400, James Bottomley wrote:
> On Tue, 2004-09-21 at 12:25, Matthew Wilcox wrote:
> >    Configuration writes are not posted. (I/O writes can be posted in the
> >    Host Bridge, but some restrictions apply.) Read transactions (Memory,
> >    I/O, or Configuration) are not posted.
> 
> Erk, depending on what "some restrictions apply" means, that blows a
> hole in the idea of using PIO writes to guarantee no posting.
> 
> James

I don't think that P(ort)IO writes are the answer, either.

jeremy
