From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH V2 2/8] Drivers: scsi: storvsc: Set cmd_per_lun to reflect
 value supported by the Host
Date: Thu, 10 Jul 2014 22:08:23 +0000
Message-ID: <29c69dee7c6e4462a7d2913ae2b0b522@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404974008-4984-1-git-send-email-kys@microsoft.com>
 <1404974032-5023-1-git-send-email-kys@microsoft.com>
 <1404974032-5023-2-git-send-email-kys@microsoft.com>
 <20140710102457.GA31692@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140710102457.GA31692@infradead.org>
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
> Sent: Thursday, July 10, 2014 3:25 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org;
> jasowang@redhat.com; apw@canonical.com; linux-scsi@vger.kernel.org;
> stable@vger.kernel.org
> Subject: Re: [PATCH V2 2/8] Drivers: scsi: storvsc: Set cmd_per_lun to reflect
> value supported by the Host
> 
> > -	.cmd_per_lun =		1,
> > +	.cmd_per_lun =		255,
> >  	.can_queue =
> 	STORVSC_MAX_IO_REQUESTS*STORVSC_MAX_TARGETS,
> 
> slave_configure immediately adjusts this down to
> STORVSC_MAX_IO_REQUESTS (250), any reson to start out with the magic
> 255 here?

The number 255 (set for cmd_per_lun) is what the host can support (I recently discovered this in an MSDN document). STORVSC_MAX_IO_REQUESTS is an implementation limitation in this driver.

Regards,

K. Y
