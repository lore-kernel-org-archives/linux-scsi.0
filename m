From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] drivers/scsi/sym53c8xx_2/sym_glue.c
Date: Mon, 2 May 2005 21:02:10 +0100
Message-ID: <20050502200210.GA19678@parcelfarce.linux.theplanet.co.uk>
References: <20050427193924.GT6147@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:4832 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261746AbVEBUBo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 May 2005 16:01:44 -0400
Content-Disposition: inline
In-Reply-To: <20050427193924.GT6147@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bob Picco <bob.picco@hp.com>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org

On Wed, Apr 27, 2005 at 03:39:24PM -0400, Bob Picco wrote:
> I believe the attempt not to use 64-bit BARs caused an unintended
> result.  The current code disables MMIO for all 64 bit BARs and not just 
> those with an address >= 4Gb.

Thanks, Bob.  You're quite right.  The code made a lot more sense when I
was trying to handle a real 64-bit BAR, but after I decided that changing
the rest of the driver to support this rare case was more trouble than
warranted, I didn't quite get it right.  I'll try and get 2.2.1 out today.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
