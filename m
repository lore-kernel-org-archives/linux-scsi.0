From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 14:09:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409211409.11095.jbarnes@engr.sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211346.58267.jbarnes@engr.sgi.com> <1095789421.2467.414.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:25510 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267968AbUIUSJi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 14:09:38 -0400
In-Reply-To: <1095789421.2467.414.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>, Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 1:56 pm, James Bottomley wrote:
> Really, I don't think this is a good idea.  If there were a way to
> produce an api that was just ioflush(struct device *) then yes, since it
> would reduce confusion.  However, since all your API does is hide the
> fact that you're doing a MMIO read then the proposed API provides no
> relief from the fact that the driver writer needs to understand
> posting...all it does is add one extra function for them to misuse or
> get confused about.

Agreed.  I'll rename it, fix the io_ordering.txt doc to only describe I/O 
ordering issues, and resubmit it solely as a performance improvement API.

Grant, you say that I/O writes can't possibly arrive out of order if issued 
from different CPUs on any machines you're aware of?  If not, it may be that 
the API will only benefit SGI machines.

Thanks,
Jesse
