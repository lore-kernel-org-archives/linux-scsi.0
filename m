From: Mark Lord <liml@rtr.ca>
Subject: Re: [DOC PATCH]  T10/04-262r8
Date: Thu, 10 Nov 2005 09:27:54 -0500
Message-ID: <437358EA.3090406@rtr.ca>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com>	 <4371BB82.3090208@gmx.de> <4371C557.80807@gmx.de> <4371F7C3.5080702@rtr.ca>	 <43720232.6090609@gmx.de> <4372172A.50003@gmx.de>	 <43721C3C.1010103@pobox.com> <1131553363.3271.1.camel@mulgrave> <4372E66F.5070802@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([64.26.128.89]:64938 "EHLO mail.rtr.ca")
	by vger.kernel.org with ESMTP id S1750951AbVKJO1o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2005 09:27:44 -0500
In-Reply-To: <4372E66F.5070802@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

thomas schorpp wrote:
>
> for hdparm ata-security theres ide taskfile used, can scsi command sequences combined with ide taskfiles 
> which use own ioctls?

As Jeff said, libata translates some of the HDIO_TASK* functions
into SCSI passthru commands, which then get translated back
into ATA commands at the time of issue to the device.

Once passthru makes it out into the wild (Linus kernels),
I'll update hdparm to have it use SCSI passthru instead
when available/appropriate.

There will have to be about a year or so of full overlap
(hdparm, smartmontools, and kernel), to give distros time
to update/release with all of the affected components.

After that, I imagine Jeff may want to remove the HDIO_TASK*
calls again.

Cheers
