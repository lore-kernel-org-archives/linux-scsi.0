From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 19:59:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921185908.GG11446@parcelfarce.linux.theplanet.co.uk>
References: <B179AE41C1147041AA1121F44614F0B0DD04DD@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:14282 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267963AbUIUS7K
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 14:59:10 -0400
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0DD04DD@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 10:33:36AM -0700, Andrew Vasquez wrote:
> Hmm...adding more confusion to the mix.  I apologize -- my reply was
> not written correctly, yes, the config-read will flush any pending
> writes.  But, the same problem persists -- the RISC will still stop
> responding to requests (config or MMIO) during the soft-reset -- 
> potentially resulting in a MAC (as seen by SGI).

Aha!  SGI's wacky PCI controllers must be able to cope with a PCI
config space fail, otherwise they wouldn't be able to do a PCI bus walk.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
