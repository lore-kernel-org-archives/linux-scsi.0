From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 13:24:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409211324.13500.jbarnes@engr.sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211303.19110.jbarnes@engr.sgi.com> <20040921171515.GD11446@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:42433 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267891AbUIURf3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 13:35:29 -0400
In-Reply-To: <20040921171515.GD11446@parcelfarce.linux.theplanet.co.uk>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 1:15 pm, Matthew Wilcox wrote:
> On Tue, Sep 21, 2004 at 01:03:18PM -0400, Jesse Barnes wrote:
> > Does this patch describe and correctly implement what we've discussed? 
> > I've added information to io_ordering.txt to describe the conclusion
> > about posting we seem to have agreed on.  Obviously, this is just a first
> > cut.  It compiles, but I haven't made prototypes for any arch other than
> > ia64.
>
> Please kill the Documentation/io_ordering.txt file and work on improving
> the information in Documentation/DocBook/deviceiobook instead.

Sure, I can do that in the next spin.  Please make sure things look ok 
otherwise though.

Jesse
