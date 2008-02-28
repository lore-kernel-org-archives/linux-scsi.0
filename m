From: Bernd Schubert <bs@q-leap.de>
Subject: Re: need help with sg ioctls
Date: Thu, 28 Feb 2008 21:58:09 +0100
Message-ID: <20080228205809.GA13688@lanczos.q-leap.de>
References: <200802281743.51332.bs@q-leap.de> <47C7166B.6090507@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:44912 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758953AbYB1U6M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Feb 2008 15:58:12 -0500
Content-Disposition: inline
In-Reply-To: <47C7166B.6090507@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

Hello Mike,

On Thu, Feb 28, 2008 at 02:15:39PM -0600, Mike Christie wrote:
> Bernd Schubert wrote:
>> Hello,
>> for some reasons the kernel.org qla4xxx driver doesn't work for us. 
>> Version 5.01.00.08 seems to work a bit better, but all default sg-ioctl's 
>> are not defined.
>> Adding these manually as in scsi/sg.c works, but IMHO is rather stupid. Is 
>> there a sane way to call sg_ioctl()?
>> I mean it's static and also not exported and the file_operations ioctl 
>> method is already taken by the qla4xxx driver.
>
> Do you mean that with the driver from qlogic.com (or one of the distros) 
> you can do sg io to the qla4xxx driver, but with the kernel.org driver you 
> have to go through the sg (scsi/sg.c) driver?

I'm not sure about the in-kernel driver, as I was told by my boss it doesn't
work at all with the overland tape library.
And yes, with the driver from qlogic I *have* to do sg io through this driver.
But it only knows its own ioctls, but not the default sg-ioctls.
I'm now adding all these ioctls to the driver, but somehow I think it is 
ridiculous to this when these are already defined in scsi/sg.c.

Thanks,
Bernd
