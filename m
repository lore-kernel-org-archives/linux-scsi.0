From: "Duane Grigsby" <duane.grigsby@qlogic.com>
Subject: RE: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1
Date: Thu, 23 Dec 2004 11:08:36 -0800
Message-ID: <41EBA11203419D4CA8EB4C6140D8B401010212E4@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:46002 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261222AbULWTK5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2004 14:10:57 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Caushik, Ramesh" <ramesh.caushik@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

The problem is we have to support the distros which do not have support for fc_transport, so I would suggest you use but the mainline driver as well.

- Duane

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of 
> Christoph Hellwig
> Sent: Thursday, December 23, 2004 5:28 AM
> To: Caushik, Ramesh
> Cc: device-mapper development; linux-raid@vger.kernel.org;
> linux-hotplug-devel@lists.sourceforge.net; linux-scsi@vger.kernel.org
> Subject: Re: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1
> 
> 
> On Wed, Dec 22, 2004 at 01:54:45PM -0800, Caushik, Ramesh wrote:
> > The newer Qlogic (qla2xxx) driver for kernel versions 2.6.9 
> and later do not support the fc_transport class. The support 
> is #ifdefed for kernels > 2.6.6 & < 2.6.9. So I will have to 
> wait till they support this for newer kernels. Meanwhile I 
> can work with a patched version of multipath tools. Thanks 
> for feedback. 
> 
> It's supported in the mainline driver.  The qlogic drivers do 
> lots of silly
> things and you shouldn't use them.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
