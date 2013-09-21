From: KY Srinivasan <kys@microsoft.com>
Subject: RE: Drivers: scsi: FLUSH timeout
Date: Sat, 21 Sep 2013 05:24:57 +0000
Message-ID: <a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
 <20130920203222.GA14306@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20130920203222.GA14306@kroah.com>
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
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, September 20, 2013 1:32 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: Drivers: scsi: FLUSH timeout
> 
> On Fri, Sep 20, 2013 at 12:32:27PM -0700, K. Y. Srinivasan wrote:
> > The SD_FLUSH_TIMEOUT value is currently hardcoded.
> 
> Hardcoded where?  Please, more context.

This is defined in scsi/sd.h:

#define SD_FLUSH_TIMEOUT        (60 * HZ)
> 
> > On our cloud, we sometimes hit this timeout. I was wondering if we
> > could make this a module parameter. If this is acceptable, I can send
> > you a patch for this.
> 
> A module parameter don't make sense for a per-device value, does it?
Currently, the 60 second timeout is applied across devices. Ideally, I want to be
able to control the FLUSH TIMEOUT as we currently do I/O timeout. If this is 
acceptable, I can work on a patch for that as well.

Regards,

K. Y
> 
> greg k-h
