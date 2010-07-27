From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 17/19] be2iscsi: patch from Randy Dunlap
Date: Tue, 27 Jul 2010 13:21:59 -0500
Message-ID: <1280254919.2833.212.camel@mulgrave.site>
References: <20100721225949.GA9808@serverengines.com>
	 <4C48C703.70907@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47737 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab0G0SWH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2010 14:22:07 -0400
In-Reply-To: <4C48C703.70907@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jayamohan Kalickal <jayamohank@serverengines.com>, linux-scsi@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>

On Thu, 2010-07-22 at 17:32 -0500, Mike Christie wrote:
> On 07/21/2010 05:59 PM, Jayamohan Kallickal wrote:
> >    This patch add NET because be2iscsi is using sysfs_format_mac function
> >    Found and patch originally submitted by Randy Dunlap
> >
> > Signed-off-by: Randy Dunlap<randy.dunlap@oracle.com>
> > Signed-off-by: Jayamohan Kallickal<jayamohank@serverengines.com>
> > ---
> >   drivers/scsi/be2iscsi/Kconfig   |    2 +-
> >   drivers/scsi/be2iscsi/be_main.h |    1 +
> >   2 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/scsi/be2iscsi/Kconfig b/drivers/scsi/be2iscsi/Kconfig
> > index 2952fcd..9d57142 100644
> > --- a/drivers/scsi/be2iscsi/Kconfig
> > +++ b/drivers/scsi/be2iscsi/Kconfig
> > @@ -1,7 +1,7 @@
> >   config BE2ISCSI
> >   	tristate "ServerEngines' 10Gbps iSCSI - BladeEngine 2"
> >   	depends on PCI&&  SCSI
> > -	select SCSI_ISCSI_ATTRS
> > +	select SCSI_ISCSI_ATTRS&&  NET
> >
> 
> Bah. Ok the code in the patches looks ok, but with this patch I get:
> 
> scripts/kconfig/mconf arch/x86/Kconfig
> drivers/scsi/be2iscsi/Kconfig:4: invalid option
> make[1]: *** [menuconfig] Error 1
> make: *** [menuconfig] Error 2
> 
> when I try to do
> 
> make menuconfig
> or
> make oldconfig

That's because the patch is wrong.  The && NET shouldn't be on the
select, it should be on the depends.

So, next time, I want to see a 

From: A.N Author <ana@acme.org>

at the front of the patch, so I pick up the correct authorship, and the
rest of the change log they sent in, plus comments about any fixes or
changes you made, then a signoff set.

James


