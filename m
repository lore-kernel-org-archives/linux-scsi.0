From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH V1 7/7] Drivers: scsi: storvsc: Increase the value of
 STORVSC_MAX_IO_REQUESTS
Date: Thu, 16 May 2013 17:08:16 +0300
Message-ID: <20130516140816.GY30128@mwanda>
References: <1368706784-32276-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-7-git-send-email-kys@microsoft.com>
 <20130516120200.GN1360@mwanda>
 <797ed8d967414124a00ee151077c70fa@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130516135528.GX30128@mwanda>
 <fe60584bb8f2485abebffab2d0e8722d@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17627 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3EPOJF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 May 2013 10:09:05 -0400
Content-Disposition: inline
In-Reply-To: <fe60584bb8f2485abebffab2d0e8722d@SN2PR03MB061.namprd03.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "jasowang@redhat.com" <jasowang@redhat.com>

On Thu, May 16, 2013 at 02:01:12PM +0000, KY Srinivasan wrote:
> > Would the right fix be to add some sanity checks in module_init()?
> 
> The check is already there (as I noted above). Look at the function:
> storvsc_drv_init(). If the ring size is picked incorrectly, the load is failed.
> 

Ah.  I see that now.  My mistake.

regards,
dan carpenter

