From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: [PATCH 1/1] cciss: scsi error handling
Date: Fri, 11 Nov 2005 16:01:45 -0600
Message-ID: <45B36A38D959B44CB032DA427A6E10640A7A5411@cceexc18.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:11757 "EHLO
	ccerelbas04.cce.hp.com") by vger.kernel.org with ESMTP
	id S1751266AbVKKWBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2005 17:01:52 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


> No, the pointers are all held in place.  Even if everyone else releases
> their references, the commmand still contains a reference to the device
> (which holds it from being released) and the device likewise contains a
> reference to the host.

Ok, then I think it's good to go as far as locking is concerned.

Thanks for the explanation.

Regarding the CISS vs. CCISS in the config variable, is that going
to hold up this patch?  I can make a patch to change that, but it's
not really related to this patch, this patch just happens to use 
that config variable.

-- steve


