From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] scsi: storvsc: Support manual scan of FC hosts on
 Hyper-V
Date: Wed, 16 Mar 2016 23:15:59 +0000
Message-ID: <SN2PR03MB2142B8D8C2B1831522F6EB1AA08A0@SN2PR03MB2142.namprd03.prod.outlook.com>
References: <1457819568-6586-1-git-send-email-kys@microsoft.com>
 <20160315134009.GA3595@infradead.org>
 <SN2PR03MB21423A42522A21C145896431A0890@SN2PR03MB2142.namprd03.prod.outlook.com>
 <yq1twk7e8nl.fsf@sermon.lab.mkp.net>
 <SN2PR03MB21425F84DAC997491DD4C2ACA0890@SN2PR03MB2142.namprd03.prod.outlook.com>
 <yq14mc6dpbu.fsf@sermon.lab.mkp.net>
 <1458169666.4793.62.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1458169666.4793.62.camel@HansenPartnership.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Wednesday, March 16, 2016 4:08 PM
> To: Martin K. Petersen <martin.petersen@oracle.com>; KY Srinivasan
> <kys@microsoft.com>
> Cc: Christoph Hellwig <hch@infradead.org>; gregkh@linuxfoundation.org;
> linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> hare@suse.de
> Subject: Re: [PATCH 1/1] scsi: storvsc: Support manual scan of FC hosts on
> Hyper-V
> 
> On Wed, 2016-03-16 at 18:34 -0400, Martin K. Petersen wrote:
> > > > > > > "KY" == KY Srinivasan <kys@microsoft.com> writes:
> >
> > KY> How would I get the sysfs files under fc_host if I don't use the
> > FC
> > KY> transport.  The customer scripts expect these sysfs files.
> >
> > Right, but I was interested in finding out why they need those
> > files. And whether an alternative to the FC transport would be a
> > better solution.
> 
> If it's just the wwn file (or a set of other values), we might be able
> to separate that bit out of the FC transport class so you can use it
> independently ... do you have a full list of the files being used?

Wwn files are what we can support on Hyper-V and that is what I want to support
(to address customer requirements).

Regards,

K. Y 
