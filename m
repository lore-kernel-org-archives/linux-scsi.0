From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Date: Thu, 09 Feb 2012 14:45:56 -0600
Message-ID: <1328820356.2944.24.camel@dabdike.int.hansenpartnership.com>
References: <1328817851-13435-1-git-send-email-kys@microsoft.com>
	 <20120209200404.GA8816@kroah.com>
	 <1328818718.2944.20.camel@dabdike.int.hansenpartnership.com>
	 <20120209202409.GA22365@kroah.com>
	 <6E21E5352C11B742B20C142EB499E0481B70CB38@TK5EX14MBXC128.redmond.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481B70CB38@TK5EX14MBXC128.redmond.corp.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-02-09 at 20:43 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Thursday, February 09, 2012 3:24 PM
> > To: James Bottomley
> > Cc: KY Srinivasan; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > virtualization@lists.osdl.org; ohering@suse.com; hch@infradead.org; linux-
> > scsi@vger.kernel.org
> > Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of the
> > staging area
> > 
> > On Thu, Feb 09, 2012 at 02:18:38PM -0600, James Bottomley wrote:
> > > On Thu, 2012-02-09 at 12:04 -0800, Greg KH wrote:
> > > > On Thu, Feb 09, 2012 at 12:04:11PM -0800, K. Y. Srinivasan wrote:
> > > > > The storage driver (storvsc_drv.c) handles all block storage devices
> > > > > assigned to Linux guests hosted on Hyper-V. This driver has been in the
> > > > > staging tree for a while and this patch moves it out of the staging area.
> > > > > As per Greg's recommendation, this patch makes no changes to the
> > staging/hv
> > > > > directory. Once the driver moves out of staging, we will cleanup the
> > > > > staging/hv directory.
> > > > >
> > > > > James was willing to apply this patch during the 3.3-rc phase and a decision
> > > > > was taken to defer this to 3.4 since Greg had queued up a bunch of storvsc
> > > > > patches for 3.4. Now that Greg has applied all of the pending storvsc
> > patches,
> > > > > I am re-sending this patch to move this driver out of staging.
> > > > >
> > > > >
> > > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > > ---
> > > > >  drivers/scsi/Kconfig       |    7 +
> > > > >  drivers/scsi/Makefile      |    3 +
> > > > >  drivers/scsi/storvsc_drv.c | 1548
> > ++++++++++++++++++++++++++++++++++++++++++++
> > > > >  3 files changed, 1558 insertions(+), 0 deletions(-)
> > > > >  create mode 100644 drivers/scsi/storvsc_drv.c
> > > >
> > > > James, any objection to me applying this to the staging-next tree, and
> > > > at the same time, deleting this version of the driver from the
> > > > drivers/staging/hv/ directory?
> > >
> > > Well, yes, it has the same build failure as the previous one and that
> > > will make it non bisectable.
> > 
> > Ah, that would make things a bit difficult, KY, please test your
> > patches...
> 
> Greg,
> 
> I pulled down your staging tree earlier today that had all the storvsc patches that you
> checked in yesterday, applied this patch and built it (successfully).

You're leaving remnants in staging.

Move the damn thing and pull the config options from staging when you
put them in SCSI.

James
