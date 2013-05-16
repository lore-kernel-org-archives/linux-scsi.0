From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH V1 7/7] Drivers: scsi: storvsc: Increase the value of
 STORVSC_MAX_IO_REQUESTS
Date: Thu, 16 May 2013 16:55:28 +0300
Message-ID: <20130516135528.GX30128@mwanda>
References: <1368706784-32276-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-7-git-send-email-kys@microsoft.com>
 <20130516120200.GN1360@mwanda>
 <797ed8d967414124a00ee151077c70fa@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43791 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3EPN4Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 May 2013 09:56:16 -0400
Content-Disposition: inline
In-Reply-To: <797ed8d967414124a00ee151077c70fa@SN2PR03MB061.namprd03.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "jasowang@redhat.com" <jasowang@redhat.com>

On Thu, May 16, 2013 at 01:37:41PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > Sent: Thursday, May 16, 2013 8:02 AM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> > hch@infradead.org; linux-scsi@vger.kernel.org; apw@canonical.com;
> > jasowang@redhat.com
> > Subject: Re: [PATCH V1 7/7] Drivers: scsi: storvsc: Increase the value of
> > STORVSC_MAX_IO_REQUESTS
> > 
> > On Thu, May 16, 2013 at 05:21:19AM -0700, K. Y. Srinivasan wrote:
> > > Increase the value of STORVSC_MAX_IO_REQUESTS to 200 requests. The
> > current
> > > ringbuffer size can support this higher value.
> > >
> > 
> > The ringbuffer size is a module parameter so it's odd to talk about
> > the "current" size.
> 
> While the ringbuffer size is a module parameter; there is a default value. The current size refers to the default. 
> Your comment applies to the current value (of 128) as well in that it is possible for somebody to load this
> driver  with a ringbuffer size that could not support  the value of 128. If this  is the case, we fail the load.
> This safety check continues to exist. 

The issue is there in the original code, true.

Would the right fix be to add some sanity checks in module_init()?

regards,
dan carpenter

