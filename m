From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sym53c8xx module parameter passing not working (2.5.6)
Date: Fri, 1 Oct 2004 22:11:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041001211136.GN16153@parcelfarce.linux.theplanet.co.uk>
References: <7AAD212492598A4A92463C3F5D34C54F194EDC@ccd3.CC.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:23754 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266538AbUJAVLh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2004 17:11:37 -0400
Content-Disposition: inline
In-Reply-To: <7AAD212492598A4A92463C3F5D34C54F194EDC@ccd3.CC.de>
List-Id: linux-scsi@vger.kernel.org
To: "Heinzmann, Robert" <Heinzmann@cc-dresden.de>
Cc: linux-scsi@vger.kernel.org

On Fri, Oct 01, 2004 at 05:26:21PM +0200, Heinzmann, Robert wrote:
> The 2.6 version of sym53c8xx_2 did not read the module command line parameter properly. 
> This was due to a missing call to sym53c8xx_setup().

I don't understand, actually.

#ifndef MODULE
__setup("sym53c8xx=", sym53c8xx_setup);
#endif

should cause sym53c8xx_setup to be called.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
