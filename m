From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [0/2]
Date: 12 May 2003 15:10:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052770234.1769.75.camel@mulgrave>
References: <20030509063321.GA3259@beaverton.ibm.com>
	<1052711864.1768.7.camel@mulgrave>
	<20030512063833.GA4133@beaverton.ibm.com>
	<1052761851.2093.55.camel@mulgrave> <1052762365.2148.59.camel@mulgrave>
	<20030512184140.GB3226@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:27396 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262531AbTELT54 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 15:57:56 -0400
In-Reply-To: <20030512184140.GB3226@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, mochel@osdl.org

On Mon, 2003-05-12 at 13:41, Mike Anderson wrote:
> I would like to have feedback from Mochel on the device_initialize
> call.
> 
> The documentation I have read indicates the device_initialize call was to
> allow the struct device to be usable for reference counting. I think we
> should determine if that is the intent and can we call kobj_set_kset_s
> in device_initialize.
> 
> Another option may be to set the ktype value on our struct device
> kobject until device_add overrides this with the call to kobj_set_kset_s.

I can confirm that moving kobj_set_kset_s fixes my boot up problem (with
your other patch).  However, now I'm running into an obscure slab
corruption issue, so I suspect the move has to be more carefully
orchestrated.

James


