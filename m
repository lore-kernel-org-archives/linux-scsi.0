From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH V1 1/7] Drivers: hv: vmbus: Implement multi-channel
 support
Date: Thu, 23 May 2013 17:26:14 +0000
Message-ID: <ad436d7ee6d64ddfb45f0b31e4e142fc@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1368706784-32276-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-1-git-send-email-kys@microsoft.com>
 <20130516140113.GB2629@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130516140113.GB2629@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "jasowang@redhat.com" <jasowang@redhat.com>
List-Id: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, May 16, 2013 10:01 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org; linux-
> scsi@vger.kernel.org; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH V1 1/7] Drivers: hv: vmbus: Implement multi-channel
> support
> 
> On Thu, May 16, 2013 at 05:21:13AM -0700, K. Y. Srinivasan wrote:
> > Starting with Win8, the host supports multiple sub-channels for a given
> > device. As in the past, the initial channel offer specifies the device and
> > is associated with both the type and the instance GUIDs. For performance
> > critical devices, the host may support multiple sub-channels. The sub-channels
> > share the same type and instance GUID as the primary channel. The number of
> > sub-channels offerrred to the guest depends on the number of virtual CPUs
> > assigned to the guest. The guest can request the creation of these sub-
> channels
> > and once created and opened, the guest can distribute the traffic across all
> > the channels (the primary and the sub-channels). A request sent on a sub-
> channel
> > will have the response delivered on the same sub-channel.
> >
> > At channel (sub-channel) creation we bind the channel interrupt to a CPU and
> > with this sub-channel support we will be able to spread the interrupt load
> > of a given device across all available CPUs.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 

James,

Please drop this patch-set. I fixed a couple of bugs in the vmbus support for multi-channel and I would need to resubmit this. Greg, I think it may make sense to first get the vmbus support checked in before I submit the storage related patches. There are networking related patches for multi-channel support that we will be submitting shortly. Getting the vmbus support in first would allow us to decouple network and storage patches. Greg, I will shortly submit the next version of the vmbus related patches for your consideration.

Regards,

K. Y
