From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 18:15:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921171515.GD11446@parcelfarce.linux.theplanet.co.uk>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211205.22575.jbarnes@engr.sgi.com> <1095783077.2467.145.camel@mulgrave> <200409211303.19110.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:15044 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267881AbUIURPQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 13:15:16 -0400
Content-Disposition: inline
In-Reply-To: <200409211303.19110.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 01:03:18PM -0400, Jesse Barnes wrote:
> Does this patch describe and correctly implement what we've discussed?  I've 
> added information to io_ordering.txt to describe the conclusion about posting 
> we seem to have agreed on.  Obviously, this is just a first cut.  It 
> compiles, but I haven't made prototypes for any arch other than ia64.

Please kill the Documentation/io_ordering.txt file and work on improving
the information in Documentation/DocBook/deviceiobook instead.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
