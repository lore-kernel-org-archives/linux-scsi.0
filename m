From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/6] Drivers: hv: vmbus: Implement multi-channel support
Date: Thu, 16 May 2013 10:18:49 +0000
Message-ID: <8313b08b52704644b5c72f70ea4d0403@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1368655320-27599-1-git-send-email-kys@microsoft.com>
 <1368655354-27651-1-git-send-email-kys@microsoft.com>
 <20130516040130.GB16728@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130516040130.GB16728@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "jasowang@redhat.com" <jasowang@redhat.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, May 16, 2013 12:02 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org; linux-
> scsi@vger.kernel.org; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 1/6] Drivers: hv: vmbus: Implement multi-channel support
> 
> On Wed, May 15, 2013 at 03:02:29PM -0700, K. Y. Srinivasan wrote:
> > +/*
> > + * Retrieve the (sub) channel on which to send an outgoing request.
> > + * When a primary channel has multiple sub-channels, we choose a
> > + * channel whose VCPU binding is closest to the VCPU on which
> > + * this call is being made.
> > + */
> > +struct vmbus_channel *get_outgoing_channel(struct vmbus_channel
> *primary)
> 
> That's a _very_ vague global symbol name you are adding to the kernel.
> Same goes for the other functions you are adding here, please fix that,
> and make them have the vmbus_ prefix, like everything else in this
> patch.


Will do.

K. Y
