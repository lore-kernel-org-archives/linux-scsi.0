From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Fix selection of command serial numbers and pids
Date: Sun, 6 Mar 2005 16:13:22 +0000
Message-ID: <20050306161322.GR28741@parcelfarce.linux.theplanet.co.uk>
References: <20050206194123.GF18245@wotan.suse.de> <20050206195141.GA24068@wotan.suse.de> <1109838679.6824.0.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:49867 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261425AbVCFQN2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Mar 2005 11:13:28 -0500
Content-Disposition: inline
In-Reply-To: <1109838679.6824.0.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andi Kleen <ak@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Mar 03, 2005 at 10:31:19AM +0200, James Bottomley wrote:
> On Sun, 2005-02-06 at 20:51 +0100, Andi Kleen wrote:
> > This patch fixes one of Christroph's fixme comments in the SCSI midlayer.
> 
> Could you reroll this against scsi-misc-2.6, please?  I get mainly
> rejections when I try to apply it.

Looks like you already applied it:
http://linux-scsi.bkbits.net:8080/scsi-misc-2.6/cset@421af1b58twqPRWklMdgCPv43LorBw

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
