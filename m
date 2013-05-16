From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 0/6] Drivers: hv/scsi: Implement multi-channel support
Date: Thu, 16 May 2013 10:15:57 +0000
Message-ID: <31aae5e3bf764ae7a4458d18452aab9c@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1368655320-27599-1-git-send-email-kys@microsoft.com>
 <20130516040009.GA16728@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130516040009.GA16728@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "jasowang@redhat.com" <jasowang@redhat.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, May 16, 2013 12:00 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org; linux-
> scsi@vger.kernel.org; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 0/6] Drivers: hv/scsi: Implement multi-channel support
> 
> On Wed, May 15, 2013 at 03:02:00PM -0700, K. Y. Srinivasan wrote:
> > This patch-set implements multi-channel support for Hyper-V devices. Also
> > support for synthetic Fiber Channel device is included. The first two
> > patches in the series are the foundational pieces for the remaining patches.
> >
> > James, once Greg accepts the first two patches, you can consider the scsi
> > patches.
> 
> I have no objection for these first two patches to go through James's
> tree, I'll go add my ack to them.  That should make it easier for
> everyone involved.

Thanks Greg.

Regards,

K. Y
 
