From: Matthew Wilcox <willy@debian.org>
Subject: Re: 2.6.8.1-mm3
Date: Sat, 21 Aug 2004 22:47:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040821214733.GE9660@parcelfarce.linux.theplanet.co.uk>
References: <200408211838.i7LIcUdl025108@harpo.it.uu.se> <20040821191417.GA3402@beaverton.ibm.com> <1093116298.2092.388.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:60328 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267922AbUHUVrf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 17:47:35 -0400
Content-Disposition: inline
In-Reply-To: <1093116298.2092.388.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Mikael Pettersson <mikpe@csd.uu.se>, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, Aug 21, 2004 at 03:24:56PM -0400, James Bottomley wrote:
> Either we could provide a helper routine to do it and convert all the
> internal uses over, or we could define a new ioctl that is correctly
> unique, something like
> 
> #define SCSI_TEST_UNIT_READY	_IOR('S', 8, int)
> or perhaps just 0x5388
> 
> and convert the internal users over to it.
> 
> Opinions?

I prefer the former, something like

int scsi_test_unit_ready(struct scsi_device *sdev);

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
