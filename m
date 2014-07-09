From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Date: Wed, 9 Jul 2014 18:40:09 +0000
Message-ID: <651b6b11c6d6415cb0046ce03b6b2c63@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-7-git-send-email-kys@microsoft.com>
 <20140709084453.GG6012@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140709084453.GG6012@infradead.org>
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
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "ohering@suse.com" <ohering@suse.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, July 9, 2014 1:45 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
> 
> On Tue, Jul 08, 2014 at 05:46:51PM -0700, K. Y. Srinivasan wrote:
> > Correctly set SRB flags for all valid I/O directions. Some IHV drivers
> > on the Windows host require this.
> 
> What are IHV drivers?

If the target is a SAN device, the host simply passes the request over to the native driver stack on the host. Some specific hardware (IHV - independent hadware vendor) drivers on Windows require that SRB flags be correctly set in all cases.

Regards,

K. Y
> 
> 
> Otherwise looks fine,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
