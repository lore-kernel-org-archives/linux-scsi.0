From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI	Adapter
Date: Tue, 23 Nov 2004 01:40:49 +0000
Message-ID: <20041123014049.GH25636@parcelfarce.linux.theplanet.co.uk>
References: <04Nov8.094419est.332239@cyborg.cybernetics.com> <1099928314.10944.81.camel@compaq-rhel4.xsintricity.com> <41A294C5.8040702@babut.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:43920 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262535AbUKWBkv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2004 20:40:51 -0500
Content-Disposition: inline
In-Reply-To: <41A294C5.8040702@babut.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Babut <thomas@babut.net>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On Tue, Nov 23, 2004 at 02:39:17AM +0100, Thomas Babut wrote:
> Would it be possible to integrate the sym53c8xx (1, not sym53c8xx_2) 
> driver from Kernel 2.4.28 in 2.6? For me it would be the working 
> solution to use my SCSI-Controller with Kernel 2.6.
> 
> Perhaps someone could make a patch for Kernel 2.6 which adds the old driver.

No.  Don't do this.  Help make sym2 work for your system.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
