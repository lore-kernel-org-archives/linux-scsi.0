From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: return value warnings about scsi_add_host, anything in progre ss?
Date: Mon, 7 Feb 2005 16:29:14 +0000
Message-ID: <20050207162914.GA20386@parcelfarce.linux.theplanet.co.uk>
References: <0E3FA95632D6D047BA649F95DAB60E570366267A@exa-atlanta> <20050207161022.GZ20386@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:34454 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261179AbVBGQ3R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2005 11:29:17 -0500
Content-Disposition: inline
In-Reply-To: <20050207161022.GZ20386@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Ju, Seokmann" <sju@lsil.com>, 'Alexander Stohr' <Alexander.Stohr@gmx.de>, linux-scsi@vger.kernel.org

On Mon, Feb 07, 2005 at 04:10:22PM +0000, Matthew Wilcox wrote:
> I'm not sure why returning the result doesn't count as a "use" of the result
> (in the case of megaraid).
> 
> > > From: Alexander Stohr [mailto:Alexander.Stohr@gmx.de]
> > > 
> > > ./drivers/scsi/megaraid.c:4890: error = scsi_add_host(host, &pdev->dev);

I don't get a warning from this line, using gcc 3.4.4 20041218 (prerelease)
(Debian 3.4.3-7):

drivers/scsi/megaraid.c: In function `megadev_ioctl':
drivers/scsi/megaraid.c:3626: warning: ignoring return value of `copy_to_user', declared with attribute warn_unused_result

Were you confused with that warning?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
