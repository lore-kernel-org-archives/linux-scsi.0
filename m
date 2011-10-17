From: Julian Andres Klode <jak@jak-linux.org>
Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of
 staging
Date: Mon, 17 Oct 2011 16:10:21 +0200
Message-ID: <20111017141021.GA4386@jak-linux.org>
References: <1318660132-21529-1-git-send-email-kys@microsoft.com>
 <1318714047.7271.49.camel@dabdike.int.hansenpartnership.com>
 <6E21E5352C11B742B20C142EB499E0481AA0FED0@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <1318859976.4794.8.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36516 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab1JQOK2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2011 10:10:28 -0400
Content-Disposition: inline
In-Reply-To: <1318859976.4794.8.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: KY Srinivasan <kys@microsoft.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>, "ohering@suse.com" <ohering@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>

On Mon, Oct 17, 2011 at 08:59:36AM -0500, James Bottomley wrote:
> On Sun, 2011-10-16 at 03:01 +0000, KY Srinivasan wrote:
> > 
> > > -----Original Message-----
> > > From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> > > Sent: Saturday, October 15, 2011 5:27 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> > > linux-scsi@vger.kernel.org; hch@infradead.org; Haiyang Zhang
> > > Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of
> > > staging
> > > 
> > > On Fri, 2011-10-14 at 23:28 -0700, K. Y. Srinivasan wrote:
> > > > In preparation for moving the storage driver out of staging, seek community
> > > > review of the storage  driver code.
> > > 
> > > That's not exactly a very descriptive commit message for me to put into
> > > SCSI.  It doesn't have to be huge, just something like "driver to enable
> > > hyperv windows guest on Linux" or something.
> > 
> > Sorry about the commit message. I will have a more descriptive message in the next
> > submission.
> > 
> > > 
> > > 
> > > >  drivers/scsi/Kconfig             |    7 +
> > > >  drivers/scsi/Makefile            |    3 +
> > > >  drivers/scsi/storvsc_drv.c       | 1480
> > > ++++++++++++++++++++++++++++++++++++++
> > > >  drivers/staging/hv/Kconfig       |    6 -
> > > >  drivers/staging/hv/Makefile      |    2 -
> > > >  drivers/staging/hv/storvsc_drv.c | 1480 --------------------------------------
> > > >  6 files changed, 1490 insertions(+), 1488 deletions(-)
> > > 
> > > What tree is this against?  The hv/storvsc_drv.c in upstream only has
> > > 
> > > jejb@dabdike> wc -l drivers/staging/hv/storvsc_drv.c
> > > 792 drivers/staging/hv/storvsc_drv.c
> > > 
> > > i.e. whatever you're sending is double the length (and obviously I have
> > > trouble applying the patch.
> > 
> > This patch  moves the file from drivers/staging/hv/ directory to the 
> > drivers/scsi directory; hence double the length.
> 
> No, that's not it.  Look again: the storvsc_drv.c in staging is removing
> 1480 lines, but in git head, this file is only 792 lines long ... is
> there an alternative tree with the rest in?
> 
> The point I'm making is that the staging file you're modifying isn't the
> one I see in Linus' git head, so which git tree is it in (I assume it's
> somewhere waiting for the merge window)?

I guess it's the staging tree you're looking for.

-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.
