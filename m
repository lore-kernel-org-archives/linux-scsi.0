From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] attach aic7xxx to the spi transport class.
Date: Sun, 10 Apr 2005 20:05:21 +0100
Message-ID: <20050410190521.GH8669@parcelfarce.linux.theplanet.co.uk>
References: <1113159507.6737.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:34504 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261577AbVDJTFX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Apr 2005 15:05:23 -0400
Content-Disposition: inline
In-Reply-To: <1113159507.6737.10.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, Apr 10, 2005 at 01:58:27PM -0500, James Bottomley wrote:
> If anyone has a 79xx card and wants to play too, this should be a simple
> cut and paste, doing s/ahc_/ahd_/ in all my functions.  The 79xx will
> also need QAS, IU and all the other ultra320 transport properties ...

I thought QAS and IU were also U160 properties since the sym1010 supports
them.  We just haven't found any drives yet that're willing to negotiate
them ...

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
