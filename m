From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] scsi: storvsc: Support manual scan of FC hosts on
 Hyper-V
Date: Tue, 15 Mar 2016 23:01:03 +0000
Message-ID: <SN2PR03MB21425F84DAC997491DD4C2ACA0890@SN2PR03MB2142.namprd03.prod.outlook.com>
References: <1457819568-6586-1-git-send-email-kys@microsoft.com>
	<20160315134009.GA3595@infradead.org>
	<SN2PR03MB21423A42522A21C145896431A0890@SN2PR03MB2142.namprd03.prod.outlook.com>
 <yq1twk7e8nl.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1twk7e8nl.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "hare@suse.de" <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Tuesday, March 15, 2016 2:25 PM
> To: KY Srinivasan <kys@microsoft.com>
> Cc: Christoph Hellwig <hch@infradead.org>; gregkh@linuxfoundation.org;
> linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> martin.petersen@oracle.com; hare@suse.de
> Subject: Re: [PATCH 1/1] scsi: storvsc: Support manual scan of FC hosts on
> Hyper-V
> 
> >>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:
> 
> KY> Till recently I had not. However, we do support publishing wwn in
> KY> the guest and some customers wanted this. That is the reason I am
> KY> attaching FC transport and working through the issues. With this
> KY> change, I now have wwn names published in the guest and I can also
> KY> issue manual scan.
> 
> Why does it have to look like FC? Will a device identification VPD page
> not do the trick?

How would I get the sysfs files under fc_host if I don't use the FC transport.
The customer scripts expect these sysfs files.

Regards,

K. Y
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
