From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH RFC 0/3] add fc transport events
Date: Thu, 27 May 2004 22:14:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFA5D56AC9.541248A2-ONC1256EA1.006DA3A1@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:29133 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S265181AbUE0UPc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 16:15:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>





> 03-convert-fc-class.patch - converts the fc class from a class_device
> scsi_device to a kobject and adds a basic link_up/down event fucntion.
>
> (I did not convert the spi class yet, becuase I wasn't sure how people
> would feel about such a change)

Looks promising as to FC. We can add these calls in the zfcp lldd
provided the patch makes it into the kernel. Then, what would be still
missing are the required hotplug scripts, I guess.

Martin

