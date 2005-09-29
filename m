From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Thu, 29 Sep 2005 21:37:10 +0200
Message-ID: <433C4266.7040304@s5r6.in-berlin.de>
References: <43384E28.8030207@adaptec.com> <4339BFE9.1060604@pobox.com> <4339CCD6.5010409@adaptec.com> <4339F9A8.2030709@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:28644 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S964821AbVI2Tht (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 15:37:49 -0400
In-Reply-To: <4339F9A8.2030709@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Luben Tuikov <luben_tuikov@adaptec.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

Jeff Garzik wrote:
>> The sad truth is that SCSI Core knows only HCIL.
> 
> That's something that needs fixing, for SAS.

Not just for SAS.

>> The code doesn't alter Linux SCSI or anyone else's behaviour.
>> It only _provides_ SAS support to the kernel.
> 
> That's one of the problems: It should update the SCSI core.

Sure, but the same is true for the other transports except for SPI.
-- 
Stefan Richter
-=====-=-=-= =--= ===-=
http://arcgraph.de/sr/
