From: Matthew Wilcox <willy@debian.org>
Subject: Re: 2.6.5-rc1 SCSI + st regressions (was: Linux 2.6.5-rc1)
Date: Tue, 16 Mar 2004 21:17:00 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040316211700.GA25059@parcelfarce.linux.theplanet.co.uk>
References: <Pine.LNX.4.58.0403152154070.19853@ppc970.osdl.org> <20040316211203.GA3679@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:27117 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261686AbUCPVRB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 16:17:01 -0500
Content-Disposition: inline
In-Reply-To: <20040316211203.GA3679@merlin.emma.line.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Mar 16, 2004 at 10:12:03PM +0100, Matthias Andree wrote:
> I have some SCSI troubles with 2.6.5-rc1 (from BK) that 2.6.4 didn't
> have.
> 
> Modprobe, loading the st driver, tries a NULL pointer dereference in
> kernel space and my 2nd tape drive isn't found: st1 is not shown. cat
> /proc/scsi/scsi (typed after the attempted zero page dereference) hangs
> in rwsem_down_read_failed with process state D.

I notice you're using the sym2 driver.  Could you try backing out the
changes made to it in 2.6.5-rc1, just to be sure we're looking at an st
problem, not a sym2 problem?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
