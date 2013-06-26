From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH V3 0/5] Drivers: scsi: storvsc
Date: Wed, 26 Jun 2013 12:58:27 +0000
Message-ID: <868094fd01274f3c89ef2a27e9e42a3d@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1370372674-10046-1-git-send-email-kys@microsoft.com>
 <ba5d1c4a36a441f09e6a1c5aa4e6d6a3@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: KY Srinivasan
> Sent: Monday, June 17, 2013 9:32 AM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: RE: [PATCH V3 0/5] Drivers: scsi: storvsc
> 
> 
> 
> > -----Original Message-----
> > From: KY Srinivasan
> > Sent: Tuesday, June 11, 2013 9:02 AM
> > To: KY Srinivasan; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> > hch@infradead.org; linux-scsi@vger.kernel.org
> > Subject: RE: [PATCH V3 0/5] Drivers: scsi: storvsc
> >
> >
> >
> > > -----Original Message-----
> > > From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> > > Sent: Tuesday, June 04, 2013 3:05 PM
> > > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com;
> > > hch@infradead.org; linux-scsi@vger.kernel.org
> > > Cc: KY Srinivasan
> > > Subject: [PATCH V3 0/5] Drivers: scsi: storvsc
> > >
> > > This set adds multi-channel support as well synthetic Fibre Channel support
> > > to storvsc. The multi-channel support depends on infrastructure in the
> VMBUS
> > > driver. Greg has already checked in the relevant patches to VMBUS.
> > >
> > > I had posted an earlier version of this patch-set that included the VMBUS
> > > related changes. I have since separated the VMBUS chages and these have
> > > already been
> > > checked in.
> > >
> > > In this version, based on comments from James, the timeout is no longer a
> > > module
> > > parameter.
> >
> > James,
> >
> > I think I have addressed all the comments that you had; if not, please let me
> > know.
> 
> Ping.

James,

Let me know if I should re-send the patches.

Thanks,

K. Y
