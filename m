From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Date: Mon, 13 Feb 2012 18:59:35 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B70D570@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1328825688-4337-1-git-send-email-kys@microsoft.com>
 <20120210180212.GA605@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120210180212.GA605@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, February 10, 2012 1:02 PM
> To: KY Srinivasan; jbottomley@parallels.com
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of the
> staging area
> 
> On Thu, Feb 09, 2012 at 02:14:48PM -0800, K. Y. Srinivasan wrote:
> > The storage driver (storvsc_drv.c) handles all block storage devices
> > assigned to Linux guests hosted on Hyper-V. This driver has been in the
> > staging tree for a while and this patch moves it out of the staging area.
> >
> > James was willing to apply this patch during the 3.3-rc phase and a decision
> > was taken to defer this to 3.4 since Greg had queued up a bunch of storvsc
> > patches for 3.4. Now that Greg has applied all of the pending storvsc patches,
> > I am sending this patch to move this driver out of staging. Based on James'
> > recommendation, this patch gets rid of the unneeded files in the staging/hv
> > directory.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/scsi/Kconfig                       |    7 +++++++
> >  drivers/scsi/Makefile                      |    3 +++
> >  drivers/{staging/hv => scsi}/storvsc_drv.c |    0
> >  drivers/staging/Kconfig                    |    2 --
> >  drivers/staging/Makefile                   |    1 -
> >  drivers/staging/hv/Kconfig                 |    5 -----
> >  drivers/staging/hv/Makefile                |    3 ---
> >  drivers/staging/hv/TODO                    |    5 -----
> >  8 files changed, 10 insertions(+), 16 deletions(-)
> >  rename drivers/{staging/hv => scsi}/storvsc_drv.c (100%)
> >  delete mode 100644 drivers/staging/hv/Kconfig
> >  delete mode 100644 drivers/staging/hv/Makefile
> >  delete mode 100644 drivers/staging/hv/TODO
> 
> James, can I add your Acked-by: for this patch?

James,
Based on my understanding of your comments, I think this is what you
wanted. So, what is the verdict.

Regards,

K. Y. 
