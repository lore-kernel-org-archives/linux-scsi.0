From: Matthew Wilcox <willy@debian.org>
Subject: Re: SCSI vs SATA considerations
Date: Fri, 7 May 2004 13:13:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507121313.GI2281@parcelfarce.linux.theplanet.co.uk>
References: <409B7983.A3031C21@danbbs.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:43920 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263568AbUEGMNO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 08:13:14 -0400
Content-Disposition: inline
In-Reply-To: <409B7983.A3031C21@danbbs.dk>
List-Id: linux-scsi@vger.kernel.org
To: Mogens Valentin <monz@danbbs.dk>
Cc: Linux-scsi <linux-scsi@vger.kernel.org>

On Fri, May 07, 2004 at 01:56:51PM +0200, Mogens Valentin wrote:
> On a new DDR400, 2200MHz cpu, system, using 29160 with an IBM DDYS disk,
> I get 37MB/s. For reasons I don't understand, the DDYS won't negotiate
> at 80MB/s, will only do 40MB/s.

Negotiation problems are normally cable or termination issues.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
