From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: 21 Sep 2004 12:24:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095783904.2467.176.camel@mulgrave>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk>
	<200409211205.22575.jbarnes@engr.sgi.com>
	<1095783077.2467.145.camel@mulgrave>
	<200409211218.00809.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:16343 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267823AbUIUQZ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 12:25:28 -0400
In-Reply-To: <200409211218.00809.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: Matthew Wilcox <willy@debian.org>, Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, 2004-09-21 at 12:18, Jesse Barnes wrote:
> Well then.  Sounds like we're hosed for the qla2xxx case at least.  I think we 
> still need pioflush for the case of writes from different CPUs (described in 
> the document).  Using it *should* make the window pretty small for qla2xxx 
> type problems too, but we have no guarantee.

Not if we can do a PIO write ... PIO writes aren't posted.

James


