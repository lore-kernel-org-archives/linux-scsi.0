From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: fibre channel sync cache question
Date: Tue, 25 Jul 2006 16:28:19 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70248ED4@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:63469 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932503AbWGYW22 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jul 2006 18:28:28 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>, linux-scsi@vger.kernel.org
Cc: James Smart <James.Smart@Emulex.Com>, dougg@torque.net

-- Tuesday, July 25, 2006 4:22 PM, Michael Reed wrote: 

> Using fibre channel disks, I've noticed that when the system 
> shuts down
> that the sd_driver issues a sync cache command to the device. 
>  I've also
> noticed that when the lldd is removed via rmmod that this 
> sync cache is
> not executed.  I would think that the sync cache would be desirable
> under this circumstance.
> 

This is not handled from sg path as well.  Meaning if you
use sdparm, and enable the caching page WCE bit, then reboot,
there is no SYNC cache issued from above. 

We handle this in fusion drivers due to short coming from above.

Eric
