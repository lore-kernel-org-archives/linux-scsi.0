From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: return value warnings about scsi_add_host, anything in progre ss?
Date: Mon, 7 Feb 2005 18:01:44 +0000
Message-ID: <20050207180144.GB20386@parcelfarce.linux.theplanet.co.uk>
References: <0E3FA95632D6D047BA649F95DAB60E570366267D@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:6561 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261210AbVBGSBs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2005 13:01:48 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570366267D@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <sju@lsil.com>
Cc: 'Matthew Wilcox' <matthew@wil.cx>, 'Alexander Stohr' <Alexander.Stohr@gmx.de>, linux-scsi@vger.kernel.org

On Mon, Feb 07, 2005 at 12:25:21PM -0500, Ju, Seokmann wrote:
> On Monday, February 07, 2005 11:29 AM, Matthew wrote:
> > I don't get a warning from this line, using gcc 3.4.4 20041218
> > (prerelease)
> > (Debian 3.4.3-7):
> > 
> > drivers/scsi/megaraid.c: In function `megadev_ioctl':
> > drivers/scsi/megaraid.c:3626: warning: ignoring return value of
> > `copy_to_user', declared with attribute warn_unused_result
> > 
> > Were you confused with that warning?
> 
> Thank you for your comment.
> 
> The driver being referred here is pretty old version and it's been quite
> while since LSI move forward to 2.10.9.x for 2.4 kernel support.
> Please upgrade the driver to 2.10.9.x.

Um, please submit the driver for inclusion?  Looks like we're still at
2.00.3 in kernel, so you'll need to split up your changes to be sure
you're not backing out fixes other people have made to the driver since
your last update.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
