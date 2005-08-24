From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] libata: write cache and read ahead
Date: Wed, 24 Aug 2005 12:28:33 -0400
Message-ID: <430CA031.5000307@adaptec.com>
References: <43085209.50405@torque.net> <430914C2.8030301@pobox.com> <43095EB3.2020202@torque.net> <430BAFD3.9000702@adaptec.com> <430C4610.3080205@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:28802 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751129AbVHXQ2i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 12:28:38 -0400
In-Reply-To: <430C4610.3080205@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

On 08/24/05 06:04, Jeff Garzik wrote:
> 
> SAT is the useful piece of libata that makes everything work.  You can't 
> rip out it and still expect to do anything useful ;-)
> 
> libata relies on SCSI's device class drivers -- sd, sr, st, sg -- to 
> manage devices and generate commands to service.  And in turn, we rely 
> on SAT (libata-scsi.c) to translate device class commands into ATA commands.
> 
> If the SAT layer went away, then nothing would exist to generate 
> commands for libata to service.

Ok, makes sense and requires minimal effort.  I like it.

	Luben
