From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] add device_configure to the transport classes
Date: Wed, 6 Oct 2004 16:22:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041006152233.GE16153@parcelfarce.linux.theplanet.co.uk>
References: <OF2154D688.D97183DA-ONC1256F24.005BD3E3-C1256F24.005EE95C@de.ibm.com> <1096996724.2064.56.camel@mulgrave> <41637BBA.804@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:26507 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269286AbUJFPWi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Oct 2004 11:22:38 -0400
Content-Disposition: inline
In-Reply-To: <41637BBA.804@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Oct 06, 2004 at 02:59:38PM +1000, Douglas Gilbert wrote:
> >Yes, that's another reason to make it transport specific.  Even SPI code
> >has to understand 64 bit LUN returns.
> 
> So does James now support Martin's proposal or is there a "not"
> missing in the first sentence of the above paragraph?

I queried James about that yesterday; he said the "not" was missing.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
