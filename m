From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Thu, 29 Sep 2005 21:59:38 +0200
Message-ID: <433C47AA.9040809@s5r6.in-berlin.de>
References: <43384E28.8030207@adaptec.com> <4339BFE9.1060604@pobox.com> <4339CCD6.5010409@adaptec.com> <4339F9A8.2030709@pobox.com> <433AFEB2.7090003@adaptec.com> <433B0457.7020509@pobox.com> <433B14E1.6080201@adaptec.com> <433B217F.4060509@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:31718 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S964881AbVI2UAo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 16:00:44 -0400
In-Reply-To: <433B217F.4060509@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Luben Tuikov <luben_tuikov@adaptec.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

Jeff Garzik wrote:
[...]
> HCIL stuff to move to SPI-specific transport code.
> 
> That is the task that must be completed BEFORE transport layer for SAS 
> can be fully merged.

So it could at least be _halfway_ merged, like it was done with the 
other non-SPI transport layers long ago, couldn't it?
-- 
Stefan Richter
-=====-=-=-= =--= ===-=
http://arcgraph.de/sr/
