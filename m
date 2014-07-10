From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Date: Thu, 10 Jul 2014 22:22:57 +0000
Message-ID: <2e5ae79793bf4e17b05bc5285ca73bda@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-7-git-send-email-kys@microsoft.com>
 <20140709084453.GG6012@infradead.org>
 <651b6b11c6d6415cb0046ce03b6b2c63@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140710101713.GC1151@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20140710101713.GC1151@infradead.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "apw@canonical.com" <apw@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, July 10, 2014 3:17 AM
> To: KY Srinivasan
> Cc: Christoph Hellwig; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; jasowang@redhat.com; apw@canonical.com;
> linux-scsi@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
> 
> On Wed, Jul 09, 2014 at 06:40:09PM +0000, KY Srinivasan wrote:
> > > On Tue, Jul 08, 2014 at 05:46:51PM -0700, K. Y. Srinivasan wrote:
> > > > Correctly set SRB flags for all valid I/O directions. Some IHV
> > > > drivers on the Windows host require this.
> > >
> > > What are IHV drivers?
> >
> > If the target is a SAN device, the host simply passes the request over to the
> native driver stack on the host. Some specific hardware (IHV - independent
> hadware vendor) drivers on Windows require that SRB flags be correctly set
> in all cases.
> >
> 
> I'm fine with putting this in, but treating I/O request from guests as trusted in
> a hypervisor doesn't seem like a good idea in general..

The host does  validate the guest request before forwarding the request to the appropriate target.

K. Y
