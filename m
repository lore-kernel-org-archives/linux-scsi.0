From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 0/3] scsi: storvsc: Increase the tablesize based on host's
 capabilities
Date: Sun, 22 Mar 2015 02:03:34 +0000
Message-ID: <BY2PR0301MB07115F558FA4280699D54514A00C0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1425958941-23374-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
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
To: KY Srinivasan <kys@microsoft.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: KY Srinivasan
> Sent: Monday, March 16, 2015 4:45 PM
> To: 'K. Y. Srinivasan'; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com
> Subject: RE: [PATCH 0/3] scsi: storvsc: Increase the tablesize based on host's
> capabilities
> 
> 
> 
> > -----Original Message-----
> > From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> > Sent: Monday, March 9, 2015 8:42 PM
> > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; ohering@suse.com;
> > jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> > apw@canonical.com; vkuznets@redhat.com
> > Cc: KY Srinivasan
> > Subject: [PATCH 0/3] scsi: storvsc: Increase the tablesize based on host's
> > capabilities
> >
> > Presently, storvsc limits the I/O size arbitrarily. Make this configurable
> based
> > on what the host advertises.
> >
> > K. Y. Srinivasan (3):
> >   scsi: storvsc: Retrieve information about the capability of the
> >     target
> >   scsi: storvsc: Set the tablesize based on the information given by
> >     the host
> >   scsi: storvsc: Enable clustering
> >
> >  drivers/scsi/storvsc_drv.c |   78
> > +++++++++++++++++++++++++++++++++++---------
> >  1 files changed, 62 insertions(+), 16 deletions(-)
> 
> Christoph,
> 
> Let me know if I should resend these patches.
> 
> Regards,

Christoph,

Please drop this set. I will resend the patches with a couple of additional patches
that need to go in before I can enable clustering.

Regards,

K. Y 
