From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 0/2] Drivers: scsi: storvsc: Fix issues with
 hot-add/remove of LUNs
Date: Tue, 7 Oct 2014 17:44:38 +0000
Message-ID: <65593e832b5b4da184470799eac9e384@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
 <20140925134726.GA26946@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140925134726.GA26946@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, September 25, 2014 6:47 AM
> To: KY Srinivasan
> Cc: hare@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 0/2] Drivers: scsi: storvsc: Fix issues with hot-
> add/remove of LUNs
> 
> So can anywayone give me a review for those two patches?

Did you get the reviews?

K. Y
> 
> On Sat, Aug 16, 2014 at 08:09:14PM -0700, K. Y. Srinivasan wrote:
> > This patch-set addresses issues with LUN hot-add and remove. When the
> > host notifies the guest that a scan is needed, scan the host. Also,
> > prior to discovering new devices that may have been added, ensure we
> > handle the LUN remove case first.
> >
> > K. Y. Srinivasan (2):
> >   Drivers: scsi: storvsc: In responce to a scan event, scan the host
> >   Drivers: scsi: storvsc: Force discovery of LUNs that may have been
> >     removed.
> >
> >  drivers/scsi/storvsc_drv.c |   43 ++++++++++++++++++++++++++++++++-
> ----------
> >  1 files changed, 32 insertions(+), 11 deletions(-)
> >
> > --
> > 1.7.4.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> ---end quoted text---
