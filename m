From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: LSIFC909 problem
Date: Mon, 22 Oct 2007 10:42:55 -0600
Message-ID: <20071022164255.GC27248@parisc-linux.org>
References: <20071022161804.GB27248@parisc-linux.org> <664A4EBB07F29743873A87CF62C26D70A87BF1@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49813 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbXJVQm4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Oct 2007 12:42:56 -0400
Content-Disposition: inline
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70A87BF1@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: egi <pfammatter-egi@swissonline.ch>, linux-scsi@vger.kernel.org, mdr@sgi.com, "Shirron, Stephen" <Stephen.Shirron@lsi.com>

On Mon, Oct 22, 2007 at 10:33:41AM -0600, Moore, Eric wrote:
> On Monday, October 22, 2007 10:18 AM,  Matthew Wilcox wrote:
> > Sounds like we need a new driver written to support the FC909 then.
> > Unless we could pretend the FC909 is a parallel scsi card or something
> > ... that wasn't quite clear from Michael's mail.
> > 
> 
> ok, are you suggesting for FC909 we call scsi_scan_host, else chips we
> "hook into transport layer"?

Yes.  That reminds me, I need to convert fusion to the parallel scanning
regime.  I haven't forgotten our conversation at OLS2006.

> The way I understood from Stephen Shirron, is the FC909 is using mpi
> version 1.0, and all the other FC cards are on mpi version 1.2 or 1.5.
> The mpi defines the interface between driver and firmware.   The older
> mpi version 1.0 is missing feature needed for the FC transport to work.

That sounds plausible.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
