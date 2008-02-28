From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: need help with sg ioctls
Date: Thu, 28 Feb 2008 14:15:39 -0600
Message-ID: <47C7166B.6090507@cs.wisc.edu>
References: <200802281743.51332.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42811 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765746AbYB1UPs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Feb 2008 15:15:48 -0500
In-Reply-To: <200802281743.51332.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-scsi@vger.kernel.org

Bernd Schubert wrote:
> Hello,
> 
> for some reasons the kernel.org qla4xxx driver doesn't work for us. Version 
> 5.01.00.08 seems to work a bit better, but all default sg-ioctl's are not 
> defined.
> 
> Adding these manually as in scsi/sg.c works, but IMHO is rather stupid. Is 
> there a sane way to call sg_ioctl()?
> I mean it's static and also not exported and the file_operations ioctl method 
> is already taken by the qla4xxx driver.
> 

Do you mean that with the driver from qlogic.com (or one of the distros) 
you can do sg io to the qla4xxx driver, but with the kernel.org driver 
you have to go through the sg (scsi/sg.c) driver?
