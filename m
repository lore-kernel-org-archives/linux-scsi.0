From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs that
 may have been removed.
Date: Tue, 26 Aug 2014 22:54:51 +0000
Message-ID: <c5da85b38a2a4b26b9a7a7fadc40bcc2@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-2-git-send-email-kys@microsoft.com>
 <20140819175431.GA4617@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140819175431.GA4617@infradead.org>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Tuesday, August 19, 2014 10:55 AM
> To: KY Srinivasan
> Cc: hare@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; linux-scsi@vger.kernel.org; Martin K. Petersen
> Subject: Re: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs that
> may have been removed.
> 
> On Sat, Aug 16, 2014 at 08:09:48PM -0700, K. Y. Srinivasan wrote:
> > The host asks the guest to scan when a LUN is removed or added.
> > The only way a guest can identify the removed LUN is when an I/O is
> > attempted on a removed LUN - the SRB status code indicates that the
> > LUN is invalid. We currently handle this SRB status and remove the device.
> >
> > Rather than waiting for an I/O to remove the device, force the
> > discovery of LUNs that may have been removed prior to discovering LUNs
> > that may have been added.
> 
> This looks pretty reasonable to me, but I wonder if we should move this up
> to common code so that it happens for any host rescan triggered by sysfs or
> other drivers as well.
Ping. Any decision on if/when this patch may be checked in.

Regards,

K. Y
